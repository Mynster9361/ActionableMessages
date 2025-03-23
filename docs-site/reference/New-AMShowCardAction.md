---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Action.OpenUrl.html
schema: 2.0.0
---

# New-AMShowCardAction

## SYNOPSIS
Creates a ShowCard Action for an Adaptive Card.

## SYNTAX

```
New-AMShowCardAction [-Title] <String> [[-Id] <String>] [[-Card] <Hashtable>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates an Action.ShowCard element that reveals a nested card when clicked.
This action is useful for progressive disclosure of information - showing additional
details, forms, or content without navigating away from the current view or requiring
another HTTP request.

## EXAMPLES

### EXAMPLE 1
```
# Create a ShowCard action with an empty card
$showAction = New-AMShowCardAction -Title "Show Details"
```

### EXAMPLE 2
```
# Create a ShowCard action with a pre-configured card
$detailCard = New-AMCard -OriginatorId "nested-card"
Add-AMElement -Card $detailCard -Element (New-AMTextBlock -Text "These are additional details" -Wrap $true)
$showAction = New-AMShowCardAction -Title "Show Details" -Card $detailCard
```

### EXAMPLE 3
```
# Create a ShowCard action with a form inside
$feedbackCard = New-AMCard -OriginatorId "feedback-card"
Add-AMElement -Card $feedbackCard -Element (New-AMTextBlock -Text "Please provide your feedback:")
Add-AMElement -Card $feedbackCard -Element (New-AMTextInput -Id "comments" -Placeholder "Type your comments here" -IsMultiline $true)
```

# Create submit button for the nested card
$submitAction = New-AMSubmitAction -Title "Submit Feedback" -Data @{ action = "feedback" }
$actionSet = New-AMActionSet -Actions @($submitAction)
Add-AMElement -Card $feedbackCard -Element $actionSet

$feedbackAction = New-AMShowCardAction -Title "Provide Feedback" -Id "feedback-form" -Card $feedbackCard

## PARAMETERS

### -Title
The text to display on the action button that will reveal the card.

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

### -Id
Optional unique identifier for the action.
If not specified, a new GUID will be
generated automatically.
The ID can be useful when referencing this action from
other parts of your card.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: [guid]::NewGuid().ToString()
Accept pipeline input: False
Accept wildcard characters: False
```

### -Card
Optional pre-configured card to show when the button is clicked.
If not provided,
an empty card will be created with default properties.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

## OUTPUTS

## NOTES

## RELATED LINKS
