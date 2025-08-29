# Fix all deprecated withOpacity usages by converting to withValues(alpha: ...)
# Creates a backup copy of each modified file with .bak extension (once per file on first change)

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$libPath = Join-Path (Split-Path $projectRoot) 'lib'

Write-Host "Scanning for .withOpacity(... ) usages under: $libPath" -ForegroundColor Cyan

$dartFiles = Get-ChildItem -Path $libPath -Recurse -Include *.dart
$total = 0
$modified = 0

# Regex to match .withOpacity( <number or expression> )
$regex = '\.withOpacity\(([^\)]+)\)'

foreach ($file in $dartFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    if ($content -match $regex) {
        $total++
        $newContent = [System.Text.RegularExpressions.Regex]::Replace($content, $regex, { param($m) ".withValues(alpha: $($m.Groups[1].Value))" })
        if ($newContent -ne $content) {
            $backup = "$($file.FullName).bak"
            if (-not (Test-Path $backup)) {
                Copy-Item $file.FullName $backup
            }
            Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
            $modified++
            Write-Host "Updated: $($file.FullName)" -ForegroundColor Green
        }
    }
}

Write-Host "---" -ForegroundColor Yellow
Write-Host "Files containing deprecated calls: $total" -ForegroundColor Yellow
Write-Host "Files modified: $modified" -ForegroundColor Yellow
Write-Host "Done. Run 'flutter analyze' to verify." -ForegroundColor Cyan
