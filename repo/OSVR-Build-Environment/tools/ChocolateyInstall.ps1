try {
    Update-ExecutionPolicy Unrestricted
    cinst boxstarter -force
    cinst git -Version 1.9.5.20150114 -params '"/GitOnlyOnPath /NoAutoCrlf"'
    cinst poshgit
    cinst 7zip
    cinst cmake
    cinst python2
    cinst boost-x64-msvc2013 -source "https://www.myget.org/F/boost/"
    cinst nuget.commandline
    Write-ChocolateySuccess 'OSVR-Build-Environment'
} catch {
  Write-ChocolateyFailure 'OSVR-Build-Environment' $($_.Exception.Message)
  throw
}