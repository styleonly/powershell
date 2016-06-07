# Windows Server 2012 Release Priview with Hyper-V 3.0 & Powershell 3.0
# This script creates a new Hyper-V machine with hard drive, memory & network resources configured.
# Variables
$ServerName = Read-Host "Enter the Hyper-V Server name (Press [Enter] to choose localhost)"
if ($ServerName -eq ""){$ServerName="localhost"} ; if ($ServerName -eq $NULL){$ServerName="localhost"}

$VMName = Read-Host "Enter the Virtual Machine name (Press [Enter] to choose HPV-OS-IP)"
if ($VMName -eq ""){$VMName="WS12R2-"} ; if ($VMName -eq $NULL){$VMName="WS12R2-"}

$SRAM = Read-Host "Enter the size of the Virtual Machine Memory (Press [Enter] to choose 512MB; Press 1 for 2048MB; 2 for 1024MB)"
if ($SRAM -eq "1"){$SRAM=2048MB} ; if ($SRAM -eq "2"){$SRAM=1024MB};if ($SRAM -eq ""){$SRAM=2048MB} ; if ($SRAM -eq $NULL){$SRAM=2048MB}

$Network = Read-Host "Enter the name of the Virtual Machine Network (Press [Enter] to choose "public_switch")"
if ($Network -eq ""){$Network="public_switch"} ; if ($Network -eq $NULL){$Network="public_switch"}

$ParentDisk = Read-Host "Enter the ParentDisk name of the Virtual Machine without .vhdx (Press [Enter] to choose WS12R2-xx; Press 1 for WS16-xx)"
if ($ParentDisk -eq "1"){$ParentDisk="WS16-xx"};if ($ParentDisk -eq ""){$ParentDisk="WS12R2-xx"} ; if ($ParentDisk -eq $NULL){$ParentDisk="WS12R2-xx"}

$vhd = New-VHD -ComputerName "$ServerName" -Path "D:\Hyper-V\vDisks\$VMName.vhdx" -ParentPath "D:\Hyper-V\vDisks\$ParentDisk.vhdx" -Differencing

# Create Virtual Machines
New-VM -ComputerName "$ServerName" -Name "$VMName" -Generation 2 -VHDPath $($vhd.Path) -MemoryStartupBytes "$SRAM" -SwitchName $Network
Set-VMMemory  -ComputerName "$ServerName" -VMName "$VMName" -DynamicMemoryEnabled 1 -MinimumBytes 256MB -MaximumBytes 4GB
Start-VM -ComputerName "$ServerName" -Name "$VMName"
Get-VM -Name "$VMName"
