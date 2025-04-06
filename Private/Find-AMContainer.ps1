function Find-AMContainer {
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