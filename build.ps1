# Build script for Actionable Messages module

# Define the module name
$moduleName = "ActionableMessages"

# Define the output directory for the build
$outputDir = "dist"

# Create the output directory if it doesn't exist
if (-Not (Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir
}

# Copy module files to the output directory
Copy-Item -Path "$moduleName\*.psd1" -Destination $outputDir -Force
Copy-Item -Path "$moduleName\*.psm1" -Destination $outputDir -Force
Copy-Item -Path "$moduleName\Public\*" -Destination "$outputDir\Public" -Recurse -Force
Copy-Item -Path "$moduleName\Private\*" -Destination "$outputDir\Private" -Recurse -Force
Copy-Item -Path "$moduleName\Examples\*" -Destination "$outputDir\Examples" -Recurse -Force
Copy-Item -Path "$moduleName\docs\*" -Destination "$outputDir\docs" -Recurse -Force

# Output build completion message
Write-Host "Build completed. Module files are located in the '$outputDir' directory." -ForegroundColor Green