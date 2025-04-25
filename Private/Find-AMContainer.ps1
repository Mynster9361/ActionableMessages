function Find-AMContainer {
    <#
    .SYNOPSIS
        Finds a container element by its ID within a collection of Adaptive Card elements.

    .DESCRIPTION
        The `Find-AMContainer` function searches through a collection of Adaptive Card elements to locate a container
        element with a specific ID. The search is recursive, meaning it will traverse nested containers to find the
        target element.

        If the container with the specified ID is found, it is returned via the `FoundContainer` parameter, and the
        function returns `$true`. If the container is not found, the function returns `$false`.

        This function is useful for dynamically locating and modifying specific containers in complex Adaptive Card
        structures.

    .PARAMETER Elements
        An array of Adaptive Card elements to search through. These elements can include containers, text blocks,
        images, or other Adaptive Card components.

    .PARAMETER Id
        The unique identifier of the container to find. This ID should match the `id` property of the target container.

    .PARAMETER FoundContainer
        A reference parameter that will hold the found container if the search is successful. If the container is not
        found, this parameter will remain unchanged.

    .EXAMPLE
        # Define a collection of elements
        $elements = @(
            @{ id = "container1"; type = "Container"; items = @() },
            @{ id = "container2"; type = "Container"; items = @(
                @{ id = "nestedContainer"; type = "Container"; items = @() }
            )}
        )

        # Search for a container by ID
        $foundContainer = $null
        $result = Find-AMContainer -Elements $elements -Id "nestedContainer" -FoundContainer ([ref]$foundContainer)

        if ($result) {
            Write-Output "Container found: $($foundContainer.id)"
        } else {
            Write-Output "Container not found."
        }

    .INPUTS
        System.Array
        Accepts an array of Adaptive Card elements as input.

    .OUTPUTS
        System.Boolean
        Returns `$true` if the container with the specified ID is found, otherwise `$false`.

    .NOTES
        - This function uses recursion to search through nested containers.
        - Ensure that the `Elements` parameter contains valid Adaptive Card elements with an `id` property.
        - The `FoundContainer` parameter must be passed as a `[ref]` type to capture the found container.

    .LINK
        https://adaptivecards.io/
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Elements,

        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [ref]$FoundContainer
    )

    foreach ($element in $Elements) {
        if ($element.id -eq $Id) {
            $FoundContainer.Value = $element
            return $true
        }

        # Recursively check inside containers
        if ($element.ContainsKey('items') -and $element.items) {
            $found = Find-AMContainer -Elements $element.items -Id $Id -FoundContainer $FoundContainer
            if ($found) { return $true }
        }
    }

    return $false
}