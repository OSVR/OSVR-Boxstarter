# OSVR Base Environment
try {
    # Git with the correct params
    cinst git -params '"/GitOnlyOnPath /NoAutoCrlf"'
    cinst poshgit

    # Install the package management stuff that keeps us sane
    cinst chocolatey --version=0.9.8.33 # TODO this is the last powershell-only version before the rewrite: remove version override once choco 0.9.9+ is tested and adopted.
    cinst boxstarter
    cinst nuget.commandline

    # Everyone needs 7zip and Notepad++, and notepad2-mod
    cinst 7zip
    cinst notepadplusplus
    cinst notepad2-mod
    
    # Install the visual studio 2013 redist, just in case we don't bundle it well enough.
    choco install vcredist2013
    # and the 32-bit version, annoying we have to force this.
    choco install vcredist2013 -x86 --force

    Write-ChocolateySuccess 'OSVR-Base-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-Base-Environment' $($_.Exception.Message)
    throw
}
