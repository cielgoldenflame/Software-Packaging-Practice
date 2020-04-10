<#
    .SYNOPSIS
        Installation of putty
        For Practice
    
    .DESCRIPTION
        Installs software in quite mode, creates logs

    .OUTPUTS
        Logs will be created in C:\ProgramData\quick\logs\$software

    .NOTES
        Version:        1.0
        Author:         CielGoldenflame
        Creation Date:  2020 04 09
        Purpose/Change: Test Script

    .EXAMPLE
        Run with ".\Install.ps1"
#>

# Define software name
$softwarename = "Putty"

# Logging Source Folder
$logroot = "$env:ProgramData\quick"

# define script source
$scripdir = Split-Path $Script:MyInvocation.MyCommand.Path

# Check for logging folder/create (logging is not vital for success)
if(Test-Path -Path "$logroot\$softwarename")
{
    # Exists do nothing
}else{ 
    #create path
    New-Item -Path $logroot -Name $softwarename -ItemType Directory -Force -ErrorAction SilentlyContinue
}

# Var for all applications containing "Adobe Acrobat*" gets Name and Uninstall string
$uninstallSoftware = Get-ChildItem -path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall,HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | `
Get-ItemProperty | Where-Object {$_.Displayname -like "*Putty*"} | Select-Object -Property Displayname, Uninstallstring

# loop through $uninstallsoftware
foreach($uninstallobject in $uninstallSoftware){

    # remove msiexec /i & msiexec /x for uninstallstring
    $uninstallobject.Uninstallstring = $uninstallobject.Uninstallstring -replace 'msiexec.exe /i', ""

    $Uninstallstring = $uninstallobject.UninstallString -replace 'msiexec.exe /x', ""

    Start-Process msiexec.exe -ArgumentList "/q /x $Uninstallstring /L $logroot\$softwarename\prev-ver-uninstall.log" -Wait
}

# Install command
Start-Process -FilePath $scripdir\putty-64bit-0.70-installer.msi -ArgumentList "/qn /norestart /l $logroot\$softwarename\install.log" -Wait