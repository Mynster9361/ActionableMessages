---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Action.OpenUrl.html
schema: 2.0.0
---

# New-AMServerMonitoringCard

## SYNOPSIS

Creates an Adaptive Card for server monitoring alerts.

## SYNTAX

```
New-AMServerMonitoringCard [-OriginatorId] <String> [-Server] <String> [-Status] <String>
 [[-ServerType] <String>] [[-IPAddress] <String>] [[-Location] <String>] [[-CheckTime] <String>]
 [[-TestResults] <Hashtable[]>] [[-AffectedSystems] <String[]>] [[-MonitoringUrl] <String>]
 [[-ActionUrl] <String>] [[-ActionTitle] <String>] [[-ActionBody] <String>] [[-AcknowledgeUrl] <String>]
 [[-AcknowledgeBody] <String>] [<CommonParameters>]
```

## DESCRIPTION

The \`New-AMServerMonitoringCard\` function generates an Adaptive Card to notify users about the status of a specific server.
The card includes details about the server, its status, test results, affected systems, and optional actions for monitoring, restarting, or acknowledging the alert.

## EXAMPLES

### EXAMPLE 1

```
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
```

### EXAMPLE 2

```
# Example 2: Create a server monitoring alert for a degraded server using splatting
$degradedServerParams = @{
    Server        = "APPSRV01"
    Status        = "Degraded"
    ServerType    = "Application Server"
    MonitoringUrl = "https://monitoring.example.com/servers/APPSRV01"
    OriginatorId  = "ServerMonitoringSystem"
}


$serverCard = New-AMServerMonitoringCard @degradedServerParams
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

The name of the server being monitored.

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

### -Status

The current status of the server.
Valid values are:

- Online
- Offline
- Warning
- Degraded

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

### -ServerType

(Optional) The type of server (e.g., "Domain Controller", "Web Server").
Defaults to "Server".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Server
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
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location

(Optional) The physical or logical location of the server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CheckTime

(Optional) The timestamp of the last status check.
Defaults to the current date and time.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestResults

(Optional) A list of test results for the server.
Each entry should be a hashtable with \`Name\` and \`Result\` keys.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AffectedSystems

(Optional) A list of systems affected by the server's status.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonitoringUrl

(Optional) A URL to view detailed monitoring information about the server.

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

### -ActionUrl

(Optional) A URL to trigger an action, such as restarting the server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionTitle

(Optional) The title of the action button.
Defaults to "Restart Server".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: Restart Server
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionBody

(Optional) The body of the request sent to the \`ActionUrl\`.
Defaults to a JSON payload with server details.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: "{`"server`": `"$Server`", `"action`": `"restart`"}"
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
Position: 14
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
Position: 15
Default value: "{`"alertId`": `"SER-$(Get-Date -Format 'yyyy-MM-dd')`", `"server`": `"$Server`"}"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function is part of the Actionable Messages module and is used to create Adaptive Cards for server monitoring alerts.
The card can be exported and sent via email or other communication channels.

## RELATED LINKS
