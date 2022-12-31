class MaiConfig {
	$title;
	$voiceName;
	$sceneCodeFormat;
	$messageCodeFormat;
	$imageFormat;
	$audioFormat;
	$audioInterval;
	$credit;
	$ciiVolume;
	$ciiSpeed;

	MaiConfig($data) {
		$this.title = $data.title;
		if ($null -eq $this.title) { $this.title = "MaiNovel"; }

		$this.voiceName = $data.voiceName;

		$this.sceneCodeFormat = $data.sceneCodeFormat;
		if ($null -eq $this.sceneCodeFormat) { $this.sceneCodeFormat = "00"; }

		$this.messageCodeFormat = $data.messageCodeFormat;
		if ($null -eq $this.messageCodeFormat) { $this.messageCodeFormat = "00"; }

		$this.imageFormat = $data.imageFormat;
		if ($null -eq $this.imageFormat) { $this.imageFormat = "png"; }

		$this.audioFormat = $data.audioFormat;
		if ($null -eq $this.audioFormat) { $this.audioFormat = "wav"; }

		$this.audioInterval = $data.audioInterval;
		if ($null -eq $this.audioInterval) { $this.audioInterval = 1000; }

		$this.credit = $data.credit;
		if ($null -eq $this.credit) { $this.credit = ""; }

		$this.ciiVolume = $data.ciiVolume;
		if ($null -eq $this.ciiVolume) { $this.ciiVolume = 1.0; }

		$this.ciiSpeed = $data.ciiSpeed;
		if ($null -eq $this.ciiSpeed) { $this.ciiSpeed = 1.0; }
	}
}

class MaiVoice {
	$name;
	$ciiStyleId;

	MaiVoice($data) {
		$this.name = $data.voiceName;
		$this.ciiStyleId = $data.ciiStyleId;
	}
}

class MaiScene {
	$name;
	$voiceName;
	$audioInterval;
	$ciiVolume;
	$ciiSpeed;
	$messages = @();

	$index;
	$code;

	MaiScene($data) {
		$this.name = $data.sceneName;
		$this.voiceName = $data.voiceName;
		$this.audioInterval = $data.audioInterval;
		$this.ciiVolume = $data.ciiVolume;
		if ($null -eq $this.ciiVolume) { $this.ciiVolume = 1.0; }
		$this.ciiSpeed = $data.ciiSpeed;
		if ($null -eq $this.ciiSpeed) { $this.ciiSpeed = 1.0; }

		foreach ($messageData in $data.messages) {
			$this.messages += New-Object MaiMessage($messageData);
		}
	}

	[void] Initialize($novel, $index) {
		$this.index = $index;
		$this.code = "s{0:$($novel.config.sceneCodeFormat)}" -f $index;
		for ($i = 0; $i -lt $this.messages.Count; $i++) {
			$this.messages[$i].Initialize($novel, $this, $i);
		}
	}
}

class MaiMessage {
	$text;
	$insertHTML;
	$_voiceName;
	$_audioInterval;
	$imageName;
	$imagePath;
	$_ciiVolume = 1.0;
	$_ciiSpeed = 1.0;
	$ciiText;

	$scene;
	$index;
	$next;
	$voiceName;
	$voice;
	$audioInterval;
	$ciiVolume;
	$ciiSpeed;

	$code;
	$name;
	$audioPath;

	MaiMessage($data) {
		if ($data -is [string]) {
			$this.text = $data;
			$this.insertHTML = "";
		}
		else {
			$this.text = $data.text;
			if ($null -eq $this.text) { $this.text = ""; }
			$this.insertHTML = $data.insertHTML;
			if ($null -eq $this.insertHTML) { $this.insertHTML = ""; }
			$this._voiceName = $data.voiceName;
			$this._audioInterval = $data.audioInterval;
			$this.imageName = $data.imageName;
			$this.imagePath = $data.imagePath;
			if ($null -ne $data.ciiVolume) { $this._ciiVolume = $data.ciiVolume; }
			if ($null -ne $data.ciiSpeed) { $this._ciiSpeed = $data.ciiSpeed; }
			$this.ciiText = $data.ciiText;
		}
	}

