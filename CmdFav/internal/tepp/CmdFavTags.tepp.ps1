Register-PSFTeppScriptblock -Name "CmdFav.Tags" -ScriptBlock {
    try {
        Get-PSFConfigValue -FullName 'CmdFav.History' | Select-Object -ExpandProperty Tag | Select-Object -Unique
        #@{name = "Text"; expression = { $_.name } }, @{name = "ToolTip"; expression = { $_.CommandLine } }
    }
    catch {
        return "Error"
    }
}
