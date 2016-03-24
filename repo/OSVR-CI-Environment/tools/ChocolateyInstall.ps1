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
# OSVR CI Environment
try {
    Update-ExecutionPolicy UnRestricted
    Disable-InternetExplorerESC

    # Common install
    Install-BoxstarterPackage -PackageName OSVR-Build-Environment -DisableReboots

    # Settings
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
    Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart
    Enable-MicrosoftUpdate # not just windows updates - visual studio updates too.

    # Jenkins node updater
    Install-BoxstarterPackage -PackageName OSVR-Jenkins-Updater -DisableReboots

    # Install the package management stuff that keeps us sane
    #cinst chocolatey --version=0.9.8.33 # TODO this is the last powershell-only version before the rewrite: remove version override once choco 0.9.9+ is tested and adopted.
    choco install -y boxstarter

    # Add repositories
    # TODO: when choco 0.9.9 hits, this will be the command format instead
    # choco source add --name="rpavlik-choco" -s="https://www.myget.org/F/rpavlik-choco/"
    choco sources add -name myget-unity -source https://www.myget.org/F/unity/
    choco sources add -name myget-oculus -source https://www.myget.org/F/oculus-rift/

    # Packages
    choco install -y javaruntime
    choco install -y dotnet4.5

    $HasVS2013 = $false
    $VSReg = 'Microsoft\DevDiv\vs\Servicing\12.0'
    $VSEditions = @{
        'expbsln' = 'Express Edition';
    }
    foreach ($Edition in @('Ultimate', 'Premium', 'Professional')) {
        $VSEditions.Add($Edition.ToLower(), $Edition)
    }

    foreach ($baseReg in @('Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\', 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\')) {
        if (Test-Path "$baseReg$vsReg") {
            foreach ($Edition in $VSEditions.GetEnumerator()) {
                $FullReg = "$baseReg$vsReg\" + $Edition.Name
                Write-Verbose "Looking at $FullReg"
            }
        }
    }

    # TODO remove the external source here once 12.0.31101.1 is approved
    # https://chocolatey.org/packages/VisualStudioExpress2013WindowsDesktop
    if (!$HasVS2013) {
        choco install -y VisualStudioExpress2013WindowsDesktop -source "https://www.myget.org/F/rpavlik-choco/"
    }

    choco install -y vcexpress2010
    #cinst visualstudio2012wdx

    # Note that this does not license Unity - you still have a first-run thing there.
    choco install -y unity -source "https://www.myget.org/F/unity/"
    #cinst qt-sdk-windows-x86-msvc2013_opengl

    choco install -y oculus-sdk -source "https://www.myget.org/F/oculus-rift/"
    choco install -y oculus-runtime -source "https://www.myget.org/F/oculus-rift/"

    choco install -y bginfo # for marking machine on desktop

    # For building OSVR-Config tool
    choco install nodejs -version 4.4.0 -y
    choco pin add -name nodejs
    choco pin add -name nodejs.install
    npm upgrade -g npm
    npm install -g bower
    npm install -g gulp

    # Git configuration
    git config --global core.autocrlf false
    Invoke-FromTask "git config --global core.autocrlf false" -IdleTimeout 20
    git config --global core.eol lf
    Invoke-FromTask "git config --global core.eol lf" -IdleTimeout 20

    Write-ChocolateySuccess 'OSVR-CI-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-CI-Environment' $($_.Exception.Message)
    throw
}
