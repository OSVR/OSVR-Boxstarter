$JenkinsServer = "http://ci.osvr.com"
$NodeRoot = split-path -parent $MyInvocation.MyCommand.Definition
$ServiceName = "Jenkins Slave"

Write-Output "In UpdateJar - checking for the Jenkins service..."

$HasJenkinsService = $false
if (Get-Service -DisplayName "$ServiceName" -ErrorAction SilentlyContinue) {
    $HasJenkinsService = $true
}

Write-Output "Jenkins service running: $HasJenkinsService"

if ($HasJenkinsService) {
    Write-Output "Stopping Jenkins service..."
    Stop-Service -displayname $servicename
}

$webclient = New-Object System.Net.WebClient
$url = "$JenkinsServer/jnlpJars/slave.jar"
$file = "$NodeRoot\slave.jar"
Write-Output "Downloading $url"
$webclient.DownloadFile($url,$file)

if ($HasJenkinsService) {
    Write-Output "Starting Jenkins service..."
    Start-Service -displayname $servicename
}