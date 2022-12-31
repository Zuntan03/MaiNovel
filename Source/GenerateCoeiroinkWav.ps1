Add-Type -AssemblyName System.Web;
. $PSScriptRoot\_MaiNovel.ps1;
. $PSScriptRoot\_WavGenerator.ps1;
. $PSScriptRoot\_Coeiroink.ps1;
. $PSScriptRoot\_Storyboard.ps1;
. $PSScriptRoot\_SendKey.ps1;

Write-Host "先に COEIROINKonVOICEVOX.exe を起動してください。"

$hashedWav = $Args[1] -ne "0";
$json = Get-Content -Path $Args[0] | ConvertFrom-Json;
if ($hashedWav) {
	$json.config.imageFormat = "png";
	$json.config.audioFormat = "wav";
}
$novel = New-Object MaiNovel($json);

$wavGenerator = New-Object WavGenerator($novel, (New-Object Coeiroink));
$count = $wavGenerator.Generate([IO.Path]::GetDirectoryName($Args[0]), $hashedWav);
Write-Host "COEIROINK で $($count)個の wav ファイルを生成しました。"

$storyboard = New-Object Storyboard($novel);
$storyboard.GenerateHtml([IO.Path]::ChangeExtension($Args[0], "storyboard.html"), $hashedWav);
$storyboard.GenerateCsv([IO.Path]::ChangeExtension($Args[0], "storyboard.csv"));

# Chrome をフォアグラウンドにできないと動作しない。
if ($hashedWav) { SendKey "chrome" $novel.config.title "{F5}"; }
