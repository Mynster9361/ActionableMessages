---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://docs.microsoft.com/en-us/outlook/actionable-messages/
schema: 2.0.0
---

# New-AMCard

## SYNOPSIS
Creates a new Adaptive Card object.

## SYNTAX

```
New-AMCard [[-Version] <String>] [-OriginatorId] <String> [[-HideOriginalBody] <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Adaptive Card hashtable that serves as the foundation for building
an Adaptive Card.
This is typically the first function you call when creating
a new card.

The card object created by this function will contain the basic structure needed
for an Adaptive Card, including empty collections for body elements and actions.

## EXAMPLES

### EXAMPLE 1
```
# Create a basic card
$card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
```

### EXAMPLE 2
```
# Create a card and show the original email body
$card = New-AMCard -OriginatorId "1234567890" -Version "1.2" -HideOriginalBody $false
```

### EXAMPLE 3
```
# Create a complete card with content
$card = New-AMCard -OriginatorId "1234567890"
Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Expense Approval Required" -Size "Large" -Weight "Bolder")
Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Please review the following expense report:" -Wrap $true)
```

# Add more elements and then export
$json = Export-AMCard -Card $card

## PARAMETERS

### -Version
The version of the Adaptive Card schema to use.
Valid values: "1.0", "1.1", "1.2"
Default: "1.2"

Different versions support different card features:
- 1.0: Basic layout and elements
- 1.1: Adds support for additional features like horizontal alignment
- 1.2: Adds support for more advanced features and styling options

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 1.2
Accept pipeline input: False
Accept wildcard characters: False
```

### -OriginatorId
A unique identifier for the sender of the card.
For Outlook Actionable Messages,
this should be the originator ID registered with Microsoft.

This ID is critical for security purposes, as it validates that your organization
is authorized to send Actionable Messages and make HTTP requests to your endpoints.

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

### -HideOriginalBody
Specifies whether to hide the original email body when displaying the card.

When set to $true (default), only the Adaptive Card is displayed in the email.
When set to $false, both the original email text and the card are displayed.

Default: $true

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: True
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

### None. You cannot pipe input to New-AMCard.
## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable representing the Adaptive Card structure.
## NOTES
The OriginatorId is required for Outlook Actionable Messages.
You must register
your originator ID with Microsoft before using it in production through the Actionable
Email Developer Dashboard at https://aka.ms/publishactionableemails.

For testing purposes in development environments, any value can be used.

After creating a card, use Add-AMElement along with element creation functions
like New-AMTextBlock and New-AMImage to populate the card with content.

## RELATED LINKS

[https://docs.microsoft.com/en-us/outlook/actionable-messages/](https://docs.microsoft.com/en-us/outlook/actionable-messages/)

[https://adaptivecards.io/explorer/](https://adaptivecards.io/explorer/)

