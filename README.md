<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPLv3 License][license-shield]][license-url]


# CmdFav PowerShell Module

CmdFav is a PowerShell module designed to help you manage and organize your favorite commands efficiently. It provides cmdlets for adding, editing, exporting, and importing favorite commands, allowing you to streamline your command-line experience. By this it provides kind of bookmarking system for everyday snippets in the commandline.

![movingExample](media/cmdfav.gif)

## Features

- **Add-CmdFav:** Add your frequently used commands to a cache with custom names, tags, and descriptions.
- **Edit-CmdFav:** Modify properties of existing favorite commands, such as command line, tags, descriptions, and even rename them.
- **Export-CmdFav:** Export your favorite commands to a JSON file for backup or sharing.
- **Import-CmdFav:** Import favorite commands from a JSON file and integrate them into your cache.
- **Multiple Repositories:** Organize your favorites into multiple repositories, each with its own file. Easily register, unregister, and switch between repositories.

## Installation from the PowerShell Gallery

```powershell
# Install the CmdFav module from the PowerShell Gallery
Install-Module -Name CmdFav -Scope CurrentUser
```

## Usage
**Important first words!**
Even this should be obvious: **NEVER** use the module to save something secret! Everyone who gets access to the cache file can read everything in it! So instead of saving an API access token or a password save a multiline command which retrieves the secret from something like a SecretManagement Vault.

### Add a Favorite Command to the favorite System:
```PowerShell
# Directly add the command
Add-CmdFav -Name "MyFavorite" -CommandLine "Get-Process" -Tag "Monitoring"

# Take the last used command from the history
(Get-ADForest).domains|% {Get-ADUser -server $_ -filter {mail -like '*company.com'} -Properties mail}|select UserPrincipalName,name,mail
Add-CmdFav -Name Example.AllADMailAddresses -LastCommand -Description "Get all users with their mail addresses from all forest domains"

# Build a multiline command from the last 4 commands in the history
Get-History -Count 4|Add-CmdFav -Name Example.MultiLine
```

### Recall stored commands
```PowerShell
Get-CmdFav -Name Example.AllADMailAddresses

#Shorter
gcf Example.AllADMailAddresses

#Opens a GridView for selecting the command
Get-CmdFav
```

### Edit an Existing Favorite Command
```PowerShell
Edit-CmdFav -Name "MyFavorite" -CommandLine "Get-Service -Status Running" -Tag "Service" -Description "List running services"
```

### Export Favorite Commands
```PowerShell
Export-CmdFav -Path "C:\Path\To\Favorites.json"
```

### Import Favorite Commands
```PowerShell
Import-CmdFav -Path "C:\Path\To\Favorites.json"
```

### Manage Repositories


You can organize your favorites into multiple repositories, each with its own file. Assignment to repositories is now manual using the `-Repository` parameter.

> **Repository Feature:**  
> The repository feature allows you to easily share script blocks with colleagues.  
> Simply place the associated XML file on a file share and register it as a repository.  
> When you register a new repository, you can manually assign favorites to it using the `-Repository` parameter.  
> All favorites without explicit repository assignment remain in the default repository.  
> This makes it easy to separate and share favorites between personal and team contexts.

#### Register a new repository
```PowerShell
Register-CmdFavRepository -Name "Work" -Path "\\fileshare\cmdfav\work.xml"
```

#### Register the default repository
```PowerShell
Register-CmdFavRepository -Default -Path "C:\cmdfav\default.xml"
```

#### List all repositories
```PowerShell
Get-CmdFavRepository
```

#### Unregister a repository
```PowerShell
UnRegister-CmdFavRepository -Name "Work"
```

#### Keep entries from a repository after unregistering
```PowerShell
UnRegister-CmdFavRepository -Name "Work" -KeepEntries
```

#### Assign a favorite to a repository
```PowerShell
Add-CmdFav -Name "MyFav" -CommandLine "Get-Process" -Repository "PERSONALDEFAULT"
```

#### Move a favorite to another repository
```PowerShell
Move-CmdFav -Name "MyFav" -Repository "TeamRepo"
```

#### Copy a favorite to another repository under a new name
```PowerShell
Copy-CmdFav -Name "MyFav" -NewName "MyFavCopy" -Repository "TeamRepo"
```


#### Change the save location for the default repository
```PowerShell
Register-CmdFavRepository -Default -Path "C:\Users\MyUser\OneDrive\PowerShell\default.xml"
```

**Attention!** If you have already got commands saved you have to modify something in the cache to get the existing data automatically transferred! Or copy the `cmdfav.json` file from `$($env:AppData)\PowerShell\PSFramework\Config` manually to the new location.

<!-- ROADMAP -->
## Roadmap
New features will be added if any of my scripts need it ;-)

I cannot guarantee that no breaking change will occur as the development follows my internal DevOps need completely. Likewise I will not insert full documentation of all parameters as I don't have time for this copy&paste. Sorry. But major changes which classify as breaking changes will result in an increment of the major version. See [Changelog](FortigateManager\changelog.md) for information regarding breaking changes.

See the [open issues](https://github.com/Callidus2000/CmdFav/issues) for a list of proposed features (and known issues).

If you need a special function feel free to contribute to the project.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**. For more details please take a look at the [CONTRIBUTE](docs/CONTRIBUTING.md#Contributing-to-this-repository) document

Short stop:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## Limitations
* The module works on the ADOM level as this is the only permission set I've been granted
* Maybe there are some inconsistencies in the docs, which may result in a mere copy/paste marathon from my other projects

<!-- LICENSE -->
## License

Distributed under the GNU GENERAL PUBLIC LICENSE version 3. See `LICENSE.md` for more information.



<!-- CONTACT -->
## Contact


Project Link: [https://github.com/Callidus2000/CmdFav](https://github.com/Callidus2000/CmdFav)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [Friedrich Weinmann](https://github.com/FriedrichWeinmann) for his marvelous [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment) and [psframework](https://github.com/PowershellFrameworkCollective/psframework)
* [Joel Bennett](https://github.com/jaykul) for his quick help regarding [How to inject text into the NEXT command prompt](https://gist.github.com/Jaykul/7dee4f47a61616fde6858ca960743fd5)





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Callidus2000/CmdFav.svg?style=for-the-badge
[contributors-url]: https://github.com/Callidus2000/CmdFav/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Callidus2000/CmdFav.svg?style=for-the-badge
[forks-url]: https://github.com/Callidus2000/CmdFav/network/members
[stars-shield]: https://img.shields.io/github/stars/Callidus2000/CmdFav.svg?style=for-the-badge
[stars-url]: https://github.com/Callidus2000/CmdFav/stargazers
[issues-shield]: https://img.shields.io/github/issues/Callidus2000/CmdFav.svg?style=for-the-badge
[issues-url]: https://github.com/Callidus2000/CmdFav/issues
[license-shield]: https://img.shields.io/github/license/Callidus2000/CmdFav.svg?style=for-the-badge
[license-url]: https://github.com/Callidus2000/CmdFav/blob/master/LICENSE

