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
stages:
  - contain
  - deploy_postval
  - rollback
  - uncontain
"

foreach ($server in $OutputVariable){
    Write-Output $server

    $config += "
$server-contain:
    stage: contain
    before_script:
        - echo `$CI_PROJECT_DIR
        - cd `$CI_PROJECT_DIR\Scripts
    script:
        - echo 'Begin contain for $server'
        - invoke-command -computername ${server} -scriptblock { dir c:\temp }  
    when: 'manual'
    tags:
        - deploy_mit_$site

"
#this will generate multiple files base on site name
#$config | Out-File .\dynamic-config\$server-config-ci.yml -Encoding utf8
}

$config | Out-File .\dynamic-config\dynamic-config-ci.yml -Encoding utf8
Write-Output $config

