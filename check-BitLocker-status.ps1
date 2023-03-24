#Requires -RunAsAdministrator

<#
Powershell script to check BitLocker Status
requires elevation.

Usage: powershell -ExecutionPolicy Bypass -File Check-BitLocker-Status.ps1 > outfile.txt

show if device is a laptop or other Portable
show BitLocker Status
We'll do the processing elsewhere to show if we have a Portable with an unencrypted drive
of course if we have:
c: <-- boot volume, encrypted
d: <-- data volume with all the stuff we care about, not encrypted
this won't help.

Adapted from: https://powershell.one/wmi/root/cimv2/win32_systemenclosure

if not run as Administrator you'll get this error
The script 'check-BitLocker-status.ps1' cannot be run because it contains a "#requires" statement for running as
Administrator. The current Windows PowerShell session is not running as Administrator. Start Windows PowerShell by
using the Run as Administrator option, and then try running the script again.
    + CategoryInfo          : PermissionDenied: (check-BitLocker-status.ps1:String) [], ParentContainsErrorRecordExcep
   tion
    + FullyQualifiedErrorId : ScriptRequiresElevation

@author Dave Evans <https://github.com/stringydave>
@licence MIT
@version 0.0.1
#>


<#
  A calculated property is defined by a hashtable with keys "Name" and "Expression"
  "Name" defines the name of the property (in this example, it is "ChassisType", but you can rename it to anything else)
  "Expression" defines a scriptblock that calculates the content of this property
  in this example, the scriptblock uses the hashtable defined earlier to translate each numeric value to its friendly text counterpart:
#>

function Get-Chassis-Type {
 
	$ChassisType = @{
	  Name = 'ChassisType'
	  Expression = {
		# property is an array, so process all values
		$result = foreach($value in $_.ChassisTypes)
		{
			switch([int]$value)
		  {
			1          {'Other'}
			2          {'Unknown'}
			3          {'Desktop'}
			4          {'Low Profile Desktop'}
			5          {'Pizza Box'}
			6          {'Mini Tower'}
			7          {'Tower'}
			8          {'Portable'}
			9          {'Portable'} # Laptop
			10         {'Portable'} # Notebook
			11         {'Portable'} # Hand Held
			12         {'Portable'} # Docking Station
			13         {'All in One'}
			14         {'Portable'} # Sub Notebook
			15         {'Space-Saving'}
			16         {'Lunch Box'}
			17         {'Main System Chassis'}
			18         {'Expansion Chassis'}
			19         {'SubChassis'}
			20         {'Bus Expansion Chassis'}
			21         {'Peripheral Chassis'}
			22         {'Storage Chassis'}
			23         {'Rack Mount Chassis'}
			24         {'Sealed-Case PC'}
			default    {"$value"}
		  }
		  
		}
		$result
	  }  
	}

	# retrieve all instances...
	Get-CimInstance -ClassName Win32_SystemEnclosure | Select-Object -Property $ChassisType
}

$chassis = Get-Chassis-Type
Write-Host "BitLocker-Chassis:"  $chassis

# get protection status for SystemDrive
$BitLockerSysVolume = Get-BitLockerVolume -MountPoint $env:SystemDrive | Select-Object  "ProtectionStatus"
Write-Host "BitLocker-Status:"  $BitLockerSysVolume
