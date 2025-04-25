function New-AMTextBlock {
    <#
    .SYNOPSIS
        Creates a TextBlock element for an Adaptive Card.

    .DESCRIPTION
        Creates a TextBlock element that displays formatted text within an Adaptive Card.
        TextBlocks are the primary way to display text content and can be styled with
        different sizes, weights, and colors. They can also support simple markdown formatting.

    .PARAMETER Text
        The text to display in the TextBlock. This can include simple markdown formatting
        such as **bold**, *italic*, and [links](https://example.com).

    .PARAMETER Size
        Controls the size of the text.
        Valid values: "Small", "Default", "Medium", "Large", "ExtraLarge"
        Default: "Medium"

    .PARAMETER Weight
        Controls the font weight (boldness) of the text.
        Valid values: "Lighter", "Default", "Bolder"
        Default: "Default"

    .PARAMETER Color
        Sets the color of the text.
        Valid values: "Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention"
        Default: "Default"

    .PARAMETER Wrap
        Specifies whether the text should wrap to multiple lines when it doesn't fit on a single line.
        When set to $false, text that doesn't fit will be truncated.
        Default: $true

    .EXAMPLE
        # Create a simple text block
        $text = New-AMTextBlock -Text "Hello World!"
        Add-AMElement -Card $card -Element $text

    .EXAMPLE
        # Create a heading with larger text and bold weight
        $heading = New-AMTextBlock -Text "Important Notification" -Size "Large" -Weight "Bolder" -Color "Accent"

    .EXAMPLE
        # Create text with markdown formatting
        $markdownText = New-AMTextBlock -Text "Please **review** the [documentation](https://docs.example.com) before continuing."

    .INPUTS
        None. You cannot pipe input to New-AMTextBlock.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the TextBlock element.

    .NOTES
        TextBlocks are the most common element in Adaptive Cards. Some best practices:

        - Use different sizes and weights to create visual hierarchy
        - Set Wrap to $true for longer text to ensure readability
        - Use markdown sparingly for emphasis, but avoid complex formatting
        - Consider using different colors to highlight important information

    .LINK
        https://adaptivecards.io/explorer/TextBlock.html
    #>
    param (
        [string]$Text,
        [string]$Size = "Medium",
        [string]$Weight = "Default",
        [string]$Color = "Default",
        [string]$Wrap = $true
    )

    $textBlock = @{
        type   = "TextBlock"
        text   = $Text
        size   = $Size
        weight = $Weight
        color  = $Color
        wrap   = $Wrap
    }

    return $textBlock
}

Export-ModuleMember -Function New-AMTextBlock