﻿
function Restore-CmdFav {
    <#
    .SYNOPSIS
        Restores the CmdFav history cache from a specified configuration file.

    .DESCRIPTION
        The Restore-CmdFav function restores the CmdFav history cache from a configuration file.
        The path and filename for the configuration file are determined by the CmdFav module settings.

    .EXAMPLE
        Restore-CmdFav
    #>
    [CmdletBinding()]
    param (

    )
    $configfile = Join-Path (Get-PSFConfigValue -FullName 'CmdFav.HistorySave.Path') (Get-PSFConfigValue -FullName 'CmdFav.HistorySave.File')
    if (Test-Path $configfile){
        Invoke-PSFProtectedCommand -Action "Importing pre-existing configuration from $configfile" -ScriptBlock {
            Import-PSFConfig -Path $configfile
        }
    }else{
        Write-PSFMessage "Not Loading CmdFav History Cache from $configfile as the file does not exist"
    }
}