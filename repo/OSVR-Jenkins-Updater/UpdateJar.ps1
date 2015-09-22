# Copyright 2014, 2015 Sensics, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

param(
  [string] $JenkinsServer = $env:JENKINS_HOST,
  [switch] $SkipWait
)

$NodeRoot = split-path -parent $MyInvocation.MyCommand.Definition

# This is fixed - just listed here to avoid magic constants elsewhere
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

if ($SkipWait) {
    Write-Output 'Exiting directly, as requested.'
} else {
    Read-Host 'Press the enter key to exit'
}
