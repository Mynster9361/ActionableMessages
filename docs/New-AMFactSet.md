---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/FactSet.html
schema: 2.0.0
---

# New-AMFactSet

## SYNOPSIS

Creates a FactSet element for an Adaptive Card.

## SYNTAX

```
New-AMFactSet [-Facts] <Array> [[-Id] <String>] [<CommonParameters>]
```

## DESCRIPTION

Creates a FactSet element that displays a series of facts (key-value pairs) in a
structured, two-column format.
FactSets are ideal for displaying property lists,
specifications, details, or any information that benefits from a label-value layout.

The FactSet element automatically formats the facts in two columns, with titles
in the left column (typically bold) and values in the right column.

## EXAMPLES

### EXAMPLE 1

```
# Create a simple employee information FactSet
$facts = @(
    New-AMFact -Title "Employee" -Value "John Doe"
    New-AMFact -Title "Department" -Value "Engineering"
    New-AMFact -Title "Title" -Value "Senior Developer"
    New-AMFact -Title "Start Date" -Value "2020-01-15"
)
$factSet = New-AMFactSet -Facts $facts
Add-AMElement -Card $card -Element $factSet
```

### EXAMPLE 2

```
# Create a product specification FactSet with ID
$specs = @(
    New-AMFact -Title "Model" -Value "ThinkPad X1"
    New-AMFact -Title "Processor" -Value "Intel Core i7"
    New-AMFact -Title "Memory" -Value "16 GB"
    New-AMFact -Title "Storage" -Value "512 GB SSD"
)
$specSheet = New-AMFactSet -Facts $specs -Id "product-specs"
```

# Add the FactSet to a container

$container = New-AMContainer -Id "spec-container" -Style "emphasis"
Add-AMElement -Card $card -Element $container
Add-AMElement -Card $card -Element $specSheet -ContainerId "spec-container"

## PARAMETERS

### -Facts

An array of fact objects created with New-AMFact.
Each fact represents a key-value
pair with a Title (key) and Value.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

Optional unique identifier for the FactSet.
This can be useful when you need to
reference this element in other parts of the card or target it with actions.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe input to New-AMFactSet.

## OUTPUTS

### System.Collections.Hashtable

### Returns a hashtable representing the FactSet element.

## NOTES

FactSets are ideal for displaying structured information where clarity and organization
are important.
Some best practices:

- Use concise titles that clearly identify the information
- Group related facts together in a single FactSet
- For very long lists, consider using multiple FactSets with headers
- FactSets render differently across different Adaptive Card hosts,
  so test your cards in the target environment

## RELATED LINKS

[https://adaptivecards.io/explorer/FactSet.html](https://adaptivecards.io/explorer/FactSet.html)
