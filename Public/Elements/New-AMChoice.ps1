function New-AMChoice {
    <#
    .SYNOPSIS
        Creates a choice object for use in a ChoiceSet.

    .DESCRIPTION
        The `New-AMChoice` function creates a choice option to be used in a `ChoiceSetInput` element. Each choice represents
        an individual option that can be selected by users in dropdown lists, radio buttons, or checkbox groups within an Adaptive Card.

        Choice objects must be created using this function before being passed to the `New-AMChoiceSetInput` function as the `-Choices` parameter.

        The `Title` parameter specifies the text displayed to the user, while the `Value` parameter specifies the data submitted when the choice is selected.
        This separation allows you to display user-friendly text while submitting more compact or standardized values in your form data.

    .PARAMETER Title
        The text to display for this choice option in the user interface.
        This is what users will see in the dropdown list, checkbox, or radio button.

    .PARAMETER Value
        The value to be submitted when this choice is selected.
        This is the data that will be sent back when the card is submitted and may
        be different from the displayed title.

    .EXAMPLE
        # Create a single choice
        $choice = New-AMChoice -Title "Red" -Value "red"

    .EXAMPLE
        # Create multiple choices for a dropdown list
        $colors = @(
            New-AMChoice -Title "Red" -Value "red"
            New-AMChoice -Title "Green" -Value "green"
            New-AMChoice -Title "Blue" -Value "blue"
        )
        $colorPicker = New-AMChoiceSetInput -Id "favoriteColor" -Label "Select your favorite color:" -Choices $colors

    .EXAMPLE
        # Create yes/no choices
        $yesNoChoices = @(
            New-AMChoice -Title "Yes, I approve" -Value "approve"
            New-AMChoice -Title "No, I reject" -Value "reject"
        )
        $approvalInput = New-AMChoiceSetInput -Id "approval" -Label "Do you approve this request?" `
            -Choices $yesNoChoices -Style "expanded" -IsMultiSelect $false

    .INPUTS
        None. You cannot pipe input to `New-AMChoice`.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable with `title` and `value` properties that can be used in a choice set.

    .NOTES
        - The `Title` is what appears in the UI, while the `Value` is what gets submitted with the form data.
        - This separation allows you to display user-friendly text while submitting more compact or standardized values in your form data.
        - This function is typically used in conjunction with `New-AMChoiceSetInput` to create dropdowns, radio buttons, or checkbox groups.

    .LINK
        https://adaptivecards.io/explorer/Input.ChoiceSet.html
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    return [ordered]@{
        'title' = $Title
        'value' = $Value
    }
}