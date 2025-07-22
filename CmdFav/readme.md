# PSFModule guidance

## Repository Assignment

Favorites (CmdFavs) can be assigned to repositories manually using the `-Repository` parameter when adding or moving entries.

### Assign a favorite to a repository
```powershell
Add-CmdFav -Name "MyFav" -CommandLine "Get-Process" -Repository "PERSONALDEFAULT"
```

### Move a favorite to another repository
```powershell
Move-CmdFav -Name "MyFav" -Repository "TeamRepo"
```

### Copy a favorite to another repository under a new name
```powershell
Copy-CmdFav -Name "MyFav" -NewName "MyFavCopy" -Repository "TeamRepo"
```

## Function Overview

- Add-CmdFav: Add a new favorite to a repository
- Edit-CmdFav: Edit an existing favorite
- Remove-CmdFav: Remove a favorite
- Copy-CmdFav: Duplicate a favorite under a new name in any repository
- Move-CmdFav: Move a favorite to another repository
- Register-CmdFavRepository: Register a new repository
- Unregister-CmdFavRepository: Remove a repository
- Get-CmdFav: List all favorites
- Get-CmdFavRepository: List all repositories

## Path Warning

> If you want your module to be compatible with Linux and MacOS, keep in mind that those OS are case sensitive for paths and files.

`Import-ModuleFile` is preconfigured to resolve the path of the files specified, so it will reliably convert weird path notations the system can't handle.
Content imported through that command thus need not mind the path separator.
If you want to make sure your code too will survive OS-specific path notations, get used to using `Resolve-path` or the more powerful `Resolve-PSFPath`.