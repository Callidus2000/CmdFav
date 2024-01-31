function Get-CmdFavCache {
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    param (

    )
    $cmdCache = Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()
    if (-not $cmdCache) { $cmdCache = @() }
    # $cmdCache=Get-PSFTaskEngineCache -Module CmdFav -Name 'cache'
    # if($null -eq $cmdCache){
    #     Write-PSFMessage "Initialize ArrayList"
    #     $arrayFromConf=Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()
    #     $cmdCache=[System.Collections.ArrayList]::new()
    #     if(-not [string]::IsNullOrEmpty($arrayFromConf)){
    #         [void]$cmdCache.Add($arrayFromConf)
    #     }
    #     Set-PSFTaskEngineCache -Module CmdFav -Name 'cache' -Value $cmdCache.ToArray()
    # }
    # $cmdCache.add("Hubba")
    Write-PSFMessage "Saved command count=$($cmdCache.count)"
    Write-PSFMessage "type=$($cmdCache.gettype())"
    return $cmdCache
}