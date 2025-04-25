---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/ActionSet.html
schema: 2.0.0
---

# New-AMApplicationUsageSurveyCard

## SYNOPSIS

Creates an Adaptive Card for an application usage survey.

## SYNTAX

```
New-AMApplicationUsageSurveyCard [[-OriginatorId] <String>] [-ApplicationName] <String> [[-Version] <String>]
 [[-Vendor] <String>] [[-LicenseCount] <Int32>] [[-ActiveUserCount] <Int32>] [[-RenewalDate] <DateTime>]
 [[-Department] <String>] [[-TicketNumber] <String>] [[-Description] <String>] [[-frequencyChoices] <Object>]
 [[-importanceChoices] <Object>] [[-AlternativeQuestion] <Boolean>] [[-TeamMemberUsage] <Boolean>]
 [[-Suggestion] <Boolean>] [[-ResponseEndpoint] <String>] [[-ResponseBody] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The \`New-AMApplicationUsageSurveyCard\` function generates an Adaptive Card to collect information about the usage, importance, and features of a specific application.
The card includes fields for usage frequency, business function, importance rating, and suggestions for improvement.
It also provides options for users to specify alternative applications and team member usage.

## EXAMPLES

### EXAMPLE 1

```
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
```

### EXAMPLE 2

```
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
```

## PARAMETERS

### -OriginatorId

The originator ID of the card.
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

### -ApplicationName

The name of the application being surveyed.

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

### -Version

(Optional) The version of the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Vendor

(Optional) The vendor or provider of the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LicenseCount

(Optional) The total number of licenses available for the application.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActiveUserCount

(Optional) The number of active users currently using the application.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RenewalDate

(Optional) The renewal date for the application's license.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Department

(Optional) The department responsible for managing the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TicketNumber

(Optional) The ticket number associated with the application usage survey.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

(Optional) A description of the purpose of the survey.
Defaults to a predefined message.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: The IT department is conducting a review of software licenses and usage. Please provide information about your use of this application to help us optimize licensing costs and ensure continued access for essential business functions.
Accept pipeline input: False
Accept wildcard characters: False
```

### -frequencyChoices

(Optional) A hashtable of choices for the frequency of application usage.
Each key-value pair represents an option and its description.
Defaults to:
\[ordered\]@{
"daily" = "Daily"
"weekly" = "Several times per week"
"monthly" = "Few times per month"
"rarely" = "Rarely (a few times per year)"
"never" = "Never"
}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: [ordered]@{
            "daily"   = "Daily"
            "weekly"  = "Several times per week"
            "monthly" = "Few times per month"
            "rarely"  = "Rarely (a few times per year)"
            "never"   = "Never"
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### -importanceChoices

(Optional) A hashtable of choices for the importance of the application.
Each key-value pair represents an option and its description.
Defaults to:
\[ordered\]@{
"critical" = "Critical - Cannot perform job without it"
"important" = "Important - Major impact if unavailable"
"useful" = "Useful - Improves efficiency but have workarounds"
"optional" = "Optional - Nice to have but not essential"
"unnecessary" = "Unnecessary - Could work without it"
}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: [ordered]@{
            "critical"    = "Critical - Cannot perform job without it"
            "important"   = "Important - Major impact if unavailable"
            "useful"      = "Useful - Improves efficiency but have workarounds"
            "optional"    = "Optional - Nice to have but not essential"
            "unnecessary" = "Unnecessary - Could work without it"
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlternativeQuestion

(Optional) A boolean indicating whether to include a question about alternative applications.
Defaults to \`$true\`.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -TeamMemberUsage

(Optional) A boolean indicating whether to include a question about team member usage of the application.
Defaults to \`$true\`.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Suggestion

(Optional) A boolean indicating whether to include a field for improvement suggestions.
Defaults to \`$true\`.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseEndpoint

(Optional) The URL where the survey response will be sent.
Defaults to "https://api.example.com/application-usage".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: Https://api.example.com/application-usage
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseBody

(Optional) The body of the POST request sent to the \`ResponseEndpoint\`.
This is a JSON string that includes placeholders for dynamic values such as the ticket number, application name, version, and survey responses.
Defaults to:
"{\`"ticketNumber\`": \`"$TicketNumber\`", \`"applicationName\`": \`"$ApplicationName\`", \`"version\`": \`"$Version\`", \`"usageFrequency\`": \`"{{usage-frequency.value}}\`", \`"businessFunction\`": \`"{{business-function.value}}\`", \`"usedFeatures\`": \`"{{used-features.value}}\`", \`"importanceRating\`": \`"{{importance-rating.value}}\`", \`"alternativesAware\`": \`"{{alternatives-aware.value}}\`", \`"alternativesDetails\`": \`"{{alternatives-details.value}}\`", \`"teamUsage\`": \`"{{team-usage.value}}\`", \`"improvementSuggestions\`": \`"{{improvement-suggestions.value}}\`}"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: "{`"ticketNumber`": `"$TicketNumber`", `"applicationName`": `"$ApplicationName`", `"version`": `"$Version`", `"usageFrequency`": `"{{usage-frequency.value}}`", `"businessFunction`": `"{{business-function.value}}`", `"usedFeatures`": `"{{used-features.value}}`", `"importanceRating`": `"{{importance-rating.value}}`", `"alternativesAware`": `"{{alternatives-aware.value}}`", `"alternativesDetails`": `"{{alternatives-details.value}}`", `"teamUsage`": `"{{team-usage.value}}`", `"improvementSuggestions`": `"{{improvement-suggestions.value}}`}"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function is part of the Actionable Messages module and is used to create Adaptive Cards for application usage surveys.
The card can be exported and sent via email or other communication channels.

## RELATED LINKS
