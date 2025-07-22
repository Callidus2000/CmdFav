function Remove-CmdFav {
    <#
    .SYNOPSIS
        Removes a favorite command from the cache based on the specified name.

    .DESCRIPTION
        The Remove-CmdFav function allows you to remove a favorite command from the cache based on the specified name.
        The favorite commands are stored in a cache, and this function removes the command line associated with the provided name.

    .PARAMETER Name
        Specifies the name of the favorite command to retrieve. This parameter is mandatory.

    .EXAMPLE
        Remove-CmdFav -Name "MyFavorite"

        Removes the command line associated with the favorite named "MyFavorite" from the cache.

    .NOTES


    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, Position = 1)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.Names")]
        [string]$Name
    )

    # Retrieving the favorite commands cache.
    Restore-CmdFav
    # $cmdCache = Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()
    $cmdCache = Get-CmdFavCache

    # Handling the case where no favorite commands are stored.
    if (-not $cmdCache) {
        Stop-PSFFunction -Level Warning -Message "No favorite commands stored"
        return
    }

    # Removes the command line for the specified favorite name.
    $cmdCache = $cmdCache | Where-Object name -ne $Name
    Set-CmdFavCache -CmdCache $cmdCache
    # Set-PSFConfig -Module 'CmdFav' -Name 'History' -Value ($cmdCache) -AllowDelete # -PassThru | Register-PSFConfig -Scope FileUserShared
    Save-CmdFav
}
