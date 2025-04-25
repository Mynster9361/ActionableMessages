---
external help file: ActionableMessages-help.xml
Module Name: ActionableMessages
online version: https://docs.microsoft.com/en-us/outlook/actionable-messages/
https://docs.microsoft.com/en-us/graph/api/user-sendmail
https://adaptivecards.io/
schema: 2.0.0
---

# Export-AMCardForEmail

## SYNOPSIS

Exports an Adaptive Card as HTML email content for Microsoft Graph API.

## SYNTAX

```
Export-AMCardForEmail [-Card] <Hashtable> [-Subject <String>] [-FallbackText <String>]
 [-ToRecipients <String[]>] [-CreateGraphParams] [-SaveToSentItems <Boolean>]
 [<CommonParameters>]
```

## DESCRIPTION

Prepares an Adaptive Card for sending via email by embedding it in HTML with the proper format
for Microsoft Graph API.
The card is embedded as a JSON payload in a script tag with the
appropriate content type.

The function provides two main output options:

1.  HTML content only - suitable for use with any email sending mechanism
2.  Complete Microsoft Graph API parameters object - ready to use with Graph API endpoints

This enables seamless integration with either Microsoft Graph API or other email sending methods.

## EXAMPLES

### EXAMPLE 1

```
# Get HTML content for an email (for use with any email system)
$card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Hello World")
$htmlContent = Export-AMCardForEmail -Card $card
```

# Send using standard Send-MailMessage cmdlet

```
Send-MailMessage -To "recipient@example.com" -From "sender@example.com" \`
    -Subject "Adaptive Card Test" -Body $htmlContent -BodyAsHtml \`
    -SmtpServer "smtp.office365.com"
```

### EXAMPLE 2

```
# Get complete Graph API parameters for sending an email
$card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Hello World")
$params = Export-AMCardForEmail -Card $card -Subject "Important Notification" `
    -ToRecipients "user@example.com" -CreateGraphParams
```

# Send via Microsoft Graph

```
Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/me/sendMail" -Body $params
```

### EXAMPLE 3

```
# Sending to multiple recipients with Graph API
$card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Team Meeting Reminder" -Size "Large")
```

# Add action buttons

```
$acceptAction = New-AMOpenUrlAction -Title "Accept" -Url "https://teams.microsoft.com/meeting/accept"
$declineAction = New-AMOpenUrlAction -Title "Decline" -Url "https://teams.microsoft.com/meeting/decline"
$actionSet = New-AMActionSet -Actions @($acceptAction, $declineAction)
Add-AMElement -Card $card -Element $actionSet
```

# Create and send email to multiple recipients

```
$recipients = @("team.member1@example.com", "team.member2@example.com", "team.lead@example.com")
$params = Export-AMCardForEmail -Card $card -Subject "Team Meeting - Action Required" \`
-ToRecipients $recipients -CreateGraphParams
```

# Send using Microsoft Graph SDK

```
Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/me/sendMail" -Body $params
```

## PARAMETERS

### -Card

The Adaptive Card object to embed in the email.
This should be a hashtable created using
New-AMCard and populated with elements using Add-AMElement.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Subject

Optional email subject line.
Default is "Adaptive Card Notification".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Adaptive Card Notification
Accept pipeline input: False
Accept wildcard characters: False
```

### -FallbackText

Optional text to show in email clients that don't support Adaptive Cards.
Default is "This email contains an Adaptive Card.
Please use Outlook to view it."

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: This email contains an Adaptive Card. Please use Outlook to view it.
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToRecipients

Optional array of email addresses to send to.
Required if CreateGraphParams is specified.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateGraphParams

If specified, returns a complete Microsoft Graph API parameters object instead of just the HTML content.
This object can be directly used with Invoke-MgGraphRequest or other Graph API methods.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SaveToSentItems

When used with -CreateGraphParams, controls whether the sent message is saved to Sent Items.
Default is $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Collections.Hashtable

### An Adaptive Card object created using New-AMCard and populated with elements.

## OUTPUTS

### System.String or System.Collections.Hashtable

### Returns either HTML content (default) or a complete Graph API parameters object (with -CreateGraphParams).

## NOTES

This function creates HTML that embeds an Adaptive Card for use with Microsoft Graph API or other email systems.
For the Adaptive Card to render correctly, the recipient must be using Outlook.

Adaptive Cards in emails are rendered by Outlook clients (desktop, web, and mobile).
Other email
clients will display the fallback text instead.

When using with Microsoft Graph API, you will need appropriate authentication and permissions:

- Mail.Send permission for sending from your own mailbox
- Mail.Send.Shared for sending from a shared or delegated mailbox

## RELATED LINKS

[https://docs.microsoft.com/en-us/outlook/actionable-messages/
https://docs.microsoft.com/en-us/graph/api/user-sendmail
https://adaptivecards.io/](https://docs.microsoft.com/en-us/outlook/actionable-messages/
https://docs.microsoft.com/en-us/graph/api/user-sendmail
https://adaptivecards.io/)

[https://docs.microsoft.com/en-us/outlook/actionable-messages/
https://docs.microsoft.com/en-us/graph/api/user-sendmail
https://adaptivecards.io/]()
