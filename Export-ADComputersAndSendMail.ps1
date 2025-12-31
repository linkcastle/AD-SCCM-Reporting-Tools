# Email Parameters 
$smtpServer = "smtp.server.local"
$from = "email@domain.com"
$to = "it.email@domain.com"
$subject = "Weekly Computers Report Switzerland"
$body = "Dear Team, Attached the list of GiGroup Switzerland Computers and current logged user."
$attachmentPath = "C:\Temp\alessandro\SCCM_Computers_Switzerland.csv"



# Carica modulo e cambia drive SCCM
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
cd GG1:


# Ora il resto dello script
$collectionId = "GG1001B6"

$devices = Get-CMDevice -CollectionId $collectionId  | Select Name, LastLogonUser,LastActiveTime, SerialNumber, MACAddress, DeviceOSBuild,IsBlocked, IsActive
 
 #Save on CSV
$devices | Export-Csv -Path $attachmentPath -NoTypeInformation -Encoding UTF8

# Sending with Attachment
Send-MailMessage -From $from -To $to -Subject $subject -Body $body -SmtpServer $smtpServer -Attachments $attachmentPath