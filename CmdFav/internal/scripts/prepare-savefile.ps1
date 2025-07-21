Write-PSFMessage "Checking Save-File"
try{
    $configfileOld = Join-Path (Get-PSFConfigValue -FullName 'CmdFav.HistorySave.Path') (Get-PSFConfigValue -FullName 'CmdFav.HistorySave.File')
    $configFileNew = Get-PSFConfigValue -FullName 'CmdFav.Repository.PERSONALDEFAULT.Path'
    if ((Test-Path $configfileOld) -and -not (Test-Path $configFileNew)){
        Write-PSFMessage "Migrating old configuration file from $configfileOld to $configFileNew" -Level Host
        Import-PSFConfig -Path $configfileOld
        Save-CmdFav
        $backupFile="$($configfileOld)_BAK"
        Write-PSFMessage "Moving old configuration file from $configfileOld to $backupFile" -Level Host
        move-Item -Path $configfileOld -Destination $backupFile -Force
    }
}catch{
    Write-PSFMessage -Level Error -Message "Error while checking Save-File: $($_.Exception.Message)"
    # return
}
Restore-CmdFav
