Register-PSFTeppScriptblock -Name "CmdFav.Names" -ScriptBlock {
    try {
        Get-PSFConfigValue -FullName 'CmdFav.History' | Sort-Object -Property name | Select-Object @{name = "Text"; expression = { $_.name } }, @{name = "ToolTip"; expression = {
                if ([string]::IsNullOrWhiteSpace($_.Description)) { return $_.CommandLine }
                $_.Description
            }
        }
    }
    catch {
        return "Error"
    }
}
