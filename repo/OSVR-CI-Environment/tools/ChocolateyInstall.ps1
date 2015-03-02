# OSVR CI Environment
try {
    Update-ExecutionPolicy UnRestricted
    Disable-InternetExplorerESC

    # Common install
    Install-BoxstarterPackage -PackageName OSVR-Build-Environment -DisableReboots

    # Settings
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
    Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart
    Enable-MicrosoftUpdate # not just windows updates - visual studio updates too.

    # Jenkins node updater
    Install-BoxstarterPackage -PackageName OSVR-Jenkins-Updater -DisableReboots

    # Add repositories
    # TODO: when choco 0.9.9 hits, this will be the command format instead
    # choco source add --name="rpavlik-choco" -s="https://www.myget.org/F/rpavlik-choco/"
    choco sources add -name myget-unity -source https://www.myget.org/F/unity/
    choco sources add -name myget-oculus -source https://www.myget.org/F/oculus-rift/

    # Packages
    cinst javaruntime
    cinst dotnet4.5

    $HasVS2013 = $false
    $VSReg = 'Microsoft\DevDiv\vs\Servicing\12.0'
    $VSEditions = @{
        'expbsln' = 'Express Edition';
    }
    foreach ($Edition in @('Ultimate', 'Premium', 'Professional')) {
        $VSEditions.Add($Edition.ToLower(), $Edition)
    }

    foreach ($baseReg in @('Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\', 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\')) {
        if (Test-Path "$baseReg$vsReg") {
            foreach ($Edition in $VSEditions.GetEnumerator()) {
                $FullReg = "$baseReg$vsReg\" + $Edition.Name
                Write-Verbose "Looking at $FullReg"
            }
        }
    }

    # TODO remove the external source here once 12.0.31101.1 is approved
    # https://chocolatey.org/packages/VisualStudioExpress2013WindowsDesktop
    if (!$HasVS2013) {
        cinst VisualStudioExpress2013WindowsDesktop -source "https://www.myget.org/F/rpavlik-choco/"
    }

    cinst vcexpress2010
    #cinst visualstudio2012wdx

    # Note that this does not license Unity - you still have a first-run thing there.
    cinst unity -source "https://www.myget.org/F/unity/"
    #cinst qt-sdk-windows-x86-msvc2013_opengl

    cinst oculus-sdk -source "https://www.myget.org/F/oculus-rift/"
    cinst oculus-runtime -source "https://www.myget.org/F/oculus-rift/"

    cinst bginfo # for marking machine on desktop

    # Git configuration
    Invoke-FromTask "git config --global core.autocrlf false" -IdleTimeout 20
    Invoke-FromTask "git config --global core.eol lf" -IdleTimeout 20

    Write-ChocolateySuccess 'OSVR-CI-Environment'
} catch {
    Write-ChocolateyFailure 'OSVR-CI-Environment' $($_.Exception.Message)
    throw
}