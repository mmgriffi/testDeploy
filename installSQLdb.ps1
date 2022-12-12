
$errorcode = 0
$mydate = (Get-Date -format "dd-MMM-yyyy_HH_mm")

$id = "ABB6AC00-F1D8-4EBF-8128-830D090B76C0"

function install()
{
$command = 'msiexec.exe /i "C:\temp\SQL2000SampleDb.msi" targetdir="c:\temp\sql2000" /quiet /qn /norestart'
$command = $command + ' /Lv c:\temp\installer1.log'
invoke-expression $command 
}

function uninstall()
{
$command = 'msiexec.exe /x  "C:\temp\SQL2000SampleDb.msi" /quiet /qn /norestart '
$command = $command + ' /Lv c:\temp\uninstaller.log'
#$command | out-file c:\temp\installCommandline.txt
#& $command
invoke-expression $command 

}

install

start-sleep 20

if (test-path c:\temp\installer1.log)
{
$eerrorcode = 0
$logresults = (get-content c:\temp\installer1.log)

$logresults
write-host "This ran the installer"
start-sleep 5 
move-item c:\temp\installer1.log c:\temp\install_${mydate}.log -force
}
else
{
write-host "installer log not written - must be a problem"
$errorcode = 999
}

#===

write-host "Checking installed programs to see if app was installed"
$Progs = (Get-WmiObject Win32_Product| select Name,Version,identifyingNumber)
foreach ($prog in $progs) 
{ 
$progID = $prog.identifyingNumber
$progName = $prog.Name
$progversion = $prog.Version
     
    if ($progID -eq "{ABB6AC00-F1D8-4EBF-8128-830D090B76C0}")
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
    $errorcode = 999
}
#===

write-host "this script will exit with $errorcode"
exit $errorcode
