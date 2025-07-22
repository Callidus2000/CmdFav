# Changelog

## 2.2.2 (2025-07-22)
- Various bugfixes and stability improvements
- Improved parameter validation and error handling
- Enhanced documentation and help texts
- Minor UI/UX improvements in command output
- Performance optimizations for repository operations

## 2.1.1 (2025-07-22)
-- Added: Manual assignment of favorites to repositories via parameter
-- Added: Copy-CmdFav function to duplicate favorites under a new name in any repository
-- Added: Move-CmdFav function to move favorites between repositories
-- Added: Parameter validation for repository and name parameters in public functions
-- Improved: Documentation and help texts for repository assignment, copy, and move

## 2.1.0 (2025-07-22)
- Major: Repository assignment is now manual, no longer via prefix
- The attributes Prefix and Priority have been removed
- Existing functions and configurations have been updated accordingly
- README and help texts updated

## 2.0.0 (2024-06-13)
    - Favorites can now be organized into multiple repositories, each with its own file
    - Register, unregister, and list repositories with new cmdlets
    - Repository XML files can still be shared for team collaboration
    - Existing favorites are reassigned when registering new repositories
    - All favorites without explicit repository assignment remain in the default repository
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
