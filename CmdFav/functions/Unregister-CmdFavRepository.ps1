function UnRegister-CmdFavRepository {
    <#
        .SYNOPSIS
        Unregisters a CmdFav repository by name.

        .DESCRIPTION
        Removes the specified CmdFav repository from the configuration. Optionally keeps the
        repository's entries in the CmdFav cache or restores the cache from remaining repositories.

        .PARAMETER Name
        The name of the CmdFav repository to unregister.

        .PARAMETER KeepEntries
        If specified, keeps the entries from the repository in the CmdFav cache. Otherwise, restores
        the cache from the remaining repositories.

        .EXAMPLE
        UnRegister-CmdFavRepository -Name "myRepo"
        Unregisters the repository named "myRepo" and restores the cache from remaining repositories.

        .EXAMPLE
        UnRegister-CmdFavRepository -Name "myRepo" -KeepEntries
        Unregisters the repository named "myRepo" but keeps its entries in the CmdFav cache.
    #>
    [CmdletBinding()]
    param (
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.RepoNames")]
        [Parameter(Mandatory, ParameterSetName = 'removeRepo')]
        [string]$Name,
        [switch]$KeepEntries
    )
    $repo = Get-CmdFavRepository -Name $Name
    if (-not $repo) {
        Write-PSFMessage -Level Warning -Message "No CmdFav repository with name '$Name' registered, nothing to remove"
        return
    }
    Write-PSFMessage -Level Host -Message "UnRegistering CmdFav repository '$Name' with Path '$($repo.Path)'"
    $repoConfig = Get-PSFConfig -Module CmdFav -Name "Repository.$Name.*"
    $repoConfig | Unregister-PSFConfig -Scope UserDefault
    $repoConfig | Set-PSFConfig -AllowDelete
    $repoConfig | Remove-PSFConfig -Confirm:$false
    if ($KeepEntries) {
        Save-cmdFav
    }
    else {
        Restore-CmdFav
    }
}