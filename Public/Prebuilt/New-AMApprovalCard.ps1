function New-AMApprovalCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card for approval requests.

    .DESCRIPTION
    The `New-AMApprovalCard` function generates an Adaptive Card to notify approvers about a request that requires their decision.
    The card includes details about the request, requester, justification, and additional information.
    It also provides options for approvers to approve or reject the request, along with a comment field for additional input.

    .PARAMETER OriginatorId
    (Optional) The originator ID of the card. This is used to identify the source of the card. Defaults to "your-originator-id".

    .PARAMETER Title
    The title of the approval card, typically describing the request.

    .PARAMETER RequestID
    The unique identifier for the request.

    .PARAMETER Requester
    The name or email of the person submitting the request.

    .PARAMETER Details
    (Optional) A list of additional details about the request. Each entry should be a hashtable with `Title` and `Value` keys.

    .PARAMETER Description
    (Optional) A description of the request.

    .PARAMETER Justification
    (Optional) A justification for the request, explaining why it is needed.

    .PARAMETER ApproveUrl
    (Optional) The URL to send the approval action. Defaults to "https://api.example.com/approve".

    .PARAMETER ApproveBody
    (Optional) The body of the POST request sent to the `ApproveUrl`.
    Defaults to:
        "{`"requestId`": `"$RequestID`", `"action`": `"approve`", `"approver`": `"{{userEmail}}`", `"comment`": `"{{comment.value}}`"}"

    .PARAMETER RejectUrl
    (Optional) The URL to send the rejection action. Defaults to "https://api.example.com/reject".

    .PARAMETER RejectBody
    (Optional) The body of the POST request sent to the `RejectUrl`.
    Defaults to:
        "{`"requestId`": `"$RequestID`", `"action`": `"reject`", `"approver`": `"{{userEmail}}`", `"comment`": `"{{comment.value}}`"}"

    .EXAMPLE
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

    .EXAMPLE
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

    .NOTES
    This function is part of the Actionable Messages module and is used to create Adaptive Cards for approval requests.
    The card can be exported and sent via email or other communication channels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OriginatorId = "your-originator-id",

        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [string]$RequestID,

        [Parameter(Mandatory = $true)]
        [string]$Requester,

        [Parameter(Mandatory = $false)]
        [hashtable[]]$Details,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string]$Justification,

        [Parameter(Mandatory = $false)]
        [string]$ApproveUrl = "https://api.example.com/approve",

        [Parameter(Mandatory = $false)]
        [string]$ApproveBody = "{`"requestId`": `"$RequestID`", `"action`": `"approve`", `"approver`": `"{{userEmail}}`", `"comment`": `"{{comment.value}}`"}",

        [Parameter(Mandatory = $false)]
        [string]$RejectUrl = "https://api.example.com/reject",

        [Parameter(Mandatory = $false)]
        [string]$RejectBody = "{`"requestId`": `"$RequestID`", `"action`": `"reject`", `"approver`": `"{{userEmail}}`", `"comment`": `"{{comment.value}}`"}"

    )

    # Create a new card
    $card = New-AMCard -OriginatorId $OriginatorId -Version "1.0"

    # Add header
    $header = New-AMTextBlock -Text $Title -Size "Large" -Weight "Bolder"
    Add-AMElement -Card $card -Element $header

    # Add request details
    $requestDetailsContainer = New-AMContainer -Id "request-details" -Style "emphasis" -Padding "Default"
    Add-AMElement -Card $card -Element $requestDetailsContainer

    # Add requester info and request details
    $requestFacts = @(
        New-AMFact -Title "Requester" -Value $Requester
        New-AMFact -Title "Request ID" -Value $RequestID
        New-AMFact -Title "Date Submitted" -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    )

    # Add additional details if provided
    if ($Details) {
        foreach ($detail in $Details) {
            $requestFacts += New-AMFact -Title $detail.Title -Value $detail.Value
        }
    }

    $factSet = New-AMFactSet -Facts $requestFacts
    Add-AMElement -Card $card -Element $factSet -ContainerId "request-details"

    $requestContainer = New-AMContainer -Id "request" -Style "Default" -Padding "Default"
    Add-AMElement -Card $card -Element $requestContainer
    # Add description if provided
    if ($Description) {
        $descriptionBlock = New-AMTextBlock -Text "Request:" -Weight "Bolder" -Size "Medium"
        Add-AMElement -Card $card -Element $descriptionBlock -ContainerId "request"
        $descriptionBlockDescription = New-AMTextBlock -Text $Description -Wrap $true
        Add-AMElement -Card $card -Element $descriptionBlockDescription -ContainerId "request"
    }

    # Add justification if provided
    if ($Justification) {
        $justificationBlock = New-AMTextBlock -Text "Justification:" -Weight "Bolder" -Size "Medium"
        Add-AMElement -Card $card -Element $justificationBlock -ContainerId "request"
        $justificationBlockDescription = New-AMTextBlock -Text "$Justification" -Wrap $true
        Add-AMElement -Card $card -Element $justificationBlockDescription -ContainerId "request"
    }

    # Add comment field
    $commentContainer = New-AMContainer -Id "comment-container"
    Add-AMElement -Card $card -Element $commentContainer

    $commentLabel = New-AMTextBlock -Text "Add your comments:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $commentLabel -ContainerId "comment-container"

    $commentInput = New-AMTextInput -Id "comment" -Placeholder "Enter comments here..." -IsMultiline $true
    Add-AMElement -Card $card -Element $commentInput -ContainerId "comment-container"

    # Create approval/rejection actions
    $approveAction = New-AMExecuteAction -Title "Approve" -Verb "POST" `
        -Url $ApproveUrl `
        -Body $ApproveBody

    $rejectAction = New-AMExecuteAction -Title "Reject" -Verb "POST" `
        -Url $RejectUrl `
        -Body $RejectBody

    $actionSet = New-AMActionSet -Actions @($approveAction, $rejectAction)
    Add-AMElement -Card $card -Element $actionSet

    return $card
}
