BeforeAll {
    # Import the module under test
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}

Describe "Action Functions" {
    Context "New-AMOpenUrlAction" {
        It "Creates an OpenUrl action with required parameters" {
            $title = "Visit Website"
            $url = "https://example.com"

            $action = New-AMOpenUrlAction -Title $title -Url $url

            $action.type | Should -Be "Action.OpenUrl"
            $action.title | Should -Be $title
            $action.url | Should -Be $url
            $action.id | Should -Not -BeNullOrEmpty
        }

        It "Creates an OpenUrl action with custom ID" {
            $customId = "custom-action-id"

            $action = New-AMOpenUrlAction -Title "Test" -Url "https://example.com" -Id $customId

            $action.id | Should -Be $customId
        }

        It "Creates an OpenUrl action with tooltip" {
            $tooltip = "Click to visit our website"

            $action = New-AMOpenUrlAction -Title "Test" -Url "https://example.com" -Tooltip $tooltip

            $action.tooltip | Should -Be $tooltip
        }
    }

    Context "New-AMExecuteAction" {
        It "Creates an Execute action with required parameters" {
            $title = "Submit"
            $verb = "POST"

            $action = New-AMExecuteAction -Title $title -Verb $verb

            $action.type | Should -Be "Action.Http"
            $action.title | Should -Be $title
            $action.method | Should -Be $verb
        }

        It "Creates an Execute action with URL" {
            $url = "https://api.example.com/submit"

            $action = New-AMExecuteAction -Title "Submit" -Verb "POST" -Url $url

            $action.url | Should -Be $url
        }

        It "Creates an Execute action with body" {
            $body = '{"key": "value"}'

            $action = New-AMExecuteAction -Title "Submit" -Verb "POST" -Body $body

            $action.body | Should -Be $body
        }

        It "Creates an Execute action with data object" {
            $data = @{
                key1 = "value1"
                key2 = "value2"
            }

            $action = New-AMExecuteAction -Title "Submit" -Verb "POST" -Data $data

            $action.data.key1 | Should -Be "value1"
            $action.data.key2 | Should -Be "value2"
        }
    }

    Context "New-AMToggleVisibilityAction" {
        It "Creates a ToggleVisibility action with required parameters" {
            $title = "Show Details"
            $targetElements = @("element1", "element2")

            $action = New-AMToggleVisibilityAction -Title $title -TargetElements $targetElements

            $action.type | Should -Be "Action.ToggleVisibility"
            $action.title | Should -Be $title
            $action.targetElements | Should -Be $targetElements
        }

        It "Creates a ToggleVisibility action with custom ID" {
            $customId = "toggle-action-id"

            $action = New-AMToggleVisibilityAction -Title "Toggle" -TargetElements @("element1") -Id $customId

            $action.id | Should -Be $customId
        }
    }
}