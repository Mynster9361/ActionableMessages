---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/TextBlock.html
schema: 2.0.0
---

# New-AMTextBlock

## SYNOPSIS
Creates a TextBlock element for an Adaptive Card.

## SYNTAX

```
New-AMTextBlock [[-Text] <String>] [[-Size] <String>] [[-Weight] <String>] [[-Color] <String>]
 [[-Wrap] <String>]
```

## DESCRIPTION
Creates a TextBlock element that displays formatted text within an Adaptive Card.
TextBlocks are the primary way to display text content and can be styled with
different sizes, weights, and colors.
They can also support simple markdown formatting.

## EXAMPLES

### EXAMPLE 1
```
# Create a simple text block
$text = New-AMTextBlock -Text "Hello World!"
Add-AMElement -Card $card -Element $text
```

### EXAMPLE 2
```
# Create a heading with larger text and bold weight
$heading = New-AMTextBlock -Text "Important Notification" -Size "Large" -Weight "Bolder" -Color "Accent"
```

### EXAMPLE 3
```
# Create text with markdown formatting
$markdownText = New-AMTextBlock -Text "Please **review** the [documentation](https://docs.example.com) before continuing."
```

## PARAMETERS

### -Text
The text to display in the TextBlock.
This can include simple markdown formatting
such as **bold**, *italic*, and \[links\](https://example.com).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
Controls the size of the text.
Valid values: "Small", "Default", "Medium", "Large", "ExtraLarge"
Default: "Medium"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Medium
Accept pipeline input: False
Accept wildcard characters: False
```

### -Weight
Controls the font weight (boldness) of the text.
Valid values: "Lighter", "Default", "Bolder"
Default: "Default"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Color
Sets the color of the text.
Valid values: "Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention"
Default: "Default"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wrap
Specifies whether the text should wrap to multiple lines when it doesn't fit on a single line.
When set to $false, text that doesn't fit will be truncated.
Default: $true

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None. You cannot pipe input to New-AMTextBlock.
## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable representing the TextBlock element.
## NOTES
TextBlocks are the most common element in Adaptive Cards.
Some best practices:

- Use different sizes and weights to create visual hierarchy
- Set Wrap to $true for longer text to ensure readability
- Use markdown sparingly for emphasis, but avoid complex formatting
- Consider using different colors to highlight important information

## RELATED LINKS

[https://adaptivecards.io/explorer/TextBlock.html](https://adaptivecards.io/explorer/TextBlock.html)

