function Get-CmdFavHistory {
    [CmdletBinding()]
    param (
    )
    Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()
}