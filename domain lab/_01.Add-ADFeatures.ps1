$cred = Get-Credential
Enter-PSSession -VMName 2016-ops -Credential $cred

#set static IP address 
$ipaddress = "192.168.20.20" 
$ipprefix = "24" 
$ipgw = "192.168.20.1" 
$ipdns = "192.168.20.20" 
$ipif = (Get-NetAdapter).ifIndex 
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -InterfaceIndex $ipif 

-DefaultGateway $ipgw

#rename the computer 
$newname = "2016-DC" 
Rename-Computer -NewName $newname –force


#install features 
$featureLogPath = "c:\featurelog.txt" 
New-Item $featureLogPath -ItemType file -Force 
$addsTools = "RSAT-AD-Tools" 
Add-WindowsFeature $addsTools 
Get-WindowsFeature | Where installed >>$featureLogPath

#restart the computer 
Restart-Computer

#Install AD DS, DNS and GPMC 
start-job -Name addFeature -ScriptBlock { 
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "dns" #-IncludeAllSubFeature -IncludeManagementTools 
}
Wait-Job -Name addFeature 
Get-WindowsFeature | Where installed >>$featureLogPath
gc $featureLogPath



Install-windowsfeature AD-domain-services


Import-Module ADDSDeployment

Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012R2" -DomainName "zdlab.ad" -DomainNetbiosName "zdlab" -ForestMode "Win2012R2" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true