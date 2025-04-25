function New-AMApplicationUsageSurveyCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card for an application usage survey.

    .DESCRIPTION
    The `New-AMApplicationUsageSurveyCard` function generates an Adaptive Card to collect information about the usage, importance, and features of a specific application.
    The card includes fields for usage frequency, business function, importance rating, and suggestions for improvement.
    It also provides options for users to specify alternative applications and team member usage.

    .PARAMETER OriginatorId
    The originator ID of the card. This is used to identify the source of the card. Defaults to "your-originator-id".

    .PARAMETER ApplicationName
    The name of the application being surveyed.

    .PARAMETER Version
    (Optional) The version of the application.

    .PARAMETER Vendor
    (Optional) The vendor or provider of the application.

    .PARAMETER LicenseCount
    (Optional) The total number of licenses available for the application.

    .PARAMETER ActiveUserCount
    (Optional) The number of active users currently using the application.

    .PARAMETER RenewalDate
    (Optional) The renewal date for the application's license.

    .PARAMETER Department
    (Optional) The department responsible for managing the application.

    .PARAMETER TicketNumber
    (Optional) The ticket number associated with the application usage survey.

    .PARAMETER Description
    (Optional) A description of the purpose of the survey. Defaults to a predefined message.

    .PARAMETER FrequencyChoices
    (Optional) A hashtable of choices for the frequency of application usage. Each key-value pair represents an option and its description.
    Defaults to:
        [ordered]@{
            "daily" = "Daily"
            "weekly" = "Several times per week"
            "monthly" = "Few times per month"
            "rarely" = "Rarely (a few times per year)"
            "never" = "Never"
        }

    .PARAMETER ImportanceChoices
    (Optional) A hashtable of choices for the importance of the application. Each key-value pair represents an option and its description.
    Defaults to:
        [ordered]@{
            "critical" = "Critical - Cannot perform job without it"
            "important" = "Important - Major impact if unavailable"
            "useful" = "Useful - Improves efficiency but have workarounds"
            "optional" = "Optional - Nice to have but not essential"
            "unnecessary" = "Unnecessary - Could work without it"
        }

    .PARAMETER AlternativeQuestion
    (Optional) A boolean indicating whether to include a question about alternative applications. Defaults to `$true`.

    .PARAMETER TeamMemberUsage
    (Optional) A boolean indicating whether to include a question about team member usage of the application. Defaults to `$true`.

    .PARAMETER Suggestion
    (Optional) A boolean indicating whether to include a field for improvement suggestions. Defaults to `$true`.

    .PARAMETER ResponseEndpoint
    (Optional) The URL where the survey response will be sent. Defaults to "https://api.example.com/application-usage".

    .PARAMETER ResponseBody
    (Optional) The body of the POST request sent to the `ResponseEndpoint`.
    This is a JSON string that includes placeholders for dynamic values such as the ticket number, application name, version, and survey responses.
    Defaults to:
        "{`"ticketNumber`": `"$TicketNumber`", `"applicationName`": `"$ApplicationName`", `"version`": `"$Version`", `"usageFrequency`": `"{{usage-frequency.value}}`", `"businessFunction`": `"{{business-function.value}}`", `"usedFeatures`": `"{{used-features.value}}`", `"importanceRating`": `"{{importance-rating.value}}`", `"alternativesAware`": `"{{alternatives-aware.value}}`", `"alternativesDetails`": `"{{alternatives-details.value}}`", `"teamUsage`": `"{{team-usage.value}}`", `"improvementSuggestions`": `"{{improvement-suggestions.value}}`}"

    .EXAMPLE
    # Example 1: Create an application usage survey card using splatting
    $appCardParams = @{
        OriginatorId      = "your-originator-id"
        ApplicationName   = "Adobe Creative Cloud"
        Version           = "2023"
        Vendor            = "Adobe"
        LicenseCount      = 50
        ActiveUserCount   = 32
        RenewalDate       = (Get-Date).AddMonths(3)
        Department        = "IT Software Asset Management"
        TicketNumber      = "SAM-2023-003"
        Description       = "The IT department is conducting a review of software licenses and usage. Please provide information about your use of this application to help us optimize licensing costs and ensure continued access for essential business functions."
        FrequencyChoices  = [ordered]@{
            "daily" = "Daily"
            "weekly" = "Several times per week"
            "monthly" = "Few times per month"
            "rarely" = "Rarely (a few times per year)"
            "never" = "Never"
        }
        ImportanceChoices = [ordered]@{
            "critical" = "Critical - Cannot perform job without it"
            "important" = "Important - Major impact if unavailable"
            "useful" = "Useful - Improves efficiency but have workarounds"
            "optional" = "Optional - Nice to have but not essential"
            "unnecessary" = "Unnecessary - Could work without it"
        }
        AlternativeQuestion = $true
        TeamMemberUsage    = $true
        Suggestion         = $true
        ResponseEndpoint   = "https://api.example.com/application-usage"
        ResponseBody       = "{`"ticketNumber`": `"$TicketNumber`", `"applicationName`": `"$ApplicationName`", `"version`": `"$Version`", `"usageFrequency`": `"{{usage-frequency.value}}`", `"businessFunction`": `"{{business-function.value}}`", `"usedFeatures`": `"{{used-features.value}}`", `"importanceRating`": `"{{importance-rating.value}}`", `"alternativesAware`": `"{{alternatives-aware.value}}`", `"alternativesDetails`": `"{{alternatives-details.value}}`", `"teamUsage`": `"{{team-usage.value}}`", `"improvementSuggestions`": `"{{improvement-suggestions.value}}`}"
    }

    $appCard = New-AMApplicationUsageSurveyCard @appCardParams

    .EXAMPLE
    # Example 2: Create a simple application usage survey card using splatting
    $simpleAppCardParams = @{
        OriginatorId       = "software-survey-system"
        ApplicationName    = "Microsoft Excel"
        Version            = "2021"
        Vendor             = "Microsoft"
        Department         = "Finance"
        TicketNumber       = "SAM-2023-004"
        ResponseEndpoint   = "https://api.example.com/application-usage"
    }

    $appCard = New-AMApplicationUsageSurveyCard @simpleAppCardParams

    .NOTES
    This function is part of the Actionable Messages module and is used to create Adaptive Cards for application usage surveys.
    The card can be exported and sent via email or other communication channels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OriginatorId = "your-originator-id",

        [Parameter(Mandatory = $true)]
        [string]$ApplicationName,

        [Parameter(Mandatory = $false)]
        [string]$Version,

        [Parameter(Mandatory = $false)]
        [string]$Vendor,

        [Parameter(Mandatory = $false)]
        [int]$LicenseCount,

        [Parameter(Mandatory = $false)]
        [int]$ActiveUserCount,

        [Parameter(Mandatory = $false)]
        [DateTime]$RenewalDate,

        [Parameter(Mandatory = $false)]
        [string]$Department,

        [Parameter(Mandatory = $false)]
        [string]$TicketNumber,

        [Parameter(Mandatory = $false)]
        [string]$Description = "The IT department is conducting a review of software licenses and usage. Please provide information about your use of this application to help us optimize licensing costs and ensure continued access for essential business functions.",

        [Parameter(Mandatory = $false)]
        $frequencyChoices = [ordered]@{
            "daily"   = "Daily"
            "weekly"  = "Several times per week"
            "monthly" = "Few times per month"
            "rarely"  = "Rarely (a few times per year)"
            "never"   = "Never"
        },

        [Parameter(Mandatory = $false)]
        $importanceChoices = [ordered]@{
            "critical"    = "Critical - Cannot perform job without it"
            "important"   = "Important - Major impact if unavailable"
            "useful"      = "Useful - Improves efficiency but have workarounds"
            "optional"    = "Optional - Nice to have but not essential"
            "unnecessary" = "Unnecessary - Could work without it"
        },

        [Parameter(Mandatory = $false)]
        [bool]$AlternativeQuestion = $true,

        [Parameter(Mandatory = $false)]
        [bool]$TeamMemberUsage = $true,

        [Parameter(Mandatory = $false)]
        [bool]$Suggestion = $true,

        [Parameter(Mandatory = $false)]
        [string]$ResponseEndpoint = "https://api.example.com/application-usage",

        [Parameter(Mandatory = $false)]
        [string]$ResponseBody = "{`"ticketNumber`": `"$TicketNumber`", `"applicationName`": `"$ApplicationName`", `"version`": `"$Version`", `"usageFrequency`": `"{{usage-frequency.value}}`", `"businessFunction`": `"{{business-function.value}}`", `"usedFeatures`": `"{{used-features.value}}`", `"importanceRating`": `"{{importance-rating.value}}`", `"alternativesAware`": `"{{alternatives-aware.value}}`", `"alternativesDetails`": `"{{alternatives-details.value}}`", `"teamUsage`": `"{{team-usage.value}}`", `"improvementSuggestions`": `"{{improvement-suggestions.value}}`}"

    )

    # Create a new card
    $card = New-AMCard -OriginatorId $OriginatorId -Version "1.0"

    # Add header
    $header = New-AMTextBlock -Text "Application Usage Survey: $ApplicationName" -Size "Large" -Weight "Bolder" -Color "Accent"
    Add-AMElement -Card $card -Element $header

    # Add application details
    $appContainer = New-AMContainer -Id "app-details" -Style "emphasis" -Padding "Default"
    Add-AMElement -Card $card -Element $appContainer

    # Add facts
    $facts = @(
        New-AMFact -Title "Application" -Value $ApplicationName
    )

    if ($Version) {
        $facts += New-AMFact -Title "Version" -Value $Version
    }

    if ($Vendor) {
        $facts += New-AMFact -Title "Vendor" -Value $Vendor
    }

    if ($LicenseCount -gt 0) {
        $facts += New-AMFact -Title "Total Licenses" -Value $LicenseCount
    }

    if ($ActiveUserCount -gt 0) {
        $facts += New-AMFact -Title "Active Users" -Value $ActiveUserCount
    }

    if ($RenewalDate) {
        $facts += New-AMFact -Title "Renewal Date" -Value (Get-Date $RenewalDate -Format "yyyy-MM-dd")
    }

    if ($Department) {
        $facts += New-AMFact -Title "Managed By" -Value $Department
    }

    if ($TicketNumber) {
        $facts += New-AMFact -Title "Ticket Number" -Value $TicketNumber
    }

    $factSet = New-AMFactSet -Facts $facts
    Add-AMElement -Card $card -Element $factSet -ContainerId "app-details"

    # Add description
    $descriptionElement = New-AMTextBlock -Text $description -Wrap $true
    Add-AMElement -Card $card -Element $descriptionElement -ContainerId "app-details"

    # Add input fields
    $usageFrequencyLabel = New-AMTextBlock -Text "How often do you use this application?" -Weight "Bolder"
    Add-AMElement -Card $card -Element $usageFrequencyLabel

    $frequencyChoiceElements = $frequencyChoices.GetEnumerator() | ForEach-Object {
        New-AMChoice -Title $_.Value -Value $_.Key
    }

    $frequencyInput = New-AMChoiceSetInput -Id "usage-frequency" -Choices $frequencyChoiceElements -Style "expanded"
    Add-AMElement -Card $card -Element $frequencyInput

    # Add business function field
    $functionLabel = New-AMTextBlock -Text "What business function do you use this application for?" -Weight "Bolder"
    Add-AMElement -Card $card -Element $functionLabel

    $functionInput = New-AMTextInput -Id "business-function" -Placeholder "Describe how you use the application in your role" -IsMultiline $true
    Add-AMElement -Card $card -Element $functionInput

    # Add features field
    $featuresLabel = New-AMTextBlock -Text "Which features of the application do you use most?" -Weight "Bolder"
    Add-AMElement -Card $card -Element $featuresLabel

    $featuresInput = New-AMTextInput -Id "used-features" -Placeholder "List the main features you utilize" -IsMultiline $true
    Add-AMElement -Card $card -Element $featuresInput

    # Add importance rating
    $importanceLabel = New-AMTextBlock -Text "How important is this application to your daily work?" -Weight "Bolder"
    Add-AMElement -Card $card -Element $importanceLabel

    $importanceChoiceElements = $importanceChoices.GetEnumerator() | ForEach-Object {
        New-AMChoice -Title $_.Value -Value $_.Key
    }
    $importanceInput = New-AMChoiceSetInput -Id "importance-rating" -Choices $importanceChoiceElements -Style "expanded"
    Add-AMElement -Card $card -Element $importanceInput

    if ($AlternativeQuestion) {
        # Add alternative applications field
        $alternativesLabel = New-AMTextBlock -Text "Are you aware of alternative applications that could serve the same function?" -Weight "Bolder"
        Add-AMElement -Card $card -Element $alternativesLabel

        $alternativesChoices = @(
            New-AMChoice -Title "Yes" -Value "yes"
            New-AMChoice -Title "No" -Value "no"
            New-AMChoice -Title "Not sure" -Value "not-sure"
        )
        $alternativesInput = New-AMChoiceSetInput -Id "alternatives-aware" -Choices $alternativesChoices -Style "expanded"
        Add-AMElement -Card $card -Element $alternativesInput
        # Add alternatives details field
        $alternativesDetailLabel = New-AMTextBlock -Text "If yes, please specify:" -Weight "Bolder"
        Add-AMElement -Card $card -Element $alternativesDetailLabel
        $alternativesDetailInput = New-AMTextInput -Id "alternatives-details" -Placeholder "List any alternative applications you're aware of"
        Add-AMElement -Card $card -Element $alternativesDetailInput
    }

    if ($TeamMemberUsage) {
        # Add team member usage field
        $teamMemberLabel = New-AMTextBlock -Text "Do other members of your team use this application?" -Weight "Bolder"
        Add-AMElement -Card $card -Element $teamMemberLabel

        $teamMemberChoices = @(
            New-AMChoice -Title "Yes, everyone on my team uses it" -Value "all"
            New-AMChoice -Title "Yes, most team members use it" -Value "most"
            New-AMChoice -Title "Yes, but only a few team members" -Value "few"
            New-AMChoice -Title "No, I'm the only one" -Value "only-me"
            New-AMChoice -Title "I don't know" -Value "unknown"
        )
        $teamMemberInput = New-AMChoiceSetInput -Id "team-member-usage" -Choices $teamMemberChoices -Style "expanded"
        Add-AMElement -Card $card -Element $teamMemberInput
    }

    if ($Suggestion) {
        # Add suggestion field
        $suggestionLabel = New-AMTextBlock -Text "Do you have any suggestions for improving this application or its support?" -Weight "Bolder"
        Add-AMElement -Card $card -Element $suggestionLabel

        $suggestionInput = New-AMTextInput -Id "improvement-suggestions" -Placeholder "Share your ideas for improving the application or IT support for it" -IsMultiline $true
        Add-AMElement -Card $card -Element $suggestionInput
    }

    # Add submit button
    $submitAction = New-AMExecuteAction -Title "Submit Survey" -Verb "POST" -Url $ResponseEndpoint -Body $ResponseBody

    $actionSet = New-AMActionSet -Actions @($submitAction)
    Add-AMElement -Card $card -Element $actionSet

    return $card
}
