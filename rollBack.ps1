[CmdletBinding()]
param
(
[Parameter(Mandatory= $true)]
[String]$server,
[Parameter(Mandatory= $true)]
[String]$signalFilepath,
[Parameter(Mandatory= $true)]
[int]$timeToWaitHrs
)

$debug = "yes"
$errorcode = 0
$signalFile = "${server}_signal.txt"
$mydate = (Get-Date -format "dd-MMM-yyyy_HH_mm")

$signal = join-path -path $signalFilePath -childpath $signalFile
function check_signal
{
    if (test-path $signalFilePath)
    {
      
      if (test-path $signal)
      {
        # if the file exists already. Read it's contents 
       $rollback_response = get-content $signal -First 1
       $tag,$action = $rollback_response.split(":")
    

        if ($action.length -lt 1)
        {
        write-host "the file has no response yet" 
        }
        else
        {
            write-host "There is a response in $signal"
            if (($action -eq "NO") -or ($action -eq "YES"))
            {
                write-host "$action" -ForegroundColor Green
                write-host "will signal that $action to rollback"
                return $action 
            }
            else
            {
               write-host "$action" -ForegroundColor yellow
            }
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

}

function NO_Rollback
{
    write-host "NO rollback needed"
}

function RUN_Rollback
{
    write-host "Executing functions assocated with Rollback"

    $errorcode = 0
    $mydate = (Get-Date -format "dd-MMM-yyyy_HH_mm")

    $id = "ABB6AC00-F1D8-4EBF-8128-830D090B76C0"

    $command = 'msiexec.exe /x  "C:\temp\SQL2000SampleDb.msi" /quiet /qn /norestart '
    $command = $command + ' /Lv c:\temp\uninstaller.log'
    #$command | out-file c:\temp\installCommandline.txt
    #& $command
    
    if ($debug -eq "no")
    {
    invoke-expression $command 
    }
    else
    {
    write-host "$command" -ForegroundColor yellow
    }

}

#setup loop
$TimeStart = Get-Date
$TimeEnd = $timeStart.addminutes($timeToWaitHrs)
Write-Host "Start Time: $TimeStart"
write-host "End Time:   $TimeEnd"
Do { 
 $TimeNow = Get-Date
 if ($TimeNow -ge $TimeEnd) {
  Write-host "It's time to finish."
 } else {
  Write-Host "checking $signal contents"
  $my_action = check_signal

 }
 Start-Sleep -Seconds 60
}
Until (($TimeNow -ge $TimeEnd) -or ($my_Action -eq "NO") -or ($my_action -eq "YES"))

if ($my_action -eq "NO")
{
        NO_Rollback
} 
elseif ($my_action -eq "YES")
{
        RUN_ROLLBACK
}
else
{
    $message = "ALERT - no valid action was given in time allowed"
    write-host "$message" -ForegroundColor Red
    $errorcode = 999
}
write-host "will exit with a $errorcode"

$signalFile = "${server}_signal.txt"
$mydate = (Get-Date -format "dd-MMM-yyyy_HH_mm")

$backupSignal = "{signalFile}_${mydate}"
move-item $signal $signalFilePath\$backupSignal

exit $errorcode
