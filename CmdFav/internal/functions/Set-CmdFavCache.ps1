function Set-CmdFavCache {
    <#
        .SYNOPSIS
        Sets the CmdFav history cache in the configuration.

        .DESCRIPTION
        Stores the provided history cache ($CmdCache) in the CmdFav module configuration
        under the name 'History'. Overwrites existing values.

        .PARAMETER CmdCache
        The history cache to store.

        .EXAMPLE
        Set-CmdFavCache -CmdCache $myCache
        Stores $myCache as the new history cache in the configuration.
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    param (
        [Parameter(Mandatory)]
        $CmdCache
    )
    Set-PSFConfig -Module 'CmdFav' -Name 'History' -Value ($cmdCache) -AllowDelete # -PassThru | Register-PSFConfig -Scope FileUserShared
}