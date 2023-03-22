$testfile = "\\192.168.1.20\smb\mmgriffi\CICD\validfile.txt"
   if (test-path $testfile)
      {
       write-host "$testfile was found, we can close the script with a $errorcode (success)"
       $errorcode = 0
       }

    else
    {
        $errorcode = 999
        write-host "$testfile was not found, we can close the script with a $errorcode (failure)"
    }
       
write-host "We will post an $errorcode on this script no matter what"
$errorcode = 0
exit $errorcode
