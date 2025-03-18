function Export-AMCard {
    <#
    .SYNOPSIS
        Exports an Adaptive Card as JSON.

    .DESCRIPTION
        Converts an Adaptive Card object to JSON format for use in Actionable Messages.
        The function can output the JSON directly or save it to a file. It provides options
        for compressed output (no whitespace) or formatted output (with indentation) for
        better readability.

        This function does not modify the original card object.

    .PARAMETER Card
        The Adaptive Card object (hashtable) to convert to JSON.

    .PARAMETER Path
        Optional. The file path where the JSON should be saved.
        If not specified, the function will return the JSON as a string.

    .PARAMETER Compress
        Optional switch. When specified, produces compressed JSON with no whitespace.
        This is useful for production environments to reduce message size.
        When omitted, the JSON will be formatted with indentation for better readability.

    .EXAMPLE
        # Export a card as formatted JSON string
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
        Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Hello World")
        $json = Export-AMCard -Card $card

    .EXAMPLE
        # Export a card as compressed JSON string
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
        $json = Export-AMCard -Card $card -Compress

    .EXAMPLE
        # Save a card to a file
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
        Export-AMCard -Card $card -Path "C:\Cards\mycard.json"

    .EXAMPLE
        # Using pipeline input
        $card = New-AMCard -OriginatorId "1234567890" -Version "1.2"
        $card | Export-AMCard -Path "C:\Cards\mycard.json"

    .INPUTS
        System.Collections.Hashtable
        An Adaptive Card object created using New-AMCard and populated with elements.

    .OUTPUTS
        System.String
        When no Path is specified, returns the JSON representation of the card as a string.

    .NOTES
        When exporting cards for production use, consider using the -Compress switch to reduce
        the size of the JSON payload, especially for email delivery where size may be a concern.

        The function uses a high depth value (100) for JSON conversion to ensure that deeply
        nested card structures are properly serialized.

    .LINK
        https://docs.microsoft.com/en-us/outlook/actionable-messages/
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [hashtable]$Card,

        [Parameter()]
        [string]$Path,

        [Parameter()]
        [switch]$Compress
    )

    process {
        # Convert to JSON
        $jsonDepth = 100  # Ensure we can handle deeply nested structures
        $json = if ($Compress) {
            $Card | ConvertTo-Json -Depth $jsonDepth -Compress
        }
        else {
            $Card | ConvertTo-Json -Depth $jsonDepth
        }

        # Output or save the JSON
        if ($Path) {
            $json | Out-File -FilePath $Path -Encoding utf8
            Write-Verbose "Card exported to $Path"
        }
        else {
            return $json
        }
    }
}