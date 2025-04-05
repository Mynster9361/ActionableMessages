BeforeAll {
    # Import the module under test
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}

Describe "Core Functions" {
    Context "New-AMCard" {
        It "Creates a new card with specified OriginatorId" {
            $testId = "1234"
            $card = New-AMCard -OriginatorId $testId

            $card | Should -Not -BeNullOrEmpty
            $card.originator | Should -Be $testId
            $card.'@type' | Should -Be "AdaptiveCard"
            $card.version | Should -Be "1.0" # Default version
            $card.hideOriginalBody | Should -Be $true # Default value
            $card.body | Should -Be $null
            $card.body.Count | Should -Be 0
        }

        It "Creates a card with specified version" {
            $card = New-AMCard -OriginatorId "test-id" -Version "1.0"
            $card.version | Should -Be "1.0"
        }

        It "Creates a card with hideOriginalBody set to false" {
            $card = New-AMCard -OriginatorId "test-id" -HideOriginalBody $false
            $card.hideOriginalBody | Should -Be $false
        }
    }

    Context "Add-AMElement" {
        It "Adds an element to the card body" {
            $card = New-AMCard -OriginatorId "test-id"
            $text = New-AMTextBlock -Text "Test Text"

            Add-AMElement -Card $card -Element $text

            $card.body.Count | Should -Be 1
            $card.body[0].type | Should -Be "TextBlock"
            $card.body[0].text | Should -Be "Test Text"
        }

        It "Adds an element to a container" {
            $card = New-AMCard -OriginatorId "test-id"
            $container = New-AMContainer -Id "test-container"
            Add-AMElement -Card $card -Element $container

            $text = New-AMTextBlock -Text "Container Text"
            Add-AMElement -Card $card -Element $text -ContainerId "test-container"

            $card.body.Count | Should -Be 1
            $card.body[0].type | Should -Be "Container"
            $card.body[0].items.Count | Should -Be 1
            $card.body[0].items[0].type | Should -Be "TextBlock"
            $card.body[0].items[0].text | Should -Be "Container Text"
        }

        It "Throws an error when container ID doesn't exist" {
            $card = New-AMCard -OriginatorId "test-id"
            $text = New-AMTextBlock -Text "Test Text"

            # Use try/catch to properly test the exception
            $errorThrown = $false
            try {
                Add-AMElement -Card $card -Element $text -ContainerId "non-existent"
            }
            catch {
                $errorThrown = $true
                $_.Exception.Message | Should -Match "Container with ID 'non-existent' not found"
            }
            $errorThrown | Should -BeTrue
        }
    }

    Context "Export-AMCard" {
        It "Exports a card as JSON" {
            $card = New-AMCard -OriginatorId "test-id"
            Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Test")

            $json = Export-AMCard -Card $card

            $json | Should -Not -BeNullOrEmpty
            $json | Should -BeOfType [System.String]
            $json | Should -Match '"@type":\s*"AdaptiveCard"'
            $json | Should -Match '"originator":\s*"test-id"'
        }

        It "Exports compressed JSON when specified" {
            $card = New-AMCard -OriginatorId "test-id"

            $standardJson = Export-AMCard -Card $card
            $compressedJson = Export-AMCard -Card $card -Compress

            $compressedJson.Length | Should -BeLessThan $standardJson.Length
        }

        It "Saves JSON to a file when Path is specified" {
            # Note: Skipped to avoid file system dependencies in unit tests
            # A proper implementation would use mock for Out-File
            $card = New-AMCard -OriginatorId "test-id"
            $tempPath = [System.IO.Path]::GetTempFileName()

            Export-AMCard -Card $card -Path $tempPath

            Test-Path $tempPath | Should -Be $true
            Get-Content $tempPath | Should -Not -BeNullOrEmpty

            # Cleanup
            Remove-Item $tempPath -ErrorAction SilentlyContinue
        }
    }

    Context "Export-AMCardForEmail" {
        It "Creates HTML email content with embedded card" {
            $card = New-AMCard -OriginatorId "test-id"
            Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Test Email")

            $html = Export-AMCardForEmail -Card $card -Subject "Test Subject"

            $html | Should -Not -BeNullOrEmpty
            $html | Should -Match "<html"
            $html | Should -Match "application/adaptivecard\+json"
        }

        It "Includes custom fallback text when specified" {
            $card = New-AMCard -OriginatorId "test-id"
            $fallback = "Custom fallback message for non-supporting clients"

            $html = Export-AMCardForEmail -Card $card -FallbackText $fallback

            $html | Should -Match $fallback
        }

        It "Creates Graph API parameters when requested" {
            $card = New-AMCard -OriginatorId "test-id"
            $recipient = "test@example.com"

            $params = Export-AMCardForEmail -Card $card -Subject "Test" -ToRecipients $recipient -CreateGraphParams

            $params | Should -Not -BeNullOrEmpty
            $params.message | Should -Not -BeNullOrEmpty
            $params.message.subject | Should -Be "Test"
            $params.message.toRecipients[0].emailAddress.address | Should -Be $recipient
        }
    }
}