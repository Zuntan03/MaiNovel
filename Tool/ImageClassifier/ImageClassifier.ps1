<#
Tagger の Batch from directoryの設定
Output filename format: [name].[output_extension]
Action on exiting caption: 末尾に加える（Wife と Deepdanbooru の両方を使う場合）
Interrogator: wd14-convnext や deepdanbooru-v3-20211112-sdg-e28
しきい値: 0.0001
マッチしたタグの信頼度を結果に含める: 有効
アンダースコアの代わりにスペースを使用する: 有効
#>

function ClassifyImages($classifier) {
	# フォルダ名、タグ名、しきい値の順で、分類を指定します。

	# 同じタグをより厳しい精度とゆるい精度に分けたい場合は、
	# 第一引数のフォルダ名を変えつつ、厳しい精度から先に振り分けます。
	$scale = 1.0;

	$classifier.CheckTagGt("bad hands+", "bad hands", $scale * 0.001);
	$classifier.CheckTagGt("bad hands", "bad hands", $scale * 0.0003);

	$classifier.CheckTagGt("bad feet+", "bad feet", $scale * 0.001);
	$classifier.CheckTagGt("bad feet", "bad feet", $scale * 0.0003);

	$classifier.CheckTagGt("bad anatomy+", "bad anatomy", $scale * 0.002);
	$classifier.CheckTagGt("bad anatomy", "bad anatomy", $scale * 0.001);

	$classifier.CheckTagGt("pussy", "pussy", $scale * 0.1);
}

class Image {
	$txtPath;
	$pngPath;
	$tags = @{};
	$copied = $false;

	Image($txtPath) {
		$this.txtPath = $txtPath;
		$this.pngPath = [IO.Path]::ChangeExtension($txtPath, "png");

		$txt = [IO.File]::ReadAllText($txtPath);
		$tagStrs = $txt.Split(',');

		foreach ($tagStr in $tagStrs) {
			$openIndex = $tagStr.IndexOf('(') + 1;
			if ($openIndex -eq -1) { continue; }

			$closeIndex = $tagStr.LastIndexOf(')');
			if ($closeIndex -eq -1) { continue; }

			$tagStr = $tagStr.Substring($openIndex, $closeIndex - $openIndex);

			$colonIndex = $tagStr.LastIndexOf(':');
			if ($colonIndex -eq -1) { continue; }

			$tagName = $tagStr.Substring(0, $colonIndex);
			$tagValueStr = $tagStr.Substring($colonIndex + 1, $tagStr.Length - ($colonIndex + 1));
			$tagValue = [double]0.0;
			if ([double]::TryParse($tagValueStr, [ref]$tagValue)) {
				$value = [double]$tagValue;

				# 同じタグがすでに存在したら、値の大きい方を残す
				if ($this.tags.ContainsKey($tagName)) {
					if ($this.tags[$tagName] -gt $value) { continue; }
				}
				$this.tags[$tagName] = [double]$tagValue;
			}
		}
	}

	[void] Copy($dstDir) {
		if ($this.copied) { Write-Error "[Error] Copied $($this.txtPath)"; return; }
		$dstPngPath = "$dstDir\$([IO.Path]::GetFileName($this.pngPath))";

		# 元画像を残したくない場合は Move にする
		[IO.File]::Copy($this.pngPath, $dstPngPath, $true);
		$this.copied = $true;
	}
}

class ImageClassifier {
	$dir;
	$images = @();

	[void] Classify($arg) {
		$this.dir = [IO.Path]::GetFullPath($arg);
		$this.images = @();
		$txtPaths = [IO.Directory]::GetFiles($this.dir , "*.txt");
		Write-Host "$($this.dir) $($txtPaths.Length)files";

		foreach ($txtPath in $txtPaths) {
			$image = New-Object Image($txtPath);
			$this.images += $image;
		}

		ClassifyImages($this);

		$cRankDir = "$($this.dir)\other";
		$this.ResetImageDir($cRankDir);
		$copyCount = 0;
		foreach ($image in $this.images) {
			if (!$image.copied) {
				$image.Copy($cRankDir);
				$copyCount++;
			}
		}
		Write-Host ("{0,5} {1,3}%: other" -f $copyCount, [int]($copyCount / $this.images.Length * 100));
	}

	[void] CheckTagGt($dir, $tag, $threshold) {
		$dstDir = "$($this.dir)\$dir";
		$this.ResetImageDir($dstDir);

		$copyCount = 0;
		foreach ($image in $this.images) {
			if ($image.copied) { continue; }
			if (!$image.tags.ContainsKey($tag)) { continue; }

			$tagValue = $image.tags[$tag];
			if ($tagValue -gt $threshold) {
				$image.Copy($dstDir);
				$copyCount++;
			}
		}
		Write-Host ("{0,5} {1,3}%: $tag > $threshold" -f $copyCount, [int]($copyCount / $this.images.Length * 100));
	}

	# Gt 版との違いは if ($tagValue -le $threshold) { と Write-Host ("{0,5}: $tag <= $threshold" のみ
	[void] CheckTagLe($dir, $tag, $threshold) {
		$dstDir = "$($this.dir)\$dir";
		$this.ResetImageDir($dstDir);

		$copyCount = 0;
		foreach ($image in $this.images) {
			if ($image.copied) { continue; }
			if (!$image.tags.ContainsKey($tag)) { continue; }

			$tagValue = $image.tags[$tag];
			if ($tagValue -le $threshold) {
				$image.Copy($dstDir);
				$copyCount++;
			}
		}
		Write-Host ("{0,5}: $tag <= $threshold" -f $copyCount);
	}

	[void] ResetImageDir($dirPath) {
		if ([IO.Directory]::Exists($dirPath)) {
			foreach ($pngPath in [IO.Directory]::EnumerateFiles($dirPath, "*.png")) {
				[IO.File]::Delete($pngPath);
			}
		}
		else {
			[IO.Directory]::CreateDirectory($dirPath);
		}
	}
}

$imageClassifier = New-Object ImageClassifier;
foreach ($arg in $Args) {
	if (![string]::IsNullOrEmpty($arg)) { $imageClassifier.Classify($arg); }
}
