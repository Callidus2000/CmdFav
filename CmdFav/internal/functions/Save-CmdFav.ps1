function Save-CmdFav {
    <#
    .SYNOPSIS
        Saves the CmdFav history cache to a specified configuration file.

    .DESCRIPTION
        The Save-CmdFav function saves the CmdFav history cache to a configuration file.
        The path and filename for the configuration file are determined by the CmdFav module settings.

    .EXAMPLE
        Save-CmdFav

        Saves the CmdFav history cache to the configured file.
    #>
    [CmdletBinding()]
    param (

    )
    $configfile = Join-Path (Get-PSFConfigValue -FullName 'CmdFav.HistorySave.Path') (Get-PSFConfigValue -FullName 'CmdFav.HistorySave.File')
    Write-PSFMessage "Saving CmdFav History Cache to $configfile"
    Invoke-PSFProtectedCommand -Action "Saving CmdFav History Cache to $configfile" -ScriptBlock {
        Get-PSFConfig -Module 'CmdFav' -Name 'History' | Export-PSFConfig -OutPath $configfile
    }
}
