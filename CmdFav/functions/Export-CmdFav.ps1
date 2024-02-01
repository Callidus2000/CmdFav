
function Export-CmdFav {
    <#
    .SYNOPSIS
        Exports favorite commands to a JSON file.

    .DESCRIPTION
        The Export-CmdFav function exports the cache of favorite commands to a JSON file specified by the Path parameter.
        If no favorite commands are stored, a warning message is displayed, and the function returns.

    .PARAMETER Path
        Specifies the path to the JSON file where favorite commands will be exported. This parameter is mandatory.

    .EXAMPLE
        Export-CmdFav -Path "C:\Path\To\Favorites.json"

        Exports the cache of favorite commands to the specified JSON file.

    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, Position = 1)]
        [String]$Path
    )

    # Retrieving the favorite commands cache.
    $cmdCache = Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()

    # Handling the case where no favorite commands are stored.
    if (-not $cmdCache) {
        Stop-PSFFunction -Level Warning -Message "No favorite commands stored"
        return
    }

    # Converting favorite commands to JSON and exporting to the specified path.
    $cmdCache | ConvertTo-Json | Out-File $Path
}

# Define an alias for Export-CmdFav
Set-Alias -Name "Export-Favorite" -Value "Export-CmdFav"
