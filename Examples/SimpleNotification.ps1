#region Import Module
Import-Module ActionableMessages -Force -Verbose
#endregion

#region Create Notification Card
# Create a new card with your originator ID
$card = New-AMCard -OriginatorId "1234567890" -Version "1.2"

# Add a logo image
$logo = New-AMImage -Url "https://adaptivecards.io/content/adaptive-card-50.png" -AltText "Company Logo" -Size "Small"
Add-AMElement -Card $card -Element $logo

# Add a title
$title = New-AMTextBlock -Text "System Notification" -Size "Large" -Weight "Bolder" -Color "Accent"
Add-AMElement -Card $card -Element $title

# Add main message
$message = New-AMTextBlock -Text "Your request has been processed successfully." -Wrap $true -Size "Medium"
Add-AMElement -Card $card -Element $message

# Add details in a container with emphasis
$detailsContainer = New-AMContainer -Id "details" -Style "emphasis" -Padding "Default"
Add-AMElement -Card $card -Element $detailsContainer

# Add facts to the details container
$facts = @(
    New-AMFact -Title "Request ID" -Value "REQ-12345"
    New-AMFact -Title "Timestamp" -Value (Get-Date -Format "yyyy-MM-dd HH:mm")
    New-AMFact -Title "Status" -Value "Complete"
)
$factSet = New-AMFactSet -Facts $facts
Add-AMElement -Card $card -Element $factSet -ContainerId "details"

# Add a "View Details" action
$viewAction = New-AMOpenUrlAction -Title "View Details" -Url "https://example.com/request/12345"

# Create action set
$actionSet = New-AMActionSet -Actions @($viewAction)
Add-AMElement -Card $card -Element $actionSet

# Export the card to JSON
$cardJson = Export-AMCard -Card $card

# Export the card for email
$emailParams = Export-AMCardForEmail -Card $card -Subject "Request Processed Successfully" `
    -ToRecipients "user@example.com" -CreateGraphParams

Write-Host "Simple notification card created successfully."
#endregion