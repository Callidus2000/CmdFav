# Changelog

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
