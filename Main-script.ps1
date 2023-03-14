param(
[Parameter(Mandatory=$true,Position=0)][string]$CI_PROJECT_DIR,
[Parameter(Mandatory=$true,Position=1)][string]$site,
[Parameter(Mandatory=$true,Position=2)][string]$sourcefile,
[Parameter(Mandatory=$false,Position=3)][string]$LogFile=""
)

#$OutputVariable = Invoke-Expression -Command "$CI_PROJECT_DIR\Scripts\NodesList.ps1 -Site $site -CI_PROJECT_DIR $CI_PROJECT_DIR" 

#$OutputVariable = @('F32IRD415N1.f32int.mfgint.intel.com', 'F32IAP216N3.f32int.mfgint.intel.com')

$OutputVariable = @('clvwsrv2016n3','kyvwdc01')

Write-Host "Nodes List from DNS: " $OutputVariable 

$config = "
name: CI_app
on:
  workflow_dispatch:

jobs:
"

foreach ($server in $OutputVariable){
    Write-Output $server

  $config += "
  $server-preval:
    runs-on: [self-hosted,Win2016,$server]
    environment: Int_approval
    timeout-minutes: 120
    steps:
      - uses: actions/checkout@v3
      # checkout~v3 checked out the files from the repo to the target machine. Run one time per workflow.
      - name: Run a one-line script
        run: |
           .\test-path.ps1 -mypath ${CI_PROJECT_DIR}
           echo 'Path found . This is the F32int_prevalJob!'
           #copy test-path.ps1 ${CI_PROJECT_DIR}
           powershell invoke-command -computername ${server} -scriptblock { dir c:\temp }  
"
#this will generate multiple files base on site name
#$config | Out-File .\dynamic-config\$server-config-ci.yml -Encoding utf8
}

$config | Out-File .\dynamic-config\dynamic-config-ci.yml -Encoding utf8
Write-Output $config

