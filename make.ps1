# Compute settings
$OrigDir = $PWD
$ScriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptPath
$Version = git describe --tags
$InstallBase = "install"
$BuildStem = "OSVR-Boxstarter-$Version"


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
    $BadFiles += Get-RepoFullPath "$InstallBase"

    foreach ($BadFile in $BadFiles) {
        if (Test-Path $BadFile) {
            Write-Output "Cleaning $BadFile"
            Remove-Item $BadFile
        }
    }
}

function Build-Packages {
    Write-Output "Building Boxstarter packages..."
    Import-Module Boxstarter.Chocolatey
    #$OrigLocalRepo = (Get-BoxStarterConfig)["LocalRepo"]

    $Boxstarter.LocalRepo = Get-RepoFullPath "repo"

    Invoke-BoxstarterBuild -all

    #Set-BoxstarterConfig -LocalRepo $OrigLocalRepo
}

function Copy-Install {
    Write-Output "Copying Boxstarter to $InstallDir..."
    mkdir $InstallDir
    Copy-Item $Boxstarter.BaseDir $InstallDir -Recurse
    Copy-Item (Get-ChildItem -Path (RepoFullPath "repo\*.nupkg")) "$InstallDir\BuildPackages"
}

Clean
Build-Packages
Copy-Install

#

Set-Location $OrigDir