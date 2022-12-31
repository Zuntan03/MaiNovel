. $PSScriptRoot\_MaiNovel.ps1;

class Storyboard {
	$novel;

	Storyboard($novel) { $this.novel = $novel; }

	[void] GenerateHtml($path, $hashedWav) {
		$dir = [IO.Path]::GetDirectoryName($path);
		$templatePath = "$PSScriptRoot\_StoryboardTemplate.html"
		$template = Get-Content -Path $templatePath;

		$config = $this.novel.config;
		$template = $template.Replace("#novelNamePlaceholder", $config.title);

		$data = "`r`n";

		$data += "`t<ul>`r`n";
		foreach ($scene in $this.novel.scenes) {
			$data += "`t`t<li><a href=`"#$($scene.code)`">$($scene.code) $($scene.name)</a></li>`r`n";
		}
		$data += "`t</ul>`r`n";

		foreach ($scene in $this.novel.scenes) {
			$sStr = "`t<h2 id=`"$($scene.code)`">$($scene.code) $($scene.name)</h2>`r`n`t<table>`r`n";
			foreach ($message in $scene.messages) {
				$mStr = "`t`t<tr>`r`n`t`t`t<td>$($scene.code)<br>$($message.code)</td>`r`n`t`t`t<td>";

				$mStr += "<audio controls id=`"$($message.name)`" " +
				"src=`"$($message.GetWavPath($hashedWav))`"`r`n";

				$mStr += "`t`t`t`tonended=`"setTimeout(function(){ " +
				"window.maiNovelEnded('$($message.name)', '$($message.next.name)'); }, " +
				"$($message.audioInterval));`">`r`n`t`t`t`t</audio>";

				if (Test-Path -Path "$dir\$($message.imagePath)") {
					$mstr += "<br><img src=`"./$($message.imagePath)`" style=`"display:none;`">";
				}

				$mStr += "</td>`r`n";
				$mStr += "`t`t`t<td>$($message.insertHTML)$($message.text)</td>`r`n";
				$mstr += "`t`t</tr>`r`n";
				$sStr += $mStr;
			}
			$sStr += "`t</table>`r`n";
			$data += $sStr;
		}

		$data += "`t<p style=`"text-align: center;`"><small>$($config.credit)</small></p>`r`n"

		$template = $template.Replace("#data", $data);
		Set-Content -Path $path -Value $template -Encoding UTF8;
	}

	[void] GenerateCsv($path) {
		$data = @();
		foreach ($scene in $this.novel.scenes) {
			foreach ($message in $scene.messages) {
				$data += [pscustomobject]@{
					scene     = "$($scene.code) $($scene.name)";
					name      = $message.name;
					voiceName = $message.voice.name;
					text      = $message.text;
				};
			}
		}

		$data | Export-Csv -path $path -Encoding UTF8 -NoTypeInformation;
	}
}
