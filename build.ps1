# Build script for Actionable Messages module

# At the top, add parameters
param(
    [Parameter()]
    [ValidateSet('patch', 'minor', 'major')]
    [string]$VersionIncrement = 'patch',

    [Parameter()]
    [switch]$UpdateChangelog,

    [Parameter()]
    [switch]$ReleaseChangelog
)

# Define the module name
$moduleName = "ActionableMessages"

# Define the output directory for the build
$outputDir = "dist"

# Import ChangelogManagement if needed
if ($UpdateChangelog -or $ReleaseChangelog) {
    if (-not (Get-Module -Name ChangelogManagement -ListAvailable)) {
        Write-Host "Installing ChangelogManagement module..." -ForegroundColor Yellow
        Install-Module -Name ChangelogManagement -Scope CurrentUser -Force
    }
    Import-Module ChangelogManagement -Force
}

# Create changelog if it doesn't exist
if ($UpdateChangelog -or $ReleaseChangelog) {
    $changelogPath = Join-Path -Path $PSScriptRoot -ChildPath "CHANGELOG.md"

    if (-not (Test-Path -Path $changelogPath)) {
        Write-Host "Creating new CHANGELOG.md file..." -ForegroundColor Yellow
        $manifestPath = Join-Path -Path $PSScriptRoot -ChildPath "$moduleName.psd1"
        $moduleData = Import-PowerShellDataFile -Path $manifestPath
        $version = $moduleData.ModuleVersion
        New-Changelog -Path $changelogPath -Version $version -ReleaseStatus "Unreleased"
    }

    # Update version in module manifest if requested
    if ($VersionIncrement -ne '') {
        $manifestPath = Join-Path -Path $PSScriptRoot -ChildPath "$moduleName.psd1"
        $moduleData = Import-PowerShellDataFile -Path $manifestPath
        $currentVersion = [Version]$moduleData.ModuleVersion

        $newVersion = switch ($VersionIncrement) {
            'major' { [Version]::new($currentVersion.Major + 1, 0, 0) }
            'minor' { [Version]::new($currentVersion.Major, $currentVersion.Minor + 1, 0) }
            'patch' { [Version]::new($currentVersion.Major, $currentVersion.Minor, $currentVersion.Build + 1) }
        }

        # Update the module manifest
        Update-ModuleManifest -Path $manifestPath -ModuleVersion $newVersion

        Write-Host "Updated module version from $currentVersion to $newVersion" -ForegroundColor Green
    }

    # Release the changelog if requested
    if ($ReleaseChangelog) {
        $manifestPath = Join-Path -Path $PSScriptRoot -ChildPath "$moduleName.psd1"
        $moduleData = Import-PowerShellDataFile -Path $manifestPath
        $version = $moduleData.ModuleVersion

        Update-Changelog -Path $changelogPath -ReleaseVersion $version
        Write-Host "Released changelog for version $version" -ForegroundColor Green

        # Copy changelog to output directory
        Copy-Item -Path $changelogPath -Destination $outputDir -Force
    }
}

# Create the output directory if it doesn't exist
if (-Not (Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force
}

# Clean output directories if they exist
if (Test-Path -Path "$outputDir\Public") {
    Remove-Item -Path "$outputDir\Public" -Recurse -Force
}
if (Test-Path -Path "$outputDir\Private") {
    Remove-Item -Path "$outputDir\Private" -Recurse -Force
}

# Create necessary subdirectories
New-Item -ItemType Directory -Path "$outputDir\Public" -Force
New-Item -ItemType Directory -Path "$outputDir\Private" -Force
New-Item -ItemType Directory -Path "$outputDir\Examples" -Force
New-Item -ItemType Directory -Path "$outputDir\docs" -Force

# Copy module files to the output directory
Copy-Item -Path "*.psd1" -Destination $outputDir -Force
Copy-Item -Path "*.psm1" -Destination $outputDir -Force
Copy-Item -Path "Public\*" -Destination "$outputDir\Public" -Recurse -Force
Copy-Item -Path "Private\*" -Destination "$outputDir\Private" -Recurse -Force
Copy-Item -Path "Examples\*" -Destination "$outputDir\Examples" -Recurse -Force
Copy-Item -Path "docs\*" -Destination "$outputDir\docs" -Recurse -Force

# Output build completion message
Write-Host "Build completed. Module files are located in the '$outputDir' directory." -ForegroundColor Green