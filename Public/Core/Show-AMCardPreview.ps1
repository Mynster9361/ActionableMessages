function Show-AMCardPreview {
    <#
    .SYNOPSIS
    Displays an ASCII preview of an Adaptive Card in the terminal.

    .DESCRIPTION
    The `Show-AMCardPreview` function takes an Adaptive Card object as input and renders an ASCII representation of the card in the terminal.
    It dynamically adjusts the width of the preview based on the terminal size and supports nested containers, columns, and various card elements.

    .PARAMETER card
    The Adaptive Card object to be rendered. This parameter is mandatory.

    .EXAMPLE
    # Example 1: Render an application usage survey card
    $appCardParams = @{
        OriginatorId      = "your-originator-id"
        ApplicationName   = "Adobe Creative Cloud"
        Version           = "2023"
        Vendor            = "Adobe"
        LicenseCount      = 50
        ActiveUserCount   = 32
        RenewalDate       = (Get-Date).AddMonths(3)
        Department        = "IT Software Asset Management"
        TicketNumber      = "SAM-2023-003"
        Description       = "The IT department is conducting a review of software licenses and usage. Please provide information about your use of this application to help us optimize licensing costs and ensure continued access for essential business functions."
        FrequencyChoices  = [ordered]@{
            "daily" = "Daily"
            "weekly" = "Several times per week"
            "monthly" = "Few times per month"
            "rarely" = "Rarely (a few times per year)"
            "never" = "Never"
        }
        ImportanceChoices = [ordered]@{
            "critical" = "Critical - Cannot perform job without it"
            "important" = "Important - Major impact if unavailable"
            "useful" = "Useful - Improves efficiency but have workarounds"
            "optional" = "Optional - Nice to have but not essential"
            "unnecessary" = "Unnecessary - Could work without it"
        }
        AlternativeQuestion = $true
        TeamMemberUsage    = $true
        Suggestion         = $true
        ResponseEndpoint   = "https://api.example.com/application-usage"
        ResponseBody       = "{`"ticketNumber`": `"$TicketNumber`", `"applicationName`": `"$ApplicationName`", `"version`": `"$Version`", `"usageFrequency`": `"{{usage-frequency.value}}`", `"businessFunction`": `"{{business-function.value}}`", `"usedFeatures`": `"{{used-features.value}}`", `"importanceRating`": `"{{importance-rating.value}}`", `"alternativesAware`": `"{{alternatives-aware.value}}`", `"alternativesDetails`": `"{{alternatives-details.value}}`", `"teamUsage`": `"{{team-usage.value}}`", `"improvementSuggestions`": `"{{improvement-suggestions.value}}`}"`
    }

    $card = New-AMApplicationUsageSurveyCard @appCardParams
    $cardJson = Export-AMCard -Card $card
    Show-CardPreview -Card $card

    This example renders an application usage survey card with various input fields and options.

    .EXAMPLE
    # Example 2: Render a system notification card
    $notificationParams = @{
        OriginatorId = "your-originator-id"
        Title        = "System Notification"
        Message      = "The nightly backup completed successfully."
        Severity     = "Good"
        Details      = "Backup completed at 02:00 AM. No errors were encountered."
        DetailsUrl   = "https://example.com/backup-report"
    }

    $notificationCard = New-AMNotificationCard @notificationParams
    $cardJson = Export-AMCard -Card $notificationCard
    Show-CardPreview -Card $notificationCard

    This example renders a system notification card with a success message and a link to view details.

    .NOTES
    - The function dynamically adjusts the width of the preview based on the terminal size.
    - The card object must be in a format compatible with Adaptive Cards.

    .LINK
    https://adaptivecards.io
    #>
    param (
        [Parameter(Mandatory)]
        $card
    )

    # Helper function to center text within a given width
    function Center-Text {
        param (
            [string]$Text,
            [int]$Width
        )
        $padding = [math]::Max(0, ($Width - $Text.Length) / 2)
        return (" " * [math]::Floor($padding)) + $Text + (" " * [math]::Ceiling($padding))
    }

    # Recursive function to process elements with indentation
    function Process-Elements {
        param (
            [array]$Elements,
            [int]$CardWidth,
            [int]$IndentLevel = 0
        )

        $output = @()
        $indent = " " * ($IndentLevel * 4) # Indent by 4 spaces per level

        foreach ($element in $Elements) {
            switch ($element.type) {
                "TextBlock" {
                    $output += "║ " + $indent + $element.text.PadRight($CardWidth - 4 - ($IndentLevel * 4))
                }
                "Image" {
                    $output += "║ " + $indent + "[Image: $($element.altText)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                }
                "ImageSet" {
                    $output += "║ " + $indent + "[ImageSet]"
                    foreach ($image in $element.images) {
                        $output += "║ " + $indent + "    [Image: $($image.altText)]".PadRight($CardWidth - 8 - ($IndentLevel * 4))
                    }
                }
                "FactSet" {
                    $output += "║ " + $indent + "[FactSet]"
                    foreach ($fact in $element.facts) {
                        $output += "║ " + $indent + "    $($fact.title): $($fact.value)".PadRight($CardWidth - 8 - ($IndentLevel * 4))
                    }
                }
                "Input.Text" {
                    $output += "║ " + $indent + "[Input.Text: $($element.label)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                }
                "Input.Number" {
                    $output += "║ " + $indent + "[Input.Number: $($element.placeholder)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                }
                "Input.Date" {
                    $output += "║ " + $indent + "[Input.Date: $($element.label)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                }
                "Input.Time" {
                    $output += "║ " + $indent + "[Input.Time: $($element.label)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                }
                "Input.ChoiceSet" {
                    $output += "║ " + $indent + "[Input.ChoiceSet: $($element.label)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                    foreach ($choice in $element.choices) {
                        $output += "║ " + $indent + "    O $($choice.title)".PadRight($CardWidth - 8 - ($IndentLevel * 4))
                    }
                }
                "Input.Toggle" {
                    $output += "║ " + $indent + "[Input.Toggle: $($element.title)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                }
                "Container" {
                    $output += "║ " + $indent + "[Container: $($element.id)]"
                    if ($element.items) {
                        $output += Process-Elements -Elements $element.items -CardWidth $CardWidth -IndentLevel ($IndentLevel + 1)
                    }
                }
                "ColumnSet" {
                    $output += "║ " + $indent + "[ColumnSet]"
                    $columns = $element.columns
                    $columnWidth = [math]::Floor(($CardWidth - 4) / $columns.Count)

                    # Collect rows for each column
                    $columnRows = @()
                    foreach ($column in $columns) {
                        $rows = @()
                        foreach ($item in $column.items) {
                            if ($item.type -eq "TextBlock") {
                                $rows += $item.text.PadRight($columnWidth)
                            }
                        }
                        $columnRows += , $rows
                    }

                    # Combine rows from all columns
                    $maxRows = ($columnRows | Measure-Object Length -Maximum).Maximum
                    for ($i = 0; $i -lt $maxRows; $i++) {
                        $row = ""
                        foreach ($column in $columnRows) {
                            $row += ($column[$i] -ne $null ? $column[$i] : "").PadRight($columnWidth)
                        }
                        $output += "║ " + $indent + "    " + $row.PadRight($CardWidth - 8 - ($IndentLevel * 4))
                    }
                }
                "ActionSet" {
                    foreach ($action in $element.actions) {
                        switch ($action.type) {
                            "Action.OpenUrl" {
                                $output += "║ " + $indent + "[OpenUrl: $($action.title)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                            }
                            "Action.ShowCard" {
                                $output += "║ " + $indent + "[ShowCard: $($action.title)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                                if ($action.card) {
                                    $output += Process-Elements -Elements $action.card.body -CardWidth $CardWidth -IndentLevel ($IndentLevel + 1)
                                }
                            }
                            "Action.Execute" {
                                $output += "║ " + $indent + "[Execute: $($action.title)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                            }
                            "Action.ToggleVisibility" {
                                $output += "║ " + $indent + "[ToggleVisibility: $($action.title)]".PadRight($CardWidth - 4 - ($IndentLevel * 4))
                            }
                        }
                    }
                }
            }
        }

        return $output
    }

    # Get the terminal width dynamically
    $CardWidth = [math]::Min([Console]::WindowWidth, 200) - 6 # Limit to 200 max for readability -6 to have enough space for borders
    $CardWidth = [math]::Max($CardWidth, 80) # Ensure a minimum width of 80


    # Parse the JSON into a PowerShell object
    $CardJson = Export-AMCard -Card $card
    $card = $CardJson | ConvertFrom-Json

    # Start building the ASCII preview
    $preview = @()
    $preview += "╔" + ("═" * ($cardWidth - 2)) + "╗"
    $preview += "║ " + (" " * ($cardWidth - 4))

    # Process all elements in the card body
    $preview += Process-Elements -Elements $card.body -CardWidth $cardWidth

    $preview += "╚" + ("═" * ($cardWidth - 2)) + "╝"

    # Output the preview
    $preview | ForEach-Object { Write-Host $_ }
    if ([Console]::WindowWidth -le 85) {
        Write-Warning "The terminal width is too small to display the card preview properly. Please increase the terminal width to get the best result."
    }
}
