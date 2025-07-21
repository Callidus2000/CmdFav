Register-PSFTeppScriptblock -Name "CmdFav.Names" -ScriptBlock {
    <#
        .SYNOPSIS
        Provides tab expansion for CmdFav entry names.

        .DESCRIPTION
        Returns a list of CmdFav entry names for tab completion, sorted by name. Each entry includes
        the name as text and the description as a tooltip, or the command line if no description is
        available.

        .EXAMPLE
        # In a parameter that uses TEPP with CmdFav.Names
        # Typing will suggest available CmdFav entry names for completion.
    #>
    try {
        Get-CmdFavCache | Sort-Object -Property name | Select-Object @{name = "Text"; expression = { $_.name } }, @{name = "ToolTip"; expression = {
                if ([string]::IsNullOrWhiteSpace($_.Description)) { return $_.CommandLine }
                $_.Description
            }
        }
    }
    catch {
        return "Error"
    }
}
