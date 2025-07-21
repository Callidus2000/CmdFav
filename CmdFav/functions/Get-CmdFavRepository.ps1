function Get-CmdFavRepository {
    <#
        .SYNOPSIS
        Retrieves CmdFav repository information from the configuration.

        .DESCRIPTION
        Returns a list of CmdFav repositories registered in the configuration, including their
        name, path, prefix, and priority. You can filter by repository name.

        .PARAMETER Name
        The name(s) of the repository or repositories to retrieve. If omitted, all repositories
        are returned.

        .EXAMPLE
        Get-CmdFavRepository
        Returns all registered CmdFav repositories.

        .EXAMPLE
        Get-CmdFavRepository -Name "myRepo"
        Returns information for the repository named "myRepo".
    #>
    [CmdletBinding()]
    param (
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.RepoNames")]
        [Parameter(Mandatory = $false, ParameterSetName = 'addOnRepo')]
        [string[]]$Name
    )
    $repoConfig = Get-PSFConfig -Module CmdFav -Name "Repository.*"
    $repoNames = $repoConfig.Name -replace 'Repository\.([^\.]+)\..*', '$1' | Select-Object -Unique
    if ($Name) {
        $repoNames = $repoNames | Where-Object { $Name -contains $_ }
    }
    Write-PSFMessage -Level Verbose -Message "Found CmdFav repositories: $($repoNames -join ', ')"
    foreach ($repoName in $repoNames) {
        $resultHash = @{name = $repoName }
        'Path', 'Prefix', 'Priority' | ForEach-Object {
            $resultHash[$_] = $repoConfig | Where-Object name -eq "Repository.$repoName.$_" | select-object -ExpandProperty value
        }
        [PSCustomObject]$resultHash
    }
}