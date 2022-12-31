class WavGenerator {
	$novel;
	$generator;

	WavGenerator($novel, $generator) {
		$this.novel = $novel;
		$this.generator = $generator;
	}

	[int] Generate($dir, $hashedWav) {
		$count = 0;
		foreach ($scene in $this.novel.scenes) {
			$wavDir = "$($dir)\wav\$($scene.code)";
			if ($hashedWav) { $wavDir = "$($dir)\hashed_wav\$($scene.code)"; }
			if (!(Test-Path $wavDir)) { New-Item $wavDir -ItemType Directory; }

			foreach ($message in $scene.messages) {
				$path = "$dir\$($message.GetWavPath($hashedWav))";
				if (Test-Path $path) { continue; }
				if (!$this.generator.Generate($message, $path)) { continue; }
				$count++;
			}
		}
		return $count;
	}
}
