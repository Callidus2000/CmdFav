function Import-CmdFav {
    <#
    .SYNOPSIS
        Imports favorite commands from a JSON file and adds them to the cache.

    .DESCRIPTION
        The Import-CmdFav function imports favorite commands from a JSON file and adds them to the cache.
        If the specified file does not exist or contains invalid JSON, an error message is displayed.

    .PARAMETER Path
        Specifies the path to the JSON file containing favorite commands. This parameter is mandatory.

    .EXAMPLE
        Import-CmdFav -Path "C:\Path\To\Favorites.json"

        Imports favorite commands from the specified JSON file and adds them to the cache.
    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, Position = 1)]
        [String]$Path
    )

    # Checking if the specified file exists.
    if (-not (Test-Path -Path $Path -PathType Leaf)) {
        Stop-PSFFunction -Level Error -Message "File not found: $Path"
        return
    }

    # Attempting to import favorite commands from the JSON file.
    try {
        $importedCmds = Get-Content -Path $Path | ConvertFrom-Json
    }
    catch {
        Stop-PSFFunction -Level Error -Message "Failed to import favorite commands from $Path. Invalid JSON format."
        return
    }

    # Saving the imported favorite commands to the cache.
    Set-PSFConfig -Module 'CmdFav' -Name 'History' -Value $importedCmds -AllowDelete -PassThru | Register-PSFConfig -Scope FileUserShared
}
