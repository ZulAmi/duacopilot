# Improved PowerShell script to fix ALL withValues() calls to withOpacity() calls

$libPath = "j:\Programming\FlutterProject\duacopilot\lib"

Get-ChildItem -Path $libPath -Recurse -Filter "*.dart" | ForEach-Object {
    $file = $_.FullName
    Write-Host "Processing: $file"
    
    $content = Get-Content -Path $file -Raw
    $originalContent = $content
    
    # Replace single-line withValues calls  
    $content = $content -replace '\.withValues\(alpha:\s*([0-9.]+)\)', '.withOpacity($1)'
    
    # Replace multi-line withValues calls - common patterns
    $content = $content -replace '\.withValues\(\s*\r?\n\s*alpha:\s*([0-9.]+[^,\)]*)\s*\)', '.withOpacity($1)'
    $content = $content -replace '\.withValues\(\s*\r?\n\s*alpha:\s*([^,\)]+?)\s*\)', '.withOpacity($1)'
    
    # Replace withValues calls with expressions/variables
    $content = $content -replace '\.withValues\(\s*alpha:\s*([^,\)]+?)\s*\)', '.withOpacity($1)'
    
    # Replace remaining withValues( patterns (catch-all for multi-line)
    $content = $content -replace '\.withValues\(\s*\r?\n([^}]*?)alpha:\s*([^,\)]+?)\s*\)', '.withOpacity($2)'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file -Value $content -NoNewline
        Write-Host "  Updated: $file"
    }
}

Write-Host "Complete!"
