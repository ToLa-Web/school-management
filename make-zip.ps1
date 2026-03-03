# Creates one clean zip of the entire project for the teacher
# Run from the project root:
#   powershell -ExecutionPolicy Bypass -File make-zip.ps1

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$out  = Join-Path $root "school-management.zip"
Add-Type -AssemblyName System.IO.Compression.FileSystem

if (Test-Path $out) { Remove-Item $out -Force }

$exclude = @(
    # Git
    '*\.git\*',
    # .NET build output
    '*\bin\*', '*\obj\*', '*\.vs\*',
    # Flutter build output
    '*\build\*', '*\.dart_tool\*',
    '*\.flutter-plugins', '*\.flutter-plugins-dependencies',
    '*\android\.gradle\*', '*\android\local.properties',
    '*\ios\Pods\*', '*\ios\.symlinks\*', '*\ios\Flutter\ephemeral\*',
    '*\macos\Pods\*', '*\macos\.symlinks\*', '*\macos\Flutter\ephemeral\*',
    # Node / Next.js
    '*\node_modules\*', '*\.next\*', '*\.turbo\*',
    # Lock files & misc
    '*.lock', '*.zip'
)

Write-Host "Scanning files..." -ForegroundColor Cyan
$files = Get-ChildItem -Path $root -Recurse -File | Where-Object {
    $path = $_.FullName
    $skip = $false
    foreach ($p in $exclude) { if ($path -like $p) { $skip = $true; break } }
    -not $skip
}

Write-Host "Packing $($files.Count) files..." -ForegroundColor Cyan
$zip = [System.IO.Compression.ZipFile]::Open($out, 'Create')
foreach ($file in $files) {
    $rel = $file.FullName.Substring($root.Length + 1)
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
        $zip, $file.FullName, $rel,
        [System.IO.Compression.CompressionLevel]::Optimal
    ) | Out-Null
}
$zip.Dispose()

$sizeMB = [math]::Round((Get-Item $out).Length / 1MB, 1)
Write-Host "Done! school-management.zip ($sizeMB MB)" -ForegroundColor Green
