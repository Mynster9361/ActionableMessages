---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/
schema: 2.0.0
---

# ConvertFrom-AMJson

## SYNOPSIS

Converts an Adaptive Card JSON to PowerShell commands using the ActionableMessages module.

## SYNTAX

```
ConvertFrom-AMJson [-Json] <String> [[-OutputPath] <String>] [-GenerateId] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION

Takes an Adaptive Card JSON string and generates the equivalent PowerShell commands
that would create the same card using the ActionableMessages module functions.

This function is useful for:

- Converting existing Adaptive Cards to PowerShell code
- Learning by example how to create complex cards
- Migrating from other platforms that export Adaptive Cards as JSON
- Generating scripts from designer-created cards

The generated code follows best practices for the ActionableMessages module
and maintains proper nesting of elements within containers and column sets.

## EXAMPLES

### EXAMPLE 1

```
# Convert JSON from a file and display the PowerShell commands
$jsonContent = Get-Content -Path ".\myAdaptiveCard.json" -Raw
ConvertFrom-AMJson -Json $jsonContent
```

### EXAMPLE 2

```
# Convert JSON and save the PowerShell commands to a file
$jsonContent = Get-Content -Path ".\designerCard.json" -Raw
ConvertFrom-AMJson -Json $jsonContent -OutputPath ".\createCard.ps1"
```

### EXAMPLE 3

```
# Convert JSON from a web response
$response = Invoke-RestMethod -Uri "https://myapi.example.com/cards/template"
$response.cardJson | ConvertFrom-AMJson
```

## PARAMETERS

### -Json

The Adaptive Card JSON string to convert to PowerShell commands.
This can be a complete Adaptive Card JSON object with schema, type, version, etc.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OutputPath

Optional.
If specified, writes the generated PowerShell script to this file path
instead of returning it as a string.

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

### -GenerateId

Optional switch.
When specified, generates new IDs for elements that don't have them,
which can be useful when you need to reference elements later in your code.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.String or None

### Returns the generated PowerShell script as a string if no OutputPath is specified.

### If OutputPath is specified, writes to the file and returns a confirmation message.

## NOTES

This function will attempt to handle all standard Adaptive Card elements and actions,
including TextBlocks, Images, ImageSets, Containers, ColumnSets, FactSets, Input elements,
and various action types.

If the JSON contains unsupported element types, they will be commented in the output script.

Variable names in the generated script are based on element types and IDs when available.

## RELATED LINKS

[https://adaptivecards.io/explorer/](https://adaptivecards.io/explorer/)

[Export-AMCard]()
