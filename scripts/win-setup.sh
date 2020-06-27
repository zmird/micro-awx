#!/bin/sh

# Run ansible setup
vagrant winrm --shell powershell --command "./setup/Upgrade-Powershell.ps1"
vagrant winrm --shell powershell --command "./setup/ConfigureRemotingForAnsible.ps1"
vagrant winrm --shell powershell --command "./setup/Install-WMF3Hotfix.ps1"

# Setup icmp v4
vagrant winrm --shell powershell --command 'netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow'
