$errorcode = 0
write-host "Checking installed programs to see if app was installed"
$Progs = (Get-WmiObject Win32_Product| select Name,Version,identifyingNumber)
foreach ($prog in $progs) 
{ 
$progID = $prog.identifyingNumber
$progName = $prog.Name
$progversion = $prog.Version
     
    if ($progID -eq "{ABB6AC00-F1D8-4EBF-8128-830D090B76C0}")
#    if ($progID -eq "{BBB6AC00-F1D8-4EBF-8128-830D090B76C0}")
     {
     #write-host "you have installed $progName, version $progversion"
     
     $myprogName = $progName
     $myprogVersion = $progVersion
     $installed = $true

     #write-host "installed $progName"
     }
}
if ($installed)
{
    write-host "you have installed $myprogName, version $myprogversion"
}
else
{
    write-host "Error : did not find the required program"
    $errorcode = 999
}
#===

write-host "this script will exit with $errorcode"
exit $errorcode
