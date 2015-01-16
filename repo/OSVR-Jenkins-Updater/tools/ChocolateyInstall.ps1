try {
    $JenkinsRoot = "C:\jenkins-node"
    if (Test-Path $JenkinsRoot) {} else {
        mkdir -Path $JenkinsRoot # -ErrorAction SilentlyContinue
    }
    $UpdateScriptName = "UpdateJar.ps1"
    $FullUpdateScriptName = Join-Path $JenkinsRoot $UpdateScriptName
    Copy-Item (Join-Path (Get-PackageRoot($MyInvocation)) $UpdateScriptName) "$FullUpdateScriptName" -Force
    Invoke-Expression "$FullUpdateScriptName"
    Write-ChocolateySuccess 'OSVR-Jenkins-Updater'
} catch {
  Write-ChocolateyFailure 'OSVR-Jenkins-Updater' $($_.Exception.Message)
  throw
}