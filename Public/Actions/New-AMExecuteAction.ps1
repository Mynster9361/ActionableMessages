function New-AMExecuteAction {
    <#
    .SYNOPSIS
        Creates an HTTP action for an Adaptive Card.

    .DESCRIPTION
        Creates an Action.Http element that makes an HTTP request when the action button is clicked.
        This action is used in Outlook Actionable Messages to trigger server-side operations like
        approving requests, submitting data, or any other operation requiring a backend API call.

    .PARAMETER Title
        The text to display on the action button.

    .PARAMETER Verb
        The HTTP verb/method to use for the request (e.g., "POST", "GET", "PUT", "DELETE").

    .PARAMETER Url
        The URL endpoint that will receive the HTTP request when the button is clicked.

    .PARAMETER Body
        Optional JSON string containing the payload to send with the request.
        You can include user-specific tokens like {{userEmail}} that will be replaced at runtime.

    .PARAMETER Data
        Optional data object (hashtable) to include with the request. This is an alternative to Body
        for when you want to specify the data as a PowerShell object rather than a JSON string.

    .PARAMETER Id
        Optional unique identifier for the action. If not specified, an empty string is used.

    .EXAMPLE
        # Create a simple approval action
        $approveAction = New-AMExecuteAction -Title "Approve" -Verb "POST" `
            -Url "https://api.example.com/approve" `
            -Body '{"requestId": "12345", "status": "approved"}'

    .EXAMPLE
        # Create an action with dynamic user data
        $rejectAction = New-AMExecuteAction -Title "Reject" -Verb "POST" `
            -Url "https://api.contoso.com/api/requests/reject" `
            -Body '{"requestId": "ABC123", "rejectedBy": "{{userEmail}}", "timestamp": "{{utcNow}}"}'

    .EXAMPLE
        # Create an action with a PowerShell object as data
        $data = @{
            requestId = "REQ-789"
            action = "complete"
            comments = "Task completed successfully"
        }
        $completeAction = New-AMExecuteAction -Title "Mark Complete" -Verb "POST" `
            -Url "https://tasks.example.org/api/complete" `
            -Data $data

    .INPUTS
        None. You cannot pipe input to New-AMExecuteAction.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Action.Http element.

    .NOTES
        In Actionable Messages, the correct action type is "Action.Http", not "Action.Execute".
        Action.Http is used for making HTTP requests when the action is triggered.

        For security reasons, the target URL must be registered with the Actionable Email Developer Dashboard
        and associated with your Originator ID before it can be used in production environments.

    .LINK
        https://docs.microsoft.com/en-us/outlook/actionable-messages/message-card-reference#actions
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [string]$Verb,

        [Parameter()]
        [string]$Url,

        [Parameter()]
        [string]$Body,

        [Parameter()]
        [object]$Data,

        [Parameter()]
        [string]$Id,

        [parameter()]
        $IsPrimary = $false
    )

    # Create the basic action object - Note type is Action.Http not Action.Execute for ActionableMessages
    $action = [ordered]@{
        'type' = 'Action.Http'
        'title' = $Title
        'method' = $Verb  # 'method' is the correct property name, not 'verb'
    }

    # Add optional properties
    if ($Url) { $action.url = $Url }
    if ($Body) { $action.body = $Body }
    if ($Data) { $action.data = $Data }
    if ($Id) { $action.id = $Id }
    if ($IsPrimary) {
        $action.isPrimary = $IsPrimary
        $action.style = "positive"  # Set style to primary if isPrimary is true
    }
    else { $action.id = "" }  # Empty ID to match the desired output

    return $action
}