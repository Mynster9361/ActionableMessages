BeforeAll {
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}
Describe 'New-AMServerMonitoringCard' {

    Context 'Parameter Validation' {
        It 'Should throw an error if mandatory parameters are not provided' {
            { New-AMServerMonitoringCard -OriginatorId $null } | Should -Throw
        }

        It 'Should not throw an error if all mandatory parameters are provided' {
            { New-AMServerMonitoringCard -OriginatorId 'monitoring-system' -Server 'DCSRV01' -Status 'Offline' } | Should -Not -Throw
        }
    }

    Context 'Card Structure' {
        It 'Should create a card with the correct header' {
            $card = New-AMServerMonitoringCard -OriginatorId 'monitoring-system' -Server 'DCSRV01' -Status 'Offline'
            $card.Body | Where-Object { $_.Text -eq 'Server Offline : DCSRV01' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include server details in the facts section' {
            $card = New-AMServerMonitoringCard -OriginatorId 'monitoring-system' -Server 'DCSRV01' -Status 'Offline' -ServerType 'Domain Controller' -IPAddress '10.0.0.10' -Location 'Data Center 1'
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Server' -and $_.Value -eq 'DCSRV01 (Domain Controller)' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Status' -and $_.Value -eq 'OFFLINE' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'IP Address' -and $_.Value -eq '10.0.0.10' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Location' -and $_.Value -eq 'Data Center 1' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include test results if provided' {
            $testResults = @(
                @{ Name = 'ICMP Ping'; Result = 'Failed' },
                @{ Name = 'TCP Port 389 (LDAP)'; Result = 'Failed' }
            )
            $card = New-AMServerMonitoringCard -OriginatorId 'monitoring-system' -Server 'DCSRV01' -Status 'Offline' -TestResults $testResults
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'ICMP Ping' -and $_.Value -eq 'Failed' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'TCP Port 389 (LDAP)' -and $_.Value -eq 'Failed' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include affected systems if provided' {
            $affectedSystems = @('WEBSRV01', 'WEBSRV02', 'APPSRV01')
            $card = New-AMServerMonitoringCard -OriginatorId 'monitoring-system' -Server 'DCSRV01' -Status 'Offline' -AffectedSystems $affectedSystems
            $card.Body.items | Where-Object { $_.Text -eq 'Affected Systems' } | Should -Not -BeNullOrEmpty
            $card.Body.items | Where-Object { $_.Text -eq 'WEBSRV01, WEBSRV02, APPSRV01' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include actions if URLs are provided' {
            $card = New-AMServerMonitoringCard -OriginatorId 'monitoring-system' -Server 'DCSRV01' -Status 'Offline' `
                -MonitoringUrl 'https://example.com/monitoring' -ActionUrl 'https://example.com/restart' -AcknowledgeUrl 'https://example.com/acknowledge'
            $card.body.actions | Where-Object { $_.Title -eq 'View Details' -and $_.Url -eq 'https://example.com/monitoring' } | Should -Not -BeNullOrEmpty
            $card.body.actions | Where-Object { $_.Title -eq 'Restart Server' -and $_.Url -eq 'https://example.com/restart' } | Should -Not -BeNullOrEmpty
            $card.body.actions | Where-Object { $_.Title -eq 'Acknowledge' -and $_.Url -eq 'https://example.com/acknowledge' } | Should -Not -BeNullOrEmpty
        }
    }
}