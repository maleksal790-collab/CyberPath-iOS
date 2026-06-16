$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..")
Set-Location $root

$requiredFiles = @(
  "CyberPath.xcodeproj\project.pbxproj",
  "CyberPath.xcodeproj\xcshareddata\xcschemes\CyberPath.xcscheme",
  "CyberPath\CyberPathApp.swift",
  "CyberPath\ContentView.swift",
  "CyberPath\Models.swift",
  "CyberPath\CyberPathData.swift",
  "CyberPath\ProgressStore.swift",
  "CyberPath\Assets.xcassets\Contents.json",
  "CyberPath\Assets.xcassets\AppIcon.appiconset\Contents.json",
  "CyberPath\Assets.xcassets\AccentColor.colorset\Contents.json",
  "docs\governance\DELIVERY_PIPELINE.md",
  "docs\governance\QUALITY_GATES.md",
  "docs\governance\TEST_STRATEGY.md",
  "docs\governance\SECURITY_PRIVACY.md",
  "docs\governance\TRACEABILITY_MATRIX.md",
  "docs\governance\RELEASE_PROCESS.md",
  "docs\governance\RISK_REGISTER.md",
  "docs\governance\ACCEPTANCE_CHECKLIST.md",
  "docs\governance\APP_STORE_CONNECT_DEPLOYMENT.md",
  "docs\governance\PRIVACY_NUTRITION.md",
  "docs\governance\RELEASE_NOTES.md",
  "ExportOptions-AppStore.plist"
)

foreach ($file in $requiredFiles) {
  if (-not (Test-Path $file)) {
    throw "Missing required file: $file"
  }
}

$iconCount = (Get-ChildItem "CyberPath\Assets.xcassets\AppIcon.appiconset" -Filter "*.png").Count
if ($iconCount -ne 10) {
  throw "Expected 10 app icon PNG files, found $iconCount"
}

$textScanInputs = @("CyberPath", "scripts", "docs", ".github", "README.md", "IOS_HANDOFF.md", "COMPLETION_STATUS.md")
$textScanFiles = foreach ($inputPath in $textScanInputs) {
  if (Test-Path $inputPath -PathType Container) {
    Get-ChildItem $inputPath -Recurse -File
  } elseif (Test-Path $inputPath -PathType Leaf) {
    Get-Item $inputPath
  }
}
$textScanFiles = $textScanFiles | Where-Object { $_.Name -notin @("validate_structure.sh", "validate_structure.ps1") }
$unfinished = $textScanFiles | Select-String -Pattern "TODO|FIXME" -ErrorAction SilentlyContinue
if ($unfinished) {
  $unfinished | ForEach-Object { Write-Error "$($_.Path):$($_.LineNumber): $($_.Line)" }
  throw "Blocked unfinished marker found."
}

$unsafeSwift = Select-String -Path "CyberPath\*.swift" -Pattern "fatalError|try!|as!" -ErrorAction SilentlyContinue
if ($unsafeSwift) {
  $unsafeSwift | ForEach-Object { Write-Error "$($_.Path):$($_.LineNumber): $($_.Line)" }
  throw "Blocked unsafe Swift pattern found."
}

$secretScan = Get-ChildItem -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch "\\.git\\" } |
  Where-Object { $_.Name -notin @("validate_structure.sh", "validate_structure.ps1") } |
  Select-String -Pattern "BEGIN CERTIFICATE|BEGIN .*PRIVATE KEY" -ErrorAction SilentlyContinue
if ($secretScan) {
  $secretScan | ForEach-Object { Write-Error "$($_.Path):$($_.LineNumber): $($_.Line)" }
  throw "Potential signing secret committed to source."
}

Write-Output "CyberPath iOS governed structure validation passed."
