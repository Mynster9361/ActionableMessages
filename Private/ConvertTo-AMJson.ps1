function ConvertTo-AMJson {
    <#
    .SYNOPSIS
        Converts an Adaptive Card object to properly formatted JSON.

    .DESCRIPTION
        Specialized JSON converter for Adaptive Cards that ensures correct formatting and handles the
        deep nesting that can occur in complex cards. This function is primarily used by Export-AMCard
        but can be used directly when needed.

    .PARAMETER Card
        The Adaptive Card object (hashtable) to convert to JSON.

    .PARAMETER Depth
        The maximum depth of nested objects to include in the JSON output.
        Default is 100, which should be sufficient for most Adaptive Cards.

    .PARAMETER Compress
        When specified, removes whitespace from the JSON output to produce a more compact representation.
        Useful for production environments, but less readable for debugging.

    .EXAMPLE
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
        $json = ConvertTo-AMJson -Card $card

    .EXAMPLE
        $json = ConvertTo-AMJson -Card $card -Compress

    .INPUTS
        System.Collections.Hashtable

    .OUTPUTS
        System.String

    .NOTES
        This function handles the serialization of Adaptive Card objects to JSON format.
        It is designed to properly handle the complex structure of Adaptive Cards including
        containers, actions, and deeply nested elements.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$Card,

        [Parameter()]
        [int]$Depth = 100,

        [Parameter()]
        [switch]$Compress
    )

    # For now, just use standard ConvertTo-Json with high depth
    # This can be enhanced later to handle special cases specific to cards
    if ($Compress) {
        return $Card | ConvertTo-Json -Depth $Depth -Compress
    }
    else {
        return $Card | ConvertTo-Json -Depth $Depth
    }
}