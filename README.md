PowerShell File Type Report Script
Overview
This script traverses a specified directory tree, identifies the top 10 file types by total size, and generates a summary report. It is designed to be cross-platform, working seamlessly on both Windows and Linux (PowerShell Core).

Features
Recursive Scanning: Checks all subdirectories.

Cross-Platform: Handles file paths (\ vs /) and system folders automatically.

Error Handling: Gracefully skips inaccessible system directories without crashing.

Formatted Output: Generates a clean, aligned text report.

Usage
Prerequisites
Windows: PowerShell 5.1 or PowerShell 7+

Linux: PowerShell Core (pwsh) installed

Running the Script
Windows Example:

PowerShell

.\Get-FileTypeReport.ps1 -InputDirectory "C:\Users\MyUser\Documents" -OutputDirectory "C:\Reports"
Linux Example:

Bash

./Get-FileTypeReport.ps1 -InputDirectory "/home/user/documents" -OutputDirectory "/tmp/reports"
Troubleshooting
"Running scripts is disabled on this system" (Windows)

If you encounter an Execution Policy error, you can bypass it for this specific run without changing your global system security settings:

PowerShell

powershell.exe -ExecutionPolicy Bypass -File .\Get-FileTypeReport.ps1 -InputDirectory "C:\Target" -OutputDirectory "C:\Report"
Output Example
The script generates a text file (e.g., Top10_FileTypes_Report.txt) with the following format:

Plaintext

Extension       Summary Value in MB
-----------------------------------
.mkv            21210
.zip            12747
.mp3            1187
no_extension    20
