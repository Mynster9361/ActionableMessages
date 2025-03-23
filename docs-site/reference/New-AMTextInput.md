---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Input.Text.html
schema: 2.0.0
---

# New-AMTextInput

## SYNOPSIS
Creates a text input field for an Adaptive Card.

## SYNTAX

```
New-AMTextInput [-Id] <String> [[-Label] <String>] [[-Placeholder] <String>] [[-Value] <String>]
 [[-IsMultiline] <Boolean>] [[-IsRequired] <Boolean>] [[-MaxLength] <Int32>] [[-Separator] <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates an Input.Text element that allows users to enter text in an Adaptive Card.
Text inputs can be single-line or multi-line and support various configuration options
like placeholders, default values, maximum length, and validation requirements.

This is one of the most common input elements used for collecting free-form text from users.

## EXAMPLES

### EXAMPLE 1
```
# Create a simple single-line text input
$nameInput = New-AMTextInput -Id "userName" -Label "Your Name:"
Add-AMElement -Card $card -Element $nameInput
```

### EXAMPLE 2
```
# Create a multiline text input with placeholder
$feedbackInput = New-AMTextInput -Id "feedback" -Label "Your Feedback:" `
    -Placeholder "Please share your thoughts..." -IsMultiline $true
```

### EXAMPLE 3
```
# Create a required text input with maximum length
$subjectInput = New-AMTextInput -Id "subject" -Label "Subject:" `
    -IsRequired $true -MaxLength 100 -Separator $true
```

### EXAMPLE 4
```
# Create a text input with default value
$emailInput = New-AMTextInput -Id "email" -Label "Email Address:" `
    -Value "user@example.com" -Placeholder "name@company.com"
```

## PARAMETERS

### -Id
A unique identifier for the input element.
This ID will be used when the card is submitted
to identify the text entered by the user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
Optional text label to display above the input field, describing what the input is for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Placeholder
Optional text to display when the input field is empty.
This text provides a hint to the user
about what they should enter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Optional default text to pre-fill in the input field when the card is displayed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsMultiline
When set to $true, creates a text area that allows for multiple lines of text.
When set to $false (default), creates a single-line text input field.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsRequired
When set to $true, the field must contain text when submitted.
When set to $false (default), the field is optional.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxLength
Optional maximum number of characters allowed in the input field.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
When set to $true, adds a visible separator line above the input field.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe input to New-AMTextInput.
## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable representing the Input.Text element.
## NOTES
Text inputs are versatile elements for gathering user feedback.
Some best practices:

- Always use clear labels to identify what information is being requested
- Use placeholder text to provide examples or formatting guidance
- For longer text entries, set IsMultiline to $true
- Consider using MaxLength to prevent excessive text entry
- Set IsRequired for fields that must be filled

## RELATED LINKS

[https://adaptivecards.io/explorer/Input.Text.html](https://adaptivecards.io/explorer/Input.Text.html)

