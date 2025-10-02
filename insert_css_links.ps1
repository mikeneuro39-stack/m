$path = "c:\Users\Dell\Desktop\aksh\weddings.html"
$cssHrefs = @(
  "../../etc.clientlibs/itchotels/clientlibs/clientlib-itc.min.ACSHASHd258147e3c7ce68109ca7fb0e0eb2033.css",
  "../../etc.clientlibs/itchotels/clientlibs/clientlib-mementos.min.ACSHASHab679df52936d453d7eb24afd873f28e.css",
  "../../etc.clientlibs/itchotels/clientlibs/clientlib-storii.min.ACSHASH1d8e1cdd47ea9b656e896e68105eb702.css",
  "../../etc.clientlibs/itchotels/clientlibs/clientlib-welcomHotel.min.ACSHASH1e2101cfa59049c63a38baa3b7517f60.css",
  "../../etc.clientlibs/itchotels/clientlibs/clientlib-welcomHeritage.min.ACSHASH197b1ebde70e1155570eba83ab39b31c.css",
  "../../etc.clientlibs/itchotels/clientlibs/clientlib-fortune.min.ACSHASH5273c8d56934070f9f43d59190097f8d.css"
)

$content = Get-Content -LiteralPath $path
$allText = $content -join "`n"
$missing = $cssHrefs | Where-Object { $allText -notmatch [regex]::Escape($_) }
if ($missing.Count -eq 0) {
  Write-Output "All CSS links already present. No changes made."
  exit 0
}

$needle = 'href="../../etc.clientlibs/itchotels/clientlibs/clientlib-umbrella'
$match = $content | Select-String -SimpleMatch $needle | Select-Object -First 1
if ($null -eq $match) {
  Write-Output "Could not find the clientlib-umbrella link line to anchor insertion."
  exit 1
}

$idx = $match.LineNumber - 1
$insertLines = $missing | ForEach-Object { '    <link rel="stylesheet" href="' + $_ + '" type="text/css">' }

$new = @()
if ($idx -ge 0) { $new += $content[0..$idx] } else { $new += $content }
$new += $insertLines
if ($idx + 1 -lt $content.Count) { $new += $content[($idx+1)..($content.Count-1)] }

Set-Content -LiteralPath $path -Value $new -Encoding UTF8
Write-Output ("Inserted {0} CSS link(s)." -f $insertLines.Count)
