. $PSScriptRoot\_MaiNovel.ps1;
. $PSScriptRoot\_SendKey.ps1;

$novel = New-Object MaiNovel(Get-Content -Path $Args[0] | ConvertFrom-Json);

# Chrome をフォアグラウンドにできないと動作しない。
SendKey "chrome" $novel.config.title "{F5}";
