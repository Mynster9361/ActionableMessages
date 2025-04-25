---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Column.html
schema: 2.0.0
---

# New-AMColumn

## SYNOPSIS

Creates a Column element for use in ColumnSets within an Adaptive Card.

## SYNTAX

```
New-AMColumn [[-Width] <String>] [[-VerticalContentAlignment] <String>] [[-Items] <Array>]
 [<CommonParameters>]
```

## DESCRIPTION

Creates a Column object that can be used in a ColumnSet to create multi-column layouts.
Columns can contain any number of items and help organize content horizontally.
Multiple columns are typically grouped together in a ColumnSet element created with
New-AMColumnSet.

## EXAMPLES

### EXAMPLE 1

```
# Create a simple column with text
$column = New-AMColumn -Width "1" -Items @(
    (New-AMTextBlock -Text "Column 1 Content" -Wrap $true)
)
```

### EXAMPLE 2

```
# Create multiple columns for use in a ColumnSet
$leftColumn = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://example.com/profile.jpg" -Size "Small")
)
```

$rightColumn = New-AMColumn -Width "stretch" -Items @(
(New-AMTextBlock -Text "John Doe" -Size "Medium" -Weight "Bolder"),
(New-AMTextBlock -Text "Software Developer" -Spacing "None")
)

# Combine columns into a ColumnSet

$columnSet = New-AMColumnSet -Columns @($leftColumn, $rightColumn)

### EXAMPLE 3

```
# Create a three-column layout with vertical alignment
$col1 = New-AMColumn -Width "1" -VerticalContentAlignment "top" -Items @(
    (New-AMTextBlock -Text "Top Aligned")
)
```

$col2 = New-AMColumn -Width "1" -VerticalContentAlignment "center" -Items @(
(New-AMTextBlock -Text "Center Aligned")
)

$col3 = New-AMColumn -Width "1" -VerticalContentAlignment "bottom" -Items @(
(New-AMTextBlock -Text "Bottom Aligned")
)

$columnSet = New-AMColumnSet -Columns @($col1, $col2, $col3)

## PARAMETERS

### -Width

Specifies the width of the column.
This can be:

- An absolute pixel value (e.g., "50px")
- A relative weight (e.g., "2")
- "auto" to automatically size based on content
- "stretch" to fill available space

Default: "auto"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Auto
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerticalContentAlignment

Controls how the content is vertically aligned within the column.
Valid values: "top", "center", "bottom"

Default: "top"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Top
Accept pipeline input: False
Accept wildcard characters: False
```

### -Items

An array of elements to place inside the column.
These should be created using
other New-AM\* functions like New-AMTextBlock, New-AMImage, etc.

Default: empty array (@())

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe input to New-AMColumn.

## OUTPUTS

### System.Collections.Hashtable

### Returns a hashtable representing the Column element.

## NOTES

Columns must be used within a ColumnSet.
To create a multi-column layout:

1.  Create individual columns using New-AMColumn
2.  Combine them using New-AMColumnSet
3.  Add the ColumnSet to your card with Add-AMElement

Width values can be:

- "auto" - Column uses minimum width needed for its content
- "stretch" - Column stretches to fill available width
- "pixel" value (e.g., "50px") - Fixed width in pixels
- Numeric proportion (e.g., "1", "2") - Relative width compared to other columns

## RELATED LINKS

[https://adaptivecards.io/explorer/Column.html](https://adaptivecards.io/explorer/Column.html)
