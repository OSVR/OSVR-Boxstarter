Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
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


cinst bginfo # for marking machine on desktop
Set-Executionpolicy -Scope CurrentUser -ExecutionPolicy UnRestricted # Unblock powershell