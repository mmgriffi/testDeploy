[CmdletBinding()]
param
(
[Parameter(Mandatory= $true)]
[String]$mypath
)

$errorcode = 0

"logfile" | Out-File testpathlog.log

test-path $mypath

if (test-path $mypath)
{
    $message =  "path was found, $errorcode"
    $message |  Out-File testpathlog.log -append
}
else
   {
    $errorcode =1
    $message =  "path was not found, $errorcode"
   }

EXIT $errorcode
