BeforeAll {
    # Import the module under test
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}

Describe "Example Cards Integration Tests" {
    It "Creates and exports a simple notification card" {
        # Create a new card
        $card = New-AMCard -OriginatorId "test-originator-id" -Version "1.2"

        # Add a title
        $title = New-AMTextBlock -Text "Notification" -Size "Large" -Weight "Bolder"
        Add-AMElement -Card $card -Element $title

        # Add content
        $message = New-AMTextBlock -Text "This is an important notification." -Wrap $true
        Add-AMElement -Card $card -Element $message

        # Add an action button
        $action = New-AMOpenUrlAction -Title "Learn More" -Url "https://example.com/details"
        $actionSet = New-AMActionSet -Id "actions" -Actions @($action)
        Add-AMElement -Card $card -Element $actionSet

        # Export the card
        $json = Export-AMCard -Card $card

        # Verify the exported JSON contains expected elements
        $json | Should -Match '"text":\s*"Notification"'
        $json | Should -Match '"text":\s*"This is an important notification."'
        $json | Should -Match '"title":\s*"Learn More"'
        $json | Should -Match '"url":\s*"https://example.com/details"'
    }

    It "Creates and exports an approval workflow card" {
        # Create a new card
        $card = New-AMCard -OriginatorId "test-originator-id" -Version "1.2"

        # Add header
        $header = New-AMTextBlock -Text "Expense Report Approval" -Size "Large" -Weight "Bolder"
        Add-AMElement -Card $card -Element $header

        # Add facts
        $facts = @(
            New-AMFact -Title "Employee" -Value "John Smith"
            New-AMFact -Title "Amount" -Value "$1,245.78"
            New-AMFact -Title "Purpose" -Value "Client Meeting"
        )
        $factSet = New-AMFactSet -Facts $facts
        Add-AMElement -Card $card -Element $factSet

        # Add comment field
        $comment = New-AMTextInput -Id "comment" -Label "Comments:" -IsMultiline $true
        Add-AMElement -Card $card -Element $comment

        # Add actions
        $approveAction = New-AMExecuteAction -Title "Approve" -Verb "POST" -Url "https://example.com/approve"
        $rejectAction = New-AMExecuteAction -Title "Reject" -Verb "POST" -Url "https://example.com/reject"
        $actionSet = New-AMActionSet -Id "approval-actions" -Actions @($approveAction, $rejectAction)
        Add-AMElement -Card $card -Element $actionSet

        # Export the card
        $json = Export-AMCard -Card $card

        # Verify the exported JSON contains expected elements
        $json | Should -Match '"text":\s*"Expense Report Approval"'
        $json | Should -Match '"title":\s*"Employee"'
        $json | Should -Match '"value":\s*"John Smith"'
        $json | Should -Match '"type":\s*"Input.Text"'
        $json | Should -Match '"title":\s*"Approve"'
        $json | Should -Match '"title":\s*"Reject"'
    }

    It "Creates and exports a complex feedback form card" {
        # Create a new card
        $card = New-AMCard -OriginatorId "test-originator-id" -Version "1.2"

        # Add header
        $header = New-AMTextBlock -Text "Customer Feedback" -Size "Large" -Weight "Bolder"
        Add-AMElement -Card $card -Element $header

        # Create container for form
        $formContainer = New-AMContainer -Id "feedback-form" -Style "default" -Padding "Default"
        Add-AMElement -Card $card -Element $formContainer

        # Create rating input
        $ratingChoices = @(
            New-AMChoice -Title "★★★★★ Excellent" -Value "5"
            New-AMChoice -Title "★★★★☆ Very Good" -Value "4"
            New-AMChoice -Title "★★★☆☆ Good" -Value "3"
            New-AMChoice -Title "★★☆☆☆ Fair" -Value "2"
            New-AMChoice -Title "★☆☆☆☆ Poor" -Value "1"
        )

        $ratingInput = New-AMChoiceSetInput -Id "rating" -Label "How would you rate our service?" -Choices $ratingChoices -Style "expanded"
        Add-AMElement -Card $card -Element $ratingInput -ContainerId "feedback-form"

        # Add comment field
        $commentInput = New-AMTextInput -Id "comments" -Label "Additional Comments:" -IsMultiline $true
        Add-AMElement -Card $card -Element $commentInput -ContainerId "feedback-form"

        # Add contact permission
        $contactToggle = New-AMToggleInput -Id "contact_permission" -Label "May we contact you about your feedback?"
        Add-AMElement -Card $card -Element $contactToggle -ContainerId "feedback-form"

        # Add submit action
        $submitAction = New-AMExecuteAction -Title "Submit Feedback" -Verb "POST" -Url "https://api.example.com/feedback"
        $actionSet = New-AMActionSet -Id "feedback-actions" -Actions @($submitAction)
        Add-AMElement -Card $card -Element $actionSet

        # Export the card
        $json = Export-AMCard -Card $card

        # Verify the exported JSON contains expected elements
        $json | Should -Match '"text":\s*"Customer Feedback"'
        $json | Should -Match '"id":\s*"rating"'
        $json | Should -Match '"title":\s*"★★★★★ Excellent"'
        $json | Should -Match '"id":\s*"comments"'
        $json | Should -Match '"title":\s*"Submit Feedback"'
    }

    It "Creates a card with column layouts and toggle visibility" {
        # Create a new card
        $card = New-AMCard -OriginatorId "test-originator-id" -Version "1.2"

        # Add header
        $header = New-AMTextBlock -Text "Product Information" -Size "Large" -Weight "Bolder"
        Add-AMElement -Card $card -Element $header

        # Create a container for the summary
        $summaryContainer = New-AMContainer -Id "summary" -Style "default"
        Add-AMElement -Card $card -Element $summaryContainer

        # Create a simple text summary
        $summaryText = New-AMTextBlock -Text "Product XYZ-100 is our premier offering with advanced features."
        Add-AMElement -Card $card -Element $summaryText -ContainerId "summary"

        # Create a hidden container for details
        $detailsContainer = New-AMContainer -Id "details" -IsVisible $false
        Add-AMElement -Card $card -Element $detailsContainer

        # Create columns for the details
        $col1 = New-AMColumn -Width "1" -Items @(
            (New-AMTextBlock -Text "Specifications" -Weight "Bolder"),
            (New-AMTextBlock -Text "Weight: 2.5 kg"),
            (New-AMTextBlock -Text "Dimensions: 10 x 15 x 20 cm")
        )

        $col2 = New-AMColumn -Width "1" -Items @(
            (New-AMTextBlock -Text "Features" -Weight "Bolder"),
            (New-AMTextBlock -Text "Wireless connectivity"),
            (New-AMTextBlock -Text "10-hour battery life")
        )

        $columnSet = New-AMColumnSet -Id "spec-columns" -Columns @($col1, $col2)
        Add-AMElement -Card $card -Element $columnSet -ContainerId "details"

        # Add toggle action
        $toggleAction = New-AMToggleVisibilityAction -Title "Show/Hide Details" -TargetElements @("details")
        $actionSet = New-AMActionSet -Id "toggle-actions" -Actions @($toggleAction)
        Add-AMElement -Card $card -Element $actionSet

        # Export the card
        $json = Export-AMCard -Card $card

        # Verify the exported JSON
        $json | Should -Match '"text":\s*"Product Information"'
        $json | Should -Match '"id":\s*"details"'
        $json | Should -Match '"isVisible":\s*false'
        $json | Should -Match '"title":\s*"Show/Hide Details"'
        $json | Should -Match '"targetElements":\s*\[\s*"details"\s*\]'
    }
}