@{
	# Script module or binary module file associated with this manifest
	RootModule = 'CmdFav.psm1'

	# Version number of this module.
	ModuleVersion = '2.0.0'

	# ID used to uniquely identify this module
	GUID = '7608a40d-981d-440d-b140-1ce3c4033cf5'

	# Author of this module
	Author = 'Sascha Spiekermann'

	# Company or vendor of this module
	CompanyName = 'MyCompany'

	# Copyright statement for this module
	Copyright = 'Copyright (c) 2024 Sascha Spiekermann'

	# Description of the functionality provided by this module
	Description = 'Helper for storing and accessing favorite/commonly used commands/scriptblocks'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'

	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		@{ ModuleName='PSFramework'; ModuleVersion='1.9.310' }
	)

	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\CmdFav.dll')

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\CmdFav.Types.ps1xml')

	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @('xml\CmdFav.Format.ps1xml')

	# Functions to export from this module
	FunctionsToExport = @(
		'Add-CmdFav'
		'Edit-CmdFav'
		'Export-CmdFav'
		'Get-CmdFav'
		'Get-CmdFavCache'
		'Get-CmdFavRepository'
		'Import-CmdFav'
		'Register-CmdFavRepository'
		'Remove-CmdFav'
		'UnRegister-CmdFavRepository'
	)

	# Cmdlets to export from this module
	CmdletsToExport = ''

	# Variables to export from this module
	VariablesToExport = ''

	# Aliases to export from this module
	AliasesToExport = @(
		'acf'
		'gcf'
	)

	# List of all modules packaged with this module
	ModuleList = @()

	# List of all files packaged with this module
	FileList = @()

	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{

		#Support for PowerShellGet galleries.
		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags       = @('snippet', 'bookmark', 'favorite', 'command')

			# A URL to the license for this module.
			LicenseUri = 'https://github.com/Callidus2000/CmdFav/blob/master/LICENSE'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/Callidus2000/CmdFav/'

			# A URL to an icon representing this module.
			# IconUri = ''

			# ReleaseNotes of this module
			ReleaseNotes = @"
# Changelog
## 1.0.1 (2024-02-02)
 - Fixed handling of multiline commands
## 1.0.0 (2024-01-31)
 - First release
"@

		} # End of PSData hashtable

	} # End of PrivateData hashtable
}