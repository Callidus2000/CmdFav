
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
        [string[]]$RepositoryName
    )
    $repos = Get-CmdFavRepository
    if (-not $repos) {
        Write-PSFMessage -Level Warning -Message "No CmdFav repositories registered, nothing to save"
        return
    }
    $cmdCache = @()
    foreach ($repository in $repos) {
        $filePath = $repository.Path
        if ($repository.Name -eq 'PERSONALDEFAULT') {
            $prefix = ''
        }
        else {
            $prefix = "$($repository.Prefix)."
        }

        # $repoCommands = $cmdCache | Where-Object { $_.Repository -eq $repository.Name } | Select-PSFObject -Property @{N = 'Name'; E = {
        #         $_.Name -replace "^$($repository.Prefix)\.", ""
        #     }
        # }, CommandLine, Tag
        # write-PSFMessage -Level Verbose -Message "Saving $($repoCommands.count) favorites with prefix '$($repository.Prefix)' to CmdFav repository '$($repository.Name)' to file '$filePath'"
        if(-not (Test-Path -Path $filePath)) {
            Write-PSFMessage -Level Warning -Message "File '$filePath' does not exist, skipping repository '$($repository.Name)'"
            continue
        }
        Invoke-PSFProtectedCommand -Action "Restoring favorites with prefix '$($repository.Prefix)' from CmdFav repository '$($repository.Name)' file '$filePath'" -ScriptBlock {
            $cmdCache += [array] (import-PSFClixml -Path $filePath | select-PSFObject -Property @{Name = 'Name'; Expression = { "$Prefix$($_.Name)" } }, CommandLine, Tag, @{Name = 'Repository'; Expression = { $repository.Name } })
        }
    }
    Set-PSFConfig -Module 'CmdFav' -Name 'History' -Value ($cmdCache) -AllowDelete # -PassThru | Register-PSFConfig -Scope FileUserShared
}
