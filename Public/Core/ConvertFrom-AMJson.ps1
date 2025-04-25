function ConvertFrom-AMJson {
    <#
    .SYNOPSIS
        Converts an Adaptive Card JSON to PowerShell commands using the ActionableMessages module.

    .DESCRIPTION
        The `ConvertFrom-AMJson` function takes an Adaptive Card JSON string and generates equivalent PowerShell
        commands that would create the same card using the ActionableMessages module functions.

        This function is useful for:
        - Converting existing Adaptive Cards to PowerShell code
        - Learning by example how to create complex cards
        - Migrating from other platforms that export Adaptive Cards as JSON
        - Generating reusable scripts from designer-created cards

        The generated code follows best practices for the ActionableMessages module and maintains proper nesting
        of elements within containers, column sets, and other structures.

        If the JSON contains unsupported element types, they will be commented in the output script for manual review.

    .PARAMETER Json
        The Adaptive Card JSON string to convert to PowerShell commands.
        This can be a complete Adaptive Card JSON object with schema, type, version, etc.

    .PARAMETER OutputPath
        (Optional) If specified, writes the generated PowerShell script to this file path instead of returning it
        as a string.

    .PARAMETER GenerateId
        (Optional) When specified, generates new IDs for elements that don't have them. This can be useful when
        you need to reference elements later in your code.

    .EXAMPLE
        # Convert JSON from a file and display the PowerShell commands
        $jsonContent = Get-Content -Path ".\myAdaptiveCard.json" -Raw
        ConvertFrom-AMJson -Json $jsonContent

    .EXAMPLE
        # Convert JSON and save the PowerShell commands to a file
        $jsonContent = Get-Content -Path ".\designerCard.json" -Raw
        ConvertFrom-AMJson -Json $jsonContent -OutputPath ".\createCard.ps1"

    .EXAMPLE
        # Convert JSON from a web response
        $response = Invoke-RestMethod -Uri "https://myapi.example.com/cards/template"
        $response.cardJson | ConvertFrom-AMJson

    .EXAMPLE
        # Convert JSON and generate new IDs for elements
        $jsonContent = Get-Content -Path ".\card.json" -Raw
        ConvertFrom-AMJson -Json $jsonContent -GenerateId

    .INPUTS
        System.String
        Accepts a JSON string representing an Adaptive Card.

    .OUTPUTS
        System.String or None
        - Returns the generated PowerShell script as a string if no `OutputPath` is specified.
        - If `OutputPath` is specified, writes the script to the file and returns a confirmation message.

    .NOTES
        - This function supports all standard Adaptive Card elements and actions, including:
          TextBlocks, Images, ImageSets, Containers, ColumnSets, FactSets, Input elements, and various action types.
        - Unsupported element types will be commented in the output script for manual review.
        - Variable names in the generated script are based on element types and IDs when available.
        - The function ensures proper nesting of elements and maintains the structure of the original card.

    .LINK
        https://adaptivecards.io/explorer/

    .LINK
        Export-AMCard
    #>
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
        # Track processed elements to avoid duplicates
        $script:processedElements = @{}
        $script:variableCounter = 0

        # Generic function to convert JSON object to PowerShell hashtable representation
        function ConvertTo-PowerShellHashtable {
            param(
                [Parameter(Mandatory = $true)]
                $InputObject,

                [Parameter(Mandatory = $false)]
                [int]$IndentLevel = 0,

                [Parameter(Mandatory = $false)]
                [switch]$AsString
            )

            $indent = "    " * $IndentLevel
            $nextIndent = "    " * ($IndentLevel + 1)

            if ($null -eq $InputObject) {
                return "`$null"
            }
            elseif ($InputObject -is [string]) {
                return "`"$($InputObject.Replace('"', '`"'))`""
            }
            elseif ($InputObject -is [bool]) {
                return "`$$($InputObject.ToString().ToLower())"
            }
            elseif ($InputObject -is [int] -or $InputObject -is [double]) {
                return "$InputObject"
            }
            elseif ($InputObject -is [array]) {
                $arrayItems = @()
                foreach ($item in $InputObject) {
                    $arrayItems += (ConvertTo-PowerShellHashtable -InputObject $item -IndentLevel ($IndentLevel + 1))
                }

                if ($AsString) {
                    return "@(`n$($nextIndent)$($arrayItems -join ",`n$nextIndent")`n$indent)"
                }
                else {
                    return $arrayItems
                }
            }
            elseif ($InputObject -is [PSCustomObject] -or $InputObject -is [hashtable]) {
                $hashtable = [ordered]@{}
                foreach ($prop in $InputObject.PSObject.Properties) {
                    $hashtable[$prop.Name] = ConvertTo-PowerShellHashtable -InputObject $prop.Value -IndentLevel ($IndentLevel + 1)
                }

                if ($AsString) {
                    $hashLines = "@{`n"
                    foreach ($key in $hashtable.Keys) {
                        $hashLines += "$nextIndent'$key' = $($hashtable[$key]);`n"
                    }
                    $hashLines += "$indent}"
                    return $hashLines
                }
                else {
                    return $hashtable
                }
            }
            else {
                return "$InputObject"
            }
        }

        # Function to generate a unique variable name
        function Get-UniqueVarName {
            param(
                [string]$Type,
                [string]$Id = "",
                [int]$Index = -1
            )

            # Use the element ID if provided, otherwise generate a sequential name
            if ($Id -and -not [string]::IsNullOrWhiteSpace($Id)) {
                $baseName = "$($Type.ToLower())_$($Id -replace '[^a-zA-Z0-9]', '_')"
            }
            elseif ($Index -ge 0) {
                $baseName = "$($Type.ToLower())_$Index"
            }
            else {
                $script:variableCounter++
                $baseName = "$($Type.ToLower())_$($script:variableCounter)"
            }

            # Make sure the name is unique
            if ($script:processedElements.ContainsKey($baseName)) {
                $script:variableCounter++
                $baseName = "${baseName}_$($script:variableCounter)"
            }

            # Register this name as used
            $script:processedElements[$baseName] = $true

            return $baseName
        }

        # Add a line to the output script
        function Add-ScriptLine {
            param(
                [string]$Line,
                [int]$IndentLevel = 0
            )

            $indent = "    " * $IndentLevel
            $script:output += "$indent$Line`r`n"
        }

        $script:output = ""

        # Process elements in order - to ensure dependencies are created first
        function Process-Card {
            param($CardObject)

            # Start with the card
            Add-ScriptLine "# Create a new card"
            $cardParams = @()
            if ($CardObject.originator) {
                $cardParams += "-OriginatorId `"$($CardObject.originator)`""
            }
            else {
                $cardParams += "-OriginatorId `"Replace-Me-With-Your-OriginatorId`""
            }
            if ($CardObject.version) {
                $cardParams += "-Version `"$($CardObject.version)`""
            }
            Add-ScriptLine "`$card = New-AMCard $($cardParams -join ' ')"
            Add-ScriptLine ""

            # Process all elements
            Add-ScriptLine "# Add elements to the card"

            # Main body elements
            if ($CardObject.body -and $CardObject.body.Count -gt 0) {
                foreach ($element in $CardObject.body) {
                    Process-Element -Element $element
                }
            }
        }

        # Process any element by type
        function Process-Element {
            param(
                $Element,
                [string]$ContainerId = $null
            )

            switch ($Element.type) {
                "TextBlock" { Process-TextBlock -Element $Element -ContainerId $ContainerId }
                "Image" { Process-Image -Element $Element -ContainerId $ContainerId }
                "ImageSet" { Process-ImageSet -Element $Element -ContainerId $ContainerId }
                "Container" { Process-Container -Element $Element -ContainerId $ContainerId }
                "ColumnSet" { Process-ColumnSet -Element $Element -ContainerId $ContainerId }
                "FactSet" { Process-FactSet -Element $Element -ContainerId $ContainerId }
                "ActionSet" { Process-ActionSet -Element $Element -ContainerId $ContainerId }
                default {
                    if ($Element.type -match "Input\.") {
                        Process-Input -Element $Element -ContainerId $ContainerId
                    }
                    else {
                        Add-ScriptLine "# Unsupported element type: $($Element.type)"
                    }
                }
            }
        }

        # Process TextBlock element
        function Process-TextBlock {
            param($Element, [string]$ContainerId = $null)

            $varName = Get-UniqueVarName -Type "textBlock" -Id $Element.id
            $params = @("-Text `"$($Element.text)`"")

            if ($Element.size -and $Element.size -ne "Medium") {
                $params += "-Size `"$($Element.size)`""
            }
            if ($Element.weight -and $Element.weight -ne "Default") {
                $params += "-Weight `"$($Element.weight)`""
            }
            if ($Element.color -and $Element.color -ne "Default") {
                $params += "-Color `"$($Element.color)`""
            }
            if ($Element.wrap -and $Element.wrap -eq "True") {
                $params += "-Wrap `$true"
            }

            Add-ScriptLine "`$$varName = New-AMTextBlock $($params -join ' ')"

            Add-ElementToCard -VarName $varName -ContainerId $ContainerId
        }

        # Process Image element
        function Process-Image {
            param($Element, [string]$ContainerId = $null)

            $varName = Get-UniqueVarName -Type "image" -Id $Element.id
            $params = @()

            if ($Element.url) {
                $params += "-Url `"$($Element.url)`""
            }
            if ($Element.altText) {
                $params += "-AltText `"$($Element.altText)`""
            }
            if ($Element.size) {
                $params += "-Size `"$($Element.size)`""
            }

            Add-ScriptLine "`$$varName = New-AMImage $($params -join ' ')"

            Add-ElementToCard -VarName $varName -ContainerId $ContainerId
        }

        # Process ImageSet element
        function Process-ImageSet {
            param($Element, [string]$ContainerId = $null)

            $varName = Get-UniqueVarName -Type "imageSet" -Id $Element.id

            Add-ScriptLine "`$images = @("
            foreach ($image in $Element.images) {
                # Add each image URL to the array with a trailing comma except for the last one
                if ($image -eq $Element.images[-1]) {
                    Add-ScriptLine "    `"$($image.url)`""
                }
                else {
                    Add-ScriptLine "    `"$($image.url)`","
                }
            }
            Add-ScriptLine ")"

            Add-ScriptLine "`$$varName = New-AMImageSet -Images `$images"

            Add-ElementToCard -VarName $varName -ContainerId $ContainerId
        }

        # Process Container element
        function Process-Container {
            param($Element, [string]$ContainerId = $null)

            $varName = Get-UniqueVarName -Type "container" -Id $Element.id
            $params = @()

            if ($Element.id) {
                $params += "-Id `"$($Element.id)`""
            }
            if ($Element.style) {
                $params += "-Style `"$($Element.style)`""
            }
            if ($Element.padding) {
                if ($Element.padding -is [PSCustomObject]) {
                    $customPadding = [hashtable]@{}
                    $customPadding.top = "$($Element.padding.top)"
                    $customPadding.bottom = "$($Element.padding.bottom)"
                    $customPadding.left = "$($Element.padding.left)"
                    $customPadding.right = "$($Element.padding.right)"

                    # Format the hashtable as PowerShell syntax
                    $formattedPadding = "@{"
                    foreach ($key in $customPadding.Keys) {
                        if ($customPadding[$key]) {
                            $formattedPadding += "$key=`"$($customPadding[$key])`"; "
                        }
                    }
                    $formattedPadding = $formattedPadding.TrimEnd('; ') + "}"

                    # Add properly formatted hashtable to params separately
                    $params += "-Padding `"Custom`""
                    $params += "-CustomPadding $formattedPadding"
                }
                else {
                    $params += "-Padding `"$($Element.padding)`""
                }
            }

            Add-ScriptLine "`$$varName = New-AMContainer $($params -join ' ')"

            Add-ElementToCard -VarName $varName -ContainerId $ContainerId

            # Process container items
            if ($Element.items -and $Element.items.Count -gt 0) {
                foreach ($item in $Element.items) {
                    Process-Element -Element $item -ContainerId $Element.id
                }
            }
        }

        # Process ColumnSet element
        function Process-ColumnSet {
            param($Element, [string]$ContainerId = $null)

            $varName = Get-UniqueVarName -Type "columnSet" -Id $Element.id

            # First process all columns
            $columnVars = @()

            for ($i = 0; $i -lt $Element.columns.Count; $i++) {
                $column = $Element.columns[$i]
                $colVarName = Get-UniqueVarName -Type "column" -Index $i

                # Create column items
                if ($column.items -and $column.items.Count -gt 0) {
                    Add-ScriptLine "`$$colVarName = New-AMColumn -Width `"$($column.width)`" -Items @("

                    foreach ($item in $column.items) {
                        switch ($item.type) {
                            TextBlock {
                                $textParams = @("`"$($item.text)`"")

                                if ($item.size -and $item.size -ne "Medium") {
                                    $textParams += "-Size `"$($item.size)`""
                                }
                                if ($item.weight -and $item.weight -ne "Default") {
                                    $textParams += "-Weight `"$($item.weight)`""
                                }
                                if ($item.color -and $item.color -ne "Default") {
                                    $textParams += "-Color `"$($item.color)`""
                                }
                                if ($item.wrap -and $item.wrap -eq "True") {
                                    $textParams += "-Wrap `$true"
                                }

                                Add-ScriptLine "    (New-AMTextBlock $($textParams -join ' ')),"
                            }
                            Image {
                                $imgParams = @("-Url `"$($item.url)`"")

                                if ($item.altText) {
                                    $imgParams += "-AltText `"$($item.altText)`""
                                }
                                if ($item.size) {
                                    $imgParams += "-Size `"$($item.size)`""
                                }

                                Add-ScriptLine "    (New-AMImage $($imgParams -join ' ')),"
                            }
                            ImageSet {
                                $imgSetParams = @("-Images @(")
                                foreach ($img in $item.images) {
                                    $imgSetParams += "`"$($img.url)`","
                                }
                                # Remove the trailing comma
                                $imgSetParams[$imgSetParams.Count - 1] = $imgSetParams[$imgSetParams.Count - 1].TrimEnd(',')
                                $imgSetParams += "))"

                                Add-ScriptLine "    (New-AMImageSet $($imgSetParams -join ' ')),"
                            }
                            FactSet {
                                $factParams = @("-Facts @(")
                                foreach ($fact in $item.facts) {
                                    if ($fact -eq $item.facts[-1]) {
                                        $factParams += "(New-AMFact -Title `"$($fact.title)`" -Value `"$($fact.value)`")"
                                    }
                                    else {
                                        $factParams += "(New-AMFact -Title `"$($fact.title)`" -Value `"$($fact.value)`"),"
                                    }
                                }
                                $factParams += "))"

                                Add-ScriptLine "    (New-AMFactSet $($factParams -join ' '),"
                            }
                            ActionSet {
                                $actionVars = @()
                                foreach ($action in $item.actions) {
                                    $actionVar = Process-Action -Action $action
                                    if ($actionVar) {
                                        $actionVars += "`$$actionVar"
                                    }
                                }

                                $params = @("-Actions @($($actionVars -join ', '))")
                                if ($item.id) { $params += "-Id `"$($item.id)`"" }

                                Add-ScriptLine "    (New-AMActionSet $($params -join ' ')),"
                            }
                            Container {
                                $containerVar = Process-Container -Element $item -ContainerId $colVarName
                                if ($containerVar) {
                                    Add-ScriptLine "    `$containerVar,"
                                }
                            }
                            ColumnSet {
                                $colSetVar = Process-ColumnSet -Element $item -ContainerId $colVarName
                                if ($colSetVar) {
                                    Add-ScriptLine "    `$colSetVar,"
                                }
                            }
                            Input.Text {
                                $inputParams = @("-Id `"$($item.id)`"")
                                if ($item.label) { $inputParams += "-Label `"$($item.label)`"" }
                                if ($item.placeholder) { $inputParams += "-Placeholder `"$($item.placeholder)`"" }
                                if ($item.maxLength) { $inputParams += "-MaxLength $($item.maxLength)" }

                                Add-ScriptLine "    (New-AMTextInput $($inputParams -join ' ')),"
                            }
                            Input.Number {
                                $inputParams = @("-Id `"$($item.id)`"")
                                if ($item.placeholder) { $inputParams += "-Placeholder `"$($item.placeholder)`"" }
                                if ($item.min) { $inputParams += "-Min $($item.min)" }
                                if ($item.max) { $inputParams += "-Max $($item.max)" }

                                Add-ScriptLine "    (New-AMNumberInput $($inputParams -join ' ')),"
                            }
                            Input.Date {
                                $inputParams = @("-Id `"$($item.id)`"")
                                if ($item.label) { $inputParams += "-Label `"$($item.label)`"" }
                                if ($item.value) { $inputParams += "-Value `"$($item.value)`"" }

                                Add-ScriptLine "    (New-AMDateInput $($inputParams -join ' ')),"
                            }
                            Input.Time {
                                $inputParams = @("-Id `"$($item.id)`"")
                                if ($item.label) { $inputParams += "-Label `"$($item.label)`"" }
                                if ($item.value) { $inputParams += "-Value `"$($item.value)`"" }

                                Add-ScriptLine "    (New-AMTimeInput $($inputParams -join ' ')),"
                            }
                            Input.ChoiceSet {
                                # Create choices array
                                Add-ScriptLine "`$choices = @("
                                foreach ($choice in $item.choices) {
                                    Add-ScriptLine "    (New-AMChoice -Title `"$($choice.title)`" -Value `"$($choice.value)`"),"
                                }
                                # Remove the trailing comma
                                $script:output = $script:output -replace ",\r\n$", "`r`n"
                                Add-ScriptLine ")"

                                $inputParams = @("-Id `"$($item.id)`"")
                                if ($item.label) { $inputParams += "-Label `"$($item.label)`"" }
                                if ($item.style) { $inputParams += "-Style `"$($item.style)`"" }
                                if ($item.isMultiSelect -ne $false) { $inputParams += "-IsMultiSelect `$$($item.isMultiSelect)" }
                                $inputParams += "-Choices `$choices"

                                Add-ScriptLine "    (New-AMChoiceSetInput $($inputParams -join ' ')),"
                            }
                            Input.Toggle {
                                $inputParams = @("-Id `"$($item.id)`"")
                                if ($item.title) { $inputParams += "-Title `"$($item.title)`"" }
                                if ($item.value) { $inputParams += "-Value `"$($item.value)`"" }

                                Add-ScriptLine "    (New-AMToggleInput $($inputParams -join ' ')),"
                            }
                            Default {
                                Add-ScriptLine "    # Unsupported column item: $($item.type)"
                            }
                        }
                    }

                    # Remove the trailing comma
                    $script:output = $script:output -replace ",\r\n$", "`r`n"
                    Add-ScriptLine ")"
                }
                else {
                    Add-ScriptLine "`$$colVarName = New-AMColumn -Width `"$($column.width)`" -Items @()"
                }

                $columnVars += "`$$colVarName"
            }

            # Now create the ColumnSet
            $csParams = @()
            if ($Element.id) {
                $csParams += "-Id `"$($Element.id)`""
            }
            else {
                $csParams += "-Id `"$($varName)`""
            }
            $csParams += "-Columns @($($columnVars -join ', '))"

            Add-ScriptLine "`$$varName = New-AMColumnSet $($csParams -join ' ')"

            Add-ElementToCard -VarName $varName -ContainerId $ContainerId
        }

        # Process FactSet element
        function Process-FactSet {
            param($Element, [string]$ContainerId = $null)

            $varName = Get-UniqueVarName -Type "factSet" -Id $Element.id

            Add-ScriptLine "`$facts = @("
            foreach ($fact in $Element.facts) {
                if ($fact -eq $Element.facts[-1]) {
                    Add-ScriptLine "    (New-AMFact -Title `"$($fact.title)`" -Value `"$($fact.value)`")"
                }
                else {
                    Add-ScriptLine "    (New-AMFact -Title `"$($fact.title)`" -Value `"$($fact.value)`"),"
                }
            }
            Add-ScriptLine ")"

            Add-ScriptLine "`$$varName = New-AMFactSet -Facts `$facts"

            Add-ElementToCard -VarName $varName -ContainerId $ContainerId
        }

        # Process Input elements
        function Process-Input {
            param($Element, [string]$ContainerId = $null)

            $inputType = $Element.type.Replace("Input.", "")
            $varName = Get-UniqueVarName -Type $inputType -Id $Element.id

            switch ($inputType) {
                "Text" {
                    $params = @("-Id `"$($Element.id)`"")
                    if ($Element.label) { $params += "-Label `"$($Element.label)`"" }
                    if ($Element.placeholder) { $params += "-Placeholder `"$($Element.placeholder)`"" }
                    if ($Element.maxLength) { $params += "-MaxLength $($Element.maxLength)" }
                    if ($Element.isMultiline -eq $true) { $params += "-IsMultiline `$true" }

                    Add-ScriptLine "`$$varName = New-AMTextInput $($params -join ' ')"
                }
                "Number" {
                    $params = @("-Id `"$($Element.id)`"")
                    if ($Element.placeholder) { $params += "-Placeholder `"$($Element.placeholder)`"" }
                    if ($Element.min) { $params += "-Min $($Element.min)" }
                    if ($Element.max) { $params += "-Max $($Element.max)" }

                    Add-ScriptLine "`$$varName = New-AMNumberInput $($params -join ' ')"
                }
                "Date" {
                    $params = @("-Id `"$($Element.id)`"")
                    if ($Element.label) { $params += "-Label `"$($Element.label)`"" }
                    if ($Element.value) { $params += "-Value `"$($Element.value)`"" }

                    Add-ScriptLine "`$$varName = New-AMDateInput $($params -join ' ')"
                }
                "Time" {
                    $params = @("-Id `"$($Element.id)`"")
                    if ($Element.label) { $params += "-Label `"$($Element.label)`"" }
                    if ($Element.value) { $params += "-Value `"$($Element.value)`"" }

                    Add-ScriptLine "`$$varName = New-AMTimeInput $($params -join ' ')"
                }
                "ChoiceSet" {
                    # Create choices array
                    Add-ScriptLine "`$choices = @("
                    foreach ($choice in $Element.choices) {
                        if ($choice -eq $Element.choices[-1]) {
                            Add-ScriptLine "    (New-AMChoice -Title `"$($choice.title)`" -Value `"$($choice.value)`")"
                        }
                        else {
                            Add-ScriptLine "    (New-AMChoice -Title `"$($choice.title)`" -Value `"$($choice.value)`"),"
                        }
                    }
                    Add-ScriptLine ")"

                    $params = @("-Id `"$($Element.id)`"")
                    if ($Element.label) { $params += "-Label `"$($Element.label)`"" }
                    if ($Element.style) { $params += "-Style `"$($Element.style)`"" }
                    if ($Element.isMultiSelect -ne $false) { $params += "-IsMultiSelect `$$($Element.isMultiSelect)" }
                    $params += "-Choices `$choices"

                    Add-ScriptLine "`$$varName = New-AMChoiceSetInput $($params -join ' ')"
                }
                "Toggle" {
                    $params = @("-Id `"$($Element.id)`"")
                    if ($Element.title) { $params += "-Title `"$($Element.title)`"" }
                    if ($Element.value) { $params += "-Value `"$($Element.value)`"" }

                    Add-ScriptLine "`$$varName = New-AMToggleInput $($params -join ' ')"
                }
                default {
                    Add-ScriptLine "# Unsupported input type: $inputType"
                    return
                }
            }

            Add-ElementToCard -VarName $varName -ContainerId $ContainerId
        }

        # Process Action element
        function Process-Action {
            param($Action)

            $actionType = $Action.type.Replace("Action.", "")
            $varName = Get-UniqueVarName -Type $actionType -Id $Action.id

            switch ($actionType) {
                "OpenUrl" {
                    $params = @()
                    if ($Action.title) { $params += "-Title `"$($Action.title)`"" }
                    if ($Action.url) { $params += "-Url `"$($Action.url)`"" }

                    Add-ScriptLine "`$$varName = New-AMOpenUrlAction $($params -join ' ')"
                }
                "ShowCard" {
                    $params = @()
                    if ($Action.title) { $params += "-Title `"$($Action.title)`"" }
                    if ($Action.id) { $params += "-Id `"$($Action.id)`"" }

                    # Create a properly structured card object manually
                    Add-ScriptLine "`$detailCard = @{"
                    Add-ScriptLine "    'type' = 'AdaptiveCard'"

                    # Handle the body array properly
                    if ($Action.card.body -and $Action.card.body.Count -gt 0) {
                        Add-ScriptLine "    'body' = @("

                        foreach ($bodyItem in $Action.card.body) {
                            Add-ScriptLine "        @{"
                            Add-ScriptLine "            'type' = `"$($bodyItem.type)`""

                            # Add other properties based on type
                            if ($bodyItem.id) { Add-ScriptLine "            'id' = `"$($bodyItem.id)`"" }

                            switch -Regex ($bodyItem.type) {
                                "Input\.Text" {
                                    if ($bodyItem.placeholder) { Add-ScriptLine "            'placeholder' = `"$($bodyItem.placeholder)`"" }
                                    if ($bodyItem.isMultiline -ne $null) { Add-ScriptLine "            'isMultiline' = `$$($bodyItem.isMultiline.ToString().ToLower())" }
                                }
                                "ActionSet" {
                                    Add-ScriptLine "            'actions' = @("

                                    foreach ($action in $bodyItem.actions) {
                                        Add-ScriptLine "                @{"
                                        Add-ScriptLine "                    'type' = `"$($action.type)`""
                                        if ($action.id) { Add-ScriptLine "                    'id' = `"$($action.id)`"" }
                                        if ($action.title) { Add-ScriptLine "                    'title' = `"$($action.title)`"" }
                                        if ($action.method) { Add-ScriptLine "                    'method' = `"$($action.method)`"" }
                                        if ($action.url) { Add-ScriptLine "                    'url' = `"$($action.url)`"" }
                                        if ($action.body) { Add-ScriptLine "                    'body' = `"$($action.body.Replace('"', '`"'))`"" }
                                        Add-ScriptLine "                }"
                                    }

                                    Add-ScriptLine "            )"
                                }
                            }

                            Add-ScriptLine "        },"
                        }

                        # Remove trailing comma from last item
                        $script:output = $script:output -replace ",\r\n$", "`r`n"
                        Add-ScriptLine "    )"
                    }
                    else {
                        Add-ScriptLine "    'body' = @()"
                    }

                    # Add other card properties
                    if ($Action.card.'$schema') { Add-ScriptLine "    '`$schema' = '$($Action.card.'$schema')'" }
                    if ($Action.card.fallbackText) { Add-ScriptLine "    'fallbackText' = '$($Action.card.fallbackText)'" }
                    if ($Action.card.padding) { Add-ScriptLine "    'padding' = '$($Action.card.padding)'" }
                    Add-ScriptLine "}"

                    $params += "-Card `$detailCard"
                    Add-ScriptLine "`$$varName = New-AMShowCardAction $($params -join ' ')"
                }
                "Http" {
                    $params = @()
                    if ($Action.title) { $params += "-Title `"$($Action.title)`"" }
                    if ($Action.method) { $params += "-Verb `"$($Action.method)`"" }
                    if ($Action.url) { $params += "-Url `"$($Action.url)`"" }
                    if ($Action.body) {
                        $escapedBody = $Action.body.Replace("'", "''").Replace('"', '`"')
                        $params += "-Body '$escapedBody'"
                    }
                    if ($Action.isPrimary -eq $true) { $params += "-IsPrimary `$true" }

                    Add-ScriptLine "`$$varName = New-AMExecuteAction $($params -join ' ')"
                }
                "ToggleVisibility" {
                    $params = @()
                    if ($Action.title) { $params += "-Title `"$($Action.title)`"" }

                    if ($Action.targetElements) {
                        $targets = $Action.targetElements | ForEach-Object { "`"$_`"" }
                        $params += "-TargetElements @($($targets -join ', '))"
                    }

                    Add-ScriptLine "`$$varName = New-AMToggleVisibilityAction $($params -join ' ')"
                }
                default {
                    Add-ScriptLine "# Unsupported action type: $actionType"
                    return $null
                }
            }

            return $varName
        }

        # Process ActionSet element
        function Process-ActionSet {
            param($Element, [string]$ContainerId = $null)

            $varName = Get-UniqueVarName -Type "actionSet" -Id $Element.id

            $actionVars = @()
            foreach ($action in $Element.actions) {
                $actionVar = Process-Action -Action $action
                if ($actionVar) {
                    $actionVars += "`$$actionVar"
                }
            }

            $params = @()
            if ($Element.id) { $params += "-Id `"$($Element.id)`"" }
            $params += "-Actions @($($actionVars -join ', '))"

            Add-ScriptLine "`$$varName = New-AMActionSet $($params -join ' ')"

            Add-ElementToCard -VarName $varName -ContainerId $ContainerId
        }

        # Helper to add element to card or container
        function Add-ElementToCard {
            param(
                [string]$VarName,
                [string]$ContainerId = $null
            )

            $params = @("-Card `$card", "-Element `$$VarName")
            if ($ContainerId) {
                $params += "-ContainerId `"$ContainerId`""
            }

            Add-ScriptLine "Add-AMElement $($params -join ' ')"
        }
    }

    process {
        try {
            $cardObject = $Json | ConvertFrom-Json

            # Process the card
            Process-Card -CardObject $cardObject

            # Add export line
            Add-ScriptLine "`n# Export the card"
            Add-ScriptLine "`$cardJson = Export-AMCard -Card `$card"

            # Output the result
            if ($OutputPath) {
                $script:output | Out-File -FilePath $OutputPath -Force
                Write-Output "Script written to $OutputPath"
            }
            else {
                $script:output
            }
        }
        catch {
            Write-Error "Error processing JSON: $_"
        }
    }
}