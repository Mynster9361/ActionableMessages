# ActionableMessages PowerShell Module

## Overview

The ActionableMessages PowerShell module provides a streamlined approach to creating interactive Adaptive Cards for use in Outlook and Microsoft 365 applications. Using this module, you can easily build rich, interactive content that allows recipients to take action directly from within their email client.

## Installation

### From PowerShell Gallery

```powershell
Install-Module -Name ActionableMessages -Scope CurrentUser
```

### Manual Installation

1. Download the module from the repository
2. Extract to a directory in your PowerShell module path:

```powershell
$modulePath = "$env:USERPROFILE\Documents\PowerShell\Modules\ActionableMessages"
New-Item -Path $modulePath -ItemType Directory -Force
Copy-Item -Path "path\to\extracted\module\*" -Destination $modulePath -Recurse
```

3. Import the module:

```powershell
Import-Module ActionableMessages
```

## Key Concepts

### Adaptive Cards

Adaptive Cards are platform-agnostic card objects that automatically adapt to the host application's look and feel. They provide a rich way to present information and gather input from users.

### Actionable Messages

Actionable Messages add interactive capabilities to emails, allowing recipients to take actions without leaving their inbox. These actions can include opening URLs, submitting data, or triggering server-side processes.

## Basic Usage

### Creating a Simple Card

```powershell
# Import the module
Import-Module ActionableMessages

# Create a new card
$card = New-AMCard -OriginatorId "your-originator-id" -Version "1.2"

# Add a title
$title = New-AMTextBlock -Text "Notification Title" -Size "Large" -Weight "Bolder"
Add-AMElement -Card $card -Element $title

# Add content
$message = New-AMTextBlock -Text "This is an important notification." -Wrap $true
Add-AMElement -Card $card -Element $message

# Add an action button
$action = New-AMOpenUrlAction -Title "Learn More" -Url "https://example.com/details"
$actionSet = New-AMActionSet -Id "actions" -Actions @($action)
Add-AMElement -Card $card -Element $actionSet

# Export the card for email
$emailParams = Export-AMCardForEmail -Card $card -Subject "Important Notification" -ToRecipients "user@example.com"
```

## Module Structure

The module is organized into logical function categories:

- **Core**: Functions for card creation, manipulation, and export
- **Elements**: Visual components like text, images, containers, etc.
- **Actions**: Interactive components like buttons and links
- **Inputs**: Form elements for collecting user input

## Function Reference

### Core Functions

| Function | Description |
|----------|-------------|
| `New-AMCard` | Creates a new Adaptive Card |
| `Add-AMElement` | Adds an element to a card or container |
| `Export-AMCard` | Exports a card as JSON |
| `Export-AMCardForEmail` | Prepares a card for email delivery |

### Element Functions

| Function | Description |
|----------|-------------|
| `New-AMTextBlock` | Creates text content |
| `New-AMImage` | Adds an image |
| `New-AMImageSet` | Creates a collection of images |
| `New-AMContainer` | Groups elements together |
| `New-AMColumnSet` | Creates a multi-column layout |
| `New-AMColumn` | Defines a column within a ColumnSet |
| `New-AMFactSet` | Creates a list of facts (key-value pairs) |
| `New-AMFact` | Creates a single fact (key-value pair) |
| `New-AMActionSet` | Groups actions together |

### Action Functions

| Function | Description |
|----------|-------------|
| `New-AMOpenUrlAction` | Creates a button that opens a URL |
| `New-AMExecuteAction` | Creates a button that calls an API |
| `New-AMShowCardAction` | Creates a button that reveals another card |
| `New-AMToggleVisibilityAction` | Creates a button that shows/hides elements |

### Input Functions

| Function | Description |
|----------|-------------|
| `New-AMTextInput` | Creates a text field |
| `New-AMNumberInput` | Creates a numeric input field |
| `New-AMDateInput` | Creates a date picker |
| `New-AMTimeInput` | Creates a time picker |
| `New-AMToggleInput` | Creates a checkbox/toggle switch |
| `New-AMChoiceSetInput` | Creates a dropdown or radio button group |
| `New-AMChoice` | Creates an option for a ChoiceSetInput |

