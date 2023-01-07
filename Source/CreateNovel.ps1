class Template {

	[void] Generate($debugArgs) {
		$debug = $debugArgs.Length -eq 2;
		if ($debug) {
			$title = $debugArgs[0];
			$dstDir = [IO.Path]::GetFullPath("$($debugArgs[1])\$title");
		}
		else {
			$title = Read-Host "ノベルのフォルダ名を、英数字で入力してください"
			$dstDir = [IO.Path]::GetFullPath("$PSScriptRoot\..\$title");
		}
		[IO.Directory]::CreateDirectory($dstDir);

		$templateDir = "$PSScriptRoot\Template";
		$maiNovelDir = [IO.Path]::GetFullPath("$PSScriptRoot\..");

		Copy-Item -Path "$templateDir\*" -Destination $dstDir -Recurse -Force;
		Copy-Item -Path "$maiNovelDir\Source" -Destination $dstDir -Recurse -Force;
		Copy-Item -Path "$maiNovelDir\Document" -Destination $dstDir -Recurse -Force;
		Copy-Item -Path "$maiNovelDir\README.md" -Destination $dstDir -Force;

		$this.RenameFile("$dstDir\TitlePlaceholder.json", "$dstDir\$title.json");
		$this.RenameFile("$dstDir\TitlePlaceholder.code-workspace", "$dstDir\$title.code-workspace");
		$this.RenameFile("$dstDir\TitlePlaceholder.storyboard.html", "$dstDir\$title.storyboard.html");

		$this.Replace("$dstDir\index.html", "TitlePlaceholder", $title);
		$this.Replace("$dstDir\$title.json", "TitlePlaceholder", $title);
		$this.Replace("$dstDir\$title.code-workspace", "TitlePlaceholder", $title);
		$this.Replace("$dstDir\$title.storyboard.html", "TitlePlaceholder", $title);

		$this.ReplaceNoBOM("$dstDir\.vscode\launch.json", "TitlePlaceholder", $title);
		$this.ReplaceNoBOM("$dstDir\Preview.bat", "TitlePlaceholder", $title);
		$this.ReplaceNoBOM("$dstDir\Publish.bat", "TitlePlaceholder", $title);
		$this.ReplaceNoBOM("$dstDir\GenerateWav.bat", "TitlePlaceholder", $title);
		$this.ReplaceNoBOM("$dstDir\RegenerateWav.bat", "TitlePlaceholder", $title);
		$this.ReplaceNoBOM("$dstDir\ReloadChrome.bat", "TitlePlaceholder", $title);
		$this.ReplaceNoBOM("$dstDir\UpdateStoryboard.bat", "TitlePlaceholder", $title);

		Write-Host "$dstDir がノベル作成環境です。";
		Write-Host "$dstDir を他の場所に移動できます。";
		Write-Host "いずれかのキーを押すと終わります。";
		if (!$debug) { [Console]::ReadKey() | Out-Null; }
	}

	[void] RenameFile($originalPath, $renamePath) {
		if ([IO.File]::Exists($renamePath)) { Remove-Item $renamePath; }
		Rename-Item $originalPath $renamePath;
	}

	[void] Replace($filePath, $placeholder, $value) {
		$content = Get-Content -Path $filePath;
		$content = $content.Replace($placeholder, $value);
		Set-Content -Path $filePath -Value $content -Encoding UTF8 -Force;
	}

	[void] ReplaceNoBOM($filePath, $placeholder, $value) {
		$content = Get-Content -Path $filePath;
		$content = $content.Replace($placeholder, $value);
		$utf8NoBom = New-Object System.Text.UTF8Encoding($False);
		[System.IO.File]::WriteAllLines($filePath, $content, $utf8NoBom);
	}
}

$template = New-Object Template;
$template.Generate($Args);
