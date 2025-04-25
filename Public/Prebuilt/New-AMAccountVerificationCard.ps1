function New-AMAccountVerificationCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card for account verification.

    .DESCRIPTION
    The `New-AMAccountVerificationCard` function generates an Adaptive Card to notify users about an account that requires verification.
    The card includes details about the account, its owner, department, last login, and systems the account has access to.
    It also provides options for the user to confirm, disable, or transfer the account, along with a comment field for additional input.

    .PARAMETER OriginatorId
    The originator ID of the card. This is used to identify the source of the card. Defaults to "your-originator-id".

    .PARAMETER Username
    The username of the account being verified.

    .PARAMETER AccountOwner
    (Optional) The name of the account owner.

    .PARAMETER Department
    (Optional) The department associated with the account.

    .PARAMETER LastLoginDate
    (Optional) The date and time of the last login for the account.

    .PARAMETER InactiveDays
    (Optional) The number of days the account has been inactive. Defaults to 90 days.

    .PARAMETER AccessibleSystems
    (Optional) A list of systems the account has access to.

    .PARAMETER TicketNumber
    (Optional) The ticket number associated with the account verification request.

    .PARAMETER DisableDate
    (Optional) The date when the account will be disabled if no response is received.

    .PARAMETER DisableText
    (Optional) The text displayed to describe the reason for the account verification. Defaults to a predefined message.

    .PARAMETER StatusChoices
    (Optional) A hashtable of status choices for the account. Each key-value pair represents an option and its description.
    Defaults to:
        @{
            "keep" = "Account is still needed and actively used"
            "keep-infrequent" = "Account is needed but used infrequently"
            "disable" = "Account can be disabled"
            "transfer" = "Account needs to be transferred to another user"
            "unknown" = "I don't know / Need more information"
        }

    .PARAMETER ResponseEndpoint
    (Optional) The URL where the response will be sent. Defaults to "https://api.example.com/account-verification".

    .PARAMETER ResponseBody
    (Optional) The body of the POST request sent to the `ResponseEndpoint`.
    This is a JSON string that includes placeholders for dynamic values such as the ticket number, username, account status, comments, and transfer details.
    Defaults to:
        "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"

    .EXAMPLE
    # Example 1: Create an account verification card using splatting
    $accountCardParams = @{
        OriginatorId       = "your-originator-id"
        Username           = "jsmith"
        AccountOwner       = "John Smith"
        Department         = "Marketing"
        LastLoginDate      = (Get-Date).AddDays(-120)
        InactiveDays       = 120
        AccessibleSystems  = @("CRM System", "Marketing Automation", "Document Repository")
        TicketNumber       = "ACC-2023-001"
        DisableDate        = (Get-Date).AddDays(14)
        DisableText        = "This account has been identified as inactive."
        StatusChoices      = @{
            "keep" = "Account is still needed and actively used"
            "keep-infrequent" = "Account is needed but used infrequently"
            "disable" = "Account can be disabled"
            "transfer" = "Account needs to be transferred to another user"
            "unknown" = "I don't know / Need more information"
        }
        ResponseEndpoint   = "https://api.example.com/account-verification"
        ResponseBody       = "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"
    }

    $accountCard = New-AMAccountVerificationCard @accountCardParams

    .EXAMPLE
    # Example 2: Create a simple account verification card using splatting
    $simpleAccountCardParams = @{
        OriginatorId       = "account-verification-system"
        Username           = "asmith"
        AccountOwner       = "Alice Smith"
        LastLoginDate      = (Get-Date).AddDays(-60)
        InactiveDays       = 60
        ResponseEndpoint   = "https://api.example.com/account-verification"
        ResponseBody       = "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"
    }

    $accountCard = New-AMAccountVerificationCard @simpleAccountCardParams

    .NOTES
    This function is part of the Actionable Messages module and is used to create Adaptive Cards for account verification.
    The card can be exported and sent via email or other communication channels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OriginatorId = "your-originator-id",

        [Parameter(Mandatory = $true)]
        [string]$Username,

        [Parameter(Mandatory = $false)]
        [string]$AccountOwner,

        [Parameter(Mandatory = $false)]
        [string]$Department,

        [Parameter(Mandatory = $false)]
        [DateTime]$LastLoginDate,

        [Parameter(Mandatory = $false)]
        [int]$InactiveDays = 90,

        [Parameter(Mandatory = $false)]
        [string[]]$AccessibleSystems,

        [Parameter(Mandatory = $false)]
        [string]$TicketNumber,

        [Parameter(Mandatory = $false)]
        [DateTime]$DisableDate,

        [Parameter(Mandatory = $false)]
        [string]$DisableText = "This account has been identified as inactive. Please respond to this notification to confirm if this account is still required. If no response is received, the account may be disabled as part of our security protocols.",

        [Parameter(Mandatory = $false)]
        $statusChoices = [ordered]@{
            "keep"            = "Account is still needed and actively used"
            "keep-infrequent" = "Account is needed but used infrequently"
            "disable"         = "Account can be disabled"
            "transfer"        = "Account needs to be transferred to another user"
            "unknown"         = "I don't know / Need more information"
        },

        [Parameter(Mandatory = $false)]
        [string]$ResponseEndpoint = "https://api.example.com/account-verification",

        [Parameter(Mandatory = $false)]
        [string]$ResponseBody = "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"

    )

    # Create a new card
    $card = New-AMCard -OriginatorId $OriginatorId -Version "1.0"

    # Add header
    $header = New-AMTextBlock -Text "Account Verification Required" -Size "Large" -Weight "Bolder" -Color "Accent"
    Add-AMElement -Card $card -Element $header

    # Add account details
    $accountContainer = New-AMContainer -Id "account-details" -Style "emphasis" -Padding "Default"
    Add-AMElement -Card $card -Element $accountContainer

    # Add facts
    $facts = @(
        New-AMFact -Title "Username" -Value $Username
    )

    if ($AccountOwner) {
        $facts += New-AMFact -Title "Account Owner" -Value $AccountOwner
    }

    if ($Department) {
        $facts += New-AMFact -Title "Department" -Value $Department
    }

    if ($LastLoginDate) {
        $facts += New-AMFact -Title "Last Login" -Value (Get-Date $LastLoginDate -Format "yyyy-MM-dd HH:mm:ss")
        $facts += New-AMFact -Title "Days Inactive" -Value "$InactiveDays days"
    }

    if ($TicketNumber) {
        $facts += New-AMFact -Title "Ticket Number" -Value $TicketNumber
    }

    if ($DisableDate) {
        $facts += New-AMFact -Title "Disable Date" -Value (Get-Date $DisableDate -Format "yyyy-MM-dd")
    }

    $factSet = New-AMFactSet -Facts $facts
    Add-AMElement -Card $card -Element $factSet -ContainerId "account-details"

    # Add description
    $description = New-AMTextBlock -Text $DisableText -Wrap $true
    Add-AMElement -Card $card -Element $description -ContainerId "account-details"

    # Add systems access if provided
    if ($AccessibleSystems -and $AccessibleSystems.Count -gt 0) {
        $systemsHeader = New-AMTextBlock -Text "Systems Access" -Weight "Bolder"
        Add-AMElement -Card $card -Element $systemsHeader

        $systemsList = New-AMTextBlock -Text ("• " + ($AccessibleSystems -join "`n• ")) -Wrap $true
        Add-AMElement -Card $card -Element $systemsList
    }

    # Add input fields
    $statusContainer = New-AMContainer -Id "status-container"
    Add-AMElement -Card $card -Element $statusContainer

    $statusLabel = New-AMTextBlock -Text "Please select an option:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $statusLabel -ContainerId "status-container"

    $statusChoiceElements = $statusChoices.GetEnumerator() | ForEach-Object {
        New-AMChoice -Title $_.Value -Value $_.Key
    }
    $statusInput = New-AMChoiceSetInput -Id "account-status" -Choices $statusChoiceElements -Style "expanded"
    Add-AMElement -Card $card -Element $statusInput -ContainerId "status-container"

    # Add comment field
    $commentLabel = New-AMTextBlock -Text "Additional Comments:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $commentLabel

    $commentInput = New-AMTextInput -Id "comment" -Placeholder "Please provide any additional information..." -IsMultiline $true
    Add-AMElement -Card $card -Element $commentInput

    # Add transfer field if needed
    $transferContainer = New-AMContainer -Id "transfer-container"
    Add-AMElement -Card $card -Element $transferContainer

    $transferLabel = New-AMTextBlock -Text "If transferring, provide the new owner's email:" -Weight "Bolder"
    Add-AMElement -Card $card -Element $transferLabel -ContainerId "transfer-container"

    $transferInput = New-AMTextInput -Id "transfer-to" -Placeholder "user@example.com"
    Add-AMElement -Card $card -Element $transferInput -ContainerId "transfer-container"

    # Add submit button
    $submitAction = New-AMExecuteAction -Title "Submit Response" -Verb "POST" -Url $ResponseEndpoint -Body $ResponseBody

    $actionSet = New-AMActionSet -Actions @($submitAction)
    Add-AMElement -Card $card -Element $actionSet

    return $card
}
