function New-AMImageSet {
    <#
    .SYNOPSIS
        Creates an ImageSet element for an Adaptive Card.

    .DESCRIPTION
        Creates an ImageSet element that displays a collection of images in a grid layout.
        ImageSets are useful when you need to show multiple related images together, such as
        product galleries, photo collections, or thumbnails.

        The images are automatically arranged in a grid based on available space, and all
        images within the set share the same size.

    .PARAMETER Images
        An array of image URLs to include in the ImageSet. Each URL must point to a valid
        and accessible image file.

    .PARAMETER AltText
        Alternative text for the image set, providing a textual description for
        accessibility purposes. This alt text will be applied to all images in the set.
        Default: "Image Set"

    .EXAMPLE
        # Create a simple image set with three images
        $imageUrls = @(
            "https://example.com/product1.jpg",
            "https://example.com/product2.jpg",
            "https://example.com/product3.jpg"
        )

        $productGallery = New-AMImageSet -Images $imageUrls -AltText "Product Photos"
        Add-AMElement -Card $card -Element $productGallery

    .EXAMPLE
        # Create an image set from local files
        $baseUrl = "https://storage.contoso.com/images/"
        $fileNames = @("photo1.jpg", "photo2.jpg", "photo3.jpg", "photo4.jpg")
        $imageUrls = $fileNames | ForEach-Object { $baseUrl + $_ }

        $photoGallery = New-AMImageSet -Images $imageUrls -AltText "Vacation Photos"

    .INPUTS
        None. You cannot pipe input to New-AMImageSet.

    .OUTPUTS
        System.Collections.Hashtable
        Returns a hashtable representing the ImageSet element.

    .NOTES
        ImageSets are designed to display collections of similarly-sized images.
        For best results:

        - Use images of similar dimensions and aspect ratios
        - Keep the number of images reasonable (4-8 is typically optimal)
        - Remember that images will be resized to fit the layout
        - Ensure all image URLs are publicly accessible

    .LINK
        https://adaptivecards.io/explorer/ImageSet.html
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$Images,

        [string]$AltText = "Image Set"
    )

    $imageSet = @{
        type = "ImageSet"
        images = @()
        altText = $AltText
    }

    foreach ($image in $Images) {
        $imageSet.images += @{
            url = $image
            altText = $AltText
        }
    }

    return $imageSet
}

Export-ModuleMember -Function New-AMImageSet