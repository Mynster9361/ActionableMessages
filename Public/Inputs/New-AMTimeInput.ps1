function New-AMTimeInput {
    <#
    .SYNOPSIS
        Creates a Time Input element for an Adaptive Card.

    .DESCRIPTION
        Creates an Input.Time element that allows users to select a time value.
        Time inputs are useful for scheduling, appointment setting, or any scenario
        where users need to specify a time of day.

        The element typically renders as a text field with a time picker interface,
        though the exact appearance may vary across different Adaptive Card hosts.

    .PARAMETER id
        A unique identifier for the time input element. This ID will be used when the card
        is submitted to identify the time value selected by the user.

    .PARAMETER title
        Text label to display above the input field, describing what the time selection is for.

    .PARAMETER value
        Optional default time value for the input. Should be in 24-hour format (HH:MM).
        If not specified, defaults to the current time.

    .PARAMETER placeholder
        Optional text to display when no time has been selected.
        Default: "Select time"

    .PARAMETER style
        Optional visual style for the input element.
        Valid values: "default", "expanded"
        Default: "default"

    .EXAMPLE
        # Create a simple time input with default values (current time)
        $meetingTime = New-AMTimeInput -id "meetingStart" -title "Meeting Start Time:"
        Add-AMElement -Card $card -Element $meetingTime

    .EXAMPLE
        # Create a time input with specific default time
        $reminderTime = New-AMTimeInput -id "reminderTime" -title "Set Reminder For:" `
            -value "14:30" -placeholder "Select reminder time"

    .EXAMPLE
        # Create a time input for a form
        $card = New-AMCard -OriginatorId "calendar-app"

        $startTime = New-AMTimeInput -id "startTime" -title "Start Time:" -value "09:00"
        $endTime = New-AMTimeInput -id "endTime" -title "End Time:" -value "17:00"

        Add-AMElement -Card $card -Element $startTime
        Add-AMElement -Card $card -Element $endTime

        $submitAction = New-AMSubmitAction -Title "Schedule" -Data @{ action = "createEvent" }
        Add-AMAction -Card $card -Action $submitAction

    .INPUTS
        None. You cannot pipe input to New-AMTimeInput.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Input.Time element.

    .NOTES
        Time inputs in Adaptive Cards:
        - Values are typically in 24-hour format (HH:MM)
        - The display format may vary based on user locale settings
        - Not all Adaptive Card hosts support all time input features consistently

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
        type       = "Input.Time"
        id         = $id
        title      = $title
        value      = $value
        placeholder = $placeholder
        style      = $style
    }
    Write-Warning "New-AMTimeInput - This item is not supported in all outlook clients. Currently only supported in Outlook on the web."
    return $timeInput
}