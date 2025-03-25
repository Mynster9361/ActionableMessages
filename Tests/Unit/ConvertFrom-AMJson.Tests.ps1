Describe "ConvertFrom-AMJson" {
    BeforeAll {
        # Import the module
        Import-Module "$PSScriptRoot\..\..\ActionableMessages.psd1" -Force

        # Sample JSON for testing
        $simpleCardJson = @'
{
  "type": "AdaptiveCard",
  "version": "1.2",
  "originator": "test-originator-id",
  "body": [
    {
      "type": "TextBlock",
      "text": "Hello World",
      "size": "Large",
      "weight": "Bolder",
      "color": "Accent"
    }
  ],
  "$schema": "http://adaptivecards.io/schemas/adaptive-card.json"
}
'@

        $complexCardJson = @'
{
  "type": "AdaptiveCard",
  "version": "1.2",
  "originator": "test-complex-id",
  "body": [
    {
      "type": "TextBlock",
      "text": "Test Card",
      "size": "Large"
    },
    {
      "type": "Image",
      "url": "https://example.com/image.png",
      "altText": "Test Image"
    },
    {
      "id": "container1",
      "type": "Container",
      "style": "emphasis",
      "items": [
        {
          "type": "TextBlock",
          "text": "Inside Container"
        },
        {
          "type": "Input.Text",
          "id": "name",
          "label": "Name",
          "placeholder": "Enter your name"
        }
      ]
    },
    {
      "type": "ActionSet",
      "id": "actions1",
      "actions": [
        {
          "type": "Action.OpenUrl",
          "title": "Open Website",
          "url": "https://example.com"
        }
      ]
    }
  ],
  "$schema": "http://adaptivecards.io/schemas/adaptive-card.json"
}
'@
    }

    Context "Function behavior" {
        It "Should exist" {
            Get-Command ConvertFrom-AMJson | Should -Not -BeNullOrEmpty
        }

        It "Should accept input from pipeline" {
            $simpleCardJson | ConvertFrom-AMJson | Should -Not -BeNullOrEmpty
        }

        It "Should handle file output with -OutputPath" {
            $tempFile = [System.IO.Path]::GetTempFileName()
            ConvertFrom-AMJson -Json $simpleCardJson -OutputPath $tempFile
            Test-Path $tempFile | Should -BeTrue
            Remove-Item $tempFile -Force
        }
    }

    Context "Simple card conversion" {
        BeforeAll {
            $result = ConvertFrom-AMJson -Json $simpleCardJson
        }

        It "Should generate script with card creation" {
            $result | Should -Match "New-AMCard -OriginatorId `"test-originator-id`" -Version `"1.2`""
        }

        It "Should include text block with correct properties" {
            $result | Should -Match "New-AMTextBlock -Text `"Hello World`" -Size `"Large`" -Weight `"Bolder`" -Color `"Accent`""
        }

        It "Should include Add-AMElement statement" {
            # Use a more flexible pattern that doesn't rely on exact variable naming
            $result | Should -Match "Add-AMElement -Card"
        }

        It "Should include export command" {
            $result | Should -Match "Export-AMCard -Card"
        }
    }

    Context "Complex card conversion" {
        BeforeAll {
            $result = ConvertFrom-AMJson -Json $complexCardJson
        }

        It "Should generate script with container" {
            $result | Should -Match "New-AMContainer -Id `"container1`" -Style `"emphasis`""
        }

        It "Should handle nested elements properly" {
            # Check if we have an Add-AMElement with a ContainerId
            $result | Should -Match "Add-AMElement.*-ContainerId `"container1`""
        }

        It "Should process input elements" {
            $result | Should -Match "New-AMTextInput -Id `"name`" -Label `"Name`" -Placeholder `"Enter your name`""
        }

        It "Should process action elements" {
            $result | Should -Match "New-AMOpenUrlAction -Title `"Open Website`" -Url `"https://example.com`""
            $result | Should -Match "New-AMActionSet -Id `"actions1`""
        }
    }

    Context "Error handling" {
        It "Should throw error on invalid JSON" {
            { ConvertFrom-AMJson -Json "This is not JSON" -ErrorAction Stop } | Should -Throw
        }

        It "Should handle unsupported element types gracefully" {
            $invalidElementJson = @'
{
  "type": "AdaptiveCard",
  "version": "1.2",
  "body": [
    {
      "type": "UnsupportedType",
      "text": "This won't work"
    }
  ]
}
'@
            $result = ConvertFrom-AMJson -Json $invalidElementJson
            $result | Should -Match "Unsupported"
        }
    }

    Context "Advanced functionality tests" {
        It "Should properly handle multiple columns in a ColumnSet" {
            $columnSetJson = @'
{
  "type": "AdaptiveCard",
  "version": "1.2",
  "body": [
    {
      "type": "ColumnSet",
      "id": "columnSet1",
      "columns": [
        {
          "type": "Column",
          "width": "1",
          "items": [
            {
              "type": "TextBlock",
              "text": "Column 1"
            }
          ]
        },
        {
          "type": "Column",
          "width": "2",
          "items": [
            {
              "type": "TextBlock",
              "text": "Column 2"
            }
          ]
        }
      ]
    }
  ]
}
'@
            $result = ConvertFrom-AMJson -Json $columnSetJson
            $result | Should -Match "New-AMColumnSet -Id `"columnSet1`""
            $result | Should -Match "New-AMColumn -Width `"1`""
            $result | Should -Match "New-AMColumn -Width `"2`""
        }

        It "Should properly handle ImageSet" {
            $imageSetJson = @'
{
  "type": "AdaptiveCard",
  "version": "1.2",
  "body": [
    {
      "type": "ImageSet",
      "images": [
        {
          "url": "https://example.com/image1.png"
        },
        {
          "url": "https://example.com/image2.png"
        }
      ]
    }
  ]
}
'@
            $result = ConvertFrom-AMJson -Json $imageSetJson
            $result | Should -Match '\$images\s*=\s*@\('
            $result | Should -Match "https://example.com/image1.png"
            $result | Should -Match "New-AMImageSet -Images"
        }

        It "Should properly handle FactSet" {
            $factSetJson = @'
{
  "type": "AdaptiveCard",
  "version": "1.2",
  "body": [
    {
      "type": "FactSet",
      "facts": [
        {
          "title": "Fact 1",
          "value": "Value 1"
        },
        {
          "title": "Fact 2",
          "value": "Value 2"
        }
      ]
    }
  ]
}
'@
            $result = ConvertFrom-AMJson -Json $factSetJson
            $result | Should -Match '\$facts\s*=\s*@\('
            $result | Should -Match "New-AMFact -Title `"Fact 1`""
            $result | Should -Match "New-AMFactSet -Facts"
        }

        It "Should properly handle ChoiceSetInput" {
            $choiceSetJson = @'
{
  "type": "AdaptiveCard",
  "version": "1.2",
  "body": [
    {
      "type": "Input.ChoiceSet",
      "id": "choices",
      "label": "Pick one",
      "isMultiSelect": false,
      "choices": [
        {
          "title": "Option 1",
          "value": "1"
        },
        {
          "title": "Option 2",
          "value": "2"
        }
      ]
    }
  ]
}
'@
            $result = ConvertFrom-AMJson -Json $choiceSetJson
            $result | Should -Match '\$choices\s*=\s*@\('
            $result | Should -Match "New-AMChoice -Title `"Option 1`""
            $result | Should -Match "New-AMChoiceSetInput -Id `"choices`""
        }
    }
}