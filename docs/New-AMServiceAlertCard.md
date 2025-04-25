---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Action.OpenUrl.html
schema: 2.0.0
---

# New-AMServiceAlertCard

## SYNOPSIS

Creates an Adaptive Card for service status alerts.

## SYNTAX

```
New-AMServiceAlertCard [-OriginatorId] <String> [-Server] <String> [-ServiceName] <String>
 [-ServiceDisplayName] <String> [-Status] <String> [[-PreviousState] <String>] [[-DownSince] <String>]
 [[-RecentEvents] <String[]>] [[-MonitoringUrl] <String>] [[-ActionUrl] <String>] [[-ActionTitle] <String>]
 [[-ActionBody] <String>] [[-AcknowledgeUrl] <String>] [[-AcknowledgeBody] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The \`New-AMServiceAlertCard\` function generates an Adaptive Card to notify users about the status of a specific service on a server.
The card includes details about the server, service, current status, previous state, downtime, and recent events.
It also provides options for actions such as viewing monitoring details, restarting the service, or acknowledging the alert.

## EXAMPLES

### EXAMPLE 1

```
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
```

### EXAMPLE 2

```
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
```

## PARAMETERS

### -OriginatorId

The originator ID of the card.
This is used to identify the source of the card.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server

The name of the server where the service alert is being generated.

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

### -ServiceName

The internal name of the service being monitored.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceDisplayName

The display name of the service being monitored.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status

The current status of the service.
Valid values are:

- Running
- Stopped
- StartPending
- StopPending
- Unknown

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreviousState

(Optional) The previous state of the service.
Defaults to "Running".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Running
Accept pipeline input: False
Accept wildcard characters: False
```

### -DownSince

(Optional) The timestamp indicating when the service went down.
Defaults to one hour ago.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: (Get-Date).AddHours(-1).ToString("yyyy-MM-dd HH:mm:ss")
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecentEvents

(Optional) A list of recent event log entries related to the service.
Each entry should be a string.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonitoringUrl

(Optional) A URL to view detailed monitoring information about the service.

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

### -ActionUrl

(Optional) A URL to trigger an action, such as restarting the service.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionTitle

(Optional) The title of the action button.
Defaults to "Restart Service".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: Restart Service
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionBody

(Optional) The body of the request sent to the \`ActionUrl\`.
Defaults to a JSON payload with server and service details.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: "{`"server`": `"$Server`", `"service`": `"$ServiceName`", `"action`": `"restart`"}"
Accept pipeline input: False
Accept wildcard characters: False
```

### -AcknowledgeUrl

(Optional) A URL to acknowledge the alert.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AcknowledgeBody

(Optional) The body of the request sent to the \`AcknowledgeUrl\`.
Defaults to a JSON payload with alert and server details.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: "{`"alertId`": `"SER-$(Get-Date -Format 'yyyy-MM-dd')`", `"server`": `"$Server`"}"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function is part of the Actionable Messages module and is used to create Adaptive Cards for service status alerts.
The card can be exported and sent via email or other communication channels.

## RELATED LINKS
