#Simple System Audit script for Mac os
# Lucas Jones Wrote this
# Data october 7th 12pm

#Output file

$desktopPath = "/$HOME/Desktop"
$reportFile = "$desktopPath/SimpleAuditReport.rtf"

#Ensure desktop directory exists and can write

if (-Not (Test-Path -Path $desktopPath)) {
    Write-Host "The Desktop path does not exist. please check your user directory." -ForegroundColor Red
    exit
}

# Check if we can write to desktop directory

try {
    New-Item -Path $reportFile -ItemType File -Force | Out-Null
    Write-Host "report file created successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Unable to create the report file. Please check your permissions." -ForegroundColor Red
        Exit
    }


# Header for report

$rtfHeader = @"
{\rtf1\ansi
{\b ------------------------------- \par
Simple MacOS System Audit \par
Date: $(Get-Date) \par
----------------------------------- \b0 \par
}
"@

Add-Content -Path $reportFile -Value $rtfHeader

#check disk space

function Check-DiskSpace {
    Write-Host "Checking disk space on system for you..."
    $diskSpace = df -h
    $formattedDiskSpace = $diskSpace -replace "'n", "'r'n\par " #RTF For line breaks
    Add-Content -Path $reportFile -Value "'n{\b Disk Space Usage: \b0 \par $formattedDiskSpace \par}"
    }
# list running processes

function Check-RunningProcesses {
    Write-Host "Checking Running Processes for you..."
        $processes = ps aux
        $formattedProcesses = $processes -replace "'n", "'r'n\par " # RTF formatting for line break
        Add-Content -Path $reportFile -Value "'n{\b Running Processes: \b0 \par $formattedProcesses \par}"
    }

#check system uptime

function Check-SystemUptime {
    Write-Host "Checking system uptime for you..."
    $uptime = uptime
    Add-Content -Path $reportFile -Value "'n{\b System Uptime: \b0 \par $uptime \par}"
    }

# All checks

Check-DiskSpace
Check-RunningProcesses
Check-SystemUptime

# close the RTF document
$rtfFooter = "}"
Add-Content -Path $reportFile -Value $rtfFooter

# Completion Message

Write-Host "Simple System Audit Completed for you! Report saved to #$reportFile"