## Examples

### Approval Workflow Card

```powershell
# Create approval card
$card = New-AMCard -OriginatorId "your-originator-id" -Version "1.2"

# Add header
Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Expense Report Approval" -Size "Large" -Weight "Bolder")

# Add expense details
$facts = @(
    New-AMFact -Title "Employee" -Value "John Smith"
    New-AMFact -Title "Report #" -Value "EXP-2023-0456"
    New-AMFact -Title "Amount" -Value "$1,245.78"
    New-AMFact -Title "Date" -Value "2023-10-15"
    New-AMFact -Title "Purpose" -Value "Client Meeting"
)
$factSet = New-AMFactSet -Facts $facts
Add-AMElement -Card $card -Element $factSet

# Add comment field
$comment = New-AMTextInput -Id "comment" -Label "Comments (optional):" -IsMultiline $true
Add-AMElement -Card $card -Element $comment

# Add approve/reject buttons
$approveAction = New-AMExecuteAction -Title "Approve" -Verb "POST" -Url "https://api.example.com/approve" -Body '{"reportId": "EXP-2023-0456"}'
$rejectAction = New-AMExecuteAction -Title "Reject" -Verb "POST" -Url "https://api.example.com/reject" -Body '{"reportId": "EXP-2023-0456"}'
$actionSet = New-AMActionSet -Id "approval-actions" -Actions @($approveAction, $rejectAction)
Add-AMElement -Card $card -Element $actionSet
```

### Feedback Form Card

```powershell
# Create feedback form card
$card = New-AMCard -OriginatorId "your-originator-id" -Version "1.2"

# Add header
Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Customer Feedback" -Size "Large" -Weight "Bolder")

# Create rating input
$ratingChoices = @(
    New-AMChoice -Title "★★★★★ Excellent" -Value "5"
    New-AMChoice -Title "★★★★☆ Very Good" -Value "4"
    New-AMChoice -Title "★★★☆☆ Good" -Value "3"
    New-AMChoice -Title "★★☆☆☆ Fair" -Value "2"
    New-AMChoice -Title "★☆☆☆☆ Poor" -Value "1"
)
$ratingInput = New-AMChoiceSetInput -Id "rating" -Label "How would you rate our service?" -Choices $ratingChoices -Style "expanded"
Add-AMElement -Card $card -Element $ratingInput

# Add comment field
$feedback = New-AMTextInput -Id "comments" -Label "Additional Comments:" -IsMultiline $true
Add-AMElement -Card $card -Element $feedback

# Add submit button
$submitAction = New-AMExecuteAction -Title "Submit Feedback" -Verb "POST" -Url "https://api.example.com/feedback"
$actionSet = New-AMActionSet -Id "feedback-actions" -Actions @($submitAction)
Add-AMElement -Card $card -Element $actionSet
```

## Best Practices

### Security
- Register your originator ID with Microsoft before deploying to production (https://aka.ms/publishactionableemails)

### Design Considerations
- Keep cards focused on a single task or piece of information
- Use clear, concise language for buttons and instructions
- Test your cards in different Outlook clients (desktop, web, mobile)
- Provide fallback text for email clients that don't support Adaptive Cards

### Performance
- Use the `-Compress` parameter with `Export-AMCard` for production deployments
- Keep image sizes small to ensure quick loading

### Accessibility
- Always include alt text for images
- Use appropriate color contrast
- Ensure all interactive elements have clear labels

## Registering Your Originator ID

Before using Actionable Messages in production, you must register your originator ID with Microsoft:

1. Go to the Actionable Email Developer Dashboard
2. Sign in with your Microsoft account
3. Register a new sender by providing the required information
4. Use the provided originator ID in your cards

## Additional Resources

- [Adaptive Cards Documentation](https://adaptivecards.io/)
- [Outlook Actionable Messages Documentation](https://learn.microsoft.com/en-us/outlook/actionable-messages/)
- [Adaptive Cards Designer](https://adaptivecards.io/designer/)

## Support

For issues, feature requests, or contributions, please use the project's issue tracker.

## License

This module is licensed under the MIT License. See the LICENSE file for details.