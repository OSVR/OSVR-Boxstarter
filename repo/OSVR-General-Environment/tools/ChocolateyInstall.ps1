# OSVR General Environment
try {

    # Common install
    Install-BoxstarterPackage -PackageName OSVR-Base-Environment -DisableReboots

    # Git works nicer with this
    cinst git-credential-winstore

    # Markdown tools
    cinst pandoc
    cinst markpad
    # TODO package CuteMarkEd

    Write-ChocolateySuccess 'OSVR-General-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-General-Environment' $($_.Exception.Message)
    throw
}
