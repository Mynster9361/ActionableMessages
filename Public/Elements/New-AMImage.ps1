function New-AMImage {
    <#
    .SYNOPSIS
        Creates an Image element for an Adaptive Card.

    .DESCRIPTION
        Creates an Image element that displays an image within an Adaptive Card.
        Images can be used to display logos, photos, icons, diagrams, or any visual content
        that enhances the card's appearance and information.

    .PARAMETER Url
        The URL to the image. This must be a valid and accessible URL that points to the image file.
        Required parameter.

    .PARAMETER AltText
        Alternative text for the image, which provides a textual description of the image for
        accessibility purposes or in cases where the image cannot be displayed.

    .PARAMETER Size
        Controls the size of the image.
        Valid values: "Auto", "Stretch", "Small", "Medium", "Large"
        Default: "Medium"

    .EXAMPLE
        # Create a simple image
        $logo = New-AMImage -Url "https://example.com/logo.png" -AltText "Company Logo"
        Add-AMElement -Card $card -Element $logo

    .EXAMPLE
        # Create a large image with alt text
        $banner = New-AMImage -Url "https://example.com/banner.jpg" -Size "Large" -AltText "Product Banner"

    .EXAMPLE
        # Add an image to a container
        $icon = New-AMImage -Url "https://example.com/icon.png" -Size "Small" -AltText "Alert Icon"
        $container = New-AMContainer -Id "alert-container" -Style "warning"

        Add-AMElement -Card $card -Element $container
        Add-AMElement -Card $card -Element $icon -ContainerId "alert-container"
        Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Warning: Action required") -ContainerId "alert-container"

    .INPUTS
        None. You cannot pipe input to New-AMImage.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Image element.

    .NOTES
        Images should be hosted on publicly accessible servers to ensure they display correctly.
        Consider the following best practices:

        - Use appropriate image sizes to avoid slow loading times
        - Always include descriptive alt text for accessibility
        - Consider using smaller images for mobile viewing
        - Remember that some email clients may block external images by default

    .LINK
        https://adaptivecards.io/explorer/Image.html
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter()]
        [string]$AltText,

        [Parameter()]
        [ValidateSet("auto", "stretch", "small", "medium", "large")]
        [string]$Size = "auto"
    )

    if (-not $Url) {
        throw "The 'Url' parameter is required."
    }

    return @{
        type = "Image"
        url = $Url
        altText = $AltText
        size = $Size
    }
}

Export-ModuleMember -Function New-AMImage