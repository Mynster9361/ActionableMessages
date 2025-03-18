BeforeAll {
    # Import the module under test
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}

Describe "Input Functions" {
    Context "New-AMTextInput" {
        It "Creates a TextInput with required ID" {
            $id = "name-input"

            $input = New-AMTextInput -Id $id

            $input.type | Should -Be "Input.Text"
            $input.id | Should -Be $id
        }

        It "Creates a TextInput with label and placeholder" {
            $label = "Your Name"
            $placeholder = "Enter your full name"

            $input = New-AMTextInput -Id "name" -Label $label -Placeholder $placeholder

            $input.label | Should -Be $label
            $input.placeholder | Should -Be $placeholder
        }

        It "Creates a multi-line required TextInput" {
            $input = New-AMTextInput -Id "comments" -IsMultiline $true -IsRequired $true

            $input.isMultiline | Should -Be $true
            $input.isRequired | Should -Be $true
        }

        It "Creates a TextInput with default value and max length" {
            $value = "Default text"
            $maxLength = 100

            $input = New-AMTextInput -Id "description" -Value $value -MaxLength $maxLength

            $input.value | Should -Be $value
            $input.maxLength | Should -Be $maxLength
        }
    }

    Context "New-AMChoiceSetInput" {
        BeforeAll {
            $choices = @(
                (New-AMChoice -Title "Option A" -Value "A"),
                (New-AMChoice -Title "Option B" -Value "B"),
                (New-AMChoice -Title "Option C" -Value "C")
            )
        }

        It "Creates a ChoiceSetInput with required parameters" {
            $id = "options"

            $input = New-AMChoiceSetInput -Id $id -Choices $choices

            $input.type | Should -Be "Input.ChoiceSet"
            $input.id | Should -Be $id
            $input.choices.Count | Should -Be 3
            $input.choices[0].title | Should -Be "Option A"
            $input.choices[0].value | Should -Be "A"
        }

        It "Creates a multi-select ChoiceSetInput" {
            $input = New-AMChoiceSetInput -Id "options" -Choices $choices -IsMultiSelect $true

            $input.isMultiSelect | Should -Be $true
        }

        It "Creates an expanded style ChoiceSetInput" {
            $input = New-AMChoiceSetInput -Id "options" -Choices $choices -Style "expanded"

            $input.style | Should -Be "expanded"
        }

        It "Creates a ChoiceSetInput with default value" {
            $value = "B"

            $input = New-AMChoiceSetInput -Id "options" -Choices $choices -Value $value

            $input.value | Should -Be $value
        }
    }

    Context "New-AMDateInput" {
        It "Creates a DateInput with required parameters" {
            $id = "eventDate"
            $label = "Event Date"

            $input = New-AMDateInput -Id $id -Label $label

            $input.type | Should -Be "Input.Date"
            $input.id | Should -Be $id
            $input.label | Should -Be $label
            $input.value | Should -Not -BeNullOrEmpty
        }

        It "Creates a DateInput with specific value" {
            $value = "2025-12-31"

            $input = New-AMDateInput -Id "date" -Label "Date" -Value $value

            $input.value | Should -Be $value
        }

        It "Creates a DateInput with min and max constraints" {
            $min = "2023-01-01"
            $max = "2023-12-31"

            $input = New-AMDateInput -Id "date" -Label "Date" -Min $min -Max $max

            $input.min | Should -Be $min
            $input.max | Should -Be $max
        }
    }
}