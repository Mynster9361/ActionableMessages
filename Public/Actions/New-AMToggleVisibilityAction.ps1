function New-AMToggleVisibilityAction {
    <#
    .SYNOPSIS
        Creates a ToggleVisibility Action for an Adaptive Card.

    .DESCRIPTION
        The `New-AMToggleVisibilityAction` function generates an `Action.ToggleVisibility` element for an Adaptive Card.
        This action allows you to toggle the visibility of one or more elements in the card when the button is clicked.
        It is commonly used for creating interactive cards with expandable/collapsible sections, "Read more" functionality,
        tabbed interfaces, or multi-step forms.

        This action is client-side only and does not require server communication, making it ideal for lightweight
        interactivity within Adaptive Cards.

    .PARAMETER Title
        The text to display on the action button that will trigger the visibility toggle.

    .PARAMETER TargetElements
        An array of element IDs to toggle visibility. When the action is triggered, these elements will switch
        between visible and hidden states. The elements must have valid IDs defined in the card.

    .PARAMETER Id
        (Optional) A unique identifier for the action. If not specified, a new GUID will be generated automatically.
        The ID can be useful when referencing this action programmatically or from other parts of your card.

    .EXAMPLE
        # Create a simple toggle action for one element
        $toggleAction = New-AMToggleVisibilityAction -Title "Show Details" -TargetElements @("details-section")

    .EXAMPLE
        # Toggle multiple elements with one button
        $toggleAction = New-AMToggleVisibilityAction -Title "Toggle Sections" `
            -TargetElements @("section1", "section2", "section3") `
            -Id "toggle-all-sections"

    .EXAMPLE
        # Creating a tab-like interface with toggle actions
        $tab1Content = New-AMContainer -Id "tab1-content" -Items @(
            (New-AMTextBlock -Text "This is the content of tab 1" -Wrap $true)
        )
        $tab2Content = New-AMContainer -Id "tab2-content" -Items @(
            (New-AMTextBlock -Text "This is the content of tab 2" -Wrap $true)
        ) -IsVisible $false

        # Add content containers to card
        Add-AMElement -Card $card -Element $tab1Content
        Add-AMElement -Card $card -Element $tab2Content

        # Create toggle actions for tabs
        $tab1Action = New-AMToggleVisibilityAction -Title "Tab 1" -TargetElements @("tab1-content", "tab2-content")
        $tab2Action = New-AMToggleVisibilityAction -Title "Tab 2" -TargetElements @("tab1-content", "tab2-content")

        # Add actions to an ActionSet
        $tabActionSet = New-AMActionSet -Actions @($tab1Action, $tab2Action)
        Add-AMElement -Card $card -Element $tabActionSet

    .INPUTS
        None. You cannot pipe input to `New-AMToggleVisibilityAction`.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the `Action.ToggleVisibility` element.

    .NOTES
        - `Action.ToggleVisibility` is extremely useful for creating interactive cards without requiring
          server communication. It works well for:
            - Creating expandable/collapsible sections
            - Implementing "Read more" functionality
            - Building simple wizards or multi-step forms
            - Showing and hiding form fields based on previous selections
            - Creating tab-like interfaces within cards
        - Elements referenced in `TargetElements` must have valid IDs defined in the card.

    .LINK
        https://adaptivecards.io/explorer/Action.ToggleVisibility.html
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [string[]]$TargetElements,

        [Parameter()]
        [string]$Id = [guid]::NewGuid().ToString()
    )

    $action = [ordered]@{
        'type'           = 'Action.ToggleVisibility'
        'id'             = $Id
        'title'          = $Title
        'targetElements' = $TargetElements
    }

    return $action
}