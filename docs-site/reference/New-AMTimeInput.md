---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Input.Time.html
schema: 2.0.0
---

# New-AMTimeInput

## SYNOPSIS
Creates a Time Input element for an Adaptive Card.

## SYNTAX

```
New-AMTimeInput [[-id] <String>] [[-title] <String>] [[-value] <String>] [[-placeholder] <String>]
 [[-style] <String>]
```

## DESCRIPTION
Creates an Input.Time element that allows users to select a time value.
Time inputs are useful for scheduling, appointment setting, or any scenario
where users need to specify a time of day.

The element typically renders as a text field with a time picker interface,
though the exact appearance may vary across different Adaptive Card hosts.

## EXAMPLES

### EXAMPLE 1
```
# Create a simple time input with default values (current time)
$meetingTime = New-AMTimeInput -id "meetingStart" -title "Meeting Start Time:"
Add-AMElement -Card $card -Element $meetingTime
```

### EXAMPLE 2
```
# Create a time input with specific default time
$reminderTime = New-AMTimeInput -id "reminderTime" -title "Set Reminder For:" `
    -value "14:30" -placeholder "Select reminder time"
```

### EXAMPLE 3
```
# Create a time input for a form
$card = New-AMCard -OriginatorId "calendar-app"
```

$startTime = New-AMTimeInput -id "startTime" -title "Start Time:" -value "09:00"
$endTime = New-AMTimeInput -id "endTime" -title "End Time:" -value "17:00"

Add-AMElement -Card $card -Element $startTime
Add-AMElement -Card $card -Element $endTime

$submitAction = New-AMSubmitAction -Title "Schedule" -Data @{ action = "createEvent" }
Add-AMAction -Card $card -Action $submitAction

## PARAMETERS

### -id
A unique identifier for the time input element.
This ID will be used when the card
is submitted to identify the time value selected by the user.

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

### -title
Text label to display above the input field, describing what the time selection is for.

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

### -value
Optional default time value for the input.
Should be in 24-hour format (HH:MM).
If not specified, defaults to the current time.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: (Get-Date).ToString("HH:mm")
Accept pipeline input: False
Accept wildcard characters: False
```

### -placeholder
Optional text to display when no time has been selected.
Default: "Select time"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Select time
Accept pipeline input: False
Accept wildcard characters: False
```

### -style
Optional visual style for the input element.
Valid values: "default", "expanded"
Default: "default"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None. You cannot pipe input to New-AMTimeInput.
## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable representing the Input.Time element.
## NOTES
Time inputs in Adaptive Cards:
- Values are typically in 24-hour format (HH:MM)
- The display format may vary based on user locale settings
- Not all Adaptive Card hosts support all time input features consistently

## RELATED LINKS

[https://adaptivecards.io/explorer/Input.Time.html](https://adaptivecards.io/explorer/Input.Time.html)

