---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/
schema: 2.0.0
---

# Add-AMElement

## SYNOPSIS
Adds an element to an Adaptive Card.

## SYNTAX

```
Add-AMElement [-Card] <Hashtable> [-Element] <Hashtable> [-ContainerId <String>] [-ColumnId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Adds an element directly to the card body or to a specific container within the card.
This function modifies the card in-place; there is no need to reassign the result.

The function handles adding elements to:
- The main card body
- Inside a container (by specifying ContainerId)
- Inside a specific column in a ColumnSet (future functionality)

## EXAMPLES

### EXAMPLE 1
```
# Add a text block directly to card body
$title = New-AMTextBlock -Text "Hello World" -Size "Large" -Weight "Bolder"
Add-AMElement -Card $card -Element $title
```

### EXAMPLE 2
```
# Add a text block to a container
$text = New-AMTextBlock -Text "This text is inside a container" -Wrap $true
Add-AMElement -Card $card -Element $text -ContainerId "details-container"
```

### EXAMPLE 3
```
# Create a container and add multiple elements to it
$container = New-AMContainer -Id "info-section" -Style "emphasis"
Add-AMElement -Card $card -Element $container
```

# Now add elements to the container
$header = New-AMTextBlock -Text "Important Information" -Size "Medium" -Weight "Bolder"
Add-AMElement -Card $card -Element $header -ContainerId "info-section"

$content = New-AMTextBlock -Text "Here are the details you requested..." -Wrap $true
Add-AMElement -Card $card -Element $content -ContainerId "info-section"

$factSet = New-AMFactSet -Facts @(
    (New-AMFact -Title "Status" -Value "Active"),
    (New-AMFact -Title "Priority" -Value "High")
)
Add-AMElement -Card $card -Element $factSet -ContainerId "info-section"

## PARAMETERS

### -Card
The Adaptive Card hashtable to add the element to.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Element
The element to add to the card.
This should be a hashtable created by one of the
New-AM* functions such as New-AMTextBlock, New-AMImage, New-AMContainer, etc.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContainerId
Optional.
The ID of a container to add the element to.
If specified, the element
will be added to the container's items collection rather than directly to the card body.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColumnId
Optional.
The ID of a column within a container to add the element to.
Only applicable
when ContainerId is also specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

### System.Collections.Hashtable
## OUTPUTS

### None
## NOTES
This function modifies the card directly.
It uses ArrayList operations to ensure
changes are reflected in the original card variable.

When adding elements to containers, make sure the container exists and has the
correct ID, otherwise an error will be thrown.

The function automatically creates the body array if it doesn't exist, but it
expects containers to already be present when referencing them by ID.

## RELATED LINKS

[https://adaptivecards.io/explorer/](https://adaptivecards.io/explorer/)

