BeforeAll {
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}
Describe 'New-AMDiskSpaceAlertCard' {

    Context 'Parameter Validation' {
        It 'Should throw an error if mandatory parameters are not provided' {
            { New-AMDiskSpaceAlertCard -OriginatorId $null } | Should -Throw
        }

        It 'Should not throw an error if all mandatory parameters are provided' {
            { New-AMDiskSpaceAlertCard -OriginatorId 'disk-space-monitor' -Server 'SQLSRV01' -Drive 'D:' -FreeSpace '15 GB' -TotalSize '500 GB' } | Should -Not -Throw
        }
    }

    Context 'Card Structure' {
        It 'Should create a card with the correct header' {
            $card = New-AMDiskSpaceAlertCard -OriginatorId 'disk-space-monitor' -Server 'SQLSRV01' -Drive 'D:' -FreeSpace '15 GB' -TotalSize '500 GB'
            $card.Body | Where-Object { $_.Text -eq 'Disk Space Alert: SQLSRV01' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include server and drive details in the facts section' {
            $card = New-AMDiskSpaceAlertCard -OriginatorId 'disk-space-monitor' -Server 'SQLSRV01' -Drive 'D:' -FreeSpace '15 GB' -TotalSize '500 GB'
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Server' -and $_.Value -eq 'SQLSRV01' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Drive' -and $_.Value -eq 'D:' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Total Size' -and $_.Value -eq '500 GB' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Free Space' -and $_.Value -eq '15 GB (3%)' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include a description with the correct severity' {
            $card = New-AMDiskSpaceAlertCard -OriginatorId 'disk-space-monitor' -Server 'SQLSRV01' -Drive 'D:' -FreeSpace '15 GB' -TotalSize '500 GB'
            $card.Body | Where-Object { $_.Type -eq 'TextBlock' -and $_.Text -like 'The disk is critically low on free space*' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include top consumers if provided' {
            $topConsumers = @(
                @{ Path = 'D:\Backups'; Size = '250 GB' },
                @{ Path = 'D:\Logs'; Size = '120 GB' }
            )
            $card = New-AMDiskSpaceAlertCard -OriginatorId 'disk-space-monitor' -Server 'SQLSRV01' -Drive 'D:' -FreeSpace '15 GB' -TotalSize '500 GB' -TopConsumers $topConsumers
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'D:\Backups' -and $_.Value -eq '250 GB' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'D:\Logs' -and $_.Value -eq '120 GB' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include actions if URLs are provided' {
            $card = New-AMDiskSpaceAlertCard -OriginatorId 'disk-space-monitor' -Server 'SQLSRV01' -Drive 'D:' -FreeSpace '15 GB' -TotalSize '500 GB' `
                -MonitoringUrl 'https://example.com/monitoring' -ActionUrl 'https://example.com/take-action' -AcknowledgeUrl 'https://example.com/acknowledge'
            $card.body.actions | Where-Object { $_.Title -eq 'View Details' -and $_.Url -eq 'https://example.com/monitoring' } | Should -Not -BeNullOrEmpty
            $card.body.actions | Where-Object { $_.Title -eq 'Take Action' -and $_.Url -eq 'https://example.com/take-action' } | Should -Not -BeNullOrEmpty
            $card.body.actions | Where-Object { $_.Title -eq 'Acknowledge' -and $_.Url -eq 'https://example.com/acknowledge' } | Should -Not -BeNullOrEmpty
        }
    }
}