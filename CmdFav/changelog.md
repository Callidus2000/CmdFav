# Changelog

## 2.0.0 (2024-06-13)
- Major: Introduced repository feature for favorites
    - Favorites can now be organized into multiple repositories, each with its own file, prefix, and priority
    - Register, unregister, and list repositories with new cmdlets
    - Favorites are automatically assigned to repositories based on their prefix (e.g., "Work.")
    - Repository XML files can be shared via fileshares for team collaboration
    - Existing favorites are reassigned when registering new repositories
    - All favorites without a specific prefix remain in the default repository
- Added help blocks to all internal and public functions
- Updated README with repository usage and sharing instructions
- Minor bugfixes and code cleanup

## 1.2.4 (2025-06-12)
- Fixed bug where `Import-CmdFav` did not save correctly

## 1.2.3 (2024-02-09)
- `Add-CmdFav -Name` now supports Tab Completion

## 1.2.2 (2024-02-05)
- Fixed issue where `Edit/Remove-CmdFav` saved incorrectly
- Fixed warning message when config file does not exist

## 1.2.0 (2024-02-05)
- History is now manually saved into a JSON file
- Existing file is reloaded before adding a new entry
- Module now works across multiple windows/sessions in parallel

## 1.1.0 (2024-02-05)
- Added the `-Id` parameter to `Add-CmdFav`

## 1.0.1 (2024-02-02)
- Fixed handling of multiline commands
- Code cleanup

## 1.0.0 (2024-01-31)
- Initial release
- First caching steps
- Injection functionality added
- Export/Import functionality added
- Switched from `Publish-Module` to `Publish-PSResource`
- Added meta tags
- README.md created and updated
- Added demo animated GIF
