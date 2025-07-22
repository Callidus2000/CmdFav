Register-PSFTeppScriptblock -Name "CmdFav.RepoNames" -ScriptBlock {
    <#
        .SYNOPSIS
        Provides tab expansion for CmdFav repository names except 'PERSONALDEFAULT'.

        .DESCRIPTION
        Returns a list of CmdFav repository names (excluding 'PERSONALDEFAULT') for tab completion,
        sorted by name. Each entry includes the repository name as text and the path as a tooltip,
        if available.

        .EXAMPLE
        # In a parameter that uses TEPP with CmdFav.RepoNames
        # Typing will suggest available repository names for completion.
    #>
    try {
        Get-CmdFavRepository | Sort-Object -Property name | Select-Object @{name = "Text"; expression = { $_.name } }, @{name = "ToolTip"; expression = {
                if ([string]::IsNullOrWhiteSpace($_.path)) { return $_.Name }
                $_.path
            }
        }
    }
    catch {
        return "Error"
    }
}
