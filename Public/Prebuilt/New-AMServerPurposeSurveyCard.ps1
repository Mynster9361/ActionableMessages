function New-AMServerPurposeSurveyCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card for collecting server purpose and usage information.

    .DESCRIPTION
    The `New-AMServerPurposeSurveyCard` function generates an Adaptive Card to collect detailed information about a server's purpose, usage, and criticality.
    The card includes fields for server details, detected services, business and technical contacts, and maintenance preferences.
    It also provides options for users to select the server's primary purpose, business criticality, and preferred maintenance window.

    .PARAMETER OriginatorId
    The originator ID of the card. This is used to identify the source of the card. Defaults to "your-originator-id".

    .PARAMETER ServerName
    The name of the server being surveyed.

    .PARAMETER IPAddress
    (Optional) The IP address of the server.

    .PARAMETER OperatingSystem
    (Optional) The operating system running on the server.

    .PARAMETER DetectedServices
    (Optional) A list of services detected on the server.

    .PARAMETER CreationDate
    (Optional) The date the server was created or provisioned.

    .PARAMETER TicketNumber
    (Optional) The ticket number associated with the server survey request.

    .PARAMETER Description
    (Optional) A description of the purpose of the survey. Defaults to a predefined message.

    .PARAMETER PurposeChoices
    (Optional) A hashtable of choices for the server's primary purpose. Each key-value pair represents an option and its description.
    Defaults to:
        @{
            "application" = "Application Server"
            "database" = "Database Server"
            "web" = "Web Server"
            "file" = "File Server"
            "domain" = "Domain Controller"
            "development" = "Development/Testing"
            "backup" = "Backup/Recovery"
            "other" = "Other (please specify)"
        }

    .PARAMETER CriticalityChoices
    (Optional) A hashtable of choices for the server's business criticality. Each key-value pair represents an option and its description.
    Defaults to:
        @{
            "critical" = "Mission Critical (Immediate business impact if down)"
            "high" = "High (Significant impact within hours)"
            "medium" = "Medium (Impact within 1-2 days)"
            "low" = "Low (Minimal impact)"
        }

    .PARAMETER MaintenanceChoices
    (Optional) A hashtable of choices for the server's preferred maintenance window. Each key-value pair represents an option and its description.
    Defaults to:
        @{
            "weekends" = "Weekends only"
            "weeknights" = "Weeknights (after 8pm)"
            "monthly" = "Monthly scheduled downtime"
            "special" = "Requires special coordination"
        }

    .PARAMETER ResponseEndpoint
    (Optional) The URL where the survey response will be sent. Defaults to "https://api.example.com/server-purpose".

    .PARAMETER ResponseBody
    (Optional) The body of the POST request sent to the `ResponseEndpoint`.
    This is a JSON string that includes placeholders for dynamic values such as the ticket number, server name, purpose, and other survey fields.
    Defaults to:
        "{`"ticketNumber`": `"$TicketNumber`", `"serverName`": `"$ServerName`", `"serverPurpose`": `"{{server-purpose.value}}`", `"purposeDescription`": `"{{purpose-description.value}}`", `"businessOwner`": `"{{business-owner.value}}`", `"technicalContact`": `"{{technical-contact.value}}`", `"businessCriticality`": `"{{business-criticality.value}}`", `"maintenanceWindow`": `"{{maintenance-window.value}}`", `"additionalComments`": `"{{additional-comments.value}}`}"

    .EXAMPLE
    # Example 1: Create a detailed server purpose survey card using splatting
    $cardParams = @{
        OriginatorId       = "your-originator-id"
        ServerName         = "SVR-APP-001"
        IPAddress          = "10.0.2.15"
        OperatingSystem    = "Windows Server 2019"
        CreationDate       = (Get-Date).AddYears(-2)
        DetectedServices   = @("IIS", "SQL Server Express", "Custom Application Service")
        TicketNumber       = "SRV-2023-002"
        Description        = "Our IT department is updating server documentation and requires information about this server. Please provide details about its purpose and usage to ensure proper management and support."
        ResponseEndpoint   = "https://api.example.com/server-purpose"
        ResponseBody       = "{`"ticketNumber`": `"$TicketNumber`", `"serverName`": `"$ServerName`", `"serverPurpose`": `"{{server-purpose.value}}`", `"purposeDescription`": `"{{purpose-description.value}}`", `"businessOwner`": `"{{business-owner.value}}`", `"technicalContact`": `"{{technical-contact.value}}`", `"businessCriticality`": `"{{business-criticality.value}}`", `"maintenanceWindow`": `"{{maintenance-window.value}}`", `"additionalComments`": `"{{additional-comments.value}}`}"
        PurposeChoices     = @{
            "application" = "Application Server"
            "database" = "Database Server"
            "web" = "Web Server"
            "file" = "File Server"
            "domain" = "Domain Controller"
            "development" = "Development/Testing"
            "backup" = "Backup/Recovery"
            "other" = "Other (please specify)"
        }
        CriticalityChoices = @{
            "critical" = "Mission Critical (Immediate business impact if down)"
            "high" = "High (Significant impact within hours)"
            "medium" = "Medium (Impact within 1-2 days)"
            "low" = "Low (Minimal impact)"
        }
        MaintenanceChoices = @{
            "weekends" = "Weekends only"
            "weeknights" = "Weeknights (after 8pm)"
            "monthly" = "Monthly scheduled downtime"
            "special" = "Requires special coordination"
        }
    }

    $serverCard = New-AMServerPurposeSurveyCard @cardParams

    .EXAMPLE
    # Example 2: Create a simple server purpose survey card using splatting
    $simpleCardParams = @{
        ServerName       = "SVR-DB-001"
        IPAddress        = "10.0.3.20"
        OperatingSystem  = "Linux"
        DetectedServices = @("MySQL", "Nginx")
        ResponseEndpoint = "https://api.example.com/server-purpose"
        OriginatorId     = "server-survey-system"
    }

    $serverCard = New-AMServerPurposeSurveyCard @simpleCardParams

    .NOTES
    This function is part of the Actionable Messages module and is used to create Adaptive Cards for server purpose surveys.
    The card can be exported and sent via email or other communication channels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OriginatorId = "your-originator-id",

        [Parameter(Mandatory = $true)]
        [string]$ServerName,

        [Parameter(Mandatory = $false)]
        [string]$IPAddress,

        [Parameter(Mandatory = $false)]
        [string]$OperatingSystem,

        [Parameter(Mandatory = $false)]
        [string[]]$DetectedServices,

        [Parameter(Mandatory = $false)]
        [DateTime]$CreationDate,

        [Parameter(Mandatory = $false)]
        [string]$TicketNumber,

        [Parameter(Mandatory = $false)]
        [string]$Description = "Our IT department is updating server documentation and requires information about this server. Please provide details about its purpose and usage to ensure proper management and support.",

        [Parameter(Mandatory = $false)]
        $purposeChoices = [ordered]@{
            "application" = "Application Server"
            "database"    = "Database Server"
            "web"         = "Web Server"
            "file"        = "File Server"
            "domain"      = "Domain Controller"
            "development" = "Development/Testing"
            "backup"      = "Backup/Recovery"
            "other"       = "Other (please specify)"
        },

        [Parameter(Mandatory = $false)]
        $criticalityChoices = [ordered]@{
            "critical" = "Mission Critical (Immediate business impact if down)"
            "high"     = "High (Significant impact within hours)"
            "medium"   = "Medium (Impact within 1-2 days)"
            "low"      = "Low (Minimal impact)"
        },

        [Parameter(Mandatory = $false)]
        $maintenanceChoices = [ordered]@{
            "weekends"   = "Weekends only"
            "weeknights" = "Weeknights (after 8pm)"
            "monthly"    = "Monthly scheduled downtime"
            "special"    = "Requires special coordination"
        },

        [Parameter(Mandatory = $false)]
        [string]$ResponseEndpoint = "https://api.example.com/server-purpose",

        [Parameter(Mandatory = $false)]
        [string]$ResponseBody = "{`"ticketNumber`": `"$TicketNumber`", `"serverName`": `"$ServerName`", `"serverPurpose`": `"{{server-purpose.value}}`", `"purposeDescription`": `"{{purpose-description.value}}`", `"businessOwner`": `"{{business-owner.value}}`", `"technicalContact`": `"{{technical-contact.value}}`", `"businessCriticality`": `"{{business-criticality.value}}`", `"maintenanceWindow`": `"{{maintenance-window.value}}`", `"additionalComments`": `"{{additional-comments.value}}`}"

    )

    # Create a new card
    $card = New-AMCard -OriginatorId $OriginatorId -Version "1.0"

    # Add header
    $header = New-AMTextBlock -Text "Server Information Survey" -Size "Large" -Weight "Bolder" -Color "Accent"
    Add-AMElement -Card $card -Element $header

    # Add server details
    $serverContainer = New-AMContainer -Id "server-details" -Style "emphasis" -Padding "Default"
    Add-AMElement -Card $card -Element $serverContainer

    # Add facts
    $facts = @(
        New-AMFact -Title "Server Name" -Value $ServerName
    )

    if ($IPAddress) {
        $facts += New-AMFact -Title "IP Address" -Value $IPAddress
    }

    if ($OperatingSystem) {
        $facts += New-AMFact -Title "Operating System" -Value $OperatingSystem
    }

    if ($CreationDate) {
        $facts += New-AMFact -Title "Creation Date" -Value (Get-Date $CreationDate -Format "yyyy-MM-dd")
    }

    if ($TicketNumber) {
        $facts += New-AMFact -Title "Ticket Number" -Value $TicketNumber
    }

    $factSet = New-AMFactSet -Facts $facts
    Add-AMElement -Card $card -Element $factSet -ContainerId "server-details"

    # Add description
    $descriptionElement = New-AMTextBlock -Text $Description -Wrap $true
    Add-AMElement -Card $card -Element $descriptionElement -ContainerId "server-details"

    # Add detected services if provided
    if ($DetectedServices -and $DetectedServices.Count -gt 0) {
        $servicesHeader = New-AMTextBlock -Text "Detected Services" -Weight "Bolder"
        Add-AMElement -Card $card -Element $servicesHeader -ContainerId "server-details"

        $servicesList = New-AMTextBlock -Text ("• " + ($DetectedServices -join "`n• ")) -Wrap $true
        Add-AMElement -Card $card -Element $servicesList -ContainerId "server-details"
    }

    # Add input fields
    $purposeLabel = New-AMTextBlock -Text "Primary Purpose of Server:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $purposeLabel

    $purposeChoiceElements = $purposeChoices.GetEnumerator() | ForEach-Object {
        New-AMChoice -Title $_.Value -Value $_.Key
    }

    $purposeInput = New-AMChoiceSetInput -Id "server-purpose" -Choices $purposeChoiceElements -Style "expanded"
    Add-AMElement -Card $card -Element $purposeInput

    # Add description field
    $descriptionLabel = New-AMTextBlock -Text "Detailed Description of Server Purpose:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $descriptionLabel

    $purposeDescription = New-AMTextInput -Id "purpose-description" -Placeholder "Please describe what this server does, what applications it runs, etc." -IsMultiline $true
    Add-AMElement -Card $card -Element $purposeDescription

    # Add business owner field
    $ownerLabel = New-AMTextBlock -Text "Business Owner:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $ownerLabel

    $ownerInput = New-AMTextInput -Id "business-owner" -Placeholder "Who is responsible for this server from a business perspective?"
    Add-AMElement -Card $card -Element $ownerInput

    # Add technical contact field
    $techLabel = New-AMTextBlock -Text "Technical Contact:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $techLabel

    $techInput = New-AMTextInput -Id "technical-contact" -Placeholder "Who should be contacted for technical questions about this server?"
    Add-AMElement -Card $card -Element $techInput

    # Add criticality field
    $criticalityLabel = New-AMTextBlock -Text "Business Criticality:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $criticalityLabel

    $criticalityChoiceElements = $criticalityChoices.GetEnumerator() | ForEach-Object {
        New-AMChoice -Title $_.Value -Value $_.Key
    }

    $criticalityInput = New-AMChoiceSetInput -Id "business-criticality" -Choices $criticalityChoiceElements -Style "compact"
    Add-AMElement -Card $card -Element $criticalityInput

    # Add maintenance window field
    $maintenanceLabel = New-AMTextBlock -Text "Preferred Maintenance Window:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $maintenanceLabel

    $maintenanceChoiceElements = $maintenanceChoices.GetEnumerator() | ForEach-Object {
        New-AMChoice -Title $_.Value -Value $_.Key
    }

    $maintenanceInput = New-AMChoiceSetInput -Id "maintenance-window" -Choices $maintenanceChoiceElements -Style "expanded"
    Add-AMElement -Card $card -Element $maintenanceInput

    # Add additional comments field
    $commentsLabel = New-AMTextBlock -Text "Additional Comments:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $commentsLabel

    $commentsInput = New-AMTextInput -Id "additional-comments" -Placeholder "Any other relevant information about this server..." -IsMultiline $true
    Add-AMElement -Card $card -Element $commentsInput

    # Add submit button
    $submitAction = New-AMExecuteAction -Title "Submit Information" -Verb "POST" -Url $ResponseEndpoint -Body $ResponseBody

    $actionSet = New-AMActionSet -Actions @($submitAction)
    Add-AMElement -Card $card -Element $actionSet

    return $card
}
