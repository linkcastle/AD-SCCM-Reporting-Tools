# IT Automation Scripts for AD/SCCM Reporting

These scripts were originally developed for a **large enterprise environment** but have been **genericized** for public use. Replace all placeholders (e.g., `Domain`, `smtp.server.com`) with your organization's details.

## Features
This repository contains **production-tested PowerShell scripts** used to automate:
- **AD User Reports**: Exports users with manager hierarchy, group memberships, and last logon dates.
- **AD Group Reports**: Lists all groups with members, descriptions, and creation dates.
- **SCCM Computer Reports**: Tracks devices, logged-in users, and activity status.


Scripts are **configurable** via `Config/template.config.ps1` and designed for **weekly automated runs via Windows Task Scheduler**.

---

##  Scripts

| Script                     | Purpose                                  | Output Formats       |
|----------------------------|------------------------------------------|----------------------|
| [`AD-Reports/Export-ADUsers.ps1`](AD-Reports/) | Exports all AD users with manager hierarchy and group memberships. | CSV + JSON |
| [`AD-Reports/Export-ADGroups.ps1`](AD-Reports/) | Lists all AD groups, members, and metadata. | CSV |
| [`SCCM-Reports/Export-SCCMComputers.ps1`](SCCM-Reports/) | Exports SCCM device inventory with user logon data. | CSV |

---

##  Requirements
- **PowerShell 5.1+**
- **Modules**:
  - `ActiveDirectory` (for AD scripts)
  - `ConfigurationManager` (for SCCM script, installed with SCCM console)
- **Permissions**:
  - Read access to target AD OUs/SCCM collections.
  - SMTP access for email notifications.

Install AD module (if missing):
```powershell
Install-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory
