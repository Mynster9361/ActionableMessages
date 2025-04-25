BeforeAll {
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}
Describe 'New-AMITResourceRequestCard' {

    Context 'Parameter Validation' {
        It 'Should not throw an error if all mandatory parameters are provided' {
            { New-AMITResourceRequestCard -OriginatorId 'it-resource-system' -RequestHeader 'Request New Hardware' -RequestDescription 'Request description' } | Should -Not -Throw
        }
    }

    Context 'Card Structure' {
        It 'Should create a card with the correct header' {
            $card = New-AMITResourceRequestCard -OriginatorId 'it-resource-system' -RequestHeader 'Request New Hardware' -RequestDescription 'Request description'
            $card.Body | Where-Object { $_.Text -eq 'Request New Hardware' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include the request description' {
            $card = New-AMITResourceRequestCard -OriginatorId 'it-resource-system' -RequestHeader 'Request New Hardware' -RequestDescription 'Request description'
            $card.Body | Where-Object { $_.Text -eq 'Request description' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include urgency choices in the card' {
            $card = New-AMITResourceRequestCard -OriginatorId 'it-resource-system' -RequestHeader 'Request New Hardware' -RequestDescription 'Request description'
            $card.Body | Where-Object { $_.type -eq 'Input.ChoiceSet' -and $_.id -eq 'urgency' } | ForEach-Object {
                $_.Choices | Where-Object { $_.Value -eq 'critical' -and $_.Title -eq 'Critical (Required immediately)' } | Should -Not -BeNullOrEmpty
                $_.Choices | Where-Object { $_.Value -eq 'low' -and $_.Title -eq 'Low (Required within months)' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include acknowledgment message if enabled' {
            $card = New-AMITResourceRequestCard -OriginatorId 'it-resource-system' -RequestHeader 'Request New Hardware' -RequestDescription 'Request description' -Acknowledge $true
            $($card.Body | Where-Object { $_.id -eq "acknowledge-container" } | Select-Object -ExpandProperty items).text  | Should -Not -BeNullOrEmpty
        }

        It 'Should include the submit button with the correct endpoint' {
            $card = New-AMITResourceRequestCard -OriginatorId 'it-resource-system' -RequestHeader 'Request New Hardware' -RequestDescription 'Request description' -ResponseEndpoint 'https://api.example.com/resource-request'
            $card.body.actions | Where-Object { $_.Type -eq 'Action.Http' -and $_.Url -eq 'https://api.example.com/resource-request' } | Should -Not -BeNullOrEmpty
        }
    }
}