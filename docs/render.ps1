Add-Type -AssemblyName System.Drawing

function Render-TextImage([string]$text,[string]$outPath){
    $font = New-Object System.Drawing.Font("Consolas",14)
    $tmp = New-Object System.Drawing.Bitmap(1,1)
    $gtmp = [System.Drawing.Graphics]::FromImage($tmp)
    $w=1200
    $s=$gtmp.MeasureString($text,$font,$w)
    $h=[Math]::Ceiling([double]$s.Height)+40
    if($h -lt 100){ $h=100 }
    $bmp=New-Object System.Drawing.Bitmap($w,$h)
    $g=[System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::White)
    $g.DrawString($text,$font,[System.Drawing.Brushes]::Black,15,15)
    $bmp.Save($outPath,[System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose(); $gtmp.Dispose(); $tmp.Dispose()
}

$docs = Split-Path -Parent $MyInvocation.MyCommand.Definition
$nl = [char]10
$fence3 = '````'

Write-Host "Generating 02-modelo-relacional.png ..."
$md2 = Get-Content (Join-Path $docs "02-modelo-relacional.md") -Raw
$x1 = $md2.IndexOf('```')
$x1 = $md2.IndexOf($nl,$x1)+1
$x2 = $md2.IndexOf('```',$x1)
$text2 = $md2.Substring($x1,$x2-$x1).Trim()
Render-TextImage $text2 (Join-Path $docs "02-modelo-relacional.png")
Write-Host "  OK"

Write-Host "Skipping 05-casos-de-uso: se entrega como PDF (docs/05-casos-de-uso.pdf)"

Write-Host "Generated files:"
Get-ChildItem $docs -Filter *.png | ForEach-Object { Write-Host ("  "+$_.FullName) }