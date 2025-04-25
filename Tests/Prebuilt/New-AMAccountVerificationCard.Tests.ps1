BeforeAll {
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}

Describe 'New-AMAccountVerificationCard' {

    Context 'Parameter Validation' {
        It 'Should throw an error if Username is not provided' {
            { New-AMAccountVerificationCard -Username $null } | Should -Throw
        }

        It 'Should not throw an error if only mandatory parameters are provided' {
            { New-AMAccountVerificationCard -Username 'testuser' } | Should -Not -Throw
        }
    }

    Context 'Card Structure' {
        It 'Should create a card with the correct header' {
            $card = New-AMAccountVerificationCard -Username 'testuser'
            $card.Body | Where-Object { $_.Text -eq 'Account Verification Required' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include the username in the facts section' {
            $card = New-AMAccountVerificationCard -Username 'testuser'
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Username' -and $_.Value -eq 'testuser' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include optional parameters in the facts section if provided' {
            $card = New-AMAccountVerificationCard -Username 'testuser' -AccountOwner 'John Doe' -Department 'IT'
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Account Owner' -and $_.Value -eq 'John Doe' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Department' -and $_.Value -eq 'IT' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include the status choices in the card' {
            $card = New-AMAccountVerificationCard -Username 'testuser'
            $card.Body | Where-Object { $_.Type -eq 'Input.ChoiceSet' -and $_.Id -eq 'account-status' } | ForEach-Object {
                $_.Choices | Where-Object { $_.Value -eq 'keep' -and $_.Title -eq 'Account is still needed and actively used' } | Should -Not -BeNullOrEmpty
                $_.Choices | Where-Object { $_.Value -eq 'disable' -and $_.Title -eq 'Account can be disabled' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include the submit button with the correct endpoint' {
            $card = New-AMAccountVerificationCard -Username 'testuser' -ResponseEndpoint 'https://api.example.com/test-endpoint'
            $card.body.actions | Where-Object { $_.type -eq 'Action.Http' -and $_.Url -eq 'https://api.example.com/test-endpoint' } | Should -Not -BeNullOrEmpty
        }
    }
}