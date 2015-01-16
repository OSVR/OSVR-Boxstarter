try {
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
    # Common install
    Install-BoxstarterPackage -PackageName OSVR-Build-Environment -DisableReboots
    
    # Packages
    cinst notepadplusplus
    cinst sysinternals
    cinst putty
    cinst winmerge
    cinst powershell4
    cinst sumatrapdf
    cinst winscp
    cinst git-credential-winstore
    cinst notepad2-mod
    cinst tortoisemerge
    cinst boxstarter

    Write-ChocolateySuccess 'OSVR-Dev-Environment'
} catch {
  Write-ChocolateyFailure 'OSVR-Dev-Environment' $($_.Exception.Message)
  throw
}