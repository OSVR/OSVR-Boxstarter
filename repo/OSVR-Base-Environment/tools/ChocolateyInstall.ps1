# OSVR Base Environment
try {
    # Git with the correct params
    cinst git -params '"/GitOnlyOnPath /NoAutoCrlf"'
    cinst poshgit

    # Install the package management stuff that keeps us sane
    cinst chocolatey
    cinst boxstarter
    cinst nuget.commandline

    # Everyone needs 7zip and Notepad++, and notepad2-mod
    cinst 7zip
    cinst notepadplusplus
    cinst notepad2-mod

    Write-ChocolateySuccess 'OSVR-Base-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-Base-Environment' $($_.Exception.Message)
    throw
}