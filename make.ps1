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

function Build-SFX () {
    Set-Location "$InstallDir"
    $SevenZip = "$ScriptPath\7z920_extra"
    &"$SevenZip\7zr" -r a "..\$BuildStem.7z" "*"

    Set-Location (Get-RepoFullPath "$InstallBase")
    foreach ($Config in @("CI","DEV")) {
        Get-Content "$SevenZip\7zSD.sfx", ("$ScriptPath\$Config" + "sfxconfig.txt"), "$BuildStem.7z" -Encoding Byte -Read 512 | Set-Content "$BuildStem-$Config.exe" -Encoding Byte
    }
}

Clean
Build-Packages
Copy-Install
Build-SFX

#

Set-Location $OrigDir