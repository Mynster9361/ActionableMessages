function New-AMImage {
    <#
    .SYNOPSIS
        Creates an Image element for an Adaptive Card.

    .DESCRIPTION
        The `New-AMImage` function creates an Image element that displays an image within an Adaptive Card.
        Images can be used to display logos, photos, icons, diagrams, or any visual content
        that enhances the card's appearance and information.

        This function supports customization of image size, alternative text for accessibility, and style.
        Images should be hosted on publicly accessible servers to ensure they display correctly in all environments.

    .PARAMETER Url
        The URL to the image. This must be a valid and accessible URL that points to the image file.
        This parameter is required.

    .PARAMETER AltText
        Alternative text for the image, which provides a textual description of the image for
        accessibility purposes or in cases where the image cannot be displayed.

    .PARAMETER Size
        Controls the size of the image.
        Valid values: "auto", "stretch", "small", "medium", "large"
        Default: "auto"

        - "auto": Automatically adjusts the size based on the image's natural dimensions.
        - "stretch": Stretches the image to fill the available space.
        - "small", "medium", "large": Predefined sizes for consistent rendering.

    .PARAMETER Style
        Specifies the style of the image.
        Valid values: "default", "person"
        Default: "default"

        - "default": Standard image rendering.
        - "person": Circular cropping, typically used for profile pictures or avatars.

    .EXAMPLE
        # Create a simple image
        $logo = New-AMImage -Url "https://example.com/logo.png" -AltText "Company Logo"
        Add-AMElement -Card $card -Element $logo

    .EXAMPLE
        # Create a large image with alt text
        $banner = New-AMImage -Url "https://example.com/banner.jpg" -Size "large" -AltText "Product Banner"

    .EXAMPLE
        # Add an image to a container
        $icon = New-AMImage -Url "https://example.com/icon.png" -Size "small" -AltText "Alert Icon"
        $container = New-AMContainer -Id "alert-container" -Style "warning"

        Add-AMElement -Card $card -Element $container
        Add-AMElement -Card $card -Element $icon -ContainerId "alert-container"
        Add-AMElement -Card $card -Element (New-AMTextBlock -Text "Warning: Action required") -ContainerId "alert-container"

    .EXAMPLE
        # Create a circular profile picture
        $profilePicture = New-AMImage -Url "https://example.com/profile.jpg" -Style "person" -AltText "User Profile Picture"

    .INPUTS
        None. You cannot pipe input to `New-AMImage`.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the Image element.

    .NOTES
        - Images should be hosted on publicly accessible servers to ensure they display correctly.
        - Consider the following best practices:
          - Use appropriate image sizes to avoid slow loading times.
          - Always include descriptive alt text for accessibility.
          - Use smaller images for mobile viewing.
          - Be aware that some email clients may block external images by default.
        - The "person" style is ideal for profile pictures or avatars, as it applies circular cropping.

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
        [string]$Size = "auto",

        # implement style parameter to allow you to set the style Person should be a switch parameter
        [Parameter()]
        [ValidateSet("default", "person")]
        [string]$Style = "default"

    )

    if (-not $Url) {
        throw "The 'Url' parameter is required."
    }

    return @{
        type    = "Image"
        url     = $Url
        altText = $AltText
        size    = $Size
        style   = $Style
    }
}