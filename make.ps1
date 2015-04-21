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

# Compute settings
$OrigDir = $PWD
$ScriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptPath
$Version = git describe --tags --always
$InstallBase = "install"
$BuildStem = "OSVR-Boxstarter-$Version"

# All files in the root directory ending in this will result in a self-extracting installer.
$ConfigBase = "sfxconfig.txt"

function Get-RepoFullPath ($RelativePath) {
    Join-Path -ChildPath $RelativePath -Path $ScriptPath
}

$InstallDir = Get-RepoFullPath "$InstallBase\$BuildStem"


Write-Output "Building OSVR Boxstarter Packages, release $Version"


# Clean the build
function Clean {
    Write-Output "Cleaning..."
    $BadFiles = @(Get-ChildItem -Path (RepoFullPath "repo\*.nupkg") -Recurse)
    $BadFiles += Get-RepoFullPath "repo\OSVR-CI-Environment\tools\slave.jar"
    $BadFiles += Get-RepoFullPath "repo\OSVR-Jenkins-Updater\slave.jar"
    $BadFiles += Get-RepoFullPath "$InstallBase"

    foreach ($BadFile in $BadFiles) {
        if (Test-Path $BadFile) {
            Write-Output "Cleaning $BadFile"
            Remove-Item $BadFile -Recurse
        }
    }
}

function Build-Packages {
    Write-Output "Building Boxstarter packages..."
    Import-Module Boxstarter.Chocolatey
    #$OrigLocalRepo = (Get-BoxStarterConfig)["LocalRepo"]

    #$Boxstarter.LocalRepo = Get-RepoFullPath "repo"
    #Invoke-BoxstarterBuild -all
    Set-Location (Get-RepoFullPath "repo")
    foreach ($nuspec in @(Get-ChildItem -path "$PWD\*.nuspec" -recurse)) {
        Set-Location $nuspec.Directory.Parent.FullName
        nuget pack (join-path $nuspec.Directory $nuspec.Name) -NoPackageAnalysis -NonInteractive
    }

    #Set-BoxstarterConfig -LocalRepo $OrigLocalRepo
}

function Copy-Install {
    Import-Module Boxstarter.Chocolatey
    Write-Output "Copying Boxstarter to $InstallDir..."
    mkdir -Path $InstallDir
    Copy-Item $Boxstarter.BaseDir $InstallDir -Recurse
    Copy-Item (Get-ChildItem -Path (RepoFullPath "repo\*.nupkg")) "$InstallDir\Boxstarter\BuildPackages" -Recurse
}

# Example: Create-7ZipSFX 7z920_extra\7zSD.sfx MySFXConfig.txt MyFiles.7z MyOutputFile.exe
function Create-7ZipSFX ($7zSFXModule, $SFXConfig, $7zFile, $Output) {
    Get-Content "$7zSFXModule", "$SFXConfig", "$7zFile" -Encoding Byte -Read 512 | Set-Content "$Output" -Encoding Byte
}

function Build-SFX () {
    # Get list of configs
    Set-Location "$ScriptPath"
    $Configs = Get-ChildItem "*$ConfigBase" | foreach-object {$_.name.Replace($ConfigBase, "")}


    Write-Output "Compressing distribution..."
    Set-Location "$InstallDir"
    $SevenZip = "$ScriptPath\7z920_extra"
    &"$SevenZip\7zr" -r a "..\$BuildStem.7z" "*"

    Set-Location (Get-RepoFullPath "$InstallBase")
    foreach ($Config in $Configs) {
        Write-Output "Creating $Config self-extracting file"
        Create-7ZipSFX "$SevenZip\7zSD.sfx" ("$ScriptPath\$Config" + "sfxconfig.txt") "$BuildStem.7z" "$BuildStem-$Config.exe"
    }
}

Clean
Build-Packages
Copy-Install
Build-SFX

Write-Output "Done!"
#

Set-Location $OrigDir
