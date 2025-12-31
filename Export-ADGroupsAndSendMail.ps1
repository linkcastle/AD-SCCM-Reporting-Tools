# Email Parameters
$smtpServer     = "smtp.server.local"
$from           = "email@domain.com"
$to             = "email@domain.com"
$subject        = "Weekly Groups Report Switzerland"
$body           = "Dear Team, Attached the list of AD groups of Switzerland."
$attachmentPath = "C:\Temp\alessandro\AD_Groups_Switzerland.csv"

# Get Groups from OU (adjust OU if needed)
$ou = "OU=Groups,OU=OU_TO_USE,OU=Switzerland,OU=OUR_TO_USE,DC=gigroup,DC=local"

# Fetch groups and select a few basic fields
$groups = Get-ADGroup -Filter * -SearchBase $ou -Properties *

# Save to CSV (simple list)
$groups |
    Select-Object Name, SamAccountName, Description, whenCreated,mail, member, ObjectGUID |
    Export-Csv -Path $attachmentPath -NoTypeInformation -Encoding UTF8

# Send email with attachment
Send-MailMessage -From $from -To $to -Subject $subject -Body $body -SmtpServer $smtpServer -Attachments $attachmentPath
