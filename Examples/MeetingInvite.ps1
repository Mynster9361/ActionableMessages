#region Import Module
Import-Module ActionableMessages -Force -Verbose
#endregion

#region Create Meeting Invitation Card
# Create a new card
$card = New-AMCard -OriginatorId "1234567890" -Version "1.2"

# Add header
$header = New-AMTextBlock -Text "Team Meeting Invitation" -Size "ExtraLarge" -Weight "Bolder" -Color "Accent"
Add-AMElement -Card $card -Element $header

# Add meeting description
$description = New-AMTextBlock -Text "You're invited to join our quarterly planning session. Please respond with your availability." -Wrap $true
Add-AMElement -Card $card -Element $description

# Create a container for meeting details
$detailsContainer = New-AMContainer -Id "meeting-details" -Style "emphasis" -Padding "Default"
Add-AMElement -Card $card -Element $detailsContainer

# Add meeting facts
$meetingFacts = @(
    New-AMFact -Title "Topic" -Value "Q4 Planning Session"
    New-AMFact -Title "Date" -Value "November 15, 2023"
    New-AMFact -Title "Time" -Value "10:00 AM - 12:00 PM (EST)"
    New-AMFact -Title "Location" -Value "Conference Room A / Teams Meeting"
    New-AMFact -Title "Organizer" -Value "Sarah Johnson"
)
$factSet = New-AMFactSet -Facts $meetingFacts
Add-AMElement -Card $card -Element $factSet -ContainerId "meeting-details"

# Create column layout for agenda
$agendaContainer = New-AMContainer -Id "agenda-container" -Style "default" -Padding "Default"
Add-AMElement -Card $card -Element $agendaContainer

$agendaHeader = New-AMTextBlock -Text "Agenda" -Size "Medium" -Weight "Bolder"
Add-AMElement -Card $card -Element $agendaHeader -ContainerId "agenda-container"

# Add agenda items
$agendaItems = @(
    "1. Review Q3 Results (20 min)",
    "2. Q4 Goals & Objectives (30 min)",
    "3. Budget Planning (40 min)",
    "4. Action Items & Next Steps (20 min)"
)

foreach ($item in $agendaItems) {
    $agendaItem = New-AMTextBlock -Text $item -Wrap $true
    Add-AMElement -Card $card -Element $agendaItem -ContainerId "agenda-container"
}

# Create availability response section
$responseContainer = New-AMContainer -Id "response-container"
Add-AMElement -Card $card -Element $responseContainer

$responseHeader = New-AMTextBlock -Text "Your Response" -Size "Medium" -Weight "Bolder"
Add-AMElement -Card $card -Element $responseHeader -ContainerId "response-container"

# Create attendance options
$attendanceChoices = @(
    New-AMChoice -Title "I'll attend in person" -Value "in-person"
    New-AMChoice -Title "I'll attend virtually" -Value "virtual"
    New-AMChoice -Title "I can't attend" -Value "decline"
)
$attendanceInput = New-AMChoiceSetInput -Id "attendance" -Label "Attendance:" -Choices $attendanceChoices -Style "expanded" -IsMultiSelect $false
Add-AMElement -Card $card -Element $attendanceInput -ContainerId "response-container"

# Add comment field
$commentInput = New-AMTextInput -Id "comment" -Label "Comments (optional):" -Placeholder "Add any comments or questions here..." -IsMultiline $true
Add-AMElement -Card $card -Element $commentInput -ContainerId "response-container"

# Create calendar links
$teamsLink = New-AMOpenUrlAction -Title "Join Teams Meeting" -Url "https://teams.microsoft.com/l/meetup-join/meeting-id"
$calendarLink = New-AMOpenUrlAction -Title "Add to Calendar" -Url "https://calendar.example.com/event?id=12345"

# Create response actions
$respondAction = New-AMExecuteAction -Title "Submit Response" -Verb "POST" `
    -Url "https://api.example.com/meeting/respond" `
    -Body '{"meetingId": "MTG-12345", "response": "{{attendance.value}}", "attendee": "{{userEmail}}", "comment": "{{comment.value}}"}'

# Show meeting documents (using ShowCard action)
$documentsCard = New-AMCard -OriginatorId "docs-card"
Add-AMElement -Card $documentsCard -Element (New-AMTextBlock -Text "Meeting Documents" -Weight "Bolder")
Add-AMElement -Card $documentsCard -Element (New-AMTextBlock -Text "Click to download:" -Wrap $true)

$doc1 = New-AMOpenUrlAction -Title "Q3 Results.pdf" -Url "https://example.com/docs/q3-results.pdf"
$doc2 = New-AMOpenUrlAction -Title "Q4 Planning Template.xlsx" -Url "https://example.com/docs/q4-template.xlsx"
$documentsActionSet = New-AMActionSet -Actions @($doc1, $doc2)
Add-AMElement -Card $documentsCard -Element $documentsActionSet

$showDocsAction = New-AMShowCardAction -Title "Meeting Documents" -Card $documentsCard

# Create action sets
$meetingLinksActionSet = New-AMActionSet -Id "meeting-links" -Actions @($teamsLink, $calendarLink)
Add-AMElement -Card $card -Element $meetingLinksActionSet

$responseActionSet = New-AMActionSet -Id "response-actions" -Actions @($respondAction, $showDocsAction)
Add-AMElement -Card $card -Element $responseActionSet

# Export the card to JSON
$cardJson = Export-AMCard -Card $card

# Export the card for email
$emailParams = Export-AMCardForEmail -Card $card -Subject "Invitation: Q4 Planning Session" `
    -ToRecipients "team@example.com" -CreateGraphParams

Write-Host "Meeting invitation card created successfully."
#endregion