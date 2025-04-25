function New-AMITResourceRequestCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card for IT resource requests.

    .DESCRIPTION
    The `New-AMITResourceRequestCard` function generates an Adaptive Card to collect information about IT resource requests.
    The card includes fields for request type, requester information, resource details, urgency, and additional requirements.
    It also provides an acknowledgment option and a submit button to send the request to a specified endpoint.

    .PARAMETER OriginatorId
    The originator ID of the card. This is used to identify the source of the card. Defaults to "your-originator-id".

    .PARAMETER RequestHeader
    The header text displayed at the top of the card. Defaults to "IT Resource Request Form".

    .PARAMETER RequestDescription
    The description text displayed below the header. Defaults to a predefined message explaining the purpose of the form.

    .PARAMETER RequestTypeChoices
    (Optional) A hashtable of choices for the type of IT resource being requested. Each key-value pair represents an option and its description.
    Defaults to:
        [ordered]@{
            "hardware" = "New Hardware"
            "software" = "Software License/Application"
            "cloud"    = "Cloud Resource"
            "access"   = "System Access"
            "integration" = "Service Integration"
            "other"    = "Other"
        }

    .PARAMETER RequesterInformationRequired
    (Optional) A boolean indicating whether requester information fields (e.g., name, email, department) are required. Defaults to `$true`.

    .PARAMETER UrgencyChoices
    (Optional) A hashtable of choices for the urgency of the request. Each key-value pair represents an option and its description.
    Defaults to:
        [ordered]@{
            "critical" = "Critical (Required immediately)"
            "high"     = "High (Required within days)"
            "medium"   = "Medium (Required within weeks)"
            "low"      = "Low (Required within months)"
        }

    .PARAMETER Acknowledge
    (Optional) A boolean indicating whether an acknowledgment section is included in the card. Defaults to `$true`.

    .PARAMETER AcknowledgeMessage
    (Optional) The acknowledgment message displayed in the card. Defaults to a predefined message about approvals and budget availability.

    .PARAMETER ResponseEndpoint
    (Optional) The URL where the request will be sent. Defaults to "https://api.example.com/resource-request".

    .PARAMETER ResponseBody
    (Optional) The body of the POST request sent to the `ResponseEndpoint`.
    This is a JSON string that includes placeholders for dynamic values such as request type, requester information, and resource details.
    Defaults to:
        "{`"requestType`": `"{{request-type.value}}`", `"requestorName`": `"{{requestor-name.value}}`", `"department`": `"{{department.value}}`", `"manager`": `"{{manager.value}}`", `"projectName`": `"{{project-name.value}}`", `"costCenter`": `"{{cost-center.value}}`", `"resourceName`": `"{{resource-name.value}}`", `"quantity`": {{quantity.value}}, `"businessJustification`": `"{{business-justification.value}}`", `"urgency`": `"{{urgency.value}}`", `"neededBy`": `"{{needed-by.value}}`", `"additionalRequirements`": `"{{additional-requirements.value}}`", `"approvalAcknowledgment`": {{approval-acknowledgment.value}}}"

    .EXAMPLE
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

    .EXAMPLE
    # Example 2: Create a simple IT resource request card using splatting
    $simpleCardParams = @{
        RequestHeader = "Request New Hardware"
        RequestDescription = "Use this form to request new hardware resources."
        RequesterInformationRequired = $false
        ResponseEndpoint = "https://api.example.com/resource-request"
        OriginatorId = "it-resource-system"
    }

    $requestCard = New-AMITResourceRequestCard @simpleCardParams

    .NOTES
    This function is part of the Actionable Messages module and is used to create Adaptive Cards for IT resource requests.
    The card can be exported and sent via email or other communication channels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OriginatorId = "your-originator-id",

        [Parameter(Mandatory = $false)]
        [string]$RequestHeader = "IT Resource Request Form",

        [Parameter(Mandatory = $false)]
        [string]$RequestDescription = "Use this form to request new IT resources or services. Complete all applicable fields to help us process your request efficiently.",

        [Parameter(Mandatory = $false)]
        $RequestTypeChoices = [ordered]@{
            "hardware"    = "New Hardware"
            "software"    = "Software License/Application"
            "cloud"       = "Cloud Resource"
            "access"      = "System Access"
            "integration" = "Service Integration"
            "other"       = "Other"
        },

        [Parameter(Mandatory = $false)]
        [bool]$RequesterInformationRequired = $true,

        [Parameter(Mandatory = $false)]
        $urgencyChoices = [ordered]@{
            "critical" = "Critical (Required immediately)"
            "high"     = "High (Required within days)"
            "medium"   = "Medium (Required within weeks)"
            "low"      = "Low (Required within months)"
        },

        [Parameter(Mandatory = $false)]
        [bool]$Acknowledge = $true,

        [Parameter(Mandatory = $false)]
        [string]$AcknowledgeMessage = "I acknowledge that this request may require additional approvals and may be subject to budget availability.",

        [Parameter(Mandatory = $false)]
        [string]$ResponseEndpoint = "https://api.example.com/resource-request",

        [Parameter(Mandatory = $false)]
        [string]$ResponseBody = "{`"requestType`": `"{{request-type.value}}`", `"requestorName`": `"{{requestor-name.value}}`", `"department`": `"{{department.value}}`", `"manager`": `"{{manager.value}}`", `"projectName`": `"{{project-name.value}}`", `"costCenter`": `"{{cost-center.value}}`", `"resourceName`": `"{{resource-name.value}}`", `"quantity`": {{quantity.value}}, `"businessJustification`": `"{{business-justification.value}}`", `"urgency`": `"{{urgency.value}}`", `"neededBy`": `"{{needed-by.value}}`", `"additionalRequirements`": `"{{additional-requirements.value}}`", `"approvalAcknowledgment`": {{approval-acknowledgment.value}}}"

    )

    # Create a new card
    $card = New-AMCard -OriginatorId $OriginatorId -Version "1.0"

    # Add header
    $header = New-AMTextBlock -Text $RequestHeader -Size "Large" -Weight "Bolder" -Color "Accent"
    Add-AMElement -Card $card -Element $header

    # Add description
    $description = New-AMTextBlock -Text $RequestDescription -Wrap $true
    Add-AMElement -Card $card -Element $description

    # Add request type selection
    $requestTypeLabel = New-AMTextBlock -Text "Request Type:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $requestTypeLabel

    $requestTypeChoiceElements = $requestTypeChoices.GetEnumerator() | ForEach-Object {
        New-AMChoice -Title $_.Value -Value $_.Key
    }

    $requestTypeInput = New-AMChoiceSetInput -Id "request-type" -Choices $requestTypeChoiceElements -Style "expanded"
    Add-AMElement -Card $card -Element $requestTypeInput

    if ($RequesterInformationRequired) {
        # Add personal information container
        $infoContainer = New-AMContainer -Id "personal-info" -Style "emphasis" -Padding "Default"
        Add-AMElement -Card $card -Element $infoContainer

        $infoHeader = New-AMTextBlock -Text "Requestor Information" -Weight "Bolder"
        Add-AMElement -Card $card -Element $infoHeader -ContainerId "personal-info"

        # Add name field
        $nameLabel = New-AMTextBlock -Text "Full Name:" -Weight "Bolder"
        Add-AMElement -Card $card -Element $nameLabel -ContainerId "personal-info"

        $nameInput = New-AMTextInput -Id "requestor-name" -Placeholder "Enter your full name"
        Add-AMElement -Card $card -Element $nameInput -ContainerId "personal-info"

        # Add email field
        $emailLabel = New-AMTextBlock -Text "E-Mail:" -Weight "Bolder"
        Add-AMElement -Card $card -Element $emailLabel -ContainerId "personal-info"

        $emailInput = New-AMTextInput -Id "requestor-name" -Placeholder "Enter your E-mail address"
        Add-AMElement -Card $card -Element $emailInput -ContainerId "personal-info"

        # Add department field
        $deptLabel = New-AMTextBlock -Text "Department:" -Weight "Bolder"
        Add-AMElement -Card $card -Element $deptLabel -ContainerId "personal-info"

        $deptInput = New-AMTextInput -Id "department" -Placeholder "Enter your department"
        Add-AMElement -Card $card -Element $deptInput -ContainerId "personal-info"

        # Add manager field
        $managerLabel = New-AMTextBlock -Text "Manager:" -Weight "Bolder"
        Add-AMElement -Card $card -Element $managerLabel -ContainerId "personal-info"

        $managerInput = New-AMTextInput -Id "manager" -Placeholder "Enter your manager's name"
        Add-AMElement -Card $card -Element $managerInput -ContainerId "personal-info"

        # Add project field
        $projectLabel = New-AMTextBlock -Text "Project (if applicable):" -Weight "Bolder"
        Add-AMElement -Card $card -Element $projectLabel -ContainerId "personal-info"

        $projectInput = New-AMTextInput -Id "project-name" -Placeholder "Enter the project name"
        Add-AMElement -Card $card -Element $projectInput -ContainerId "personal-info"

        # Add cost center field
        $costLabel = New-AMTextBlock -Text "Cost Center:" -Weight "Bolder"
        Add-AMElement -Card $card -Element $costLabel -ContainerId "personal-info"

        $costInput = New-AMTextInput -Id "cost-center" -Placeholder "Enter the cost center"
        Add-AMElement -Card $card -Element $costInput -ContainerId "personal-info"
    }

    # Add resource details container
    $detailsContainer = New-AMContainer -Id "resource-details" -Style "emphasis" -Padding "Default"
    Add-AMElement -Card $card -Element $detailsContainer

    $detailsHeader = New-AMTextBlock -Text "Resource Details" -Weight "Bolder"
    Add-AMElement -Card $card -Element $detailsHeader -ContainerId "resource-details"

    # Add resource name field
    $resourceLabel = New-AMTextBlock -Text "Resource Name/Description:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $resourceLabel -ContainerId "resource-details"

    $resourceInput = New-AMTextInput -Id "resource-name" -Placeholder "Enter the name or description of the requested resource"
    Add-AMElement -Card $card -Element $resourceInput -ContainerId "resource-details"

    # Add quantity field
    $quantityLabel = New-AMTextBlock -Text "Quantity:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $quantityLabel -ContainerId "resource-details"

    $quantityInput = New-AMNumberInput -Id "quantity" -Placeholder "Enter quantity" -Min 1 -Value 1
    Add-AMElement -Card $card -Element $quantityInput -ContainerId "resource-details"

    # Add business justification field
    $justificationLabel = New-AMTextBlock -Text "Business Justification:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $justificationLabel -ContainerId "resource-details"

    $justificationInput = New-AMTextInput -Id "business-justification" -Placeholder "Explain why this resource is needed and its business impact" -IsMultiline $true
    Add-AMElement -Card $card -Element $justificationInput -ContainerId "resource-details"

    # Add urgency field
    $urgencyLabel = New-AMTextBlock -Text "Urgency:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $urgencyLabel -ContainerId "resource-details"

    $urgencyChoiceElements = $urgencyChoices.GetEnumerator() | ForEach-Object {
        New-AMChoice -Title $_.Value -Value $_.Key
    }
    $urgencyInput = New-AMChoiceSetInput -Id "urgency" -Choices $urgencyChoiceElements -Style "compact"
    Add-AMElement -Card $card -Element $urgencyInput -ContainerId "resource-details"

    # Add needed by date
    $neededByLabel = New-AMTextBlock -Text "Needed By Date:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $neededByLabel -ContainerId "resource-details"

    $neededByInput = New-AMDateInput -Id "needed-by" -Placeholder "Select date" -Label "Needed By" -Value (Get-Date).AddDays(7).ToString("yyyy-MM-dd")
    Add-AMElement -Card $card -Element $neededByInput -ContainerId "resource-details"

    # Add additional requirements field
    $additionalReqLabel = New-AMTextBlock -Text "Additional Requirements or Specifications:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $additionalReqLabel -ContainerId "resource-details"

    $additionalReqInput = New-AMTextInput -Id "additional-requirements" -Placeholder "Enter any specific requirements or specifications" -IsMultiline $true
    Add-AMElement -Card $card -Element $additionalReqInput -ContainerId "resource-details"

    if ($Acknowledge) {
        # Add acknowledgment container
        $acknowledgeContainer = New-AMContainer -Id "acknowledge-container" -Style "default" -Padding "Default"
        Add-AMElement -Card $card -Element $acknowledgeContainer

        $acknowledgeText = New-AMTextBlock -Text $AcknowledgeMessage -Wrap $true -Size "Small"
        Add-AMElement -Card $card -Element $acknowledgeText -ContainerId "acknowledge-container"

        $acknowledgeInput = New-AMToggleInput -Id "acknowledgment" -Title "I acknowledge"
        Add-AMElement -Card $card -Element $acknowledgeInput -ContainerId "acknowledge-container"
    }

    # Add submit button
    $submitAction = New-AMExecuteAction -Title "Submit Request" -Verb "POST" -Url $ResponseEndpoint -Body $ResponseBody

    $actionSet = New-AMActionSet -Actions @($submitAction)
    Add-AMElement -Card $card -Element $actionSet

    return $card
}
