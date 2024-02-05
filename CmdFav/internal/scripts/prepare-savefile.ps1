Write-PSFMessage "Checking Save-File"
$savePath=Get-PSFConfigValue -FullName 'CmdFav.HistorySave.Path'

if (-not (Test-Path $savePath)){
    Write-PSFMessage "Creating configuration directory $savePath"
    New-Item -Path $savePath -ItemType Directory -Force
}
Restore-CmdFav
