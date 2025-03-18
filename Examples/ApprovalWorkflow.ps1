#region Import Module
Import-Module ActionableMessages -Force -Verbose
#endregion

#region Create Approval Request Card
# Create a new card
$card = New-AMCard -OriginatorId "1234567890" -Version "1.2"

# Add header
$header = New-AMTextBlock -Text "Expense Approval Request" -Size "Large" -Weight "Bolder" -Color "Accent"
Add-AMElement -Card $card -Element $header

# Add requester info
$requesterInfo = New-AMTextBlock -Text "John Smith has submitted an expense report for your approval" -Wrap $true
Add-AMElement -Card $card -Element $requesterInfo

# Create a container for expense details
$expenseContainer = New-AMContainer -Id "expense-details" -Style "emphasis" -Padding "Default"
Add-AMElement -Card $card -Element $expenseContainer

# Add expense facts
$expenseFacts = @(
    New-AMFact -Title "Report #" -Value "EXP-2023-0456"
    New-AMFact -Title "Amount" -Value "`$1,245.78"
    New-AMFact -Title "Date Submitted" -Value "2023-10-15"
    New-AMFact -Title "Purpose" -Value "Client Meeting - Contoso Corp"
    New-AMFact -Title "Department" -Value "Sales"
)
$factSet = New-AMFactSet -Facts $expenseFacts
Add-AMElement -Card $card -Element $factSet -ContainerId "expense-details"

# Create a collapsible section for line items
$lineItemsContainer = New-AMContainer -Id "line-items" -IsVisible $false
Add-AMElement -Card $card -Element $lineItemsContainer

# Create column headers
$headerColumn1 = New-AMColumn -Width "1" -Items @(
    (New-AMTextBlock -Text "Date" -Weight "Bolder")
)
$headerColumn2 = New-AMColumn -Width "2" -Items @(
    (New-AMTextBlock -Text "Description" -Weight "Bolder")
)
$headerColumn3 = New-AMColumn -Width "1" -Items @(
    (New-AMTextBlock -Text "Amount" -Weight "Bolder")
)
$headerColumnSet = New-AMColumnSet -Id "header-columns" -Columns @($headerColumn1, $headerColumn2, $headerColumn3)
Add-AMElement -Card $card -Element $headerColumnSet -ContainerId "line-items"

# Add line items
$lineItems = @(
    @{ date = "2023-10-10"; desc = "Airfare"; amount = "`$650.00" },
    @{ date = "2023-10-11"; desc = "Hotel"; amount = "`$425.50" },
    @{ date = "2023-10-11"; desc = "Meals"; amount = "`$78.25" },
    @{ date = "2023-10-12"; desc = "Taxi"; amount = "`$92.03" }
)

foreach ($item in $lineItems) {
    $itemColumn1 = New-AMColumn -Width "1" -Items @(
        (New-AMTextBlock -Text $item.date)
    )
    $itemColumn2 = New-AMColumn -Width "2" -Items @(
        (New-AMTextBlock -Text $item.desc -Wrap $true)
    )
    $itemColumn3 = New-AMColumn -Width "1" -Items @(
        (New-AMTextBlock -Text $item.amount)
    )
    $itemColumnSet = New-AMColumnSet -Id "item-columns-$($lineItems.IndexOf($item))" `
        -Columns @($itemColumn1, $itemColumn2, $itemColumn3)

    Add-AMElement -Card $card -Element $itemColumnSet -ContainerId "line-items"
}

# Add a optional comment input
$commentContainer = New-AMContainer -Id "comment-container"
Add-AMElement -Card $card -Element $commentContainer

$commentInput = New-AMTextInput -Id "comment" -Label "Comments (optional):" -Placeholder "Add your comments here" -IsMultiline $true
Add-AMElement -Card $card -Element $commentInput -ContainerId "comment-container"

# Create approval/rejection actions
$approveAction = New-AMExecuteAction -Title "Approve" -Verb "POST" `
    -Url "https://api.example.com/expense/approve" `
    -Body '{"reportId": "EXP-2023-0456", "action": "approve", "approver": "{{userEmail}}", "comment": "{{comment.value}}"}'

$rejectAction = New-AMExecuteAction -Title "Reject" -Verb "POST" `
    -Url "https://api.example.com/expense/reject" `
    -Body '{"reportId": "EXP-2023-0456", "action": "reject", "approver": "{{userEmail}}", "comment": "{{comment.value}}"}'

# Create toggle action to show/hide line items
$toggleAction = New-AMToggleVisibilityAction -Title "View Details" -TargetElements @("line-items")

# Create action set with approval actions
$actionSet = New-AMActionSet -Id "approval-actions" -Actions @($approveAction, $rejectAction, $toggleAction)
Add-AMElement -Card $card -Element $actionSet

# Export the card to JSON
$cardJson = Export-AMCard -Card $card

# Export the card for email
$emailParams = Export-AMCardForEmail -Card $card -Subject "Expense Report Approval Required" `
    -ToRecipients "manager@example.com" -CreateGraphParams

Write-Host "Approval workflow card created successfully."
#endregion