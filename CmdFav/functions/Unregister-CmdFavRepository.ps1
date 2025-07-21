function UnRegister-CmdFavRepository {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'removeRepo')]
        [string]$Name
    )
    $repo = Get-CmdFavRepository -Name $Name
    if (-not $repo) {
        Write-PSFMessage -Level Warning -Message "No CmdFav repository with name '$Name' registered, nothing to remove"
        return
    }
    Write-PSFMessage -Level Host -Message "UnRegistering CmdFav repository '$Name' with Path '$($repo.Path)' and prefix '$($repo.Prefix)'"
    $repoConfig = Get-PSFConfig -Module CmdFav -Name "Repository.$Name.*"
    $repoConfig | Unregister-PSFConfig -Scope UserDefault
    $repoConfig | Remove-PSFConfig -Confirm:$false
}