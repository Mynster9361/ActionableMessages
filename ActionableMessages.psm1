# ActionableMessages.psm1
# This file loads all the individual function files

# Get all public and private function definition files
$publicFolders = @('Core', 'Elements', 'Actions', 'Inputs', 'Prebuilt')
$publicFunctions = @()
foreach ($folder in $publicFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath "Public\$folder"
    if (Test-Path -Path $folderPath) {
        $publicFunctions += Get-ChildItem -Path $folderPath -Filter "*.ps1"
    }
}

$privatePath = Join-Path -Path $PSScriptRoot -ChildPath "Private"
$privateFunctions = @()
if (Test-Path -Path $privatePath) {
    $privateFunctions += Get-ChildItem -Path $privatePath -Filter "*.ps1"
}

# Dot source all files
foreach ($file in @($privateFunctions + $publicFunctions)) {
    try {
        . $file.FullName
        Write-Verbose "Imported $($file.FullName)"
    }
    catch {
        Write-Error "Failed to import function $($file.FullName): $_"
    }
}

# Export public functions
$functionsToExport = $publicFunctions | ForEach-Object { $_.BaseName }
Export-ModuleMember -Function $functionsToExport