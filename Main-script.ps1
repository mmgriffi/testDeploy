param(
[Parameter(Mandatory=$true,Position=0)][string]$CI_PROJECT_DIR,
[Parameter(Mandatory=$true,Position=1)][string]$site,
[Parameter(Mandatory=$true,Position=2)][string]$sourcefile,
[Parameter(Mandatory=$false,Position=3)][string]$LogFile=""
)

#$OutputVariable = Invoke-Expression -Command "$CI_PROJECT_DIR\Scripts\NodesList.ps1 -Site $site -CI_PROJECT_DIR $CI_PROJECT_DIR" 

$OutputVariable = @('F32IRD415N1.f32int.mfgint.intel.com', 'F32IAP216N3.f32int.mfgint.intel.com')

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
        - powershell `$CI_PROJECT_DIR\Scripts\Contain.ps1 -CI_PROJECT_DIR `$CI_PROJECT_DIR -site $site -LogFile $LogFile -server $server
    when: 'manual'
    tags:
        - deploy_mit_$site

$server-deploy_postval:
    stage: deploy_postval
    script:
        - echo 'Begin deploy and Post validation for $server'
        - powershell `$CI_PROJECT_DIR\Scripts\Deploy.ps1 -CI_PROJECT_DIR `$CI_PROJECT_DIR -site $site -sourcefile $sourcefile -LogFile $LogFile -server $server
    when: 'manual'
    #needs: ['$server-contain']
    tags:
        - deploy_mit_$site

$server-rollback:
    stage: rollback
    script:
        - echo 'Begin rollback for $server'
        - powershell `$CI_PROJECT_DIR\Scripts\rollback.ps1 -site $site -sourcefile $sourcefile -server $server -CI_PROJECT_DIR `$CI_PROJECT_DIR
    when: 'manual'
    tags:
        - deploy_mit_$site

$server-uncontain:
    stage: uncontain
    script:
        - echo 'Begin uncontain for $server'
        - powershell `$CI_PROJECT_DIR\Scripts\uncontain.ps1 -CI_PROJECT_DIR `$CI_PROJECT_DIR -site $site -LogFile $LogFile -server $server
    when: 'manual'
    #needs: ['$server-deploy_postval']
    tags:
        - deploy_mit_$site
"
#this will generate multiple files base on site name
#$config | Out-File .\dynamic-config\$server-config-ci.yml -Encoding utf8
}

$config | Out-File .\dynamic-config\dynamic-config-ci.yml -Encoding utf8
Write-Output $config

