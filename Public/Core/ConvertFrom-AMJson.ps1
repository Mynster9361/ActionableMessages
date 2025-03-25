<#
.SYNOPSIS
    Converts an Adaptive Card JSON to PowerShell commands that would create it
.DESCRIPTION
    Takes an Adaptive Card JSON representation and generates the PowerShell commands
    using the ActionableMessages module functions that would recreate the card.
.PARAMETER Json
    The JSON string representing an Adaptive Card
.PARAMETER OutputPath
    If specified, the commands will be written to this file path
.PARAMETER GenerateId
    If specified, new random IDs will be generated for all elements
.EXAMPLE
    $json = Get-Content -Path "card.json" -Raw
    - -Json $json
.EXAMPLE
    $json = Get-Content -Path "card.json" -Raw
    ConvertFrom-AMJson -Json $json -OutputPath "cardCommands.ps1"
.NOTES
    Make sure to review and test the generated code before using it in production
#>
function ConvertFrom-AMJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Json,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath,

        [Parameter(Mandatory = $false)]
        [switch]$GenerateId
    )

    begin {
        # Function to generate indented script lines
        function Add-Line {
            param(
                [string]$Line,
                [int]$IndentLevel = 0
            )
            $indent = "    " * $IndentLevel
            $script:commandOutput += "$indent$Line`r`n"
        }

        # Function to generate a variable name for an element
        function Get-VariableName {
            param(
                [string]$Type,
                [string]$Id = "",
                [int]$Index = -1
            )
            if ($Id) {
                return "$($Type.ToLower())_$($Id -replace '[^a-zA-Z0-9]', '_')"
            }
            elseif ($Index -ge 0) {
                return "$($Type.ToLower())_$Index"
            }
            else {
                return "$($Type.ToLower())_$(Get-Random)"
            }
        }

        # Function to process a TextBlock element
        function Process-TextBlock {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0,
                [string]$ContainerId = ""
            )
            $varName = Get-VariableName -Type "textBlock" -Id $Element.id -Index $elementIndex

            $params = @()
            if ($Element.text) { $params += "-Text ""$($Element.text)""" }
            if ($Element.size) { $params += "-Size ""$($Element.size)""" }
            if ($Element.weight) { $params += "-Weight ""$($Element.weight)""" }
            if ($Element.color) { $params += "-Color ""$($Element.color)""" }
            if ($Element.wrap -and $Element.wrap -ne "True") { $params += "-Wrap `$$($Element.wrap)" }

            Add-Line "`$$varName = New-AMTextBlock $($params -join ' ')" -IndentLevel $IndentLevel

            $addParams = @("-Card `$card", "-Element `$$varName")
            if ($ContainerId) { $addParams += "-ContainerId ""$ContainerId""" }
            Add-Line "Add-AMElement $($addParams -join ' ')" -IndentLevel $IndentLevel

            return $varName
        }

        # Function to process an Image element
        function Process-Image {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0,
                [string]$ContainerId = ""
            )
            $varName = Get-VariableName -Type "image" -Id $Element.id -Index $elementIndex

            $params = @()
            if ($Element.url) { $params += "-Url ""$($Element.url)""" }
            if ($Element.altText) { $params += "-AltText ""$($Element.altText)""" }
            if ($Element.size) { $params += "-Size ""$($Element.size)""" }

            Add-Line "`$$varName = New-AMImage $($params -join ' ')" -IndentLevel $IndentLevel

            $addParams = @("-Card `$card", "-Element `$$varName")
            if ($ContainerId) { $addParams += "-ContainerId ""$ContainerId""" }
            Add-Line "Add-AMElement $($addParams -join ' ')" -IndentLevel $IndentLevel

            return $varName
        }

        # Function to process an ImageSet element
        function Process-ImageSet {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0,
                [string]$ContainerId = ""
            )
            $varName = Get-VariableName -Type "imageSet" -Id $Element.id -Index $elementIndex

            # First create image URLs array
            Add-Line "`$images = @(" -IndentLevel $IndentLevel
            foreach ($image in $Element.images) {
                Add-Line """$($image.url)""," -IndentLevel ($IndentLevel + 1)
            }
            Add-Line ")" -IndentLevel $IndentLevel

            Add-Line "`$$varName = New-AMImageSet -Images `$images" -IndentLevel $IndentLevel

            $addParams = @("-Card `$card", "-Element `$$varName")
            if ($ContainerId) { $addParams += "-ContainerId ""$ContainerId""" }
            Add-Line "Add-AMElement $($addParams -join ' ')" -IndentLevel $IndentLevel

            return $varName
        }

        # Function to process a Container element
        function Process-Container {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0,
                [string]$ContainerId = ""
            )
            $varName = Get-VariableName -Type "container" -Id $Element.id -Index $elementIndex

            $params = @()
            if ($Element.id) { $params += "-Id ""$($Element.id)""" }
            if ($Element.style) { $params += "-Style ""$($Element.style)""" }
            if ($Element.padding) { $params += "-Padding ""$($Element.padding)""" }

            Add-Line "`$$varName = New-AMContainer $($params -join ' ')" -IndentLevel $IndentLevel

            $addParams = @("-Card `$card", "-Element `$$varName")
            if ($ContainerId) { $addParams += "-ContainerId ""$ContainerId""" }
            Add-Line "Add-AMElement $($addParams -join ' ')" -IndentLevel $IndentLevel

            # Process items within the container
            if ($Element.items) {
                foreach ($item in $Element.items) {
                    Process-Element -Element $item -IndentLevel $IndentLevel -ContainerId $Element.id
                }
            }

            return $varName
        }

        # Function to process a Column element
        function Process-Column {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0
            )
            $varName = Get-VariableName -Type "column" -Id $Element.id -Index $elementIndex

            # First create items for the column
            if ($Element.items -and $Element.items.Count -gt 0) {
                Add-Line "`$$varName = New-AMColumn -Width ""$($Element.width)"" -Items @(" -IndentLevel $IndentLevel

                foreach ($item in $Element.items) {
                    # Create item definitions inline
                    if ($item.type -eq "TextBlock") {
                        $params = @()
                        if ($item.text) { $params += "-Text ""$($item.text)""" }
                        if ($item.size) { $params += "-Size ""$($item.size)""" }
                        if ($item.weight) { $params += "-Weight ""$($item.weight)""" }
                        if ($item.color) { $params += "-Color ""$($item.color)""" }

                        Add-Line "(New-AMTextBlock $($params -join ' '))," -IndentLevel ($IndentLevel + 1)
                    }
                    # Add other element types as needed
                }

                Add-Line ")" -IndentLevel $IndentLevel
            }
            else {
                Add-Line "`$$varName = New-AMColumn -Width ""$($Element.width)""" -IndentLevel $IndentLevel
            }

            return $varName
        }

        # Function to process a ColumnSet element
        function Process-ColumnSet {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0,
                [string]$ContainerId = ""
            )
            $varName = Get-VariableName -Type "columnSet" -Id $Element.id -Index $elementIndex

            # Process each column
            $columnVars = @()
            foreach ($column in $Element.columns) {
                $columnVar = Process-Column -Element $column -IndentLevel $IndentLevel
                $columnVars += "`$$columnVar"
            }

            Add-Line "`$$varName = New-AMColumnSet -Id ""$($Element.id)"" -Columns @($($columnVars -join ', '))" -IndentLevel $IndentLevel

            $addParams = @("-Card `$card", "-Element `$$varName")
            if ($ContainerId) { $addParams += "-ContainerId ""$ContainerId""" }
            Add-Line "Add-AMElement $($addParams -join ' ')" -IndentLevel $IndentLevel

            return $varName
        }

        # Function to process a FactSet element
        function Process-FactSet {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0,
                [string]$ContainerId = ""
            )
            $varName = Get-VariableName -Type "factSet" -Id $Element.id -Index $elementIndex

            # Create facts array
            Add-Line "`$facts = @(" -IndentLevel $IndentLevel
            foreach ($fact in $Element.facts) {
                Add-Line "(New-AMFact -Title ""$($fact.title)"" -Value ""$($fact.value)"")," -IndentLevel ($IndentLevel + 1)
            }
            Add-Line ")" -IndentLevel $IndentLevel

            Add-Line "`$$varName = New-AMFactSet -Facts `$facts" -IndentLevel $IndentLevel

            $addParams = @("-Card `$card", "-Element `$$varName")
            if ($ContainerId) { $addParams += "-ContainerId ""$ContainerId""" }
            Add-Line "Add-AMElement $($addParams -join ' ')" -IndentLevel $IndentLevel

            return $varName
        }

        # Function to process input elements
        function Process-Input {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0,
                [string]$ContainerId = ""
            )
            $inputType = $Element.type.Replace("Input.", "")
            $varName = Get-VariableName -Type $inputType -Id $Element.id -Index $elementIndex

            $params = @()
            if ($Element.id) { $params += "-Id ""$($Element.id)""" }

            switch ($inputType) {
                "Text" {
                    if ($Element.label) { $params += "-Label ""$($Element.label)""" }
                    if ($Element.placeholder) { $params += "-Placeholder ""$($Element.placeholder)""" }
                    if ($Element.maxLength) { $params += "-MaxLength $($Element.maxLength)" }
                    Add-Line "`$$varName = New-AMTextInput $($params -join ' ')" -IndentLevel $IndentLevel
                }
                "Number" {
                    if ($Element.placeholder) { $params += "-Placeholder ""$($Element.placeholder)""" }
                    if ($Element.min) { $params += "-Min $($Element.min)" }
                    if ($Element.max) { $params += "-Max $($Element.max)" }
                    Add-Line "`$$varName = New-AMNumberInput $($params -join ' ')" -IndentLevel $IndentLevel
                }
                "Date" {
                    if ($Element.label) { $params += "-Label ""$($Element.label)""" }
                    if ($Element.value) { $params += "-Value ""$($Element.value)""" }
                    Add-Line "`$$varName = New-AMDateInput $($params -join ' ')" -IndentLevel $IndentLevel
                }
                "Time" {
                    if ($Element.label) { $params += "-Label ""$($Element.label)""" }
                    if ($Element.value) { $params += "-Value ""$($Element.value)""" }
                    Add-Line "`$$varName = New-AMTimeInput $($params -join ' ')" -IndentLevel $IndentLevel
                }
                "ChoiceSet" {
                    if ($Element.label) { $params += "-Label ""$($Element.label)""" }
                    if ($Element.style) { $params += "-Style ""$($Element.style)""" }
                    if ($Element.isMultiSelect) { $params += "-IsMultiSelect `$$($Element.isMultiSelect)" }

                    # Create choices array
                    Add-Line "`$choices = @(" -IndentLevel $IndentLevel
                    foreach ($choice in $Element.choices) {
                        Add-Line "(New-AMChoice -Title ""$($choice.title)"" -Value ""$($choice.value)"")," -IndentLevel ($IndentLevel + 1)
                    }
                    Add-Line ")" -IndentLevel $IndentLevel

                    Add-Line "`$$varName = New-AMChoiceSetInput $($params -join ' ') -Choices `$choices" -IndentLevel $IndentLevel
                }
                "Toggle" {
                    if ($Element.title) { $params += "-Title ""$($Element.title)""" }
                    if ($Element.value) { $params += "-Value ""$($Element.value)""" }
                    Add-Line "`$$varName = New-AMToggleInput $($params -join ' ')" -IndentLevel $IndentLevel
                }
                default {
                    Add-Line "# Unsupported input type: $inputType" -IndentLevel $IndentLevel
                    return $null
                }
            }

            $addParams = @("-Card `$card", "-Element `$$varName")
            if ($ContainerId) { $addParams += "-ContainerId ""$ContainerId""" }
            Add-Line "Add-AMElement $($addParams -join ' ')" -IndentLevel $IndentLevel

            return $varName
        }

        # Function to process actions
        function Process-Action {
            param(
                [PSCustomObject]$Action,
                [int]$IndentLevel = 0
            )
            $actionType = $Action.type.Replace("Action.", "")
            $varName = Get-VariableName -Type $actionType -Id $Action.id -Index $actionIndex

            $params = @()
            if ($Action.title) { $params += "-Title ""$($Action.title)""" }

            switch ($actionType) {
                "OpenUrl" {
                    if ($Action.url) { $params += "-Url ""$($Action.url)""" }
                    Add-Line "`$$varName = New-AMOpenUrlAction $($params -join ' ')" -IndentLevel $IndentLevel
                }
                "ShowCard" {
                    # Create a hashtable for the card definition
                    Add-Line "`$detailCard = @{" -IndentLevel $IndentLevel
                    Add-Line "'type' = 'AdaptiveCard'" -IndentLevel ($IndentLevel + 1)

                    if ($Action.card.body) {
                        Add-Line "'body' = @(" -IndentLevel ($IndentLevel + 1)
                        foreach ($item in $Action.card.body) {
                            Add-Line "@{" -IndentLevel ($IndentLevel + 2)
                            foreach ($prop in $item.PSObject.Properties) {
                                if ($prop.Value -is [string]) {
                                    Add-Line "'$($prop.Name)' = ""$($prop.Value)""" -IndentLevel ($IndentLevel + 3)
                                } else {
                                    Add-Line "'$($prop.Name)' = $($prop.Value)" -IndentLevel ($IndentLevel + 3)
                                }
                            }
                            Add-Line "}" -IndentLevel ($IndentLevel + 2)
                        }
                        Add-Line ")" -IndentLevel ($IndentLevel + 1)
                    }

                    if ($Action.card.'$schema') {
                        Add-Line "'`$schema' = '$($Action.card.'$schema')'" -IndentLevel ($IndentLevel + 1)
                    }

                    if ($Action.card.padding) {
                        Add-Line "'padding' = '$($Action.card.padding)'" -IndentLevel ($IndentLevel + 1)
                    }

                    Add-Line "}" -IndentLevel $IndentLevel

                    Add-Line "`$$varName = New-AMShowCardAction $($params -join ' ') -Card `$detailCard" -IndentLevel $IndentLevel
                }
                "Http" {
                    if ($Action.method) { $params += "-Verb ""$($Action.method)""" }
                    if ($Action.url) { $params += "-Url ""$($Action.url)""" }
                    if ($Action.body) { $params += "-Body '$($Action.body)'" }
                    Add-Line "`$$varName = New-AMExecuteAction $($params -join ' ')" -IndentLevel $IndentLevel
                }
                "ToggleVisibility" {
                    if ($Action.targetElements) {
                        $targetParams = $Action.targetElements | ForEach-Object { """$_""" }
                        $params += "-TargetElements @($($targetParams -join ', '))"
                    }
                    Add-Line "`$$varName = New-AMToggleVisibilityAction $($params -join ' ')" -IndentLevel $IndentLevel
                }
                default {
                    Add-Line "# Unsupported action type: $actionType" -IndentLevel $IndentLevel
                    return $null
                }
            }

            return $varName
        }

        # Function to process an ActionSet element
        function Process-ActionSet {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0,
                [string]$ContainerId = ""
            )
            $varName = Get-VariableName -Type "actionSet" -Id $Element.id -Index $elementIndex

            # Process each action
            $actionVars = @()
            $actionIndex = 0
            foreach ($action in $Element.actions) {
                $actionVar = Process-Action -Action $action -IndentLevel $IndentLevel
                $actionVars += "`$$actionVar"
                $actionIndex++
            }

            Add-Line "`$$varName = New-AMActionSet -Id ""$($Element.id)"" -Actions @($($actionVars -join ', '))" -IndentLevel $IndentLevel

            $addParams = @("-Card `$card", "-Element `$$varName")
            if ($ContainerId) { $addParams += "-ContainerId ""$ContainerId""" }
            Add-Line "Add-AMElement $($addParams -join ' ')" -IndentLevel $IndentLevel

            return $varName
        }

        # Main function to process any element by type
        function Process-Element {
            param(
                [PSCustomObject]$Element,
                [int]$IndentLevel = 0,
                [string]$ContainerId = ""
            )
            $script:elementIndex++

            switch -Regex ($Element.type) {
                "TextBlock" { Process-TextBlock -Element $Element -IndentLevel $IndentLevel -ContainerId $ContainerId }
                "Image" { Process-Image -Element $Element -IndentLevel $IndentLevel -ContainerId $ContainerId }
                "ImageSet" { Process-ImageSet -Element $Element -IndentLevel $IndentLevel -ContainerId $ContainerId }
                "Container" { Process-Container -Element $Element -IndentLevel $IndentLevel -ContainerId $ContainerId }
                "ColumnSet" { Process-ColumnSet -Element $Element -IndentLevel $IndentLevel -ContainerId $ContainerId }
                "FactSet" { Process-FactSet -Element $Element -IndentLevel $IndentLevel -ContainerId $ContainerId }
                "Input\." { Process-Input -Element $Element -IndentLevel $IndentLevel -ContainerId $ContainerId }
                "ActionSet" { Process-ActionSet -Element $Element -IndentLevel $IndentLevel -ContainerId $ContainerId }
                default { Add-Line "# Unsupported element type: $($Element.type)" -IndentLevel $IndentLevel }
            }
        }

        $script:commandOutput = ""
        $script:elementIndex = 0
    }

    process {
        try {
            # Parse the JSON
            $card = $Json | ConvertFrom-Json

            # Start with creating a new card with top-level properties
            $cardParams = @()
            if ($card.originator) { $cardParams += "-OriginatorId ""$($card.originator)""" }
            if ($card.version) { $cardParams += "-Version ""$($card.version)""" }

            Add-Line "# Create a new card"
            Add-Line "`$card = New-AMCard $($cardParams -join ' ')"
            Add-Line ""

            # Process each element in the card's body
            Add-Line "# Add elements to the card"
            foreach ($element in $card.body) {
                Process-Element -Element $element
                Add-Line ""
            }

            # Add export code
            Add-Line "# Export the card"
            Add-Line "`$cardJson = Export-AMCard -Card `$card"
        }
        catch {
            Write-Error "Error processing card JSON: $_"
        }
    }

    end {
        if ($OutputPath) {
            $script:commandOutput | Out-File -FilePath $OutputPath -Force
            Write-Host "PowerShell commands have been written to $OutputPath"
        }
        else {
            return $script:commandOutput
        }
    }
}