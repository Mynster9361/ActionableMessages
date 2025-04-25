function New-AMFactSet {
    <#
    .SYNOPSIS
        Creates a FactSet element for an Adaptive Card.

    .DESCRIPTION
        The `New-AMFactSet` function creates a FactSet element that displays a series of facts (key-value pairs) in a
        structured, two-column format. FactSets are ideal for displaying property lists, specifications, details, or
        any information that benefits from a label-value layout.

        The FactSet element automatically formats the facts in two columns, with titles in the left column (typically bold)
        and values in the right column. This layout ensures clarity and organization when presenting structured data.

        Facts must be created using the `New-AMFact` function before being passed to the `-Facts` parameter of this function.

    .PARAMETER Facts
        An array of fact objects created with `New-AMFact`. Each fact represents a key-value pair with a Title (key) and Value.

    .PARAMETER Id
        (Optional) A unique identifier for the FactSet. This can be useful when you need to reference this element in other
        parts of the card or target it with actions.

    .EXAMPLE
        # Create a simple employee information FactSet
        $facts = @(
            New-AMFact -Title "Employee" -Value "John Doe"
            New-AMFact -Title "Department" -Value "Engineering"
            New-AMFact -Title "Title" -Value "Senior Developer"
            New-AMFact -Title "Start Date" -Value "2020-01-15"
        )
        $factSet = New-AMFactSet -Facts $facts
        Add-AMElement -Card $card -Element $factSet

    .EXAMPLE
        # Create a product specification FactSet with ID
        $specs = @(
            New-AMFact -Title "Model" -Value "ThinkPad X1"
            New-AMFact -Title "Processor" -Value "Intel Core i7"
            New-AMFact -Title "Memory" -Value "16 GB"
            New-AMFact -Title "Storage" -Value "512 GB SSD"
        )
        $specSheet = New-AMFactSet -Facts $specs -Id "product-specs"

        # Add the FactSet to a container
        $container = New-AMContainer -Id "spec-container" -Style "emphasis"
        Add-AMElement -Card $card -Element $container
        Add-AMElement -Card $card -Element $specSheet -ContainerId "spec-container"

    .EXAMPLE
        # Create a FactSet for order details
        $orderFacts = @(
            New-AMFact -Title "Order Number" -Value "ORD-12345"
            New-AMFact -Title "Date" -Value (Get-Date -Format "yyyy-MM-dd")
            New-AMFact -Title "Status" -Value "**Shipped**"
            New-AMFact -Title "Total" -Value "$125.99"
        )
        $factSet = New-AMFactSet -Facts $orderFacts
        Add-AMElement -Card $card -Element $factSet

    .INPUTS
        None. You cannot pipe input to `New-AMFactSet`.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the FactSet element.

    .NOTES
        - FactSets are ideal for displaying structured information where clarity and organization are important.
        - Best practices for using FactSets:
          - Use concise titles that clearly identify the information.
          - Group related facts together in a single FactSet.
          - For very long lists, consider using multiple FactSets with headers.
        - FactSets render differently across different Adaptive Card hosts, so test your cards in the target environment.

    .LINK
        https://adaptivecards.io/explorer/FactSet.html
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$Facts,

        [Parameter()]
        [string]$Id
    )

    $factSet = [ordered]@{
        'type'  = 'FactSet'
        'facts' = $Facts
    }

    if ($Id) {
        $factSet.id = $Id
    }

    return $factSet
}