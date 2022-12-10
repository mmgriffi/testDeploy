
$errorcode = 0
$mydate = (Get-Date -format "dd-MMM-yyyy")
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

if (test-path c:\temp\installer1.log)
{
$eerrorcode = 0
$logresults = (get-content c:\temp\installer1.log)

$logresults
write-host "This ran the installer"
start-sleep 5 
move-item c:\temp\installer1.log c:\temp\install_${mydate}.log
}
else
{
write-host "installer log not written - must be a problem"
$errorcode = 999
}
exit $errocode

