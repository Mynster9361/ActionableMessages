function New-AMFact {
    <#
    .SYNOPSIS
        Creates a Fact object for use in a FactSet within an Adaptive Card.

    .DESCRIPTION
        Creates a key-value pair (fact) to be displayed in a FactSet element.
        Facts are used to display information in a structured, two-column format
        with labels on the left and values on the right.

        Multiple Fact objects are typically grouped together in a FactSet element
        created with New-AMFactSet to create a list of related information.

    .PARAMETER Title
        The label or name of the fact. This appears in the left column of the FactSet
        and is typically bold or emphasized in the rendered card.

    .PARAMETER Value
        The value or content of the fact. This appears in the right column of the FactSet,
        paired with the Title.

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

    .INPUTS
        None. You cannot pipe input to New-AMFact.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable with 'title' and 'value' properties.

    .NOTES
        Facts are designed to display in a two-column format and work best for structured
        data like properties, specifications, or details about an item or person.

        While Values can contain simple Markdown formatting (bold, italics, etc.),
        complex formatting may not render consistently across all Adaptive Card hosts.

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