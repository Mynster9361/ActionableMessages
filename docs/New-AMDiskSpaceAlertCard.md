---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/Input.Date.html
schema: 2.0.0
---

# New-AMDiskSpaceAlertCard

## SYNOPSIS

Creates an Adaptive Card for disk space alerts.

## SYNTAX

```
New-AMDiskSpaceAlertCard [-OriginatorId] <String> [-Server] <String> [-Drive] <String> [-FreeSpace] <String>
 [-TotalSize] <String> [[-ThresholdPercent] <Int32>] [[-TopConsumers] <Hashtable[]>]
 [[-MonitoringUrl] <String>] [[-ActionUrl] <String>] [[-ActionBody] <String>] [[-ActionTitle] <String>]
 [[-AcknowledgeUrl] <String>] [[-AcknowledgeBody] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION

The \`New-AMDiskSpaceAlertCard\` function generates an Adaptive Card to notify users about low disk space on a specific server and drive.
The card includes details about the server, drive, free space, total size, and other relevant information.
It also provides options for actions such as viewing monitoring details, acknowledging the alert, or taking corrective actions.

## EXAMPLES

### EXAMPLE 1

```
# Example 1: Create a detailed disk space alert card using splatting
$diskCardParams = @{
    Server          = "SQLSRV01"
    Drive           = "D:"
    FreeSpace       = "15 GB"
    TotalSize       = "500 GB"
    TopConsumers    = @(
        @{ Path = "D:\Backups\"; Size = "250 GB" },
        @{ Path = "D:\Logs\"; Size = "120 GB" }
    )
    ActionUrl       = "https://example.com/take-action"
    ActionBody      = "{`"server`": `"$Server`", `"action`": `"cleanup_disk`", `"drive`": `"$Drive`"}"
    ActionTitle     = "Take Action"
    AcknowledgeUrl  = "https://example.com/acknowledge"
    AcknowledgeBody = "{`"alertId`": `"DSK-$(Get-Date -Format 'yyyy-MM-dd')`", `"server`": `"$Server`"}"
    MonitoringUrl   = "https://example.com/monitoring"
    OriginatorId    = "disk-space-monitor"
}


$diskCard = New-AMDiskSpaceAlertCard @diskCardParams
```

### EXAMPLE 2

```
# Example 2: Create a simple disk space alert card using splatting
$simpleDiskCardParams = @{
    Server          = "WEB01"
    Drive           = "C:"
    FreeSpace       = "5 GB"
    TotalSize       = "100 GB"
    ThresholdPercent = 15
    OriginatorId    = "disk-space-monitor"
}


$diskCard = New-AMDiskSpaceAlertCard @simpleDiskCardParams
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

The name of the server where the disk space alert is being generated.

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

### -Drive

The drive letter (e.g., "C:") of the disk being monitored.

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

### -FreeSpace

The amount of free space available on the drive (e.g., "15 GB").

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

### -TotalSize

The total size of the drive (e.g., "500 GB").

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

### -ThresholdPercent

(Optional) The threshold percentage for triggering a warning.
Defaults to 10%.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -TopConsumers

(Optional) A list of the top space-consuming directories or files on the drive.
Each entry should be a hashtable with \`Path\` and \`Size\` keys.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonitoringUrl

(Optional) A URL to view detailed monitoring information about the server or drive.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionUrl

(Optional) A URL to trigger an action, such as running a cleanup script.

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

### -ActionBody

(Optional) The body of the request sent to the \`ActionUrl\`.
Defaults to a JSON payload with server and drive details.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: "{`"server`": `"$Server`", `"action`": `"cleanup_disk`", `"drive`": `"$Drive`"}"
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionTitle

(Optional) The title of the action button.
Defaults to "Take Action".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: Take Action
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
Position: 12
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
Position: 13
Default value: "{`"alertId`": `"DSK-$(Get-Date -Format 'yyyy-MM-dd')`", `"server`": `"$Server`"}"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function is part of the Actionable Messages module and is used to create Adaptive Cards for disk space alerts.
The card can be exported and sent via email or other communication channels.

## RELATED LINKS
