function New-AMDiskSpaceAlertCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card for disk space alerts.

    .DESCRIPTION
    The `New-AMDiskSpaceAlertCard` function generates an Adaptive Card to notify users about low disk space on a specific server and drive.
    The card includes details about the server, drive, free space, total size, and other relevant information.
    It also provides options for actions such as viewing monitoring details, acknowledging the alert, or taking corrective actions.

    .PARAMETER OriginatorId
    The originator ID of the card. This is used to identify the source of the card.

    .PARAMETER Server
    The name of the server where the disk space alert is being generated.

    .PARAMETER Drive
    The drive letter (e.g., "C:") of the disk being monitored.

    .PARAMETER FreeSpace
    The amount of free space available on the drive (e.g., "15 GB").

    .PARAMETER TotalSize
    The total size of the drive (e.g., "500 GB").

    .PARAMETER ThresholdPercent
    (Optional) The threshold percentage for triggering a warning. Defaults to 10%.

    .PARAMETER TopConsumers
    (Optional) A list of the top space-consuming directories or files on the drive.
    Each entry should be a hashtable with `Path` and `Size` keys.

    .PARAMETER MonitoringUrl
    (Optional) A URL to view detailed monitoring information about the server or drive.

    .PARAMETER ActionUrl
    (Optional) A URL to trigger an action, such as running a cleanup script.

    .PARAMETER ActionBody
    (Optional) The body of the request sent to the `ActionUrl`. Defaults to a JSON payload with server and drive details.

    .PARAMETER ActionTitle
    (Optional) The title of the action button. Defaults to "Take Action".

    .PARAMETER AcknowledgeUrl
    (Optional) A URL to acknowledge the alert.

    .PARAMETER AcknowledgeBody
    (Optional) The body of the request sent to the `AcknowledgeUrl`. Defaults to a JSON payload with alert and server details.

    .EXAMPLE
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

    .EXAMPLE
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

    .NOTES
    This function is part of the Actionable Messages module and is used to create Adaptive Cards for disk space alerts.
    The card can be exported and sent via email or other communication channels.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OriginatorId,

        [Parameter(Mandatory = $true)]
        [string]$Server,

        [Parameter(Mandatory = $true)]
        [string]$Drive,

        [Parameter(Mandatory = $true)]
        [string]$FreeSpace,

        [Parameter(Mandatory = $true)]
        [string]$TotalSize,

        [Parameter(Mandatory = $false)]
        [int]$ThresholdPercent = 10,

        [Parameter(Mandatory = $false)]
        [hashtable[]]$TopConsumers,

        [Parameter(Mandatory = $false)]
        [string]$MonitoringUrl,

        [Parameter(Mandatory = $false)]
        [string]$ActionUrl,

        [Parameter(Mandatory = $false)]
        [string]$ActionBody = "{`"server`": `"$Server`", `"action`": `"cleanup_disk`", `"drive`": `"$Drive`"}",

        [Parameter(Mandatory = $false)]
        [string]$ActionTitle = "Take Action",

        [Parameter(Mandatory = $false)]
        [string]$AcknowledgeUrl,

        [Parameter(Mandatory = $false)]
        [string]$AcknowledgeBody = "{`"alertId`": `"DSK-$(Get-Date -Format 'yyyy-MM-dd')`", `"server`": `"$Server`"}"
    )

    # Calculate FreeSpacePercent
    $freeSpaceBytes = [double]($FreeSpace -replace '[^\d.]', '') * 1GB
    $totalSizeBytes = [double]($TotalSize -replace '[^\d.]', '') * 1GB
    $FreeSpacePercent = [math]::Round(($freeSpaceBytes / $totalSizeBytes) * 100)

    # Create a new card
    $card = New-AMCard -OriginatorId $OriginatorId -Version "1.0"

    # Determine severity
    $severityColor = if ($FreeSpacePercent -lt 5) { "Attention" } elseif ($FreeSpacePercent -lt $ThresholdPercent) { "Warning" } else { "Default" }

    # Add header with alert severity color
    $header = New-AMTextBlock -Text "Disk Space Alert: $Server" -Size "Large" -Weight "Bolder" -Color $severityColor
    Add-AMElement -Card $card -Element $header

    # Add server details
    $serverContainer = New-AMContainer -Id "server-details" -Style "emphasis" -Padding "Default"
    Add-AMElement -Card $card -Element $serverContainer

    # Add server facts
    $serverFacts = @(
        New-AMFact -Title "Server" -Value $Server
        New-AMFact -Title "Drive" -Value $Drive
        New-AMFact -Title "Total Size" -Value $TotalSize
        New-AMFact -Title "Free Space" -Value "$FreeSpace ($FreeSpacePercent%)"
        New-AMFact -Title "Threshold" -Value "$ThresholdPercent%"
        New-AMFact -Title "Alert Time" -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    )

    $factSet = New-AMFactSet -Facts $serverFacts
    Add-AMElement -Card $card -Element $factSet -ContainerId "server-details"

    # Add description
    $descText = "The disk is critically low on free space. This may impact system performance and availability."
    if ($FreeSpacePercent -lt 5) {
        $descText += " Immediate action is required!"
    }
    elseif ($FreeSpacePercent -lt $ThresholdPercent) {
        $descText += " Please take action soon."
    }

    $description = New-AMTextBlock -Text $descText -Wrap $true -Color $severityColor
    Add-AMElement -Card $card -Element $description

    # Add space usage visualization
    $spaceUsageHeader = New-AMTextBlock -Text "Space Usage" -Weight "Bolder"
    Add-AMElement -Card $card -Element $spaceUsageHeader

    $usedPercent = 100 - $FreeSpacePercent
    $filledBoxes = [Math]::Floor($usedPercent / 5)
    $emptyBoxes = 20 - $filledBoxes

    $spaceUsageText = "["
    $spaceUsageText += "&#9632;" * $filledBoxes
    $spaceUsageText += "&#9633;" * $emptyBoxes
    $spaceUsageText += "] $usedPercent% Used"

    $spaceUsage = New-AMTextBlock -Text $spaceUsageText -Color $severityColor
    Add-AMElement -Card $card -Element $spaceUsage

    # Add top consumers if provided
    if ($TopConsumers -and $TopConsumers.Count -gt 0) {
        $topConsumersContainer = New-AMContainer -Id "top-consumers" -Style "default" -Padding "Default"
        Add-AMElement -Card $card -Element $topConsumersContainer

        $topConsumersHeader = New-AMTextBlock -Text "Top Space Consumers" -Weight "Bolder"
        Add-AMElement -Card $card -Element $topConsumersHeader -ContainerId "top-consumers"

        $consumerFacts = @()
        foreach ($consumer in $TopConsumers) {
            $consumerFacts += New-AMFact -Title $consumer.Path -Value $consumer.Size
        }

        $consumerFactSet = New-AMFactSet -Facts $consumerFacts
        Add-AMElement -Card $card -Element $consumerFactSet -ContainerId "top-consumers"
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
