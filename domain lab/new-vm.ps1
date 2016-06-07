Import-Module Hyper-V
$VerbosePreference = "Continue"
$basedir = "E:\vDisks"
Write-Verbose "Working Dir is now : $basedir"
$newname = (Read-Host "Enter new server name, same as vhd file name")
Write-Verbose "New server name and vhd file name will be : $newname"
Write-Verbose "Entering working dir..."
cd "$basedir"
Write-Verbose "Copying vhd file..."
Copy-Item .\2012.vhdx .\$newname.vhdx
Write-Verbose "DONE!"
Write-Verbose "Createing new vm..."
New-VM -VHDPath $basedir\$newname.vhdx -ComputerName localhost -Name $newname -SwitchName internal -BootDevice VHD -Generation 2
Write-Verbose "DONE!"
Write-Verbose "Starting vm..."
Start-VM $newname
Write-Verbose "$newname Started"

$cred = Get-Credential
Enter-PSSession -VMName $newname -Credential $cred
Add-Computer -DomainName zdlab.ad -NewName 2016-02 -Credential zdlab\Administrator -Restart -Force
Exit-PSSession