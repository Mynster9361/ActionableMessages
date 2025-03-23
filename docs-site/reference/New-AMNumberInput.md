---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Input.Number.html
schema: 2.0.0
---

# New-AMNumberInput

## SYNOPSIS
Creates a Number Input element for an Adaptive Card.

## SYNTAX

```
New-AMNumberInput [-Id] <String> [[-Max] <String>] [[-Min] <String>] [[-Placeholder] <String>]
 [[-Value] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates an Input.Number element that allows users to enter or select a numeric value.
Number inputs are useful when you need to collect quantities, ratings, scores, or any
other numeric data from users.
The input can be configured with minimum and maximum
values.

## EXAMPLES

### EXAMPLE 1
```
# Create a simple number input
$quantityInput = New-AMNumberInput -Id "quantity"
Add-AMElement -Card $card -Element $quantityInput
```

### EXAMPLE 2
```
# Create a number input with range constraints
$ratingInput = New-AMNumberInput -Id "rating" `
    -Min "1" -Max "10" -Value "5" -Placeholder "Enter rating (1-10)"
```

### EXAMPLE 3
```
# Create a quantity selector with default value
$quantityInput = New-AMNumberInput -Id "quantity" `
    -Min "1" -Max "100" -Value "1" -Placeholder "Enter quantity"
```

## PARAMETERS

### -Id
A unique identifier for the input element.
This ID will be used when the card is submitted
to identify the numeric value entered by the user.

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

### -Max
Optional maximum allowed numeric value.
Users will not be able to enter a value above this.

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

### -Min
Optional minimum allowed numeric value.
Users will not be able to enter a value below this.

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

### -Placeholder
Optional text to display when no value has been entered.

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

### -Value
Optional default numeric value for the input.
If not specified, the field will be empty.

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

### None. You cannot pipe input to New-AMNumberInput.
## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable representing the Input.Number element.
## NOTES
Number inputs in Adaptive Cards will typically render as a text field that only accepts
numeric values.
Some clients may show increment/decrement buttons depending on the
min and max values provided.

Values are submitted as strings, so you'll need to convert them to numeric types
when processing the card data.

## RELATED LINKS

[https://adaptivecards.io/explorer/Input.Number.html](https://adaptivecards.io/explorer/Input.Number.html)

