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

# OSVR Base Environment
try {
    # Git with the correct params
    choco install -y git -params '"/GitOnlyOnPath /NoAutoCrlf"'
    choco install -y poshgit

    choco install -y nuget.commandline

    # Everyone needs 7zip and Notepad++, and notepad2-mod
    choco install -y 7zip
    choco install -y notepadplusplus
    choco install -y notepad2-mod
    
    # Install the visual studio 2013 redist, just in case we don't bundle it well enough.
    choco install -y install vcredist2013
    # and the 32-bit version, annoying we have to force this.
    choco install -y install vcredist2013 -x86 -f

    Write-ChocolateySuccess 'OSVR-Base-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-Base-Environment' $($_.Exception.Message)
    throw
}
