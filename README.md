## AD Computer Tool

A PowerShell tool for working with Active Directory computer objects. 

Upon first run, the script will create the config.json file used to store the settings. Edit the file to fit your environment. 
 

### Required Setup

The PowerShell Active Directory Module must be installed on the system.

```powershell
# On Windows 10 systems
Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
```


