function Restore-CmdFav {
    <#
        .SYNOPSIS
        Restores the CmdFav history cache from registered repository configuration files.

        .DESCRIPTION
        The Restore-CmdFav function restores the CmdFav history cache from all configured
        CmdFav repositories. The path and filename for each repository are determined by the
        CmdFav module settings. You can choose to replace the current cache or append to it.

        .PARAMETER Mode
        Determines whether to replace the current cache ('Replace') or append new entries
        while keeping existing ones ('Append'). Default is 'Replace'.

        .EXAMPLE
        Restore-CmdFav
        Restores the CmdFav history cache from all registered repositories, replacing the current cache.

        .EXAMPLE
        Restore-CmdFav -Mode Append
        Restores the CmdFav history cache and appends new entries, keeping existing commands.
    #>
    [CmdletBinding()]
    param (
        [ValidateSet('Replace','Append')]
        [string]$Mode = 'Replace'
    )
    $repos = Get-CmdFavRepository
    if (-not $repos) {
        Write-PSFMessage -Level Warning -Message "No CmdFav repositories registered, nothing to save"
        return
    }
    $cmdCache = @()
    $oldCommandCache=Get-CmdFavCache
    foreach ($repository in $repos) {
        $filePath = $repository.Path

        if(-not (Test-Path -Path $filePath)) {
            Write-PSFMessage -Level Warning -Message "File '$filePath' does not exist, skipping repository '$($repository.Name)'"
            continue
        }
        Invoke-PSFProtectedCommand -Action "Restoring favorites from CmdFav repository '$($repository.Name)' file '$filePath'" -ScriptBlock {
            $cmdCache += [array] (import-PSFClixml -Path $filePath | select-PSFObject -Property Name, CommandLine,Description, Tag, @{Name = 'Repository'; Expression = { $repository.Name } })
        }
    }

    if($Mode -eq 'Append') {
        $missingOldCommands = $oldCommandCache | Where-Object { $_.name -notin $cmdCache.Name }
        if ($missingOldCommands) {
            Write-PSFMessage -Level Verbose -Message "Keeping existing Commands '$($missingOldCommands.name -join ',')'"
            $cmdCache += $oldCommandCache
        }
    }
    Set-CmdFavCache -cmdCache $cmdCache
    # Update-CmdFavRepositoryMapping
}
