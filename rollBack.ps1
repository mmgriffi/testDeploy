[CmdletBinding()]
param
(
[Parameter(Mandatory= $true)]
[String]$server,
[Parameter(Mandatory= $true)]
[String]$signalFilepath
)

$errorcode = 0
$signalFile = "${server}_signal.txt"

if (test-path $signalFilePath)
{
  $signal = join-path -path $signalFilePath -childpath $signalFile
  
  if (test-path $signal)
  {
    # if the file exists already. Read it's contents 
   $rollback_response = get-content $signal -First 1
   $tag,$action = $rollback_response.split(":")
    
    if ($action.length -lt 1)
    {

    }
    else
    {
    write-host "there is a message here"
    }

  }
  else
  {
   # if the file does not exist, create it for 1st time. 
   "ROLLBACK:" | out-file $signal
  }
}
else
{
$errorcode = 999
write-host "warning - path to signal file not found exiting script"
}



exit $errorcode
