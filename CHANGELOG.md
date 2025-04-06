## [1.0.3] - [2025-04-06]

### Added
- additional functionality for New-AMCard

### Fixed
- New-AMTimeInput - Added warning "This function is not supported in all outlook clients. Currently only supported in Outlook on the web."
- New-AMCard - Fixed versions to use for improved reliability in diffrent outlook clients
- ConvertFrom-AMCard Originator ID missing from card
- ConvertFrom-AMCard image missing from card
- ConvertFrom-AMCard factset missing from card
- ConvertFrom-AMCard added generated id to New-AMColumnSet
- Add-AMElement added new function "Find-AMContainer" for better consistency in managing containers recursively.

### Feature
- New-AMImage Style parameter to function to allow to set avatar default = default
- New-AMContainer more options for parameter Padding valid options is now "None", "Small", "Default", "Medium", "Large", "ExtraLarge", "Custom"
- New-AmContainer parameter option Custom in $Padding and added $CustomPadding options example @{ top = "None"; bottom = "Large"; left = "Small"; right = "Small"}
- New-AMExecuteAction IsPrimary parameter to function to allow to set primary positive style on button


## [1.0.2] - [2025-03-24]

### Added
- New cmdlet
- - ConvertFrom-AMJson (Lets you convert a json card into code that can be used by the module to create the same card. Should make it easier to get started and maybe convert existing json cards)
- Auto generated documentation which can be found here "https://mynster9361.github.io/modules/actionablemessages/"
- Release Drafter
- Pester tests

### Fixed
- Github Workflows


## [1.0.1] - [2025-03-19]

### Fixed
- PSGallery Links to github repo

## [1.0.0] - [2025-03-18]

### Added
- Initial release
- New-AMCard cmdlet
- Add-AMElement cmdlet
- Export-AMCard cmdlet
- Export-AMCardForEmail cmdlet
- New-AMTextBlock cmdlet
- New-AMImage cmdlet
- New-AMChoice cmdlet
- New-AMContainer cmdlet
- New-AMColumnSet cmdlet
- New-AMColumn cmdlet
- New-AMFactSet cmdlet
- New-AMFact cmdlet
- New-AMImageSet cmdlet
- New-AMActionSet cmdlet
- New-AMOpenUrlAction cmdlet
- New-AMShowCardAction cmdlet
- New-AMToggleVisibilityAction cmdlet
- New-AMExecuteAction cmdlet
- New-AMTextInput cmdlet
- New-AMNumberInput cmdlet
- New-AMDateInput cmdlet
- New-AMTimeInput cmdlet
- New-AMToggleInput cmdlet
- New-AMChoiceSetInput cmdlet

