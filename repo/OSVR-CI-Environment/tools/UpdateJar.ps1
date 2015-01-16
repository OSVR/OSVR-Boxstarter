$JenkinsServer = "http://ci.osvr.com"
$NodeRoot = split-path -parent $MyInvocation.MyCommand.Definition
$ServiceName = "Jenkins Slave"

$HasJenkinsService = $false
if (Get-Service -DisplayName "$ServiceName" -ErrorAction SilentlyContinue) {
    $HasJenkinsService = $true
}

if ($HasJenkinsService) {
    Stop-Service -displayname $servicename
}

$webclient = New-Object System.Net.WebClient
$url = "$JenkinsServer/jnlpJars/slave.jar"
$file = "$NodeRoot\slave.jar"
$webclient.DownloadFile($url,$file)

if ($HasJenkinsService) {
    Start-Service -displayname $servicename
}