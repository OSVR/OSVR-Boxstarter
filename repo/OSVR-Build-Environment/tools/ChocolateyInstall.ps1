# OSVR Build Environment - Common package to both DEV and CI
try {
    Update-ExecutionPolicy Unrestricted
    cinst chocolatey
    cinst boxstarter
    cinst git -params '"/GitOnlyOnPath /NoAutoCrlf"'
    cinst poshgit
    cinst 7zip
    cinst cmake
    cinst python2
    cinst boost-x64-msvc2013 -source "https://www.myget.org/F/boost/"
    cinst boost-x86-msvc2013 -source "https://www.myget.org/F/boost/"
    cinst nuget.commandline
    cinst notepadplusplus
    Write-ChocolateySuccess 'OSVR-Build-Environment'
} catch {
  Write-ChocolateyFailure 'OSVR-Build-Environment' $($_.Exception.Message)
  throw
}