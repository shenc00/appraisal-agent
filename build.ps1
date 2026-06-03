# Packages appPackage/ into dist/appraisal-agent.zip for upload to Microsoft 365 Copilot.
# The zip must contain manifest.json, declarativeAgent.json, and the icons at its ROOT.

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$pkg  = Join-Path $root 'appPackage'
$dist = Join-Path $root 'dist'
$zip  = Join-Path $dist 'appraisal-agent.zip'

if (-not (Test-Path $pkg)) { throw "appPackage folder not found at $pkg" }

# Basic validation: required files present
foreach ($f in 'manifest.json','declarativeAgent.json','color.png','outline.png') {
    if (-not (Test-Path (Join-Path $pkg $f))) { throw "Missing required file: appPackage\$f" }
}

if (-not (Test-Path $dist)) { New-Item -ItemType Directory -Path $dist | Out-Null }
if (Test-Path $zip) { Remove-Item $zip -Force }

# Zip the CONTENTS of appPackage (so manifest.json is at the zip root)
Compress-Archive -Path (Join-Path $pkg '*') -DestinationPath $zip -Force

Write-Host "Built: $zip" -ForegroundColor Green
