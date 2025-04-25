function New-AMFact {
    <#
    .SYNOPSIS
        Creates a Fact object for use in a FactSet within an Adaptive Card.

    .DESCRIPTION
        The `New-AMFact` function creates a key-value pair (fact) to be displayed in a FactSet element.
        Facts are used to display information in a structured, two-column format with labels on the left
        and values on the right.

        Multiple Fact objects are typically grouped together in a FactSet element created with `New-AMFactSet`
        to create a list of related information.

        The `Title` parameter specifies the label or name of the fact, while the `Value` parameter specifies
        the content or data associated with the fact. This separation allows you to display structured information
        in a clear and organized manner.

    .PARAMETER Title
        The label or name of the fact. This appears in the left column of the FactSet
        and is typically bold or emphasized in the rendered card.

    .PARAMETER Value
        The value or content of the fact. This appears in the right column of the FactSet,
        paired with the Title. Values can include simple Markdown formatting (e.g., bold, italics).

    .EXAMPLE
        # Create a single fact
        $employeeFact = New-AMFact -Title "Employee" -Value "John Doe"

    .EXAMPLE
        # Create multiple facts for a person
        $personFacts = @(
            New-AMFact -Title "Name" -Value "Jane Smith"
            New-AMFact -Title "Title" -Value "Software Engineer"
            New-AMFact -Title "Department" -Value "R&D"
            New-AMFact -Title "Email" -Value "jane.smith@example.com"
        )

        # Add these facts to a FactSet
        $factSet = New-AMFactSet -Facts $personFacts
        Add-AMElement -Card $card -Element $factSet

    .EXAMPLE
        # Create facts with formatted values
        $orderFacts = @(
            New-AMFact -Title "Order Number" -Value "ORD-12345"
            New-AMFact -Title "Date" -Value (Get-Date -Format "yyyy-MM-dd")
            New-AMFact -Title "Status" -Value "**Shipped**"
            New-AMFact -Title "Total" -Value "$125.99"
        )

        # Add these facts to a FactSet
        $factSet = New-AMFactSet -Facts $orderFacts
        Add-AMElement -Card $card -Element $factSet

    .INPUTS
        None. You cannot pipe input to `New-AMFact`.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable with `title` and `value` properties.

    .NOTES
        - Facts are designed to display in a two-column format and work best for structured
          data like properties, specifications, or details about an item or person.
        - While `Value` can contain simple Markdown formatting (e.g., bold, italics),
          complex formatting may not render consistently across all Adaptive Card hosts.
        - Facts are typically grouped together in a FactSet using the `New-AMFactSet` function.

    .LINK
        https://adaptivecards.io/explorer/FactSet.html
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    return [ordered]@{
        'title' = $Title
        'value' = $Value
    }
}