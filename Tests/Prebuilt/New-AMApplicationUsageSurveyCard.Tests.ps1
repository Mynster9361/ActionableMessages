BeforeAll {
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}
Describe 'New-AMApplicationUsageSurveyCard' {

    Context 'Parameter Validation' {
        It 'Should throw an error if ApplicationName is not provided' {
            { New-AMApplicationUsageSurveyCard -ApplicationName $null } | Should -Throw
        }

        It 'Should not throw an error if only mandatory parameters are provided' {
            { New-AMApplicationUsageSurveyCard -ApplicationName 'TestApp' } | Should -Not -Throw
        }
    }

    Context 'Card Structure' {
        It 'Should create a card with the correct header' {
            $card = New-AMApplicationUsageSurveyCard -ApplicationName 'TestApp'
            $card.Body | Where-Object { $_.Text -eq 'Application Usage Survey: TestApp' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include the application name in the facts section' {
            $card = New-AMApplicationUsageSurveyCard -ApplicationName 'TestApp'
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Application' -and $_.Value -eq 'TestApp' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include optional parameters in the facts section if provided' {
            $card = New-AMApplicationUsageSurveyCard -ApplicationName 'TestApp' -Version '1.0' -Vendor 'TestVendor' -LicenseCount 100 -ActiveUserCount 50
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Version' -and $_.Value -eq '1.0' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Vendor' -and $_.Value -eq 'TestVendor' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Total Licenses' -and $_.Value -eq '100' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Active Users' -and $_.Value -eq '50' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include frequency choices in the card' {
            $card = New-AMApplicationUsageSurveyCard -ApplicationName 'TestApp'
            $card.Body | Where-Object { $_.Type -eq 'Input.ChoiceSet' -and $_.Id -eq 'usage-frequency' } | ForEach-Object {
                $_.Choices | Where-Object { $_.Value -eq 'daily' -and $_.Title -eq 'Daily' } | Should -Not -BeNullOrEmpty
                $_.Choices | Where-Object { $_.Value -eq 'never' -and $_.Title -eq 'Never' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include importance choices in the card' {
            $card = New-AMApplicationUsageSurveyCard -ApplicationName 'TestApp'
            $card.Body | Where-Object { $_.Type -eq 'Input.ChoiceSet' -and $_.Id -eq 'importance-rating' } | ForEach-Object {
                $_.Choices | Where-Object { $_.Value -eq 'critical' -and $_.Title -eq 'Critical - Cannot perform job without it' } | Should -Not -BeNullOrEmpty
                $_.Choices | Where-Object { $_.Value -eq 'unnecessary' -and $_.Title -eq 'Unnecessary - Could work without it' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include the submit button with the correct endpoint' {
            $card = New-AMApplicationUsageSurveyCard -ApplicationName 'TestApp' -ResponseEndpoint 'https://api.example.com/test-endpoint'
            $card.body.actions | Where-Object { $_.type -eq 'Action.Http' -and $_.Url -eq 'https://api.example.com/test-endpoint' } | Should -Not -BeNullOrEmpty
        }
    }
}