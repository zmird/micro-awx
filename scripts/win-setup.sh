#!/bin/sh

# Run ansible setup
vagrant winrm --shell powershell --command "./Upgrade-Powershell.ps1"
vagrant winrm --shell powershell --command "./ConfigureRemotingForAnsible.ps1"
vagrant winrm --shell powershell --command "./Install-WMF3Hotfix.ps1"

# Setup icmp v4
vagrant winrm --shell powershell --command "./Enable-ICMP-v4.ps1"
