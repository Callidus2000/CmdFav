﻿<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'CmdFav' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

Set-PSFConfig -Module 'CmdFav' -Name 'Import.DoDotSource' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be dotsourced on import. By default, the files of this module are read as string value and invoked, which is faster but worse on debugging."
Set-PSFConfig -Module 'CmdFav' -Name 'Import.IndividualFiles' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be imported individually. During the module build, all module code is compiled into few files, which are imported instead by default. Loading the compiled versions is faster, using the individual files is easier for debugging and testing out adjustments."
Set-PSFConfig -Module 'CmdFav' -Name 'History' -Value @() -Initialize -Description "Storage of the saved history" -AllowDelete
Set-PSFConfig -Module 'CmdFav' -Name 'HistorySave.Path' -Value "$($env:AppData)\PowerShell\PSFramework\Config" -Initialize -Validation string -Description "DEPRECATED: Where should the history be saved?"
Set-PSFConfig -Module 'CmdFav' -Name 'HistorySave.File' -Value "cmdfav.json" -Initialize -Validation string -Description "DEPRECATED: Where should the history be saved?"
Set-PSFConfig -Module 'CmdFav' -Name 'Repository.PERSONALDEFAULT.Path' -Value "$($env:AppData)\PowerShell\PSFramework\Config\cmdfav.xml" -Initialize -Validation string -Description "Where should the history be saved by Default?"

