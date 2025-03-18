function New-AMToggleVisibilityAction {
    <#
    .SYNOPSIS
        Creates a ToggleVisibility Action for an Adaptive Card.

    .DESCRIPTION
        Creates an Action.ToggleVisibility element that toggles the visibility of one or more elements.
        This action allows you to show or hide elements in your card when the user clicks the action button.
        It's commonly used for creating expandable/collapsible sections, showing additional details on demand,
        or implementing tabbed interfaces within a card.

    .PARAMETER Title
        The title of the action button that will trigger the visibility toggle.

    .PARAMETER TargetElements
        An array of element IDs to toggle visibility. When the action is triggered,
        these elements will switch between visible and hidden states.

    .PARAMETER Id
        Optional unique identifier for the action. If not specified, a new GUID will be
        generated automatically. Having an ID can be useful when you need to reference
        this action from other parts of your card.

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
        None. You cannot pipe input to New-AMToggleVisibilityAction.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Action.ToggleVisibility element.

    .NOTES
        Action.ToggleVisibility is extremely useful for creating interactive cards without requiring
        server communication. It works well for:

        - Creating expandable/collapsible sections
        - Implementing "Read more" functionality
        - Building simple wizards or multi-step forms
        - Showing and hiding form fields based on previous selections
        - Creating tab-like interfaces within cards

        Note that elements referenced in targetElements must have proper IDs defined.

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
        'type' = 'Action.ToggleVisibility'
        'id' = $Id
        'title' = $Title
        'targetElements' = $TargetElements
    }

    return $action
}