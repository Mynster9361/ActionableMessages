function New-AMServiceAlertCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card for service status alerts.

    .DESCRIPTION
    The `New-AMServiceAlertCard` function generates an Adaptive Card to notify users about the status of a specific service on a server.
    The card includes details about the server, service, current status, previous state, downtime, and recent events.
    It also provides options for actions such as viewing monitoring details, restarting the service, or acknowledging the alert.

    .PARAMETER OriginatorId
    The originator ID of the card. This is used to identify the source of the card.

    .PARAMETER Server
    The name of the server where the service alert is being generated.

    .PARAMETER ServiceName
    The internal name of the service being monitored.

    .PARAMETER ServiceDisplayName
    The display name of the service being monitored.

    .PARAMETER Status
    The current status of the service. Valid values are:
    - Running
    - Stopped
    - StartPending
    - StopPending
    - Unknown

    .PARAMETER PreviousState
    (Optional) The previous state of the service. Defaults to "Running".

    .PARAMETER DownSince
    (Optional) The timestamp indicating when the service went down. Defaults to one hour ago.

    .PARAMETER RecentEvents
    (Optional) A list of recent event log entries related to the service. Each entry should be a string.

    .PARAMETER MonitoringUrl
    (Optional) A URL to view detailed monitoring information about the service.

    .PARAMETER ActionUrl
    (Optional) A URL to trigger an action, such as restarting the service.

    .PARAMETER ActionTitle
    (Optional) The title of the action button. Defaults to "Restart Service".

    .PARAMETER ActionBody
    (Optional) The body of the request sent to the `ActionUrl`. Defaults to a JSON payload with server and service details.

    .PARAMETER AcknowledgeUrl
    (Optional) A URL to acknowledge the alert.

    .PARAMETER AcknowledgeBody
    (Optional) The body of the request sent to the `AcknowledgeUrl`. Defaults to a JSON payload with alert and server details.

    .EXAMPLE
    # Example 1: Create a service alert card for a stopped service using splatting
    $stoppedServiceParams = @{
        Server             = "WEBSRV03"
        ServiceName        = "W3SVC"
        ServiceDisplayName = "World Wide Web Publishing Service"
        Status             = "Stopped"
        RecentEvents       = @(
            "System Error #1001: The W3SVC service terminated unexpectedly (Time: 14:32:45)",
            "Application Error #5002: ASP.NET Runtime failure in worker process (Time: 14:32:38)"
        )
        DownSince          = (Get-Date).AddHours(-2).ToString("yyyy-MM-dd HH:mm:ss")
        MonitoringUrl      = "https://monitoring.example.com/service-status"
        OriginatorId       = "service-monitoring-app"
        ActionUrl          = "https://monitoring.example.com/restart-service"
        ActionTitle        = "Restart Service"
        ActionBody         = "{`"server`": `"$Server`", `"service`": `"$ServiceName`", `"action`": `"restart`"}"
        AcknowledgeUrl     = "https://monitoring.example.com/acknowledge-alert"
        AcknowledgeBody    = "{`"server`": `"$Server`", `"service`": `"$ServiceName`", `"action`": `"acknowledge`"}"
    }

    $serviceCard = New-AMServiceAlertCard @stoppedServiceParams

    .EXAMPLE
    # Example 2: Create a service alert card for a service in StartPending state using splatting
    $startPendingServiceParams = @{
        Server             = "APPSRV01"
        ServiceName        = "AppService"
        ServiceDisplayName = "Application Service"
        Status             = "StartPending"
        MonitoringUrl      = "https://monitoring.example.com/service-status"
        OriginatorId       = "service-monitoring-app"
    }

    $serviceCard = New-AMServiceAlertCard @startPendingServiceParams

    .NOTES
    This function is part of the Actionable Messages module and is used to create Adaptive Cards for service status alerts.
    The card can be exported and sent via email or other communication channels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OriginatorId,

        [Parameter(Mandatory = $true)]
        [string]$Server,

        [Parameter(Mandatory = $true)]
        [string]$ServiceName,

        [Parameter(Mandatory = $true)]
        [string]$ServiceDisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Running", "Stopped", "StartPending", "StopPending", "Unknown")]
        [string]$Status,

        [Parameter(Mandatory = $false)]
        [string]$PreviousState = "Running",

        [Parameter(Mandatory = $false)]
        [string]$DownSince = (Get-Date).AddHours(-1).ToString("yyyy-MM-dd HH:mm:ss"),

        [Parameter(Mandatory = $false)]
        [string[]]$RecentEvents,

        [Parameter(Mandatory = $false)]
        [string]$MonitoringUrl,

        [Parameter(Mandatory = $false)]
        [string]$ActionUrl,

        [Parameter(Mandatory = $false)]
        [string]$ActionTitle = "Restart Service",

        [Parameter(Mandatory = $false)]
        [string]$ActionBody = "{`"server`": `"$Server`", `"service`": `"$ServiceName`", `"action`": `"restart`"}",

        [Parameter(Mandatory = $false)]
        [string]$AcknowledgeUrl,

        [Parameter(Mandatory = $false)]
        [string]$AcknowledgeBody = "{`"alertId`": `"SER-$(Get-Date -Format 'yyyy-MM-dd')`", `"server`": `"$Server`"}"

    )

    # Create a new card
    $card = New-AMCard -OriginatorId $OriginatorId -Version "1.0"

    # Determine severity color
    $severityColor = if ($Status -eq "Stopped") { "Attention" } elseif ($Status -eq "Unknown" -or $Status.EndsWith("Pending")) { "Warning" } else { "Good" }

    # Add header with alert severity color
    $title = if ($Status -eq "Stopped") { "Service Failure Alert" } else { "Service Status Change" }
    $header = New-AMTextBlock -Text $title -Size "Large" -Weight "Bolder" -Color $severityColor
    Add-AMElement -Card $card -Element $header

    # Add service details
    $serviceContainer = New-AMContainer -Id "service-details" -Style "emphasis" -Padding "Default"
    Add-AMElement -Card $card -Element $serviceContainer

    # Add service facts
    $serviceFacts = @(
        New-AMFact -Title "Server" -Value $Server
        New-AMFact -Title "Service" -Value "$ServiceDisplayName ($ServiceName)"
        New-AMFact -Title "Status" -Value $Status
        New-AMFact -Title "Previous State" -Value $PreviousState
        New-AMFact -Title "Since" -Value $DownSince
        New-AMFact -Title "Alert Time" -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    )

    $factSet = New-AMFactSet -Facts $serviceFacts
    Add-AMElement -Card $card -Element $factSet -ContainerId "service-details"

    # Add impact description for stopped services
    if ($Status -eq "Stopped") {
        $impactDescription = New-AMTextBlock -Text "This service is not running as expected. Applications depending on this service may be affected." -Wrap $true -Color $severityColor
        Add-AMElement -Card $card -Element $impactDescription
    }

    # Add event log entries if provided
    if ($RecentEvents -and $RecentEvents.Count -gt 0) {
        $eventLogContainer = New-AMContainer -Id "event-log" -Style "default" -Padding "Default"
        Add-AMElement -Card $card -Element $eventLogContainer

        $eventLogHeader = New-AMTextBlock -Text "Recent Event Logs" -Weight "Bolder"
        Add-AMElement -Card $card -Element $eventLogHeader -ContainerId "event-log"

        foreach ($event in $RecentEvents) {
            $eventBlock = New-AMTextBlock -Text $event -Wrap $true -Size "Small"
            Add-AMElement -Card $card -Element $eventBlock -ContainerId "event-log"
        }
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
