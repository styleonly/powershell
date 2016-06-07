#get domain admin credential
$cred = Get-Credential
#init ver.
$domainname = "zdlab.ad"
#change computer name
Rename-Computer (Read-Host "Enter NEW computer name:")
#join domain
Add-Computer -DomainName $domainname -Credential $cred