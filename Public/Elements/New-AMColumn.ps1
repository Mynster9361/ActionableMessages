function New-AMColumn {
    <#
    .SYNOPSIS
        Creates a Column element for use in ColumnSets within an Adaptive Card.

    .DESCRIPTION
        The `New-AMColumn` function creates a Column object that can be used in a ColumnSet to create multi-column layouts.
        Columns can contain any number of items and help organize content horizontally.
        Multiple columns are typically grouped together in a ColumnSet element created with `New-AMColumnSet`.

        Columns are flexible and can be customized with width, vertical alignment, and content. They are essential
        for creating visually appealing and organized Adaptive Cards.

    .PARAMETER Width
        Specifies the width of the column. This can be:
        - An absolute pixel value (e.g., "50px")
        - A relative weight (e.g., "2")
        - "auto" to automatically size based on content
        - "stretch" to fill available space

        Default: "auto"

    .PARAMETER VerticalContentAlignment
        Controls how the content is vertically aligned within the column.
        Valid values: "top", "center", "bottom"

        Default: "top"

    .PARAMETER Items
        An array of elements to place inside the column. These should be created using
        other `New-AM*` functions like `New-AMTextBlock`, `New-AMImage`, etc.

        Default: empty array (@())

    .EXAMPLE
        # Create a simple column with text
        $column = New-AMColumn -Width "1" -Items @(
            (New-AMTextBlock -Text "Column 1 Content" -Wrap $true)
        )

    .EXAMPLE
        # Create multiple columns for use in a ColumnSet
        $leftColumn = New-AMColumn -Width "auto" -Items @(
            (New-AMImage -Url "https://example.com/profile.jpg" -Size "Small")
        )

        $rightColumn = New-AMColumn -Width "stretch" -Items @(
            (New-AMTextBlock -Text "John Doe" -Size "Medium" -Weight "Bolder"),
            (New-AMTextBlock -Text "Software Developer" -Spacing "None")
        )

        # Combine columns into a ColumnSet
        $columnSet = New-AMColumnSet -Columns @($leftColumn, $rightColumn)

    .EXAMPLE
        # Create a three-column layout with vertical alignment
        $col1 = New-AMColumn -Width "1" -VerticalContentAlignment "top" -Items @(
            (New-AMTextBlock -Text "Top Aligned")
        )

        $col2 = New-AMColumn -Width "1" -VerticalContentAlignment "center" -Items @(
            (New-AMTextBlock -Text "Center Aligned")
        )

        $col3 = New-AMColumn -Width "1" -VerticalContentAlignment "bottom" -Items @(
            (New-AMTextBlock -Text "Bottom Aligned")
        )

        $columnSet = New-AMColumnSet -Columns @($col1, $col2, $col3)

    .INPUTS
        None. You cannot pipe input to `New-AMColumn`.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Column element.

    .NOTES
        - Columns must be used within a ColumnSet. To create a multi-column layout:
          1. Create individual columns using `New-AMColumn`.
          2. Combine them using `New-AMColumnSet`.
          3. Add the ColumnSet to your card with `Add-AMElement`.
        - Width values can be:
          - "auto" - Column uses minimum width needed for its content.
          - "stretch" - Column stretches to fill available width.
          - Pixel value (e.g., "50px") - Fixed width in pixels.
          - Numeric proportion (e.g., "1", "2") - Relative width compared to other columns.

    .LINK
        https://adaptivecards.io/explorer/Column.html
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Width = "auto",

        [Parameter()]
        [ValidateSet("top", "center", "bottom")]
        [string]$VerticalContentAlignment = "top",

        [Parameter()]
        [array]$Items = @()
    )

    $column = @{
        type                     = "Column"
        width                    = $Width
        verticalContentAlignment = $VerticalContentAlignment
        items                    = $Items
    }

    return $column
}
