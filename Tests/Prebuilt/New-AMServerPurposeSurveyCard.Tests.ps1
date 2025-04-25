BeforeAll {
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}
Describe 'New-AMServerPurposeSurveyCard' {

    Context 'Parameter Validation' {
        It 'Should throw an error if mandatory parameters are not provided' {
            { New-AMServerPurposeSurveyCard -ServerName $null } | Should -Throw
        }

        It 'Should not throw an error if all mandatory parameters are provided' {
            { New-AMServerPurposeSurveyCard -OriginatorId 'server-survey-system' -ServerName 'SVR-APP-001' } | Should -Not -Throw
        }
    }

    Context 'Card Structure' {
        It 'Should create a card with the correct header' {
            $card = New-AMServerPurposeSurveyCard -OriginatorId 'server-survey-system' -ServerName 'SVR-APP-001'
            $card.Body | Where-Object { $_.Text -eq 'Server Information Survey' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include server details in the facts section' {
            $card = New-AMServerPurposeSurveyCard -OriginatorId 'server-survey-system' -ServerName 'SVR-APP-001' -IPAddress '10.0.2.15' -OperatingSystem 'Windows Server 2019' -CreationDate (Get-Date).AddYears(-2) -TicketNumber 'SRV-2023-002'
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Server Name' -and $_.Value -eq 'SVR-APP-001' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'IP Address' -and $_.Value -eq '10.0.2.15' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Operating System' -and $_.Value -eq 'Windows Server 2019' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Creation Date' -and $_.Value -eq (Get-Date (Get-Date).AddYears(-2) -Format "yyyy-MM-dd") } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Ticket Number' -and $_.Value -eq 'SRV-2023-002' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include detected services if provided' {
            $detectedServices = @('IIS', 'SQL Server Express', 'Custom Application Service')
            $card = New-AMServerPurposeSurveyCard -OriginatorId 'server-survey-system' -ServerName 'SVR-APP-001' -DetectedServices $detectedServices
            $card.Body.items | Where-Object { $_.Text -eq 'Detected Services' } | Should -Not -BeNullOrEmpty
            $card.Body.items | Where-Object { $_.Text -eq "• IIS`n• SQL Server Express`n• Custom Application Service" } | Should -Not -BeNullOrEmpty
        }

        It 'Should include purpose choices in the card' {
            $card = New-AMServerPurposeSurveyCard -OriginatorId 'server-survey-system' -ServerName 'SVR-APP-001'
            $card.Body | Where-Object { $_.Type -eq 'Input.ChoiceSet' -and $_.Id -eq 'server-purpose' } | ForEach-Object {
                $_.Choices | Where-Object { $_.Value -eq 'application' -and $_.Title -eq 'Application Server' } | Should -Not -BeNullOrEmpty
                $_.Choices | Where-Object { $_.Value -eq 'other' -and $_.Title -eq 'Other (please specify)' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include criticality choices in the card' {
            $card = New-AMServerPurposeSurveyCard -OriginatorId 'server-survey-system' -ServerName 'SVR-APP-001'
            $card.Body | Where-Object { $_.Type -eq 'Input.ChoiceSet' -and $_.Id -eq 'business-criticality' } | ForEach-Object {
                $_.Choices | Where-Object { $_.Value -eq 'critical' -and $_.Title -eq 'Mission Critical (Immediate business impact if down)' } | Should -Not -BeNullOrEmpty
                $_.Choices | Where-Object { $_.Value -eq 'low' -and $_.Title -eq 'Low (Minimal impact)' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include maintenance choices in the card' {
            $card = New-AMServerPurposeSurveyCard -OriginatorId 'server-survey-system' -ServerName 'SVR-APP-001'
            $card.Body | Where-Object { $_.Type -eq 'Input.ChoiceSet' -and $_.Id -eq 'maintenance-window' } | ForEach-Object {
                $_.Choices | Where-Object { $_.Value -eq 'weekends' -and $_.Title -eq 'Weekends only' } | Should -Not -BeNullOrEmpty
                $_.Choices | Where-Object { $_.Value -eq 'special' -and $_.Title -eq 'Requires special coordination' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include the submit button with the correct endpoint' {
            $card = New-AMServerPurposeSurveyCard -OriginatorId 'server-survey-system' -ServerName 'SVR-APP-001' -ResponseEndpoint 'https://api.example.com/server-purpose'
            $card.body.actions | Where-Object { $_.Type -eq 'Action.Http' -and $_.Url -eq 'https://api.example.com/server-purpose' } | Should -Not -BeNullOrEmpty
        }
    }
}