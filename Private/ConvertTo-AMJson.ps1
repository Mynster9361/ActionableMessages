function ConvertTo-AMJson {
    <#
    .SYNOPSIS
        Converts an Adaptive Card object to properly formatted JSON.

    .DESCRIPTION
        The `ConvertTo-AMJson` function serializes an Adaptive Card object (hashtable) into JSON format.
        It ensures correct formatting and handles the deep nesting that can occur in complex Adaptive Cards.
        This function is primarily used by `Export-AMCard` but can also be used directly when needed.

        The function supports options for compact (compressed) JSON output, which is useful for production
        environments, and formatted JSON output, which is more readable for debugging and development.

    .PARAMETER Card
        The Adaptive Card object (hashtable) to convert to JSON. This object should be created using
        `New-AMCard` and populated with elements using other `New-AM*` functions.

    .PARAMETER Depth
        The maximum depth of nested objects to include in the JSON output.
        Default: 100
        This value should be sufficient for most Adaptive Cards, even those with deeply nested structures.

    .PARAMETER Compress
        When specified, removes whitespace and formatting from the JSON output to produce a more compact representation.
        This is useful for production environments where minimizing payload size is important.

    .EXAMPLE
        # Convert a card to formatted JSON
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
        $json = ConvertTo-AMJson -Card $card

    .EXAMPLE
        # Convert a card to compact JSON
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
        $json = ConvertTo-AMJson -Card $card -Compress

    .EXAMPLE
        # Convert a deeply nested card with a custom depth
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
        $json = ConvertTo-AMJson -Card $card -Depth 200

    .INPUTS
        System.Collections.Hashtable
        Accepts an Adaptive Card object (hashtable) as input.

    .OUTPUTS
        System.String
        Returns the JSON representation of the Adaptive Card as a string.

    .NOTES
        - This function uses the built-in `ConvertTo-Json` cmdlet with a high depth value to handle
          the complex structure of Adaptive Cards, including containers, actions, and deeply nested elements.
        - The `Compress` parameter is useful for reducing the size of the JSON payload, which is important
          when sending cards via email or other size-constrained environments.
        - Ensure that the Adaptive Card object passed to this function is properly structured and adheres
          to the Adaptive Card schema.

    .LINK
        https://adaptivecards.io/
        https://docs.microsoft.com/en-us/outlook/actionable-messages/
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