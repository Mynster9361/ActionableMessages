BeforeAll {
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}
Describe 'New-AMApprovalCard' {

    Context 'Parameter Validation' {
        It 'Should throw an error if mandatory parameters are not provided' {
            { New-AMApprovalCard -Title $null } | Should -Throw
        }

        It 'Should not throw an error if all mandatory parameters are provided' {
            { New-AMApprovalCard -Title 'Approval Request' -RequestID 'REQ-001' -Requester 'John Doe' } | Should -Not -Throw
        }
    }

    Context 'Card Structure' {
        It 'Should create a card with the correct title' {
            $card = New-AMApprovalCard -Title 'Approval Request' -RequestID 'REQ-001' -Requester 'John Doe'
            $card.Body | Where-Object { $_.Text -eq 'Approval Request' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include the requester and request ID in the facts section' {
            $card = New-AMApprovalCard -Title 'Approval Request' -RequestID 'REQ-001' -Requester 'John Doe'
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Requester' -and $_.Value -eq 'John Doe' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Request ID' -and $_.Value -eq 'REQ-001' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include additional details if provided' {
            $details = @(
                @{ Title = 'Amount'; Value = '$5000' },
                @{ Title = 'Department'; Value = 'Finance' }
            )
            $card = New-AMApprovalCard -Title 'Approval Request' -RequestID 'REQ-001' -Requester 'John Doe' -Details $details
            $card.Body | Where-Object { $_.Type -eq 'FactSet' } | ForEach-Object {
                $_.Facts | Where-Object { $_.Title -eq 'Amount' -and $_.Value -eq '$5000' } | Should -Not -BeNullOrEmpty
                $_.Facts | Where-Object { $_.Title -eq 'Department' -and $_.Value -eq 'Finance' } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should include description and justification if provided' {
            $card = New-AMApprovalCard -Title 'Approval Request' -RequestID 'REQ-001' -Requester 'John Doe' `
                -Description 'This is a test description.' -Justification 'This is a test justification.'

            # Locate the container with the description and justification
            $descriptionContainer = $card.Body | Where-Object { $_.id -eq 'request' }
            $descriptionContainer | Should -Not -BeNullOrEmpty

            # Validate the description and justification text
            $descriptionContainer.items | Where-Object { $_.Text -eq 'Request:' } | Should -Not -BeNullOrEmpty
            $descriptionContainer.items | Where-Object { $_.Text -eq 'This is a test description.' } | Should -Not -BeNullOrEmpty
            $descriptionContainer.items | Where-Object { $_.Text -eq 'Justification:' } | Should -Not -BeNullOrEmpty
            $descriptionContainer.items | Where-Object { $_.Text -eq 'This is a test justification.' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include the comment input field' {
            $card = New-AMApprovalCard -Title 'Approval Request' -RequestID 'REQ-001' -Requester 'John Doe'

            # Locate the container with the comment input field
            $commentContainer = $card.Body | Where-Object { $_.id -eq 'comment-container' }
            $commentContainer | Should -Not -BeNullOrEmpty

            # Validate the comment input field
            $commentContainer.items | Where-Object { $_.type -eq 'Input.Text' -and $_.id -eq 'comment' } | Should -Not -BeNullOrEmpty
        }

        It 'Should include approval and rejection actions with correct URLs' {
            $card = New-AMApprovalCard -Title 'Approval Request' -RequestID 'REQ-001' -Requester 'John Doe' `
                -ApproveUrl 'https://api.example.com/approve' -RejectUrl 'https://api.example.com/reject'
            $card.body.actions | Where-Object { $_.Title -eq 'Approve' -and $_.Url -eq 'https://api.example.com/approve' } | Should -Not -BeNullOrEmpty
            $card.body.actions | Where-Object { $_.Title -eq 'Reject' -and $_.Url -eq 'https://api.example.com/reject' } | Should -Not -BeNullOrEmpty
        }
    }
}