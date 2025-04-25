function New-AMNotificationCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card for displaying an alert or notification.

    .DESCRIPTION
    The `New-AMNotificationCard` function generates an Adaptive Card that can be used to display alerts or notifications.
    The card includes a title, message, optional details, and an optional action link to open a URL for more information.

    .PARAMETER OriginatorId
    The originator ID of the card. This is used to identify the source of the card.

    .PARAMETER Title
    The title of the notification. This is displayed prominently at the top of the card.

    .PARAMETER Message
    The main message or body of the notification. This provides the primary information to the user.

    .PARAMETER Severity
    (Optional) The severity level of the notification. Determines the color of the title.
    Valid values are:
    - Default
    - Accent
    - Good
    - Warning
    - Attention
    The default value is "Default".

    .PARAMETER Details
    (Optional) Additional details about the notification. This is displayed in a separate section of the card.

    .PARAMETER DetailsUrl
    (Optional) A URL for more information about the notification. If provided, a "View Details" button will be added to the card.

    .EXAMPLE
    # Example 1: Create a simple notification card using splatting
    $notificationParams = @{
        OriginatorId = "your-originator-id"
        Title        = "System Notification"
        Message      = "The nightly backup completed successfully."
        Severity     = "Good"
        Details      = "Backup completed at 02:00 AM. No errors were encountered."
        DetailsUrl   = "https://example.com/backup-report"
    }

    $notificationCard = New-AMNotificationCard @notificationParams

    .EXAMPLE
    # Example 2: Create a warning notification card using splatting
    $warningParams = @{
        OriginatorId = "your-originator-id"
        Title        = "Disk Space Warning"
        Message      = "The C: drive is running low on space."
        Severity     = "Warning"
        Details      = "Only 5% of disk space remains."
    }

    $notificationCard = New-AMNotificationCard @warningParams

    .NOTES
    This function is part of the Actionable Messages module and is used to create Adaptive Cards for notifications.
    The card can be exported and sent via email or other communication channels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OriginatorId,

        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [string]$Details,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Default", "Accent", "Good", "Warning", "Attention")]
        [string]$Severity = "Default",

        [Parameter(Mandatory = $false)]
        [string]$DetailsUrl
    )

    # Create a new card
    $card = New-AMCard -OriginatorId $OriginatorId -Version "1.0"

    # Add header with severity color
    $header = New-AMTextBlock -Text $Title -Size "Large" -Weight "Bolder" -Color $Severity
    Add-AMElement -Card $card -Element $header

    # Add message
    $messageBlock = New-AMTextBlock -Text $Message -Wrap $true
    Add-AMElement -Card $card -Element $messageBlock

    # Add details if provided
    if ($Details) {
        $detailsContainer = New-AMContainer -Id "details-container" -Style "emphasis" -Padding "Default"
        Add-AMElement -Card $card -Element $detailsContainer

        $detailsBlock = New-AMTextBlock -Text $Details -Wrap $true
        Add-AMElement -Card $card -Element $detailsBlock -ContainerId "details-container"
    }

    # Add actions if URL provided
    if ($DetailsUrl) {
        $viewAction = New-AMOpenUrlAction -Title "View Details" -Url $DetailsUrl
        $actionSet = New-AMActionSet -Actions @($viewAction)
        Add-AMElement -Card $card -Element $actionSet
    }

    return $card
}
