function New-AMExecuteAction {
    <#
    .SYNOPSIS
        Creates an HTTP action for an Adaptive Card.

    .DESCRIPTION
        The `New-AMExecuteAction` function generates an `Action.Http` element for an Adaptive Card.
        This action allows you to make HTTP requests when the action button is clicked.
        It is commonly used in Outlook Actionable Messages to trigger server-side operations such as
        approving requests, submitting data, or performing other backend API calls.

        Note: In Actionable Messages, the correct action type is `Action.Http`, not `Action.Execute`.

    .PARAMETER Title
        The text to display on the action button.

    .PARAMETER Verb
        The HTTP verb/method to use for the request (e.g., "POST", "GET", "PUT", "DELETE").

    .PARAMETER Url
        (Optional) The URL endpoint that will receive the HTTP request when the button is clicked.

    .PARAMETER Body
        (Optional) A JSON string containing the payload to send with the request.
        You can include user-specific tokens like `{{userEmail}}` or `{{utcNow}}` that will be replaced at runtime.

    .PARAMETER Data
        (Optional) A data object (hashtable) to include with the request. This is an alternative to `Body`
        for when you want to specify the data as a PowerShell object rather than a JSON string.

    .PARAMETER Id
        (Optional) A unique identifier for the action. If not specified, an empty string is used.

    .PARAMETER IsPrimary
        (Optional) Indicates whether this action is the primary action. If set to `$true`, the button style
        will be set to "positive" to visually indicate its importance.

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

    .EXAMPLE
        # Create a primary action button
        $primaryAction = New-AMExecuteAction -Title "Submit" -Verb "POST" `
            -Url "https://api.example.com/submit" -IsPrimary $true

    .INPUTS
        None. You cannot pipe input to `New-AMExecuteAction`.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the `Action.Http` element.

    .NOTES
        - In Actionable Messages, the correct action type is `Action.Http`, not `Action.Execute`.
        - For security reasons, the target URL must be registered with the Actionable Email Developer Dashboard
          and associated with your Originator ID before it can be used in production environments.
        - The `method` property is used to specify the HTTP verb (e.g., "POST"), not `verb`.

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
        'type'    = 'Action.Http'
        'title'   = $Title
        'method'  = $Verb  # 'method' is the correct property name, not 'verb'
        <#
        headers is needed in the following format
        "headers": [
            {
                "name": "Authorization",
                "value": ""
            }
        ]
        #>
        'headers' = @(
            @{ name = "Authorization"; value = "" }
        )
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