	[void] Initialize($novel, $scene, $index) {
		$this.scene = $scene;
		$this.index = $index;

		$nextMsgIdx = $index + 1;
		if ($nextMsgIdx -eq $scene.messages.Count) {
			$nextScnIdx = $scene.index + 1;
			if ($nextScnIdx -eq $novel.scenes.Count) { $nextScnIdx = 0; }
			$this.next = $novel.scenes[$nextScnIdx].messages[0];
		}
		else {
			$this.next = $scene.messages[$nextMsgIdx];
		}

		$this.voiceName = $this._voiceName;
		if ($null -eq $this.voiceName) { $this.voiceName = $scene.voiceName; }
		if ($null -eq $this.voiceName) { $this.voiceName = $novel.config.voiceName; }
		$this.voice = $novel.voices[$this.voiceName];

		$this.audioInterval = $this._audioInterval;
		if ($null -eq $this.audioInterval) { $this.audioInterval = $scene.audioInterval; }
		if ($null -eq $this.audioInterval) { $this.audioInterval = $novel.config.audioInterval; }

		$this.ciiVolume = $this._ciiVolume * $scene.ciiVolume * $novel.config.ciiVolume;
		$this.ciiSpeed = $this._ciiSpeed * $scene.ciiSpeed * $novel.config.ciiSpeed;

		$this.code = "m{0:$($novel.config.messageCodeFormat)}" -f $index;
		$this.name = "$($scene.code)$($this.code)";

		$audioFormat = $novel.config.audioFormat;
		$this.audioPath = "$audioFormat/$($scene.code)/$($this.name).$audioFormat";

		if ($null -eq $this.imagePath) {
			$imgFormat = $novel.config.imageFormat;
			if ($null -eq $this.imageName) {
				$this.imagePath = "$imgFormat/$($scene.code)/$($this.name).$imgFormat";
			}
			else {
				$firstChar = $this.imageName[0];
				if ($firstChar -eq 'm') {
					$this.imagePath = "$imgFormat/$($scene.code)/$($scene.code)$($this.imageName).$imgFormat";
				}
				elseif ($firstChar -eq 's') {
					$mIdx = $this.imageName.IndexOf("m");
					if ($mIdx -ne -1) {
						$sceneCode = $this.imageName.SubString(0, $mIdx);
						$this.imagePath = "$imgFormat/$($sceneCode)/$($this.imageName).$imgFormat";
					}
				}
			}
		}
	}

	[string] GetWavPath($hasded) {
		$path = $this.audioPath;
		$extension = [IO.Path]::GetExtension($path).Substring(1);
		$path = $path.Substring($extension.Length, $path.Length - $extension.Length);
		if ($hasded) {
			$path = "hashed_wav" + [IO.Path]::ChangeExtension($path, "{0:X8}.wav" -f $this.GetWavHashCode());
		}
		else {
			$path = "wav" + [IO.Path]::ChangeExtension($path, "wav");
		}
		return $path;
	}

	[int] GetWavHashCode() {
		function MergeHash($hash, $member) {
			if ($null -ne $member) { $hash = $hash -bxor $member.GetHashCode(); }
			return $hash;
		}
		$result = $this.text.GetHashCode();
		$result = MergeHash $result $this.ciiVolume;
		$result = MergeHash $result $this.ciiSpeed;
		$result = MergeHash $result $this.ciiText;
		$result = MergeHash $result $this.voice.ciiStyleId;
		return $result;
	}
}

class MaiNovel {
	$config;
	$voices = @{};
	$scenes = @();

	MaiNovel($data) {
		$this.config = New-Object MaiConfig($data.config);

		foreach ($voiceData in $data.voices) {
			$this.voices[$voiceData.voiceName] = New-Object MaiVoice($voiceData);
		}

		foreach ($sceneData in $data.scenes) {
			$this.scenes += New-Object MaiScene($sceneData);
		}

		for ($i = 0; $i -lt $this.scenes.Count; $i++) {
			$this.scenes[$i].Initialize($this, $i);
		}
	}
}
