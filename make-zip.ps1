# Packages the project into a clean zip for the teacher
# Run from the "school management" root folder:
#   powershell -ExecutionPolicy Bypass -File make-zip.ps1

$root  = Split-Path -Parent $MyInvocation.MyCommand.Path
$out   = Join-Path $root "school-management-for-teacher.zip"

# Remove old zip if it exists
if (Test-Path $out) { Remove-Item $out -Force }

# Folders and files to SKIP (build artifacts, secrets, caches)
$exclude = @(
    # .NET build output
    '*\bin\*', '*\obj\*',
    # Flutter build output
    '*\build\*', '*\.dart_tool\*', '*\.flutter-plugins*',
    # Android generated files (teacher rebuilds these)
    '*\android\.gradle\*', '*\android\local.properties',
    # Node / misc caches
    '*\node_modules\*',
    # Git internals
    '*\.git\*',
    # The zip itself
    '*school-management-for-teacher.zip'
)

Write-Host "Building file list..." -ForegroundColor Cyan

$files = Get-ChildItem -Path $root -Recurse -File | Where-Object {
    $path = $_.FullName
    $skip = $false
    foreach ($pattern in $exclude) {
        if ($path -like $pattern) { $skip = $true; break }
    }
    -not $skip
}

Write-Host "Found $($files.Count) files. Zipping..." -ForegroundColor Cyan

# Create the zip
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::Open($out, 'Create')
foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($root.Length + 1)
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
        $zip, $file.FullName, $relativePath,
        [System.IO.Compression.CompressionLevel]::Optimal
    ) | Out-Null
}
$zip.Dispose()

$sizeMB = [math]::Round((Get-Item $out).Length / 1MB, 1)
Write-Host ""
Write-Host "Done! Created: school-management-for-teacher.zip ($sizeMB MB)" -ForegroundColor Green
Write-Host ""
Write-Host "Teacher only needs to:" -ForegroundColor Yellow
Write-Host "  1. Install Docker Desktop"
Write-Host "  2. cd backend && docker compose up --build"
Write-Host "  3. Change baseUrl in frontend/lib/services/api_config.dart to their IP"
Write-Host "  4. flutter run"
