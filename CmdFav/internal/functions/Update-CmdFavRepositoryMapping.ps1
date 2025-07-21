function Update-CmdFavRepositoryMapping {
<#
    .SYNOPSIS
        Updates the repository mapping for stored CmdFav favorites based on current repository
        configurations.

    .DESCRIPTION
        This function iterates through all registered CmdFav repositories and assigns each stored
        favorite to the appropriate repository based on its prefix. The mapping is saved in the CmdFav
        history. If no repositories or favorites are present, the function exits with a warning.

    .EXAMPLE
        Update-CmdFavRepositoryMapping
        Updates the repository mapping for all stored favorites.

    .INPUTS
        None.

    .OUTPUTS
        None. The function updates the configuration internally.

    .LINK
        Get-CmdFavRepository

    .LINK
        Set-PSFConfig
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    param (
    )
    Write-PSFMessage -Level Verbose -Message "Updating CmdFav repository mapping"
    $repos = Get-CmdFavRepository | Sort-Object -Property Priority
    if ($null -eq $repos) {
        Stop-PSFFunction -Level Warning -Message "No CmdFav repositories registered"
        return
    }
    $cmdCache = Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()
    if (-not $cmdCache) {
        Stop-PSFFunction -Level Warning -Message "No favorite commands stored"
        return
    }
    $cmdCache = $cmdCache | select-PSFObject -Property Name, CommandLine, Tag, @{Name = 'Repository'; Expression = {
            foreach ($repo in $repos) {
                if ($_.Name -like "$($repo.Prefix)*") {
                    Write-PSFMessage -Level Verbose -Message "Assigning favorite '$($_.Name)' to repository '$($repo.Name)' regarding prefix '$($repo.Prefix)'" -FunctionName 'Update-CmdFavRepositoryMapping'
                    return $repo.Name
                }
            }
        }
    }
    Set-PSFConfig -Module 'CmdFav' -Name 'History' -Value ($cmdCache) -AllowDelete
}