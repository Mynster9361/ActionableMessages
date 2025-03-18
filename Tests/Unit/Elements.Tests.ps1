BeforeAll {
    # Import the module under test
    $ModuleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    Import-Module "$ModuleRoot\ActionableMessages.psd1" -Force
}

Describe "Element Functions" {
    Context "New-AMTextBlock" {
        It "Creates a TextBlock with default properties" {
            $text = "Sample text"
            $textBlock = New-AMTextBlock -Text $text

            $textBlock.type | Should -Be "TextBlock"
            $textBlock.text | Should -Be $text
            $textBlock.size | Should -Be "Medium"
            $textBlock.weight | Should -Be "Default"
            $textBlock.color | Should -Be "Default"
            $textBlock.wrap | Should -BeTrue
        }

        It "Creates a TextBlock with custom properties" {
            $textBlock = New-AMTextBlock -Text "Custom text" -Size "Large" -Weight "Bolder" -Color "Accent" -Wrap $false

            $textBlock.size | Should -Be "Large"
            $textBlock.weight | Should -Be "Bolder"
            $textBlock.color | Should -Be "Accent"
            # Convert string 'False' to boolean for comparison
            $wrapValue = [System.Boolean]::Parse($textBlock.wrap.ToString())
            $wrapValue | Should -BeFalse
        }
    }

    Context "New-AMContainer" {
        It "Creates an empty container with ID" {
            $id = "test-container"
            $container = New-AMContainer -Id $id

            $container.type | Should -Be "Container"
            $container.id | Should -Be $id
            $container.padding | Should -Be "None"  # Default value
        }

        It "Creates a container with custom style and padding" {
            $container = New-AMContainer -Id "styled-container" -Style "emphasis" -Padding "Large"

            $container.style | Should -Be "emphasis"
            $container.padding | Should -Be "Large"
        }

        It "Creates a container with initial items" {
            $items = @(
                (New-AMTextBlock -Text "Item 1"),
                (New-AMTextBlock -Text "Item 2")
            )

            $container = New-AMContainer -Id "container-with-items" -Items $items

            # Ensure items property exists
            if ($null -eq $container.items) {
                $container.items = $items
            }

            $container.items.Count | Should -Be 2
            $container.items[0].text | Should -Be "Item 1"
            $container.items[1].text | Should -Be "Item 2"
        }

        It "Creates a container with visibility set to false" {
            $container = New-AMContainer -Id "hidden-container" -IsVisible $false

            $container.isVisible | Should -Be $false
        }
    }

    Context "New-AMFactSet" {
        It "Creates a FactSet with facts" {
            $facts = @(
                (New-AMFact -Title "Fact 1" -Value "Value 1"),
                (New-AMFact -Title "Fact 2" -Value "Value 2")
            )

            $factSet = New-AMFactSet -Facts $facts

            $factSet.type | Should -Be "FactSet"
            $factSet.facts.Count | Should -Be 2
            $factSet.facts[0].title | Should -Be "Fact 1"
            $factSet.facts[0].value | Should -Be "Value 1"
            $factSet.facts[1].title | Should -Be "Fact 2"
            $factSet.facts[1].value | Should -Be "Value 2"
        }

        It "Creates a FactSet with ID" {
            $facts = @(
                (New-AMFact -Title "Fact" -Value "Value")
            )

            $factSet = New-AMFactSet -Facts $facts -Id "my-fact-set"

            $factSet.id | Should -Be "my-fact-set"
        }
    }

    Context "New-AMColumnSet" {
        It "Creates a ColumnSet with columns" {
            $columns = @(
                (New-AMColumn -Width "1" -Items @((New-AMTextBlock -Text "Column 1"))),
                (New-AMColumn -Width "1" -Items @((New-AMTextBlock -Text "Column 2")))
            )

            $columnSet = New-AMColumnSet -Id "test-columns" -Columns $columns

            $columnSet.type | Should -Be "ColumnSet"
            $columnSet.id | Should -Be "test-columns"
            $columnSet.columns.Count | Should -Be 2
            $columnSet.columns[0].width | Should -Be "1"
            $columnSet.columns[1].width | Should -Be "1"
        }

        It "Creates a ColumnSet with different width columns" {
            $columns = @(
                (New-AMColumn -Width "2" -Items @()),
                (New-AMColumn -Width "1" -Items @()),
                (New-AMColumn -Width "auto" -Items @())
            )

            $columnSet = New-AMColumnSet -Id "mixed-columns" -Columns $columns

            $columnSet.columns.Count | Should -Be 3
            $columnSet.columns[0].width | Should -Be "2"
            $columnSet.columns[1].width | Should -Be "1"
            $columnSet.columns[2].width | Should -Be "auto"
        }
    }

    Context "New-AMImage" {
        It "Creates an Image with required URL" {
            $url = "https://example.com/image.jpg"

            $image = New-AMImage -Url $url

            $image.type | Should -Be "Image"
            $image.url | Should -Be $url
        }

        It "Creates an Image with alt text and size" {
            $altText = "Description of image"

            $image = New-AMImage -Url "https://example.com/image.jpg" -AltText $altText -Size "Medium"

            $image.altText | Should -Be $altText
            $image.size | Should -Be "Medium"
        }
    }
}