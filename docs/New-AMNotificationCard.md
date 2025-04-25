---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://adaptivecards.io/explorer/ImageSet.html
schema: 2.0.0
---

# New-AMNotificationCard

## SYNOPSIS

Creates an Adaptive Card for displaying an alert or notification.

## SYNTAX

```
New-AMNotificationCard [-OriginatorId] <String> [-Title] <String> [-Message] <String> [[-Details] <String>]
 [[-Severity] <String>] [[-DetailsUrl] <String>] [<CommonParameters>]
```

## DESCRIPTION

The \`New-AMNotificationCard\` function generates an Adaptive Card that can be used to display alerts or notifications.
The card includes a title, message, optional details, and an optional action link to open a URL for more information.

## EXAMPLES

### EXAMPLE 1

```
# Example 1: Create a simple notification card using splatting
$notificationParams = @{
    OriginatorId = "your-originator-id"
    Title        = "System Notification"
    Message      = "The nightly backup completed successfully."
    Severity     = "Good"
    Details      = "Backup completed at 02:00 AM. No errors were encountered."
    DetailsUrl   = "https://example.com/backup-report"
}


$notificationCard = New-AMNotificationCard @notificationParams
```

### EXAMPLE 2

```
# Example 2: Create a warning notification card using splatting
$warningParams = @{
    OriginatorId = "your-originator-id"
    Title        = "Disk Space Warning"
    Message      = "The C: drive is running low on space."
    Severity     = "Warning"
    Details      = "Only 5% of disk space remains."
}


$notificationCard = New-AMNotificationCard @warningParams
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

### -Title

The title of the notification.
This is displayed prominently at the top of the card.

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

### -Message

The main message or body of the notification.
This provides the primary information to the user.

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

### -Details

(Optional) Additional details about the notification.
This is displayed in a separate section of the card.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Severity

(Optional) The severity level of the notification.
Determines the color of the title.
Valid values are:

- Default
- Accent
- Good
- Warning
- Attention
  The default value is "Default".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -DetailsUrl

(Optional) A URL for more information about the notification.
If provided, a "View Details" button will be added to the card.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function is part of the Actionable Messages module and is used to create Adaptive Cards for notifications.
The card can be exported and sent via email or other communication channels.

## RELATED LINKS
