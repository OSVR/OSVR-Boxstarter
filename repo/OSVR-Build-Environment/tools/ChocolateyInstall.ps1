# OSVR Build Environment - Common package to both DEV and CI
try {
    # Make powershell usable
    Update-ExecutionPolicy Unrestricted

    # Install the package management stuff that keeps us sane
    cinst chocolatey
    cinst boxstarter
    cinst nuget.commandline

    # TODO: when choco 0.9.9 hits, this will be the command instead
    # choco source add --name="rpavlik-choco" -s="https://www.myget.org/F/rpavlik-choco/"
    choco sources add -name rpavlik-choco -source https://www.myget.org/F/rpavlik-choco/
    choco sources add -name myget-boost -source https://www.myget.org/F/boost/

    # Git with the correct params
    cinst git -params '"/GitOnlyOnPath /NoAutoCrlf"'
    cinst poshgit

    # Everyone needs 7zip and Notepad++
    cinst 7zip
    cinst notepadplusplus

    # Build requirements
    cinst cmake
    cinst boost-x64-msvc2013 -source "https://www.myget.org/F/boost/"
    cinst boost-x86-msvc2013 -source "https://www.myget.org/F/boost/"

    # Required for jsoncpp build and assorted good things.
    cinst python2

    Write-ChocolateySuccess 'OSVR-Build-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-Build-Environment' $($_.Exception.Message)
    throw
}