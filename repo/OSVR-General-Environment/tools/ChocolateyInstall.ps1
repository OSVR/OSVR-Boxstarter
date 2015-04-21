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

# OSVR General Environment
try {

    # Common install
    Install-BoxstarterPackage -PackageName OSVR-Base-Environment -DisableReboots

    # Git works nicer with this
    choco install -y git-credential-winstore

    # Markdown tools
    choco install -y pandoc
    choco install -y markpad
    # TODO package CuteMarkEd

    Write-ChocolateySuccess 'OSVR-General-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-General-Environment' $($_.Exception.Message)
    throw
}
