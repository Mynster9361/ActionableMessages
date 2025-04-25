function New-AMServerMonitoringCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card for server monitoring alerts.

    .DESCRIPTION
    The `New-AMServerMonitoringCard` function generates an Adaptive Card to notify users about the status of a specific server.
    The card includes details about the server, its status, test results, affected systems, and optional actions for monitoring, restarting, or acknowledging the alert.

    .PARAMETER OriginatorId
    The originator ID of the card. This is used to identify the source of the card.

    .PARAMETER Server
    The name of the server being monitored.

    .PARAMETER Status
    The current status of the server. Valid values are:
    - Online
    - Offline
    - Warning
    - Degraded

    .PARAMETER ServerType
    (Optional) The type of server (e.g., "Domain Controller", "Web Server"). Defaults to "Server".

    .PARAMETER IPAddress
    (Optional) The IP address of the server.

    .PARAMETER Location
    (Optional) The physical or logical location of the server.

    .PARAMETER CheckTime
    (Optional) The timestamp of the last status check. Defaults to the current date and time.

    .PARAMETER TestResults
    (Optional) A list of test results for the server. Each entry should be a hashtable with `Name` and `Result` keys.

    .PARAMETER AffectedSystems
    (Optional) A list of systems affected by the server's status.

    .PARAMETER MonitoringUrl
    (Optional) A URL to view detailed monitoring information about the server.

    .PARAMETER ActionUrl
    (Optional) A URL to trigger an action, such as restarting the server.

    .PARAMETER ActionTitle
    (Optional) The title of the action button. Defaults to "Restart Server".

    .PARAMETER ActionBody
    (Optional) The body of the request sent to the `ActionUrl`. Defaults to a JSON payload with server details.

    .PARAMETER AcknowledgeUrl
    (Optional) A URL to acknowledge the alert.

    .PARAMETER AcknowledgeBody
    (Optional) The body of the request sent to the `AcknowledgeUrl`. Defaults to a JSON payload with alert and server details.

    .EXAMPLE
    # Example 1: Create a server monitoring alert for an offline server using splatting
    $offlineServerParams = @{
        Server          = "DCSRV01"
        Status          = "Offline"
        ServerType      = "Domain Controller"
        IPAddress       = "10.0.0.10"
        TestResults     = @(
            @{ Name = "ICMP Ping"; Result = "Failed" },
            @{ Name = "TCP Port 389 (LDAP)"; Result = "Failed" }
        )
        AffectedSystems = @("WEBSRV01", "WEBSRV02", "APPSRV01")
        MonitoringUrl   = "https://monitoring.example.com/servers/DCSRV01"
        ActionUrl       = "https://monitoring.example.com/servers/DCSRV01/restart"
        ActionTitle     = "Restart Server"
        ActionBody      = "{`"server`": `"$Server`", `"action`": `"restart`"}"
        AcknowledgeUrl  = "https://monitoring.example.com/servers/DCSRV01/acknowledge"
        AcknowledgeBody = "{`"alertId`": `"SER-$(Get-Date -Format 'yyyy-MM-dd')`", `"server`": `"$Server`"}"
        OriginatorId    = "ServerMonitoringSystem"
        Location        = "Data Center 1"
    }

    $serverCard = New-AMServerMonitoringCard @offlineServerParams

    .EXAMPLE
    # Example 2: Create a server monitoring alert for a degraded server using splatting
    $degradedServerParams = @{
        Server        = "APPSRV01"
        Status        = "Degraded"
        ServerType    = "Application Server"
        MonitoringUrl = "https://monitoring.example.com/servers/APPSRV01"
        OriginatorId  = "ServerMonitoringSystem"
    }

    $serverCard = New-AMServerMonitoringCard @degradedServerParams

    .NOTES
    This function is part of the Actionable Messages module and is used to create Adaptive Cards for server monitoring alerts.
    The card can be exported and sent via email or other communication channels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OriginatorId,

        [Parameter(Mandatory = $true)]
        [string]$Server,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Online", "Offline", "Warning", "Degraded")]
        [string]$Status,

        [Parameter(Mandatory = $false)]
        [string]$ServerType = "Server",

        [Parameter(Mandatory = $false)]
        [string]$IPAddress,

        [Parameter(Mandatory = $false)]
        [string]$Location,

        [Parameter(Mandatory = $false)]
        [string]$CheckTime = (Get-Date -Format "yyyy-MM-dd HH:mm:ss"),

        [Parameter(Mandatory = $false)]
        [hashtable[]]$TestResults,

        [Parameter(Mandatory = $false)]
        [string[]]$AffectedSystems,

        [Parameter(Mandatory = $false)]
        [string]$MonitoringUrl,

        [Parameter(Mandatory = $false)]
        [string]$ActionUrl,

        [Parameter(Mandatory = $false)]
        [string]$ActionTitle = "Restart Server",

        [Parameter(Mandatory = $false)]
        [string]$ActionBody = "{`"server`": `"$Server`", `"action`": `"restart`"}",

        [Parameter(Mandatory = $false)]
        [string]$AcknowledgeUrl,

        [Parameter(Mandatory = $false)]
        [string]$AcknowledgeBody = "{`"alertId`": `"SER-$(Get-Date -Format 'yyyy-MM-dd')`", `"server`": `"$Server`"}"

    )

    # Create a new card
    $card = New-AMCard -OriginatorId $OriginatorId -Version "1.0"

    # Determine severity color
    $severityColor = switch ($Status) {
        "Offline" { "Attention" }
        "Warning" { "Warning" }
        "Degraded" { "Warning" }
        "Online" { "Good" }
        default { "Default" }
    }

    # Add header with alert severity color
    $header = New-AMTextBlock -Text "Server $Status : $Server" -Size "Large" -Weight "Bolder" -Color $severityColor
    Add-AMElement -Card $card -Element $header

    # Add server details
    $serverContainer = New-AMContainer -Id "server-details" -Style "emphasis" -Padding "Default"
    Add-AMElement -Card $card -Element $serverContainer

    # Add server facts
    $serverFacts = @(
        New-AMFact -Title "Server" -Value "$Server ($ServerType)"
        New-AMFact -Title "Status" -Value $Status.ToUpper()
    )

    if ($IPAddress) {
        $serverFacts += New-AMFact -Title "IP Address" -Value $IPAddress
    }

    if ($Location) {
        $serverFacts += New-AMFact -Title "Location" -Value $Location
    }

    $serverFacts += New-AMFact -Title "Check Time" -Value $CheckTime

    $factSet = New-AMFactSet -Facts $serverFacts
    Add-AMElement -Card $card -Element $factSet -ContainerId "server-details"

    # Add test results if provided
    if ($TestResults -and $TestResults.Count -gt 0) {
        $testContainer = New-AMContainer -Id "test-results" -Style "default" -Padding "Default"
        Add-AMElement -Card $card -Element $testContainer

        $testHeader = New-AMTextBlock -Text "Test Results" -Weight "Bolder"
        Add-AMElement -Card $card -Element $testHeader -ContainerId "test-results"

        $testFacts = @()
        foreach ($test in $TestResults) {
            $testFacts += New-AMFact -Title $test.Name -Value $test.Result
        }

        $testFactSet = New-AMFactSet -Facts $testFacts
        Add-AMElement -Card $card -Element $testFactSet -ContainerId "test-results"
    }

    # Add affected systems if provided
    if ($AffectedSystems -and $AffectedSystems.Count -gt 0) {
        $dependentContainer = New-AMContainer -Id "dependent-systems" -Style "default" -Padding "Default"
        Add-AMElement -Card $card -Element $dependentContainer

        $dependentHeader = New-AMTextBlock -Text "Affected Systems" -Weight "Bolder"
        Add-AMElement -Card $card -Element $dependentHeader -ContainerId "dependent-systems"

        $dependentSystems = New-AMTextBlock -Text ($AffectedSystems -join ", ") -Wrap $true
        Add-AMElement -Card $card -Element $dependentSystems -ContainerId "dependent-systems"
    }

    if ($MonitoringUrl -or $ActionUrl -or $AcknowledgeUrl) {
        # Add actions
        $actions = @()
        if ($MonitoringUrl) {
            $actions += New-AMOpenUrlAction -Title "View Details" -Url $MonitoringUrl
        }

        if ($ActionUrl) {
            $actions += New-AMExecuteAction -Title $ActionTitle -Url $ActionUrl -Verb "POST" -Body $ActionBody
        }

        if ($AcknowledgeUrl) {
            $actions += New-AMExecuteAction -Title "Acknowledge" -Url $AcknowledgeUrl -Verb "POST" -Body $AcknowledgeBody
        }


        $actionSet = New-AMActionSet -Actions $actions
        Add-AMElement -Card $card -Element $actionSet

    }
    return $card
}
