$path = "c:\Users\Dell\Desktop\aksh\weddings.html"
$backup = "c:\Users\Dell\Desktop\aksh\weddings.backup.before-path-fix.html"
if (-not (Test-Path $backup)) { Copy-Item -LiteralPath $path -Destination $backup }
$text = Get-Content -LiteralPath $path -Raw
# Replace incorrect relative path to local etc.clientlibs (file is in same directory level)
$text = $text -replace '\.\./\.\./etc\.clientlibs', './etc.clientlibs'
Set-Content -LiteralPath $path -Value $text -Encoding UTF8
Write-Output "Rewrote '../../etc.clientlibs' to './etc.clientlibs'. Backup at: $backup"
