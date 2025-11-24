# Generates the styled PDF resume using Pandoc and wkhtmltopdf.

$pandocPath = 'C:\Program Files\Pandoc\pandoc.exe'
$wkhtmlPath = 'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe'

if (-not (Test-Path $pandocPath)) {
    throw "Pandoc not found at '$pandocPath'. Update the path in generate_resume.ps1."
}

if (-not (Test-Path $wkhtmlPath)) {
    throw "wkhtmltopdf not found at '$wkhtmlPath'. Update the path in generate_resume.ps1."
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot
$markdown = Join-Path $repoRoot 'markdown\Richard_Gannaway.md'
$css = Join-Path $repoRoot 'resume_generator\resume.css'
$timestamp = Get-Date -Format 'ddMMyyyy'
$outputName = "Richard_Gannaway_$timestamp.pdf"
$output = Join-Path $repoRoot "PDF\$outputName"

Write-Host "Building PDF from $markdown" -ForegroundColor Cyan

& $pandocPath `
    $markdown `
    -o $output `
    --standalone `
    --css $css `
    --pdf-engine=$wkhtmlPath `
    --pdf-engine-opt=--margin-top `
    --pdf-engine-opt=0.5in `
    --pdf-engine-opt=--margin-bottom `
    --pdf-engine-opt=0.5in `
    --pdf-engine-opt=--margin-left `
    --pdf-engine-opt=0.5in `
    --pdf-engine-opt=--margin-right `
    --pdf-engine-opt=0.5in `
    | Write-Host

if ($LASTEXITCODE -ne 0) {
    throw "Pandoc failed with exit code $LASTEXITCODE."
}

Write-Host "PDF created at $output" -ForegroundColor Green
