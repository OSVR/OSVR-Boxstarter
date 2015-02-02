# OSVR CI Environment
try {
    Update-ExecutionPolicy UnRestricted
    Disable-InternetExplorerESC

    # Common install
    Install-BoxstarterPackage -PackageName OSVR-Build-Environment -DisableReboots

    # Settings
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
    Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart

    # Jenkins node updater
    Install-BoxstarterPackage -PackageName OSVR-Jenkins-Updater -DisableReboots

    # Packages
    cinst javaruntime
    cinst dotnet4.5
    cinst notepadplusplus
    cinst VisualStudioExpress2013WindowsDesktop -source "https://www.myget.org/F/rpavlik-choco/"
    cinst vcexpress2010
    #cinst visualstudio2012wdx
    cinst unity -source "https://www.myget.org/F/unity/"
    #cinst qt-sdk-windows-x86-msvc2013_opengl

    cinst oculus-sdk -source "https://www.myget.org/F/oculus-rift/"
    cinst oculus-runtime -source "https://www.myget.org/F/oculus-rift/"

    cinst wixtoolset

    cinst bginfo # for marking machine on desktop

    # Git configuration
    Invoke-FromTask "git config --global core.autocrlf false" -IdleTimeout 20
    Invoke-FromTask "git config --global core.eol lf" -IdleTimeout 20

    Write-ChocolateySuccess 'OSVR-CI-Environment'
} catch {
  Write-ChocolateyFailure 'OSVR-CI-Environment' $($_.Exception.Message)
  throw
}
