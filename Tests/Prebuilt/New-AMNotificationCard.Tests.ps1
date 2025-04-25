BeforeAll {
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}
Describe 'New-AMNotificationCard' {

    Context 'Parameter Validation' {
        It 'Should throw an error if mandatory parameters are not provided' {
            { New-AMNotificationCard -OriginatorId $null } | Should -Throw
        }

        It 'Should not throw an error if all mandatory parameters are provided' {
            { New-AMNotificationCard -OriginatorId 'notification-system' -Title 'System Notification' -Message 'Backup completed successfully.' } | Should -Not -Throw
        }
    }

    Context 'Card Structure' {
        It 'Should create a card with the correct title' {
            $card = New-AMNotificationCard -OriginatorId 'notification-system' -Title 'System Notification' -Message 'Backup completed successfully.'
            $card.Body | Where-Object { $_.Text -eq 'System Notification' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include the message in the card' {
            $card = New-AMNotificationCard -OriginatorId 'notification-system' -Title 'System Notification' -Message 'Backup completed successfully.'
            $card.Body | Where-Object { $_.Text -eq 'Backup completed successfully.' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include the severity color in the header' {
            $card = New-AMNotificationCard -OriginatorId 'notification-system' -Title 'System Notification' -Message 'Backup completed successfully.' -Severity 'Good'
            $card.Body | Where-Object { $_.Text -eq 'System Notification' -and $_.Color -eq 'Good' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include details if provided' {
            $card = New-AMNotificationCard -OriginatorId 'notification-system' -Title 'System Notification' -Message 'Backup completed successfully.' -Details 'Backup completed at 02:00 AM.'
            $card.Body.items | Where-Object { $_.Text -eq 'Backup completed at 02:00 AM.' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include a "View Details" button if DetailsUrl is provided' {
            $card = New-AMNotificationCard -OriginatorId 'notification-system' -Title 'System Notification' -Message 'Backup completed successfully.' -DetailsUrl 'https://example.com/details'
            $card.body.actions | Where-Object { $_.Title -eq 'View Details' -and $_.Url -eq 'https://example.com/details' } | Should -Not -BeNullOrEmpty
        }
    }
}