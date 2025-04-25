@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'ActionableMessages.psm1'

    # Version number of this module.
    ModuleVersion     = '1.0.3'

    # ID used to uniquely identify this module
    GUID              = 'd1e5c3f4-5e3b-4c2a-8c3b-5e3b4c2a8c3b'

    # Author of this module
    Author            = 'Morten Mynster'

    # Company or vendor of this module
    CompanyName       = 'Mynster'

    # Copyright statement for this module
    Copyright         = 'Copyright © 2025 Mynster'

    # Description of the functionality provided by this module
    Description       = 'A PowerShell module for creating and managing Actionable Messages.'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = 'New-AMCard', 'Add-AMElement', 'Export-AMCard', 'Export-AMCardForEmail',
    'New-AMTextBlock', 'New-AMImage', 'New-AMChoice', 'New-AMContainer',
    'New-AMColumnSet', 'New-AMColumn', 'New-AMFactSet', 'New-AMFact',
    'New-AMImageSet', 'New-AMActionSet', 'New-AMOpenUrlAction',
    'New-AMShowCardAction', 'New-AMToggleVisibilityAction',
    'New-AMExecuteAction', 'New-AMTextInput', 'New-AMNumberInput',
    'New-AMDateInput', 'New-AMTimeInput', 'New-AMToggleInput',
    'New-AMChoiceSetInput', 'ConvertFrom-AMJson',
    'New-AMNotificationCard', 'New-AMServiceAlertCard',
    'New-AMServerMonitoringCard', 'New-AMServerPurposeSurveyCard',
    'New-AMITResourceRequestCard', 'New-AMApprovalCard',
    'New-AMApplicationUsageSurveyCard', 'New-AMDiskSpaceAlertCard', 'New-AMAccountVerificationCard'



    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = @()

    # List of all files packaged with this module
    FileList          = '.gitignore',
    'build.ps1',
    'README.md',
    'LICENSE',
    'docs/README.md',
    'docs/en-US/about_ActionableMessages.help.txt',
    'ActionableMessages.psd1',
    'ActionableMessages.psm1',
    'Examples/ApprovalWorkflow.ps1',
    'Examples/FeedbackForm.ps1',
    'Examples/MeetingInvite.ps1',
    'Examples/SimpleNotification.ps1',
    'Private/ConvertTo-AMJson.ps1',
    'Private/Find-AMContainer.ps1',
    'Public/Actions/New-AMActionSet.ps1',
    'Public/Actions/New-AMExecuteAction.ps1',
    'Public/Actions/New-AMOpenUrlAction.ps1',
    'Public/Actions/New-AMShowCardAction.ps1',
    'Public/Actions/New-AMToggleVisibilityAction.ps1',
    'Public/Core/Add-AMElement.ps1',
    'Public/Core/Export-AMCard.ps1',
    'Public/Core/Export-AMCardForEmail.ps1',
    'Public/Core/New-AMCard.ps1',
    'Public/Core/ConvertFrom-AMJson.ps1',
    'Public/Elements/New-AMChoice.ps1',
    'Public/Elements/New-AMColumn.ps1',
    'Public/Elements/New-AMColumnSet.ps1',
    'Public/Elements/New-AMContainer.ps1',
    'Public/Elements/New-AMFact.ps1',
    'Public/Elements/New-AMFactSet.ps1',
    'Public/Elements/New-AMImage.ps1',
    'Public/Elements/New-AMImageSet.ps1',
    'Public/Elements/New-AMTextBlock.ps1',
    'Public/Inputs/New-AMChoiceSetInput.ps1',
    'Public/Inputs/New-AMDateInput.ps1',
    'Public/Inputs/New-AMNumberInput.ps1',
    'Public/Inputs/New-AMTextInput.ps1',
    'Public/Inputs/New-AMTimeInput.ps1',
    'Public/Inputs/New-AMToggleInput.ps1',
    'Public/Prebuilt/New-AMNotificationCard.ps1',
    'Public/Prebuilt/New-AMServiceAlertCard.ps1',
    'Public/Prebuilt/New-AMServerMonitoringCard.ps1',
    'Public/Prebuilt/New-AMServerPurposeSurveyCard.ps1',
    'Public/Prebuilt/New-AMITResourceRequestCard.ps1',
    'Public/Prebuilt/New-AMApprovalCard.ps1',
    'Public/Prebuilt/New-AMApplicationUsageSurveyCard.ps1',
    'Public/Prebuilt/New-AMDiskSpaceAlertCard.ps1',
    'Tests/Integration/ExampleCards.Tests.ps1',
    'Tests/Unit/Actions.Tests.ps1',
    'Tests/Unit/Core.Tests.ps1',
    'Tests/Unit/Elements.Tests.ps1',
    'Tests/Unit/Inputs.Tests.ps1',
    'Tests/Prebuilt/New-AMNotificationCard.Tests.ps1',
    'Tests/Prebuilt/New-AMServiceAlertCard.Tests.ps1',
    'Tests/Prebuilt/New-AMServerMonitoringCard.Tests.ps1',
    'Tests/Prebuilt/New-AMServerPurposeSurveyCard.Tests.ps1',
    'Tests/Prebuilt/New-AMITResourceRequestCard.Tests.ps1',
    'Tests/Prebuilt/New-AMApprovalCard.Tests.ps1',
    'Tests/Prebuilt/New-AMApplicationUsageSurveyCard.Tests.ps1',
    'Tests/Prebuilt/New-AMDiskSpaceAlertCard.Tests.ps1'

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = 'ActionableMessages', 'PowerShell', 'Outlook'

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/Mynster9361/ActionableMessages/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/Mynster9361/ActionableMessages'

        } # End of PSData hashtable

    } # End of PrivateData hashtable


}
