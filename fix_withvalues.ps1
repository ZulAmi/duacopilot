# PowerShell script to fix all withValues() calls to withOpacity() calls

$libPath = "j:\Programming\FlutterProject\duacopilot\lib"

Get-ChildItem -Path $libPath -Recurse -Filter "*.dart" | ForEach-Object {
    $file = $_.FullName
    Write-Host "Processing: $file"
    
    $content = Get-Content -Path $file -Raw
    $originalContent = $content
    
    # Replace single-line withValues calls
    $content = $content -replace '\.withValues\(alpha:\s*([0-9.]+)\)', '.withOpacity($1)'
    
    # Replace multi-line withValues calls (most common pattern)
    $content = $content -replace '\.withValues\(\s*\r?\n\s*alpha:\s*([0-9.]+)\s*\)', '.withOpacity($1)'
    
    # Replace withValues calls with variable parameters
    $content = $content -replace '\.withValues\(\s*\r?\n\s*alpha:\s*([^,\)]+)\s*\)', '.withOpacity($1)'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file -Value $content -NoNewline
        Write-Host "  Updated: $file"
    }
}

Write-Host "Complete!"
