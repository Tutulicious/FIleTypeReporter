<#
.SYNOPSIS
    Generates a report of the top 10 largest file types by total size in a directory.
    Cross-platform compatible (Windows/Linux).

.DESCRIPTION
    This script scans a specified InputDirectory recursively. It groups files by extension,
    calculates the total size for each extension in Megabytes (MB), and exports the
    top 10 largest extensions to a text report in the OutputDirectory.

.PARAMETER InputDirectory
    The path to the directory to scan.

.PARAMETER OutputDirectory
    The path where the report file will be saved.

.EXAMPLE
    ./Get-FileTypeReport.ps1 -InputDirectory "C:\Users\Name\Downloads" -OutputDirectory "C:\Reports"

.EXAMPLE
    ./Get-FileTypeReport.ps1 -InputDirectory "/home/user/downloads" -OutputDirectory "/home/user/reports"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$InputDirectory,

    [Parameter(Mandatory=$true)]
    [string]$OutputDirectory
)

# 1. Validate Input Directory
if (-not (Test-Path -Path $InputDirectory)) {
    Write-Error "Input Directory not found: $InputDirectory"
    exit
}

# 2. Validate/Create Output Directory
if (-not (Test-Path -Path $OutputDirectory)) {
    Write-Host "Output directory does not exist. Creating it..." -ForegroundColor Cyan
    New-Item -Path $OutputDirectory -ItemType Directory -Force | Out-Null
}

Write-Host "Scanning files in '$InputDirectory'... (This may take a moment)" -ForegroundColor Green

# 3. Gather, Group, and Calculate
# We use a calculated property for the Extension to handle files with no extension.
# ErrorAction SilentlyContinue is used to skip system folders (like System Volume Information or /proc)
$Top10Files = Get-ChildItem -Path $InputDirectory -Recurse -File -ErrorAction SilentlyContinue | 
    Select-Object Length, @{Name='Extension'; Expression={
        if ([string]::IsNullOrWhiteSpace($_.Extension)) { 'no_extension' } else { $_.Extension }
    }} | 
    Group-Object -Property Extension | 
    Select-Object @{Name='Extension'; Expression={$_.Name}}, @{Name='TotalSizeMB'; Expression={
        # Sum the length of all files in the group and convert to MB (Round to 0 decimals)
        [Math]::Round(($_.Group | Measure-Object -Property Length -Sum).Sum / 1MB)
    }} | 
    Sort-Object -Property TotalSizeMB -Descending | 
    Select-Object -First 10

# 4. Construct the Report Content
$ReportLines = @()
$ReportLines += "Extension      Summary Value in Mb" # Header
$ReportLines += "----------------------------------" # Separator

foreach ($Item in $Top10Files) {
    # formatting string: {0,-14} aligns left with 14 chars padding, {1} is the value
    $Line = "{0,-14} {1}" -f $Item.Extension, $Item.TotalSizeMB
    $ReportLines += $Line
}

# 5. Determine Output File Path (Cross-platform safe)
$OutputFileName = "Top10_FileTypes_Report.txt"
$FullOutputPath = Join-Path -Path $OutputDirectory -ChildPath $OutputFileName

# 6. Write to File
try {
    $ReportLines | Out-File -FilePath $FullOutputPath -Encoding UTF8 -Force
    Write-Host "Success! Report generated at:" -ForegroundColor Green
    Write-Host $FullOutputPath -ForegroundColor White
    
    # Show a preview in the console
    Write-Host "`n--- Report Preview ---" -ForegroundColor Gray
    $ReportLines | ForEach-Object { Write-Host $_ }
}
catch {
    Write-Error "Failed to write output file. Error: $_"
}
