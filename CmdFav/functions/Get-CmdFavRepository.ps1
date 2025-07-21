function Get-CmdFavRepository {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ParameterSetName = 'addOnRepo')]
        [string]$Name
    )
    $repoConfigName = [string]::IsNullOrEmpty($name)? "Repository*" : "Repository.$Name.*"
    $repoConfig = Get-PSFConfig -Module CmdFav -Name $repoConfigName
    $repoNames = $repoConfig.Name -replace 'Repository\.([^\.]+)\..*', '$1' | Select-Object -Unique
    Write-PSFMessage -Level Verbose -Message "Found CmdFav repositories: $($repoNames -join ', ')"
    foreach ($repoName in $repoNames) {
        $resultHash=@{name=$repoName}
        'Path', 'Prefix','Priority' | ForEach-Object {
            $resultHash[$_] = $repoConfig | Where-Object name -eq "Repository.$repoName.$_" | select-object -ExpandProperty value
        }
        [PSCustomObject]$resultHash
    }
}