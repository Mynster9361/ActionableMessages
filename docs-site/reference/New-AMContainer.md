---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Container.html
schema: 2.0.0
---

# New-AMContainer

## SYNOPSIS
Creates a Container element for an Adaptive Card.

## SYNTAX

```
New-AMContainer [[-Id] <String>] [[-Items] <Array>] [[-Style] <String>] [[-IsVisible] <Boolean>]
 [[-Padding] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a Container element that can group and style multiple elements together.
Containers are fundamental building blocks for organizing content in Adaptive Cards,
allowing you to apply common styling, visibility settings, and padding to a group
of elements.

Containers can hold any combination of elements including text blocks, images,
other containers, column sets, and more.

## EXAMPLES

### EXAMPLE 1
```
# Create a simple container with text
$container = New-AMContainer -Id "info-section" -Style "emphasis"
Add-AMElement -Card $card -Element $container
```

# Add elements to the container
$title = New-AMTextBlock -Text "Important Information" -Size "Medium" -Weight "Bolder"
Add-AMElement -Card $card -Element $title -ContainerId "info-section"

$text = New-AMTextBlock -Text "Here are the details you need to know..." -Wrap $true
Add-AMElement -Card $card -Element $text -ContainerId "info-section"

### EXAMPLE 2
```
# Create a container with pre-populated items
$items = @(
    (New-AMTextBlock -Text "Container Title" -Size "Medium" -Weight "Bolder"),
    (New-AMTextBlock -Text "This container has multiple elements" -Wrap $true),
    (New-AMImage -Url "https://example.com/image.jpg" -Size "Medium")
)
```

$container = New-AMContainer -Id "pre-populated" -Items $items -Style "good" -Padding "Default"
Add-AMElement -Card $card -Element $container

### EXAMPLE 3
```
# Create a hidden container that can be toggled
$detailsContainer = New-AMContainer -Id "details-section" -IsVisible $false -Style "emphasis" -Padding "Small"
Add-AMElement -Card $card -Element $detailsContainer
```

# Add content to the hidden container
$detailsText = New-AMTextBlock -Text "These are additional details that are initially hidden." -Wrap $true
Add-AMElement -Card $card -Element $detailsText -ContainerId "details-section"

# Create a button to toggle visibility
$toggleAction = New-AMToggleVisibilityAction -Title "Show/Hide Details" -TargetElements @("details-section")
Add-AMElement -Card $card -Element (New-AMActionSet -Id "actions" -Actions @($toggleAction))

## PARAMETERS

### -Id
An optional unique identifier for the container.
This ID can be used to reference
the container when adding elements to it or when targeting it with visibility
toggle actions.

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

### -Items
An array of elements to place inside the container.
These should be created using
other New-AM* functions like New-AMTextBlock, New-AMImage, etc.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
Optional styling to apply to the container.
Valid values:
- "default": Standard container with no special styling
- "emphasis": Container with background color for emphasis
- "good": Container styled to indicate positive or successful content
- "attention": Container styled to draw attention
- "warning": Container styled to indicate warning or caution

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

### -IsVisible
Optional boolean that controls whether the container is initially visible.
When set to $false, the container will be hidden until shown by a toggle action.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Padding
Optional spacing to apply around the container contents.
Valid values: "None", "Small", "Default", "Large"
Default: "None"

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

### None. You cannot pipe input to New-AMContainer.
## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable representing the Container element.
## NOTES
Containers are one of the most versatile elements in Adaptive Cards.
They help with:
- Grouping related content together
- Applying consistent styling to multiple elements
- Creating expandable/collapsible sections with toggle visibility
- Organizing card layout into logical sections

To add elements to an existing container, use the Add-AMElement function with
the -ContainerId parameter.

## RELATED LINKS

[https://adaptivecards.io/explorer/Container.html](https://adaptivecards.io/explorer/Container.html)

