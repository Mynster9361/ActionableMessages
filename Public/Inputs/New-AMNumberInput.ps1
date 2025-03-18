function New-AMNumberInput {
    <#
    .SYNOPSIS
        Creates a Number Input element for an Adaptive Card.

    .DESCRIPTION
        Creates an Input.Number element that allows users to enter or select a numeric value.
        Number inputs are useful when you need to collect quantities, ratings, scores, or any
        other numeric data from users. The input can be configured with minimum and maximum
        values.

    .PARAMETER Id
        A unique identifier for the input element. This ID will be used when the card is submitted
        to identify the numeric value entered by the user.

    .PARAMETER Max
        Optional maximum allowed numeric value. Users will not be able to enter a value above this.

    .PARAMETER Min
        Optional minimum allowed numeric value. Users will not be able to enter a value below this.

    .PARAMETER Placeholder
        Optional text to display when no value has been entered.

    .PARAMETER Value
        Optional default numeric value for the input. If not specified, the field will be empty.

    .EXAMPLE
        # Create a simple number input
        $quantityInput = New-AMNumberInput -Id "quantity"
        Add-AMElement -Card $card -Element $quantityInput

    .EXAMPLE
        # Create a number input with range constraints
        $ratingInput = New-AMNumberInput -Id "rating" `
            -Min "1" -Max "10" -Value "5" -Placeholder "Enter rating (1-10)"

    .EXAMPLE
        # Create a quantity selector with default value
        $quantityInput = New-AMNumberInput -Id "quantity" `
            -Min "1" -Max "100" -Value "1" -Placeholder "Enter quantity"

    .INPUTS
        None. You cannot pipe input to New-AMNumberInput.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Input.Number element.

    .NOTES
        Number inputs in Adaptive Cards will typically render as a text field that only accepts
        numeric values. Some clients may show increment/decrement buttons depending on the
        min and max values provided.

        Values are submitted as strings, so you'll need to convert them to numeric types
        when processing the card data.

    .LINK
        https://adaptivecards.io/explorer/Input.Number.html
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter()]
        [string]$Max = '',

        [Parameter()]
        [string]$Min = '',

        [Parameter()]
        [string]$Placeholder = '',

        [Parameter()]
        [string]$Value = ''
    )

    $input = @{
        type       = 'Input.Number'
        id         = $Id
        max        = $Max
        min        = $Min
        placeholder = $Placeholder
        value      = $Value
    }

    return $input
}

Export-ModuleMember -Function New-AMNumberInput