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

# OSVR Dev Environment
try {
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions

    # Common install
    Install-BoxstarterPackage -PackageName OSVR-Build-Environment -DisableReboots

    # Packages
    cinst sysinternals
    cinst putty
    cinst winmerge
    cinst powershell4
    cinst sumatrapdf
    cinst winscp
    cinst git-credential-winstore
    cinst tortoisemerge

    # Markdown tools
    cinst pandoc
    cinst markpad
    # TODO package CuteMarkEd

    Write-ChocolateySuccess 'OSVR-Dev-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-Dev-Environment' $($_.Exception.Message)
    throw
}
