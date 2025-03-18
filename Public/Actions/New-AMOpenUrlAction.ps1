function New-AMOpenUrlAction {
    <#
    .SYNOPSIS
        Creates an OpenUrl Action for an Adaptive Card.

    .DESCRIPTION
        Creates an Action.OpenUrl element that opens a URL in a web browser when clicked.
        This action is commonly used to provide links to external resources, documentation,
        or related web pages from within your Adaptive Card.

    .PARAMETER Title
        The title text to display on the action button.

    .PARAMETER Url
        The URL to open when the button is clicked. This must be a valid URL including
        the protocol (e.g., "https://").

    .PARAMETER Id
        Optional unique identifier for the action. If not specified, a new GUID will be
        generated automatically. The ID can be useful when you need to reference this
        action programmatically.

    .PARAMETER Tooltip
        Optional tooltip text to display when the user hovers over the button.
        Use this to provide additional context about what will happen when clicked.

    .EXAMPLE
        # Create a simple "Learn More" button
        $learnMoreAction = New-AMOpenUrlAction -Title "Learn More" -Url "https://example.com"
        Add-AMElement -Card $card -Element (New-AMActionSet -Actions @($learnMoreAction))

    .EXAMPLE
        # Create a button with custom ID and tooltip
        $docsButton = New-AMOpenUrlAction -Title "View Documentation" `
            -Url "https://docs.contoso.com/project" `
            -Id "docs-button" `
            -Tooltip "Open the project documentation in a new browser window"

    .EXAMPLE
        # Creating multiple URL actions in an ActionSet
        $actions = @(
            (New-AMOpenUrlAction -Title "Product Page" -Url "https://contoso.com/products"),
            (New-AMOpenUrlAction -Title "Support" -Url "https://contoso.com/support")
        )
        $actionSet = New-AMActionSet -Id "links" -Actions $actions

    .INPUTS
        None. You cannot pipe input to New-AMOpenUrlAction.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Action.OpenUrl element.

    .NOTES
        Action.OpenUrl is one of the most commonly used action types in Adaptive Cards.
        Unlike other action types, Action.OpenUrl doesn't require any special permissions
        or registrations since it simply opens a URL in the user's browser.

        In Outlook, the URL will typically open in the user's default web browser.

    .LINK
        https://adaptivecards.io/explorer/Action.OpenUrl.html
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Url,

        [Parameter()]
        [string]$Id = [guid]::NewGuid().ToString(),

        [Parameter()]
        [string]$Tooltip
    )

    $action = [ordered]@{
        'type' = 'Action.OpenUrl'
        'id' = $Id
        'title' = $Title
        'url' = $Url
    }

    if ($Tooltip) {
        $action.tooltip = $Tooltip
    }

    return $action
}