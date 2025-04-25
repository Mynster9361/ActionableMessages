---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/ImageSet.html
schema: 2.0.0
---

# New-AMITResourceRequestCard

## SYNOPSIS

Creates an Adaptive Card for IT resource requests.

## SYNTAX

```
New-AMITResourceRequestCard [[-OriginatorId] <String>] [[-RequestHeader] <String>]
 [[-RequestDescription] <String>] [[-RequestTypeChoices] <Object>] [[-RequesterInformationRequired] <Boolean>]
 [[-urgencyChoices] <Object>] [[-Acknowledge] <Boolean>] [[-AcknowledgeMessage] <String>]
 [[-ResponseEndpoint] <String>] [[-ResponseBody] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION

The \`New-AMITResourceRequestCard\` function generates an Adaptive Card to collect information about IT resource requests.
The card includes fields for request type, requester information, resource details, urgency, and additional requirements.
It also provides an acknowledgment option and a submit button to send the request to a specified endpoint.

## EXAMPLES

### EXAMPLE 1

```
# Example 1: Create an IT resource request card using splatting
$cardParams = @{
    OriginatorId = "your-originator-id"
    RequestHeader = "IT Resource Request Form"
    RequestDescription = "Use this form to request new IT resources or services. Complete all applicable fields to help us process your request efficiently."
    RequestTypeChoices = [ordered]@{
        "hardware" = "New Hardware"
        "software" = "Software License/Application"
        "cloud"    = "Cloud Resource"
        "access"   = "System Access"
        "integration" = "Service Integration"
        "other"    = "Other"
    }
    RequesterInformationRequired = $true
    UrgencyChoices = [ordered]@{
        "critical" = "Critical (Required immediately)"
        "high"     = "High (Required within days)"
        "medium"   = "Medium (Required within weeks)"
        "low"      = "Low (Required within months)"
    }
    Acknowledge = $true
    AcknowledgeMessage = "I acknowledge that this request may require additional approvals and may be subject to budget availability."
    ResponseEndpoint = "https://api.example.com/resource-request"
    ResponseBody = "{`"requestType`": `"{{request-type.value}}`", `"requestorName`": `"{{requestor-name.value}}`", `"department`": `"{{department.value}}`", `"manager`": `"{{manager.value}}`", `"projectName`": `"{{project-name.value}}`", `"costCenter`": `"{{cost-center.value}}`", `"resourceName`": `"{{resource-name.value}}`", `"quantity`": {{quantity.value}}, `"businessJustification`": `"{{business-justification.value}}`", `"urgency`": `"{{urgency.value}}`", `"neededBy`": `"{{needed-by.value}}`", `"additionalRequirements`": `"{{additional-requirements.value}}`", `"approvalAcknowledgment`": {{approval-acknowledgment.value}}}"
}


$requestCard = New-AMITResourceRequestCard @cardParams
```

### EXAMPLE 2

```
# Example 2: Create a simple IT resource request card using splatting
$simpleCardParams = @{
    RequestHeader = "Request New Hardware"
    RequestDescription = "Use this form to request new hardware resources."
    RequesterInformationRequired = $false
    ResponseEndpoint = "https://api.example.com/resource-request"
    OriginatorId = "it-resource-system"
}


$requestCard = New-AMITResourceRequestCard @simpleCardParams
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

### -RequestHeader

The header text displayed at the top of the card.
Defaults to "IT Resource Request Form".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: IT Resource Request Form
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestDescription

The description text displayed below the header.
Defaults to a predefined message explaining the purpose of the form.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Use this form to request new IT resources or services. Complete all applicable fields to help us process your request efficiently.
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestTypeChoices

(Optional) A hashtable of choices for the type of IT resource being requested.
Each key-value pair represents an option and its description.
Defaults to:
\[ordered\]@{
"hardware" = "New Hardware"
"software" = "Software License/Application"
"cloud" = "Cloud Resource"
"access" = "System Access"
"integration" = "Service Integration"
"other" = "Other"
}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: [ordered]@{
            "hardware"    = "New Hardware"
            "software"    = "Software License/Application"
            "cloud"       = "Cloud Resource"
            "access"      = "System Access"
            "integration" = "Service Integration"
            "other"       = "Other"
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequesterInformationRequired

(Optional) A boolean indicating whether requester information fields (e.g., name, email, department) are required.
Defaults to \`$true\`.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -urgencyChoices

(Optional) A hashtable of choices for the urgency of the request.
Each key-value pair represents an option and its description.
Defaults to:
\[ordered\]@{
"critical" = "Critical (Required immediately)"
"high" = "High (Required within days)"
"medium" = "Medium (Required within weeks)"
"low" = "Low (Required within months)"
}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: [ordered]@{
            "critical" = "Critical (Required immediately)"
            "high"     = "High (Required within days)"
            "medium"   = "Medium (Required within weeks)"
            "low"      = "Low (Required within months)"
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### -Acknowledge

(Optional) A boolean indicating whether an acknowledgment section is included in the card.
Defaults to \`$true\`.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -AcknowledgeMessage

(Optional) The acknowledgment message displayed in the card.
Defaults to a predefined message about approvals and budget availability.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: I acknowledge that this request may require additional approvals and may be subject to budget availability.
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseEndpoint

(Optional) The URL where the request will be sent.
Defaults to "https://api.example.com/resource-request".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: Https://api.example.com/resource-request
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseBody

(Optional) The body of the POST request sent to the \`ResponseEndpoint\`.
This is a JSON string that includes placeholders for dynamic values such as request type, requester information, and resource details.
Defaults to:
"{\`"requestType\`": \`"{{request-type.value}}\`", \`"requestorName\`": \`"{{requestor-name.value}}\`", \`"department\`": \`"{{department.value}}\`", \`"manager\`": \`"{{manager.value}}\`", \`"projectName\`": \`"{{project-name.value}}\`", \`"costCenter\`": \`"{{cost-center.value}}\`", \`"resourceName\`": \`"{{resource-name.value}}\`", \`"quantity\`": {{quantity.value}}, \`"businessJustification\`": \`"{{business-justification.value}}\`", \`"urgency\`": \`"{{urgency.value}}\`", \`"neededBy\`": \`"{{needed-by.value}}\`", \`"additionalRequirements\`": \`"{{additional-requirements.value}}\`", \`"approvalAcknowledgment\`": {{approval-acknowledgment.value}}}"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value:
  {
    "requestType": "{{request-type.value}}",
    "requestorName": "{{requestor-name.value}}",
    "department": "{{department.value}}",
    "manager": "{{manager.value}}",
    "projectName": "{{project-name.value}}",
    "costCenter": "{{cost-center.value}}",
    "resourceName": "{{resource-name.value}}",
    "quantity": { { quantity.value } },
    "businessJustification": "{{business-justification.value}}",
    "urgency": "{{urgency.value}}",
    "neededBy": "{{needed-by.value}}",
    "additionalRequirements": "{{additional-requirements.value}}",
    "approvalAcknowledgment": { { approval-acknowledgment.value } },
  }
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function is part of the Actionable Messages module and is used to create Adaptive Cards for IT resource requests.
The card can be exported and sent via email or other communication channels.

## RELATED LINKS
