---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/ActionSet.html
schema: 2.0.0
---

# New-AMApprovalCard

## SYNOPSIS

Creates an Adaptive Card for approval requests.

## SYNTAX

```
New-AMApprovalCard [[-OriginatorId] <String>] [-Title] <String> [-RequestID] <String> [-Requester] <String>
 [[-Details] <Hashtable[]>] [[-Description] <String>] [[-Justification] <String>] [[-ApproveUrl] <String>]
 [[-ApproveBody] <String>] [[-RejectUrl] <String>] [[-RejectBody] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The \`New-AMApprovalCard\` function generates an Adaptive Card to notify approvers about a request that requires their decision.
The card includes details about the request, requester, justification, and additional information.
It also provides options for approvers to approve or reject the request, along with a comment field for additional input.

## EXAMPLES

### EXAMPLE 1

```
# Example 1: Create an approval card using splatting
$approvalCardParams = @{
    OriginatorId  = "approval-system"
    Title         = "Purchase Request Approval"
    RequestID     = "REQ-2023-001"
    Requester     = "John Doe"
    Details       = @(
        @{ Title = "Amount"; Value = "$5000" },
        @{ Title = "Department"; Value = "Finance" }
    )
    Description   = "Approval is required for the purchase of new office equipment."
    Justification = "The current equipment is outdated and impacts productivity."
    ApproveUrl    = "https://api.example.com/approve"
    ApproveBody   = "{`"requestId`": `"$RequestID`", `"action`": `"approve`", `"approver`": `"{{userEmail}}`", `"comment`": `"{{comment.value}}`"}"
    RejectUrl     = "https://api.example.com/reject"
    RejectBody    = "{`"requestId`": `"$RequestID`", `"action`": `"reject`", `"approver`": `"{{userEmail}}`", `"comment`": `"{{comment.value}}`"}"
}


$approvalCard = New-AMApprovalCard @approvalCardParams
```

### EXAMPLE 2

```
# Example 2: Create a simple approval card using splatting
$simpleApprovalCardParams = @{
    OriginatorId = "leave-approval-system"
    Title        = "Leave Request Approval"
    RequestID    = "REQ-2023-002"
    Requester    = "Jane Smith"
    Description  = "Approval is required for a leave request from Jane Smith."
    ApproveUrl   = "https://api.example.com/approve"
    RejectUrl    = "https://api.example.com/reject"
}


$approvalCard = New-AMApprovalCard @simpleApprovalCardParams
```

## PARAMETERS

### -OriginatorId

(Optional) The originator ID of the card.
This is used to identify the source of the card.
Defaults to "your-originator-id".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Your-originator-id
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title

The title of the approval card, typically describing the request.

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

### -RequestID

The unique identifier for the request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requester

The name or email of the person submitting the request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Details

(Optional) A list of additional details about the request.
Each entry should be a hashtable with \`Title\` and \`Value\` keys.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

(Optional) A description of the request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Justification

(Optional) A justification for the request, explaining why it is needed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApproveUrl

(Optional) The URL to send the approval action.
Defaults to "https://api.example.com/approve".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: Https://api.example.com/approve
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApproveBody

(Optional) The body of the POST request sent to the \`ApproveUrl\`.
Defaults to:
"{\`"requestId\`": \`"$RequestID\`", \`"action\`": \`"approve\`", \`"approver\`": \`"{{userEmail}}\`", \`"comment\`": \`"{{comment.value}}\`"}"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: "{`"requestId`": `"$RequestID`", `"action`": `"approve`", `"approver`": `"{{userEmail}}`", `"comment`": `"{{comment.value}}`"}"
Accept pipeline input: False
Accept wildcard characters: False
```

### -RejectUrl

(Optional) The URL to send the rejection action.
Defaults to "https://api.example.com/reject".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: Https://api.example.com/reject
Accept pipeline input: False
Accept wildcard characters: False
```

### -RejectBody

(Optional) The body of the POST request sent to the \`RejectUrl\`.
Defaults to:
"{\`"requestId\`": \`"$RequestID\`", \`"action\`": \`"reject\`", \`"approver\`": \`"{{userEmail}}\`", \`"comment\`": \`"{{comment.value}}\`"}"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: "{`"requestId`": `"$RequestID`", `"action`": `"reject`", `"approver`": `"{{userEmail}}`", `"comment`": `"{{comment.value}}`"}"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function is part of the Actionable Messages module and is used to create Adaptive Cards for approval requests.
The card can be exported and sent via email or other communication channels.

## RELATED LINKS
