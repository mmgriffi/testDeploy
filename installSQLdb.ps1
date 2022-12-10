
function install()
{
$command = 'msiexec.exe /i "C:\temp\SQL2000SampleDb.msi" targetdir="c:\temp\sql2000" /quiet /qn /norestart'
$command = $command + ' /Lv c:\temp\installer1.log'

$logresults = (get-content c:\temp\installer1.log)

$logresults

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
write-host "This ran the installer"
