function New-AMCard {
    <#
    .SYNOPSIS
        Creates a new Adaptive Card object.

    .DESCRIPTION
        Creates a new Adaptive Card hashtable that serves as the foundation for building
        an Adaptive Card. This is typically the first function you call when creating
        a new card.

        The card object created by this function will contain the basic structure needed
        for an Adaptive Card, including empty collections for body elements and actions.

    .PARAMETER Version
        The version of the Adaptive Card schema to use.
        For outlook always use 1.0
        Valid values: "1.0", "1.1", "1.2", "1.3", "1.4", "1.5"
        Default: "1.0"

        Different versions support different card features:
        - 1.0: Basic layout and elements
        - 1.1: Adds support for additional features like horizontal alignment
        - 1.2: Adds support for more advanced features and styling options
        - 1.3+: Adds support for the latest Adaptive Card features

    .PARAMETER OriginatorId
        A unique identifier for the sender of the card. For Outlook Actionable Messages,
        this should be the originator ID registered with Microsoft.

        This ID is critical for security purposes, as it validates that your organization
        is authorized to send Actionable Messages and make HTTP requests to your endpoints.

    .PARAMETER HideOriginalBody
        Specifies whether to hide the original email body when displaying the card.

        When set to $true (default), only the Adaptive Card is displayed in the email.
        When set to $false, both the original email text and the card are displayed.

        Default: $true

    .PARAMETER Padding
        Specifies the padding setting for the card.
        Valid values: "None", "Default", "Small", "Medium", "Large", "ExtraLarge"
        Default: "None"

    .PARAMETER BackgroundImage
        URL to an image that will be used as the background for the card.

    .PARAMETER RTL
        When set to $true, renders the card in right-to-left mode.
        Default: $false

    .EXAMPLE
        # Create a basic card
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.0"

    .EXAMPLE
        # Create a card with a background image
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.0" -BackgroundImage "https://example.com/image.jpg"

    .EXAMPLE
        # Create a card with right-to-left support
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.0" -RTL $true

    .INPUTS
        None. You cannot pipe input to New-AMCard.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Adaptive Card structure.

    .NOTES
        The OriginatorId is required for Outlook Actionable Messages. You must register
        your originator ID with Microsoft before using it in production through the Actionable
        Email Developer Dashboard at https://aka.ms/publishactionableemails.

        For testing purposes in development environments, any value can be used.

        After creating a card, use Add-AMElement along with element creation functions
        like New-AMTextBlock and New-AMImage to populate the card with content.

    .LINK
        https://docs.microsoft.com/en-us/outlook/actionable-messages/

    .LINK
        https://adaptivecards.io/explorer/
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet("1.0", "1.1", "1.2", "1.3", "1.4", "1.5")]
        [string]$Version = "1.0",

        [Parameter(Mandatory = $true)]
        [string]$OriginatorId,

        [Parameter()]
        [bool]$HideOriginalBody = $true,

        [Parameter()]
        [ValidateSet("None", "Default", "Small", "Medium", "Large", "ExtraLarge")]
        [string]$Padding = "Default",

        [Parameter()]
        [string]$BackgroundImage,

        [Parameter()]
        [bool]$RTL = $false
    )

    $card = [ordered]@{
        '$schema' = "http://adaptivecards.io/schemas/adaptive-card.json"
        'version' = $Version
        'originator' = $OriginatorId
        'hideOriginalBody' = $HideOriginalBody
        '@type' = 'AdaptiveCard'
        '@context' = "http://schema.org/extensions"
        'padding' = $Padding
        'body' = [System.Collections.ArrayList]@()
        'actions' = [System.Collections.ArrayList]@()
        "refresh" = '{
            "action" = {
              "type" = "Action.Execute",
              "verb" = "refreshCard"
            },
            "userIds" = [
              "user1",
              "user2"
            ]
          }'
    }

    # Add optional properties only if they're specified
    if ($BackgroundImage) {
        $card['backgroundImage'] = $BackgroundImage
    }

    if ($RTL) {
        $card['rtl'] = $true
    }

    return $card
}