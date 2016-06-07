$domainname = "zdnet.ad"
#$domainuser = "Administrator"
$cred = Get-Credential
$newname = "2016-01"
Enter-PSSession -VMName $newname -Credential $cred
Add-Computer -DomainName $domainname -Credential $cred
Restart-Computer
$servername 

Add-Computer -DomainName zdlab.ad -NewName $newname -Credential zdlab\Administrator -Restart -Force