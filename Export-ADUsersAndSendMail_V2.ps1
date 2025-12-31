<#
.SYNOPSIS
    Exports AD users with hierarchy data (manager, direct reports, groups) and emails a CSV/JSON report.
.DESCRIPTION
    Used for weekly audits of Local AD users. Outputs include:
    - User details (Name, SAM, Email, Title)
    - Manager and direct reports (for org chart mapping)
    - Group memberships (for permissions audits)
    - Last logon date (for stale account detection)
.NOTES
    Requires:
    - ActiveDirectory PowerShell module
    - SMTP access for email notifications
#>
 
 
 # Email Parameters 
$smtpServer = "smtp.server.local"
$from = "email@domain.com"
$to = "email@domain.com"
$subject = "Weekly Users Report Switzerland"
$body = "Dear Team, Attached the list of AD users of Switzerland."
$attachmentPath = "C:\Temp\alessandro\AD_Users_Switzerland.csv"

# Get Users from OU
$ou = "OU=Users,OU=OU_TO_USE,OU=Switzerland,OU=OU_TO_USE,DC=gigroup,DC=local"
$users = Get-ADUser -Filter * -SearchBase $ou -Properties Name, SamAccountName, LastLogonDate, EmailAddress, Enabled, whenCreated, Title, DirectReports, Manager, MemberOf

# Process each user and include DirectReports, Manager, MemberOf
$userList = $users | ForEach-Object {
    # Get DirectReports
    $reportSamAccountNames = @()
    $reportNames = @()
    if ($_.DirectReports) {
        foreach ($report in $_.DirectReports) {
            $reportUser = Get-ADUser $report
            if ($reportUser) {
                $reportSamAccountNames += $reportUser.sAMAccountName
                $reportNames += $reportUser.Name
            }
        }
    }

    # Get Manager
    $managerSam = ""
    $managerName = ""
    if ($_.Manager) {
        $managerUser = Get-ADUser $_.Manager
        if ($managerUser) {
            $managerSam = $managerUser.sAMAccountName
            $managerName = $managerUser.Name
        }
    }

    # Get MemberOf group names
    $groupNames = @()
    if ($_.MemberOf) {
        foreach ($groupDN in $_.MemberOf) {
            $group = Get-ADGroup $groupDN
            if ($group) {
                $groupNames += $group.Name
            }
        }
    }

    [PSCustomObject]@{
        Name                       = $_.Name
        SamAccountName             = $_.SamAccountName
        LastLogonDate              = $_.LastLogonDate
        EmailAddress               = $_.EmailAddress
        Enabled                    = $_.Enabled
        WhenCreated                = $_.WhenCreated
        Title                      = $_.Title
        Manager                    = $managerName
        DirectReports              = ($reportNames -join ", ")
        Manager_SAM                = $managerSam
        DirectReports_SAM          = ($reportSamAccountNames -join ", ")
        MemberOf                   = ($groupNames -join ", ")
    }
}

# Save to CSV
$attachmentPathCsv = "C:\Temp\alessandro\AD_Users_Switzerland.csv"
$userList | Export-Csv -Path $attachmentPathCsv -NoTypeInformation -Encoding UTF8

# Save JSON
$attachmentPathJson = "C:\Temp\alessandro\AD_Users_Switzerland.json"
$userList | ConvertTo-Json -Depth 5 | Out-File $attachmentPathJson -Encoding UTF8

# Send email with attachment
Send-MailMessage -From $from -To $to -Subject $subject -Body $body -SmtpServer $smtpServer -Attachments @($attachmentPathCsv, $attachmentPathJson)
