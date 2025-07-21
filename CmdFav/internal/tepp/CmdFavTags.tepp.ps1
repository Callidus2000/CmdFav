Register-PSFTeppScriptblock -Name "CmdFav.Tags" -ScriptBlock {
    <#
        .SYNOPSIS
        Provides tab expansion for CmdFav tags.

        .DESCRIPTION
        Returns a unique list of tags from the CmdFav history cache for tab completion.

        .EXAMPLE
        # In a parameter that uses TEPP with CmdFav.Tags
        # Typing will suggest available tags for completion.
    #>
    try {
        Get-PSFConfigValue -FullName 'CmdFav.History' | Select-Object -ExpandProperty Tag | Select-Object -Unique
        #@{name = "Text"; expression = { $_.name } }, @{name = "ToolTip"; expression = { $_.CommandLine } }
    }
    catch {
        return "Error"
    }
}
