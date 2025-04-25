---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Action.OpenUrl.html
schema: 2.0.0
---

# New-AMServerPurposeSurveyCard

## SYNOPSIS

Creates an Adaptive Card for collecting server purpose and usage information.

## SYNTAX

```
New-AMServerPurposeSurveyCard [[-OriginatorId] <String>] [-ServerName] <String> [[-IPAddress] <String>]
 [[-OperatingSystem] <String>] [[-DetectedServices] <String[]>] [[-CreationDate] <DateTime>]
 [[-TicketNumber] <String>] [[-Description] <String>] [[-purposeChoices] <Object>]
 [[-criticalityChoices] <Object>] [[-maintenanceChoices] <Object>] [[-ResponseEndpoint] <String>]
 [[-ResponseBody] <String>] [<CommonParameters>]
```

## DESCRIPTION

The \`New-AMServerPurposeSurveyCard\` function generates an Adaptive Card to collect detailed information about a server's purpose, usage, and criticality.
The card includes fields for server details, detected services, business and technical contacts, and maintenance preferences.
It also provides options for users to select the server's primary purpose, business criticality, and preferred maintenance window.

## EXAMPLES

### EXAMPLE 1

```
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
```

### EXAMPLE 2

```
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

### -ServerName

The name of the server being surveyed.

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

### -IPAddress

(Optional) The IP address of the server.

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

### -OperatingSystem

(Optional) The operating system running on the server.

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

### -DetectedServices

(Optional) A list of services detected on the server.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreationDate

(Optional) The date the server was created or provisioned.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TicketNumber

(Optional) The ticket number associated with the server survey request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
Position: 8
Default value: Our IT department is updating server documentation and requires information about this server. Please provide details about its purpose and usage to ensure proper management and support.
Accept pipeline input: False
Accept wildcard characters: False
```

### -purposeChoices

(Optional) A hashtable of choices for the server's primary purpose.
Each key-value pair represents an option and its description.
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

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: [ordered]@{
            "application" = "Application Server"
            "database"    = "Database Server"
            "web"         = "Web Server"
            "file"        = "File Server"
            "domain"      = "Domain Controller"
            "development" = "Development/Testing"
            "backup"      = "Backup/Recovery"
            "other"       = "Other (please specify)"
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### -criticalityChoices

(Optional) A hashtable of choices for the server's business criticality.
Each key-value pair represents an option and its description.
Defaults to:
@{
"critical" = "Mission Critical (Immediate business impact if down)"
"high" = "High (Significant impact within hours)"
"medium" = "Medium (Impact within 1-2 days)"
"low" = "Low (Minimal impact)"
}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: [ordered]@{
            "critical" = "Mission Critical (Immediate business impact if down)"
            "high"     = "High (Significant impact within hours)"
            "medium"   = "Medium (Impact within 1-2 days)"
            "low"      = "Low (Minimal impact)"
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### -maintenanceChoices

(Optional) A hashtable of choices for the server's preferred maintenance window.
Each key-value pair represents an option and its description.
Defaults to:
@{
"weekends" = "Weekends only"
"weeknights" = "Weeknights (after 8pm)"
"monthly" = "Monthly scheduled downtime"
"special" = "Requires special coordination"
}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: [ordered]@{
            "weekends"   = "Weekends only"
            "weeknights" = "Weeknights (after 8pm)"
            "monthly"    = "Monthly scheduled downtime"
            "special"    = "Requires special coordination"
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseEndpoint

(Optional) The URL where the survey response will be sent.
Defaults to "https://api.example.com/server-purpose".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: Https://api.example.com/server-purpose
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseBody

(Optional) The body of the POST request sent to the \`ResponseEndpoint\`.
This is a JSON string that includes placeholders for dynamic values such as the ticket number, server name, purpose, and other survey fields.
Defaults to:
"{\`"ticketNumber\`": \`"$TicketNumber\`", \`"serverName\`": \`"$ServerName\`", \`"serverPurpose\`": \`"{{server-purpose.value}}\`", \`"purposeDescription\`": \`"{{purpose-description.value}}\`", \`"businessOwner\`": \`"{{business-owner.value}}\`", \`"technicalContact\`": \`"{{technical-contact.value}}\`", \`"businessCriticality\`": \`"{{business-criticality.value}}\`", \`"maintenanceWindow\`": \`"{{maintenance-window.value}}\`", \`"additionalComments\`": \`"{{additional-comments.value}}\`}"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: "{`"ticketNumber`": `"$TicketNumber`", `"serverName`": `"$ServerName`", `"serverPurpose`": `"{{server-purpose.value}}`", `"purposeDescription`": `"{{purpose-description.value}}`", `"businessOwner`": `"{{business-owner.value}}`", `"technicalContact`": `"{{technical-contact.value}}`", `"businessCriticality`": `"{{business-criticality.value}}`", `"maintenanceWindow`": `"{{maintenance-window.value}}`", `"additionalComments`": `"{{additional-comments.value}}`}"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function is part of the Actionable Messages module and is used to create Adaptive Cards for server purpose surveys.
The card can be exported and sent via email or other communication channels.

## RELATED LINKS
