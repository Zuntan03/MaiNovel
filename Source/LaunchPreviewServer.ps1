$jsonPath = $Args[0];
if (!(Test-Path $jsonPath)) {
	Write-Host "JSONファイルをドラッグ＆ドロップしてください。: $jsonPath"
	return;
}
$jsonDir = (Split-Path -parent $jsonPath);

$delay = 0;
if ($null -ne $Args[1]) {
	$delay = [int]$Args[1];
}

$prefix = "http://+:80/Temporary_Listen_Addresses/";
$addr = "http://127.0.0.1/Temporary_Listen_Addresses/";
$ignoreUrlLen = "Temporary_Listen_Addresses/".Length;

try {
	$listener = New-Object Net.HttpListener;
	$listener.Prefixes.Add($prefix);
	$listener.Start();
	Write-Host "Listen(Delay $($delay)ms): $addr";

	$contentType = @{
		".html" = "text/html";
		".js"   = "text/javascript";
		".css"  = "text/css";
		".json" = "application/json";
		".png"  = "image/png";
		".jpg"  = "image/jpeg";
		".jpeg" = "image/jpeg";
		".webp" = "image/webp";
		".wav"  = "audio/wav";
		".aac"  = "audio/aac";
		".m4a"  = "audio/aac";
		".ogg"  = "audio/ogg";
		".mp3"  = "audio/mpeg";
	};

	while ($true) {
		$context = $listener.GetContext();
		$request = $context.Request;
		$response = $context.Response;

		$url = $request.RawUrl;
		if ($ignoreUrlLen -ge 0) { $url = $request.RawUrl.Substring($ignoreUrlLen); }
		$url = [System.Uri]::UnescapeDataString($url);
		if ($url.EndsWith("/")) { $url += "index.html"; }
		$filePath = $jsonDir + $url;
		Write-Host "Request: $($request.RawUrl)";

		if ([IO.File]::Exists($filePath)) {
			Start-Sleep -Milliseconds $delay;
			$fileExt = [IO.Path]::GetExtension($filePath);
			if ($contentType.ContainsKey($fileExt)) {
				$response.ContentType = $contentType[$fileExt];
				Write-Host "Response: $($contentType[$fileExt]) $filePath";
			}
			else {
				$response.ContentType = "text/plain";
				Write-Host "Response: text/plain $filePath";
			}
			

			$fileBytes = [IO.File]::ReadAllBytes($filePath);
			$response.OutputStream.Write($fileBytes, 0, $fileBytes.Length);
		}
		else {
			Write-Host "Response: 404 $filePath";
			$response.StatusCode = 404;
		}
		$response.Close();
	}
}
catch {
	Write-Error $_.Exception;
}
