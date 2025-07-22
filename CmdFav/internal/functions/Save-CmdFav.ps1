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
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
    )
    # Update-CmdFavRepositoryMapping
    $repos = Get-CmdFavRepository
    if (-not $repos) {
        Write-PSFMessage -Level Warning -Message "No CmdFav repositories registered, nothing to save"
        return
    }
    # $cmdCache = Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()
    $cmdCache = Get-CmdFavCache
    foreach ($repository in $repos) {
        $filePath = $repository.Path
        $repoCommands = $cmdCache | Where-Object { $_.Repository -eq $repository.Name } | Select-PSFObject -Property Name, CommandLine, Tag
        Invoke-PSFProtectedCommand -Action "Saving $($repoCommands.count) favorites to CmdFav repository '$($repository.Name)' to file '$filePath'" -ScriptBlock {
            write-PSFMessage -Level Verbose -Message "Saving $($repoCommands.count) favorites to CmdFav repository '$($repository.Name)' to file '$filePath'"
            Write-PSFMessage -Level Verbose -Message ">>>Command Names '$($repoCommands.Name -join ', ')'"
            $repoCommands | Export-PSFClixml -Path $filePath
        }

    }
    return
    $configfile = Join-Path (Get-PSFConfigValue -FullName 'CmdFav.HistorySave.Path') (Get-PSFConfigValue -FullName 'CmdFav.HistorySave.File')
    Write-PSFMessage "Saving CmdFav History Cache to $configfile"
    Invoke-PSFProtectedCommand -Action "Saving CmdFav History Cache to $configfile" -ScriptBlock {
        Get-PSFConfig -Module 'CmdFav' -Name 'History' | Export-PSFConfig -OutPath $configfile
    }
}
