function New-AMShowCardAction {
    <#
    .SYNOPSIS
        Creates a ShowCard Action for an Adaptive Card.

    .DESCRIPTION
        The `New-AMShowCardAction` function generates an `Action.ShowCard` element for an Adaptive Card.
        This action reveals a nested card when the button is clicked. It is useful for progressive disclosure
        of information, such as showing additional details, forms, or content without navigating away from
        the current view or requiring another HTTP request.

        If no card is provided, a default empty card will be created with basic properties.

    .PARAMETER Title
        The text to display on the action button that will reveal the card.

    .PARAMETER Id
        (Optional) A unique identifier for the action. If not specified, a new GUID will be generated automatically.
        The ID can be useful when referencing this action programmatically or from other parts of your card.

    .PARAMETER Card
        (Optional) A pre-configured card to show when the button is clicked. If not provided, an empty card
        with default properties will be created.

    .EXAMPLE
        # Create a ShowCard action with an empty card
        $showAction = New-AMShowCardAction -Title "Show Details"

    .EXAMPLE
        # Create a ShowCard action with a pre-configured card
        $detailCard = New-AMCard -OriginatorId "nested-card"
        Add-AMElement -Card $detailCard -Element (New-AMTextBlock -Text "These are additional details" -Wrap $true)
        $showAction = New-AMShowCardAction -Title "Show Details" -Card $detailCard

    .EXAMPLE
        # Create a ShowCard action with a form inside
        $feedbackCard = New-AMCard -OriginatorId "feedback-card"
        Add-AMElement -Card $feedbackCard -Element (New-AMTextBlock -Text "Please provide your feedback:")
        Add-AMElement -Card $feedbackCard -Element (New-AMTextInput -Id "comments" -Placeholder "Type your comments here" -IsMultiline $true)

        # Create a submit button for the nested card
        $submitAction = New-AMSubmitAction -Title "Submit Feedback" -Data @{ action = "feedback" }
        $actionSet = New-AMActionSet -Actions @($submitAction)
        Add-AMElement -Card $feedbackCard -Element $actionSet

        $feedbackAction = New-AMShowCardAction -Title "Provide Feedback" -Id "feedback-form" -Card $feedbackCard

    .INPUTS
        None. You cannot pipe input to `New-AMShowCardAction`.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the `Action.ShowCard` element.

    .NOTES
        - `Action.ShowCard` is ideal for scenarios where you want to reveal additional information or forms
          without requiring a new HTTP request or navigating away from the current card.
        - If no card is provided, a default empty card will be created with basic properties.
        - Nested cards created with `Action.ShowCard` are rendered inline within the parent card.

    .LINK
        https://adaptivecards.io/explorer/Action.ShowCard.html
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter()]
        [string]$Id = [guid]::NewGuid().ToString(),

        [Parameter()]
        [hashtable]$Card
    )

    # Create default empty card if none provided
    if (-not $Card) {
        # Create a simple card - we use a placeholder originator ID since it's a nested card
        $Card = New-AMCard -OriginatorId "show-card" -Version "1.2"

        # Remove properties not needed for a show card
        $Card.Remove('originator')
        $Card.Remove('hideOriginalBody')
        $Card.Remove('actions')

        # Add padding property specific to show cards
        $Card.padding = 'None'
    }

    $action = [ordered]@{
        'type'  = 'Action.ShowCard'
        'id'    = $Id
        'title' = $Title
        'card'  = $Card
    }

    return $action
}