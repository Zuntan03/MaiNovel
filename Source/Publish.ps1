. $PSScriptRoot\_MaiNovel.ps1;

class Publisher {
	[void] Publish($arg) {
		$novelName = [IO.Path]::GetFileNameWithoutExtension($arg);
		$novel = New-Object MaiNovel(Get-Content -Path $arg | ConvertFrom-Json);
		$srcDir = [IO.Path]::GetDirectoryName($arg)
		$dstDir = $srcDir + "\$novelName";
		[IO.Directory]::CreateDirectory($dstDir );

		Copy-Item -Path "$srcDir\index.html" -Destination $dstDir -Force;
		Copy-Item -Path "$srcDir\$novelName.json" -Destination $dstDir -Force;
		Copy-Item -Path "$srcDir\js" -Destination "$dstDir" -Force -Recurse -Filter "*.js";

		$imageFormat = $novel.config.imageFormat;
		Copy-Item -Path "$srcDir\$imageFormat" -Destination "$dstDir" -Force -Recurse -Filter "*.$imageFormat";

		$audioFormat = $novel.config.audioFormat;
		Copy-Item -Path "$srcDir\$audioFormat" -Destination "$dstDir" -Force -Recurse -Filter "*.$audioFormat";
	}
}

$publisher = New-Object Publisher;
$publisher.Publish($Args[0]);
