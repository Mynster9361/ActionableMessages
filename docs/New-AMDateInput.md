---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Input.Date.html
schema: 2.0.0
---

# New-AMDateInput

## SYNOPSIS

Creates a Date Input element for an Adaptive Card.

## SYNTAX

```
New-AMDateInput [-Id] <String> [-Label] <String> [[-Value] <String>] [[-Placeholder] <String>]
 [[-Min] <String>] [[-Max] <String>] [<CommonParameters>]
```

## DESCRIPTION

Creates an Input.Date element that allows users to select a date from a calendar interface.
Date inputs are used when you need to collect a specific date from users, such as
for scheduling events, setting deadlines, or specifying birthdates.

## EXAMPLES

### EXAMPLE 1

```
# Create a simple date input with default values
$dueDateInput = New-AMDateInput -Id "dueDate" -Label "Due Date:"
Add-AMElement -Card $card -Element $dueDateInput
```

### EXAMPLE 2

```
# Create a date input with a specific default date
$eventDateInput = New-AMDateInput -Id "eventDate" -Label "Event Date:" -Value "2025-04-15"
```

### EXAMPLE 3

```
# Create a date input with restricted date range
$birthDateInput = New-AMDateInput -Id "birthDate" -Label "Birth Date:" `
    -Placeholder "Enter your date of birth" `
    -Min "1900-01-01" -Max "2020-12-31"
```

## PARAMETERS

### -Id

A unique identifier for the input element.
This ID will be used when the card is submitted
to identify the selected date value.

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

Text label to display above the input field, describing what the date selection is for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value

Optional default date value for the input.
The date should be in ISO 8601 format (YYYY-MM-DD).
If not specified, defaults to the current date.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $(Get-Date -Format 'yyyy-MM-dd')
Accept pipeline input: False
Accept wildcard characters: False
```

### -Placeholder

Optional text to display when no date has been selected.
Default: "Select a date"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Select a date
Accept pipeline input: False
Accept wildcard characters: False
```

### -Min

Optional minimum allowed date (inclusive) in ISO 8601 format (YYYY-MM-DD).
Dates before this value will be disabled in the calendar picker.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Max

Optional maximum allowed date (inclusive) in ISO 8601 format (YYYY-MM-DD).
Dates after this value will be disabled in the calendar picker.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe input to New-AMDateInput.

## OUTPUTS

### System.Collections.Hashtable

### Returns a hashtable representing the Input.Date element.

## NOTES

Date inputs in Adaptive Cards will render differently depending on the client:

- In most clients, they appear as a text field with a calendar picker
- The format of the displayed date may vary by client or user locale
- The value submitted will always be in ISO 8601 format (YYYY-MM-DD)

## RELATED LINKS

[https://adaptivecards.io/explorer/Input.Date.html](https://adaptivecards.io/explorer/Input.Date.html)
