function New-AMTimeInput {
    <#
    .SYNOPSIS
        Creates a Time Input element for an Adaptive Card.

    .DESCRIPTION
        The `New-AMTimeInput` function creates an Input.Time element that allows users to select a time value.
        Time inputs are useful for scheduling, appointment setting, or any scenario where users need to specify a time of day.

        The element typically renders as a text field with a time picker interface, though the exact appearance may vary
        across different Adaptive Card hosts. Note that not all Adaptive Card hosts support time inputs consistently.

    .PARAMETER Id
        A unique identifier for the time input element. This ID will be used when the card
        is submitted to identify the time value selected by the user.

    .PARAMETER Title
        Text label to display above the input field, describing what the time selection is for.

    .PARAMETER Value
        Optional default time value for the input. Should be in 24-hour format (HH:mm).
        If not specified, defaults to the current time.

    .PARAMETER Placeholder
        Optional text to display when no time has been selected.
        Default: "Select time"

    .PARAMETER Style
        Optional visual style for the input element.
        Valid values: "default", "expanded"
        Default: "default"

    .EXAMPLE
        # Create a simple time input with default values (current time)
        $meetingTime = New-AMTimeInput -Id "meetingStart" -Title "Meeting Start Time:"
        Add-AMElement -Card $card -Element $meetingTime

    .EXAMPLE
        # Create a time input with a specific default time
        $reminderTime = New-AMTimeInput -Id "reminderTime" -Title "Set Reminder For:" `
            -Value "14:30" -Placeholder "Select reminder time"

    .EXAMPLE
        # Create a time input for a form
        $card = New-AMCard -OriginatorId "calendar-app"

        $startTime = New-AMTimeInput -Id "startTime" -Title "Start Time:" -Value "09:00"
        $endTime = New-AMTimeInput -Id "endTime" -Title "End Time:" -Value "17:00"

        Add-AMElement -Card $card -Element $startTime
        Add-AMElement -Card $card -Element $endTime

        $submitAction = New-AMSubmitAction -Title "Schedule" -Data @{ action = "createEvent" }
        Add-AMAction -Card $card -Action $submitAction

    .INPUTS
        None. You cannot pipe input to `New-AMTimeInput`.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Input.Time element.

    .NOTES
        - Time inputs in Adaptive Cards:
          - Values are typically in 24-hour format (HH:mm).
          - The display format may vary based on user locale settings.
          - Not all Adaptive Card hosts support all time input features consistently.
        - Currently, time inputs are only supported in Outlook on the web.
        - A warning is displayed when this function is used to indicate limited support.

    .LINK
        https://adaptivecards.io/explorer/Input.Time.html
    #>
    param (
        [string]$id,
        [string]$title,
        [string]$value = (Get-Date).ToString("HH:mm"),
        [string]$placeholder = "Select time",
        [string]$style = "default"
    )

    $timeInput = @{
        type        = "Input.Time"
        id          = $id
        title       = $title
        value       = $value
        placeholder = $placeholder
        style       = $style
    }
    Write-Warning "New-AMTimeInput - This item is not supported in all outlook clients. Currently only supported in Outlook on the web."
    return $timeInput
}