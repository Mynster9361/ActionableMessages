# ActionableMessages.psd1

@{
    # PowerShell module manifest for ActionableMessages
    ModuleVersion = '1.0.0'
    GUID = 'd1e5c3f4-5e3b-4c2a-8c3b-5e3b4c2a8c3b'
    Author = 'Morten Mynster'
    CompanyName = 'Mynster'
    Copyright = 'Copyright © 2025 Mynster'
    Description = 'A PowerShell module for creating and managing Actionable Messages.'
    RootModule = 'ActionableMessages.psm1'  # Add this line to reference the PSM1 file
    FunctionsToExport = @(
        'New-AMCard',
        'Add-AMElement',
        'Export-AMCard',
        'Export-AMCardForEmail',
        'New-AMTextBlock',
        'New-AMImage',
        'New-AMChoice',
        'New-AMContainer',
        'New-AMColumnSet',
        'New-AMColumn',
        'New-AMFactSet',
        'New-AMFact',
        'New-AMImageSet',
        'New-AMActionSet',
        'New-AMOpenUrlAction',
        'New-AMShowCardAction',
        'New-AMToggleVisibilityAction',
        'New-AMExecuteAction',
        'New-AMTextInput',
        'New-AMNumberInput',
        'New-AMDateInput',
        'New-AMTimeInput',
        'New-AMToggleInput',
        'New-AMChoiceSetInput'
    )
    RequiredModules = @()
    FileList = @(
        'ActionableMessages.psd1',
        'ActionableMessages.psm1',
        'Public/Core/New-AMCard.ps1',
        'Public/Core/Add-AMElement.ps1',
        'Public/Core/Export-AMCard.ps1',
        'Public/Core/Export-AMCardForEmail.ps1',
        'Public/Elements/New-AMTextBlock.ps1',
        'Public/Elements/New-AMImage.ps1',
        'Public/Elements/New-AMChoice.ps1',
        'Public/Elements/New-AMContainer.ps1',
        'Public/Elements/New-AMColumnSet.ps1',
        'Public/Elements/New-AMColumn.ps1',
        'Public/Elements/New-AMFactSet.ps1',
        'Public/Elements/New-AMFact.ps1',
        'Public/Elements/New-AMImageSet.ps1',
        'Public/Elements/New-AMActionSet.ps1',
        'Public/Actions/New-AMOpenUrlAction.ps1',
        'Public/Actions/New-AMShowCardAction.ps1',
        'Public/Actions/New-AMToggleVisibilityAction.ps1',
        'Public/Actions/New-AMExecuteAction.ps1',
        'Public/Inputs/New-AMTextInput.ps1',
        'Public/Inputs/New-AMNumberInput.ps1',
        'Public/Inputs/New-AMDateInput.ps1',
        'Public/Inputs/New-AMTimeInput.ps1',
        'Public/Inputs/New-AMToggleInput.ps1',
        'Public/Inputs/New-AMChoiceSetInput.ps1',
        'Private/ConvertTo-AMJson.ps1',
        'Tests/Unit/Core.Tests.ps1',
        'Tests/Unit/Elements.Tests.ps1',
        'Tests/Unit/Actions.Tests.ps1',
        'Tests/Unit/Inputs.Tests.ps1',
        'Tests/Integration/ExampleCards.Tests.ps1',
        'Examples/SimpleCard.ps1',
        'Examples/ComplexForm.ps1',
        'docs/en-US/about_ActionableMessages.help.txt',
        'docs/README.md',
        '.gitignore',
        'build.ps1',
        'psake.ps1',
        'README.md',
        'LICENSE'
    )
}