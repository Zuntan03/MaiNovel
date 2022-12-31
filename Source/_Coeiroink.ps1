class Coeiroink {
	$server = "http://127.0.0.1:50031";
	$prePhonemeLength = 0.0;
	$postPhonemeLength = 0.0;
	$outputSamplingRate = 48000;

	[bool] Generate($message, $path) {
		$text = $message.ciiText;
		if ($null -eq $text) { $text = $message.text; }
		$encodedText = [System.Web.HttpUtility]::UrlEncode($text)

		$speaker = $message.voice.ciiStyleId;
		if (!$speaker) { $speaker = 0; }

		$query = Invoke-RestMethod -Method POST `
			-Uri "$($this.server)/audio_query?text=$encodedText&speaker=$speaker";

		# グローバル設定
		$query.outputSamplingRate = $this.outputSamplingRate;
		$query.prePhonemeLength = $this.prePhonemeLength;
		$query.postPhonemeLength = $this.postPhonemeLength;

		# ローカル設定
		$query.volumeScale = $message.ciiVolume;
		$query.speedScale = $message.ciiSpeed;

		# JSON生成と文字化け対策
		$json = ConvertTo-Json $query -Depth 16
		$bytes = [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($json);
		$json = [System.Text.Encoding]::Utf8.GetString($bytes);

		Invoke-RestMethod -Method POST `
			-Uri "$($this.server)/synthesis?speaker=$speaker" `
			-ContentType "application/json" `
			-Body $json `
			-OutFile $path;
		return $true;
	}
}
