function New-AMToggleInput {
    <#
    .SYNOPSIS
        Creates a Toggle Input element for an Adaptive Card.

    .DESCRIPTION
        Creates an Input.Toggle element that allows users to switch between two states: on or off.
        Toggle inputs are useful for boolean choices, preferences, or any yes/no decision.

        The element typically renders as a checkbox or toggle switch depending on the host
        application, making it ideal for settings, confirmations, or agreement inputs.

    .PARAMETER id
        A unique identifier for the toggle input element. This ID will be used when the card
        is submitted to identify the toggle's state.

    .PARAMETER title
        The text label displayed next to the toggle control. This describes what the toggle
        represents or controls.

    .PARAMETER value
        The initial state of the toggle.
        - $true or "true": The toggle is initially on/checked
        - $false or "false": The toggle is initially off/unchecked
        Default: $false

    .PARAMETER valueOn
        Optional text value to submit when the toggle is in the "on" state.
        Default: "true"

    .PARAMETER valueOff
        Optional text value to submit when the toggle is in the "off" state.
        Default: "false"

    .PARAMETER style
        Optional visual style for the toggle input.
        Valid values: "default", "expanded", "compact"
        Default: "default"

    .EXAMPLE
        # Create a simple toggle for agreement
        $agreementToggle = New-AMToggleInput -id "termsAgreed" -title "I agree to the terms and conditions"
        Add-AMElement -Card $card -Element $agreementToggle

    .EXAMPLE
        # Create a toggle with custom values
        $notificationToggle = New-AMToggleInput -id "notifications" -title "Enable notifications" `
            -value $true -valueOn "enabled" -valueOff "disabled"

    .EXAMPLE
        # Create multiple toggles for settings
        $card = New-AMCard -OriginatorId "preferences-app"

        $settingsContainer = New-AMContainer -Id "settings" -Style "emphasis"
        Add-AMElement -Card $card -Element $settingsContainer

        $emailToggle = New-AMToggleInput -id "emailAlerts" -title "Email notifications" -value $true
        $smsToggle = New-AMToggleInput -id "smsAlerts" -title "SMS notifications" -value $false
        $weeklyToggle = New-AMToggleInput -id "weeklyDigest" -title "Weekly summary report" -value $true

        Add-AMElement -Card $card -Element $emailToggle -ContainerId "settings"
        Add-AMElement -Card $card -Element $smsToggle -ContainerId "settings"
        Add-AMElement -Card $card -Element $weeklyToggle -ContainerId "settings"

    .INPUTS
        None. You cannot pipe input to New-AMToggleInput.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Input.Toggle element.

    .NOTES
        Toggle inputs are ideal for binary choices where the user must select one of two options.

        When designing forms with toggles:
        - Use clear, concise labels that indicate the "on" state
        - Consider grouping related toggles together
        - For more complex choices with multiple options, consider using ChoiceSet instead

    .LINK
        https://adaptivecards.io/explorer/Input.Toggle.html
    #>
    param (
        [string]$id,
        [string]$title,
        [string]$value = $false,
        [string]$valueOn = "true",
        [string]$valueOff = "false",
        [string]$style = "default"
    )

    $toggleInput = @{
        type = "Input.Toggle"
        id = $id
        title = $title
        value = $value
        valueOn = $valueOn
        valueOff = $valueOff
        style = $style
    }

    return $toggleInput
}

Export-ModuleMember -Function New-AMToggleInput