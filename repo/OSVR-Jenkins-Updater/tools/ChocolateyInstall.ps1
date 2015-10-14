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

$JenkinsRoot = "C:\jenkins-node"

try {

    if (!(Test-Path $JenkinsRoot)) {
        mkdir -Path $JenkinsRoot # -ErrorAction SilentlyContinue
    }
    # Copy the stop-service script first, and run it.
    # Then, we can copy the update-jar script and run it
    $ScriptsInOrder = @('StopService.ps1', 'UpdateJar.ps1')
    ForEach ($ScriptName in $ScriptsInOrder) {
        $FullScriptName = Join-Path $JenkinsRoot $ScriptName
        Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) $ScriptName) "$FullScriptName" -Force
        Invoke-Expression "$FullScriptName -SkipWait"
    }
    Write-ChocolateySuccess 'OSVR-Jenkins-Updater'
} catch {
  Write-ChocolateyFailure 'OSVR-Jenkins-Updater' $($_.Exception.Message)
  throw
}
