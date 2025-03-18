#region Import Module
Import-Module ActionableMessages -Force -Verbose
#endregion

#region Create Feedback Form Card
# Create a new card
$card = New-AMCard -OriginatorId "1234567890" -Version "1.2"

# Add header with logo
$header = New-AMTextBlock -Text "Customer Satisfaction Survey" -Size "ExtraLarge" -Weight "Bolder" -Color "Accent"
Add-AMElement -Card $card -Element $header

# Add introduction
$intro = New-AMTextBlock -Text "Thank you for your recent purchase. We'd love to hear about your experience!" -Wrap $true
Add-AMElement -Card $card -Element $intro

# Create a container for the form
$formContainer = New-AMContainer -Id "feedback-form" -Style "default" -Padding "Default"
Add-AMElement -Card $card -Element $formContainer

# Add overall satisfaction rating
$ratingLabel = New-AMTextBlock -Text "Overall Experience:" -Weight "Bolder"
Add-AMElement -Card $card -Element $ratingLabel -ContainerId "feedback-form"

$ratingChoices = @(
    New-AMChoice -Title "★★★★★ Excellent" -Value "5"
    New-AMChoice -Title "★★★★☆ Very Good" -Value "4"
    New-AMChoice -Title "★★★☆☆ Good" -Value "3"
    New-AMChoice -Title "★★☆☆☆ Fair" -Value "2"
    New-AMChoice -Title "★☆☆☆☆ Poor" -Value "1"
)
$ratingInput = New-AMChoiceSetInput -Id "rating" -Choices $ratingChoices -Style "expanded" -IsMultiSelect $false
Add-AMElement -Card $card -Element $ratingInput -ContainerId "feedback-form"

# Add specific aspect ratings
$aspectsContainer = New-AMContainer -Id "aspects-container" -Style "default"
Add-AMElement -Card $card -Element $aspectsContainer

$aspectsLabel = New-AMTextBlock -Text "Please rate the following aspects:" -Weight "Bolder"
Add-AMElement -Card $card -Element $aspectsLabel -ContainerId "aspects-container"

# Create rating choices for aspects
$aspectRatingChoices = @(
    New-AMChoice -Title "5 - Excellent" -Value "5"
    New-AMChoice -Title "4 - Very Good" -Value "4"
    New-AMChoice -Title "3 - Good" -Value "3"
    New-AMChoice -Title "2 - Fair" -Value "2"
    New-AMChoice -Title "1 - Poor" -Value "1"
)

# Add product quality rating
$qualityLabel = New-AMTextBlock -Text "Product Quality:"
Add-AMElement -Card $card -Element $qualityLabel -ContainerId "aspects-container"
$qualityInput = New-AMChoiceSetInput -Id "quality_rating" -Choices $aspectRatingChoices -Style "compact" -IsMultiSelect $false
Add-AMElement -Card $card -Element $qualityInput -ContainerId "aspects-container"

# Add customer service rating
$serviceLabel = New-AMTextBlock -Text "Customer Service:"
Add-AMElement -Card $card -Element $serviceLabel -ContainerId "aspects-container"
$serviceInput = New-AMChoiceSetInput -Id "service_rating" -Choices $aspectRatingChoices -Style "compact" -IsMultiSelect $false
Add-AMElement -Card $card -Element $serviceInput -ContainerId "aspects-container"

# Add value for money rating
$valueLabel = New-AMTextBlock -Text "Value for Money:"
Add-AMElement -Card $card -Element $valueLabel -ContainerId "aspects-container"
$valueInput = New-AMChoiceSetInput -Id "value_rating" -Choices $aspectRatingChoices -Style "compact" -IsMultiSelect $false
Add-AMElement -Card $card -Element $valueInput

# Add comments field
$commentsInput = New-AMTextInput -Id "comments" -Label "Additional Comments:" -Placeholder "Please share any additional feedback or suggestions..." -IsMultiline $true
Add-AMElement -Card $card -Element $commentsInput -ContainerId "feedback-form"

# Add contact permission toggle
$contactLabel = New-AMTextBlock -Text "May we contact you about your feedback?"
Add-AMElement -Card $card -Element $contactLabel -ContainerId "feedback-form"
$contactToggle = New-AMToggleInput -Id "contact_permission" -ValueOn "yes" -ValueOff "no"
Add-AMElement -Card $card -Element $contactToggle -ContainerId "feedback-form"

# Create a container for contact info that's only visible when contact permission is granted
$contactInfoContainer = New-AMContainer -Id "contact-info" -IsVisible $false
Add-AMElement -Card $card -Element $contactInfoContainer

$emailInput = New-AMTextInput -Id "email" -Label "Email Address:" -Placeholder "your.email@example.com"
Add-AMElement -Card $card -Element $emailInput -ContainerId "contact-info"

$phoneInput = New-AMTextInput -Id "phone" -Label "Phone Number (optional):" -Placeholder "+1 (555) 123-4567"
Add-AMElement -Card $card -Element $phoneInput -ContainerId "contact-info"

# Toggle visibility of contact info when toggle is clicked
$toggleContactInfoAction = New-AMToggleVisibilityAction -Title "Toggle Contact Info" -TargetElements @("contact-info")

# Create submit action
$submitAction = New-AMExecuteAction -Title "Submit Feedback" -Verb "POST" `
    -Url "https://api.example.com/feedback/submit" `
    -Data @{ survey_type = "customer_satisfaction" }

# Create action set with submit actions
$actionSet = New-AMActionSet -Id "feedback-actions" -Actions @($submitAction, $toggleContactInfoAction)
Add-AMElement -Card $card -Element $actionSet

# Export the card to JSON
$cardJson = Export-AMCard -Card $card

# Export the card for email
$emailParams = Export-AMCardForEmail -Card $card -Subject "We Value Your Feedback" `
    -ToRecipients "customer@example.com" -CreateGraphParams

Write-Host "Feedback form card created successfully."
#endregion