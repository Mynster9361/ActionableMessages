BeforeAll {
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}
Describe 'New-AMServiceAlertCard' {

    Context 'Parameter Validation' {
        It 'Should throw an error if mandatory parameters are not provided' {
            { New-AMServiceAlertCard -OriginatorId $null } | Should -Throw
        }

        It 'Should not throw an error if all mandatory parameters are provided' {
            { New-AMServiceAlertCard -OriginatorId 'service-monitoring-app' -Server 'WEBSRV03' -ServiceName 'W3SVC' -ServiceDisplayName 'World Wide Web Publishing Service' -Status 'Stopped' } | Should -Not -Throw
        }
    }

    Context 'Card Structure' {
        It 'Should create a card with the correct header' {
            $card = New-AMServiceAlertCard -OriginatorId 'service-monitoring-app' -Server 'WEBSRV03' -ServiceName 'W3SVC' -ServiceDisplayName 'World Wide Web Publishing Service' -Status 'Stopped'
            $card.Body | Where-Object { $_.Text -eq 'Service Failure Alert' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include service details in the facts section' {
            $card = New-AMServiceAlertCard -OriginatorId 'service-monitoring-app' -Server 'WEBSRV03' -ServiceName 'W3SVC' -ServiceDisplayName 'World Wide Web Publishing Service' -Status 'Stopped' -DownSince '2023-04-01 14:00:00'
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Server' -and $_.Value -eq 'WEBSRV03' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Service' -and $_.Value -eq 'World Wide Web Publishing Service (W3SVC)' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Status' -and $_.Value -eq 'Stopped' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Since' -and $_.Value -eq '2023-04-01 14:00:00' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include recent events if provided' {
            $recentEvents = @(
                "System Error #1001: The W3SVC service terminated unexpectedly (Time: 14:32:45)",
                "Application Error #5002: ASP.NET Runtime failure in worker process (Time: 14:32:38)"
            )
            $card = New-AMServiceAlertCard -OriginatorId 'service-monitoring-app' -Server 'WEBSRV03' -ServiceName 'W3SVC' -ServiceDisplayName 'World Wide Web Publishing Service' -Status 'Stopped' -RecentEvents $recentEvents
            $card.Body.items | Where-Object { $_.Text -eq 'Recent Event Logs' } | Should -Not -BeNullOrEmpty
            $card.Body.items | Where-Object { $_.Text -eq 'System Error #1001: The W3SVC service terminated unexpectedly (Time: 14:32:45)' } | Should -Not -BeNullOrEmpty
            $card.Body.items | Where-Object { $_.Text -eq 'Application Error #5002: ASP.NET Runtime failure in worker process (Time: 14:32:38)' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include actions if URLs are provided' {
            $card = New-AMServiceAlertCard -OriginatorId 'service-monitoring-app' -Server 'WEBSRV03' -ServiceName 'W3SVC' -ServiceDisplayName 'World Wide Web Publishing Service' -Status 'Stopped' `
                -MonitoringUrl 'https://monitoring.example.com/service-status' -ActionUrl 'https://monitoring.example.com/restart-service' -AcknowledgeUrl 'https://monitoring.example.com/acknowledge-alert'
            $card.body.actions | Where-Object { $_.Title -eq 'View Details' -and $_.Url -eq 'https://monitoring.example.com/service-status' } | Should -Not -BeNullOrEmpty
            $card.body.actions | Where-Object { $_.Title -eq 'Restart Service' -and $_.Url -eq 'https://monitoring.example.com/restart-service' } | Should -Not -BeNullOrEmpty
            $card.body.actions | Where-Object { $_.Title -eq 'Acknowledge' -and $_.Url -eq 'https://monitoring.example.com/acknowledge-alert' } | Should -Not -BeNullOrEmpty
        }
    }
}