# Safe Arabic text corruption fixer
# This script ONLY replaces corrupted Arabic text patterns with correct Arabic text
# It does NOT modify any code structure, only text content

# Define corrupted pattern to correct Arabic mapping
$ArabicFixes = @{
    # Common corrupted patterns
    'Ø¨ÙØ³Ù'Ù…Ù Ø§Ù„Ù„ÙŽÙ'Ù‡Ù Ø§Ù„Ø±ÙŽÙ'Ø­Ù'Ù…ÙŽÙ†Ù Ø§Ù„Ø±ÙŽÙ'Ø­ÙÙŠÙ…Ù' = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'
    'Ø§Ù„ÙÙ‚Ù‡ Ø§Ù„Ø¥Ø³Ù„Ø§Ù…ÙŠ' = 'الفقه الإسلامي'
    'Ø§Ù„Ù‚Ø±Ø¢Ù† Ø§Ù„ÙƒØ±ÙŠÙ…' = 'القرآن الكريم'
    'Ø§Ù„Ø£Ø­Ø§Ø¯ÙŠØ« Ø§Ù„Ù†Ø¨ÙˆÙŠØ©' = 'الأحاديث النبوية'
    'Ø§Ù„Ø£Ø¯Ø¹ÙŠØ©' = 'الأدعية'
    'ØµØ¨Ø§Ø­' = 'صباح'
    'Ø£Ø°ÙƒØ§Ø± Ø§Ù„ØµØ¨Ø§Ø­' = 'أذكار الصباح'
    'Ø¯Ø¹Ø§Ø¡ Ø§Ù„Ø³ÙØ±' = 'دعاء السفر'
    'Ø³ÙØ±' = 'سفر'
    'Ø§Ù„Ø¨Ø­Ø« Ø§Ù„Ø¥Ø³Ù„Ø§Ù…ÙŠ' = 'البحث الإسلامي'
    'Ø§Ø³ØªØºÙØ§Ø±' = 'استغفار'
    'Ø¥Ø±Ø´Ø§Ø¯ Ø¥Ø³Ù„Ø§Ù…ÙŠ' = 'إرشاد إسلامي'
    
    # Allah variations
    'Ø§Ù„Ù„Û' = 'الله'
    'Ø§Ù„Ù„Ù‡' = 'الله'
    
    # Prayer-related terms
    'ØµÙ„Ø§Ø©' = 'صلاة'
    'Ø¯Ø¹Ø§Ø¡' = 'دعاء'
    'Ø°Ú©Ø±' = 'ذكر'
    'Ø­Ø¬' = 'حج'
    'Ø±Ù…Ø¶Ø§Ù†' = 'رمضان'
    'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡' = 'بسم الله'
    'Ø§Ù„Ø­Ù…Ø¯ Ù„Ù„Ù‡' = 'الحمد لله'
    'Ø³Ø¨Ø­Ø§Ù† Ø§Ù„Ù„Ù‡' = 'سبحان الله'
    'Ø§Ø³ØªØºÙØ± Ø§Ù„Ù„Ù‡' = 'استغفر الله'
    'Ù…Ø­Ù…Ø¯' = 'محمد'
    'Ø§Ù„Ù‚Ø±Ø¢Ù†' = 'القرآن'
    
    # Common Arabic words
    'Ù…Ø´Ø§Ø±ÙŠ Ø¨Ù† Ø±Ø§Ø´Ø¯ Ø§Ù„Ø¹ÙØ§Ø³ÙŠ' = 'مشاري بن راشد العفاسي'
}

# Get all .dart files in the project
$DartFiles = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

Write-Host "Starting Arabic text corruption fix..."
Write-Host "Found $($DartFiles.Count) .dart files to check."

$FilesModified = 0
$TotalReplacements = 0

foreach ($File in $DartFiles) {
    $Content = Get-Content -Path $File.FullName -Raw -Encoding UTF8
    $OriginalContent = $Content
    $FileReplacements = 0
    
    # Apply all Arabic fixes
    foreach ($Pattern in $ArabicFixes.Keys) {
        $Replacement = $ArabicFixes[$Pattern]
        if ($Content -like "*$Pattern*") {
            $Content = $Content -replace [regex]::Escape($Pattern), $Replacement
            $FileReplacements++
            Write-Host "  Fixed '$Pattern' -> '$Replacement' in $($File.Name)"
        }
    }
    
    # Only write file if changes were made
    if ($FileReplacements -gt 0) {
        try {
            Set-Content -Path $File.FullName -Value $Content -Encoding UTF8 -NoNewline
            $FilesModified++
            $TotalReplacements += $FileReplacements
            Write-Host "Modified: $($File.Name) ($FileReplacements replacements)"
        } catch {
            Write-Error "Failed to update $($File.Name): $_"
        }
    }
}

Write-Host ""
Write-Host "Arabic text corruption fix completed!"
Write-Host "Files modified: $FilesModified"
Write-Host "Total replacements: $TotalReplacements"
Write-Host ""
Write-Host "IMPORTANT: Only Arabic text was modified. No code structure was changed."
