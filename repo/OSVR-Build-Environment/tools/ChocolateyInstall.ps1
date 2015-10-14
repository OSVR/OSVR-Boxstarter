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

# OSVR Build Environment - Common package to both DEV and CI
try {
    # Make powershell usable
    Update-ExecutionPolicy Unrestricted

    # Common install
    Install-BoxstarterPackage -PackageName OSVR-Base-Environment -DisableReboots

    # TODO: when choco 0.9.9 hits Boxstarter, this will be the command instead
    # choco source add --name="osvr-deps" -s="https://www.myget.org/F/osvr-deps/"
    choco sources add -name osvr-deps -source https://www.myget.org/F/osvr-deps/

    # Build requirements
    choco install -y cmake
    
    # These come from osvr-deps, but for some reason the above doesn't trigger yet.
    choco install -y boost-x64-msvc2013 -source https://www.myget.org/F/osvr-deps/ # comes from osvr-deps
    choco install -y boost-x86-msvc2013 -source https://www.myget.org/F/osvr-deps/ # comes from osvr-deps
    choco install -y opencv -source https://www.myget.org/F/osvr-deps/ # updated version comes from osvr-deps

    # Required for jsoncpp build and assorted good things.
    choco install -y python2

    Write-ChocolateySuccess 'OSVR-Build-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-Build-Environment' $($_.Exception.Message)
    throw
}
