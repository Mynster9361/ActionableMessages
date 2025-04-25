---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/ActionSet.html
schema: 2.0.0
---

# New-AMActionSet

## SYNOPSIS

Creates an ActionSet element for an Adaptive Card.

## SYNTAX

```
New-AMActionSet [[-Id] <String>] [-Actions] <Array> [[-Padding] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION

Creates an ActionSet element that can contain multiple actions (buttons) and be added to a card's body.
ActionSets group related actions together and allow you to place action buttons throughout your card,
not just at the bottom.

## EXAMPLES

### EXAMPLE 1

```
# Create a simple ActionSet with two actions
$openUrlAction = New-AMOpenUrlAction -Title "Visit Website" -Url "https://example.com"
$executeAction = New-AMExecuteAction -Title "Approve" -Verb "POST" -Url "https://api.example.com/approve" -Body '{"id": "12345"}'

$actionSet = New-AMActionSet -Id "main-actions" -Actions @($openUrlAction, $submitAction)
Add-AMElement -Card $card -Element $actionSet
```

### EXAMPLE 2

```
# Create an ActionSet with no padding containing an execute action
$executeAction = New-AMExecuteAction -Title "Approve" -Verb "POST" -Url "https://api.example.com/approve"
$actionSet = New-AMActionSet -Id "approval-actions" -Actions @($executeAction) -Padding "None"
Add-AMElement -Card $card -Element $actionSet -ContainerId "container1"
```

## PARAMETERS

### -Id

Optional unique identifier for the ActionSet.
Useful when you need to reference or manipulate
the ActionSet programmatically or with visibility toggles.

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

### -Actions

An array of action objects to include in the ActionSet.
These should be created using functions like

```
New-AMOpenUrlAction,
New-AMSubmitAction,
New-AMExecuteAction,
New-AMShowCardAction,
New-AMToggleVisibilityAction.
```

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Padding

Optional padding value to apply around the ActionSet.
Valid values include: "None", "Small", "Default", "Large"

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe input to New-AMActionSet.

## OUTPUTS

### System.Collections.Hashtable

### Returns a hashtable representing the ActionSet element.

## NOTES

ActionSets provide a way to group multiple actions together and place them anywhere within your card's body,
not just at the bottom of the card.
This gives you greater flexibility in designing your card's layout.

For Outlook Actionable Messages, action buttons placed in ActionSets render better than those
in the card's top-level actions property.

## RELATED LINKS

[https://adaptivecards.io/explorer/ActionSet.html](https://adaptivecards.io/explorer/ActionSet.html)
