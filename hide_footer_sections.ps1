$path = "c:\Users\Dell\Desktop\aksh\weddings.html"
$backup = "c:\Users\Dell\Desktop\aksh\weddings.backup.before-hide-footer.html"
if (-not (Test-Path $backup)) { Copy-Item -LiteralPath $path -Destination $backup }
$lines = Get-Content -LiteralPath $path
# Find the first <style> block and its closing </style>
$openIdx = ($lines | Select-String -SimpleMatch '<style>' | Select-Object -First 1).LineNumber
if (-not $openIdx) { Write-Error 'Could not find <style> tag to anchor insertion.'; exit 1 }
$closeIdx = ($lines[($openIdx-1)..($lines.Count-1)] | Select-String -SimpleMatch '</style>' | Select-Object -First 1)
if (-not $closeIdx) { Write-Error 'Could not find </style> tag after the first <style>.'; exit 1 }
$insertAt = ($closeIdx.LineNumber) # absolute line number already
$styleToInsert = @(
    '<style>',
    '  /* Page-specific override: hide footer menus and widgets on weddings.html */',
    '  .itc-footer__menu,',
    '  .itc-footer__widgets { display: none !important; }',
    '</style>'
)
$new = @()
if ($insertAt -gt 0) { $new += $lines[0..($insertAt-1)] } else { $new += $lines }
$new += $styleToInsert
if ($insertAt -lt $lines.Count) { $new += $lines[$insertAt..($lines.Count-1)] }
Set-Content -LiteralPath $path -Value $new -Encoding UTF8
Write-Output "Inserted footer-hiding style block after existing style. Backup at: $backup"
