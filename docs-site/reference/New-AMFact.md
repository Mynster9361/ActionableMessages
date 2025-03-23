---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/FactSet.html
schema: 2.0.0
---

# New-AMFact

## SYNOPSIS
Creates a Fact object for use in a FactSet within an Adaptive Card.

## SYNTAX

```
New-AMFact [-Title] <String> [-Value] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a key-value pair (fact) to be displayed in a FactSet element.
Facts are used to display information in a structured, two-column format
with labels on the left and values on the right.

Multiple Fact objects are typically grouped together in a FactSet element
created with New-AMFactSet to create a list of related information.

## EXAMPLES

### EXAMPLE 1
```
# Create a single fact
$employeeFact = New-AMFact -Title "Employee" -Value "John Doe"
```

### EXAMPLE 2
```
# Create multiple facts for a person
$personFacts = @(
    New-AMFact -Title "Name" -Value "Jane Smith"
    New-AMFact -Title "Title" -Value "Software Engineer"
    New-AMFact -Title "Department" -Value "R&D"
    New-AMFact -Title "Email" -Value "jane.smith@example.com"
)
```

# Add these facts to a FactSet
$factSet = New-AMFactSet -Facts $personFacts
Add-AMElement -Card $card -Element $factSet

### EXAMPLE 3
```
# Create facts with formatted values
$orderFacts = @(
    New-AMFact -Title "Order Number" -Value "ORD-12345"
    New-AMFact -Title "Date" -Value (Get-Date -Format "yyyy-MM-dd")
    New-AMFact -Title "Status" -Value "**Shipped**"
    New-AMFact -Title "Total" -Value "$125.99"
)
```

## PARAMETERS

### -Title
The label or name of the fact.
This appears in the left column of the FactSet
and is typically bold or emphasized in the rendered card.

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

### -Value
The value or content of the fact.
This appears in the right column of the FactSet,
paired with the Title.

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

### None. You cannot pipe input to New-AMFact.
## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable with 'title' and 'value' properties.
## NOTES
Facts are designed to display in a two-column format and work best for structured
data like properties, specifications, or details about an item or person.

While Values can contain simple Markdown formatting (bold, italics, etc.),
complex formatting may not render consistently across all Adaptive Card hosts.

## RELATED LINKS

[https://adaptivecards.io/explorer/FactSet.html](https://adaptivecards.io/explorer/FactSet.html)

