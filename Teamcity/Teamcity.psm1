#requires -Version 2.0

Set-StrictMode -Version Latest

Push-Location $psScriptRoot
. ./Api.ps1
. ./External.ps1
. ./CustomObjects.ps1
. ./Project.ps1
. ./BuildType.ps1
. ./Build.ps1
Pop-Location

$script:g_TeamcityCredentials = $null
$script:g_TeamcityApiBase = $null

#Api.ps1
Export-ModuleMember Set-TeamcityApiBaseUrl
Export-ModuleMember Set-TeamcityCredentials
Export-ModuleMember Reset-TeamcityCredentials
Export-ModuleMember Invoke-TeamcityGetCommand
Export-ModuleMember Invoke-TeamcityPostCommand
Export-ModuleMember Invoke-TeamcityPutCommand
Export-ModuleMember Invoke-TeamcityDeleteCommand

#Project.ps1
Export-ModuleMember Get-AllProjects
Export-ModuleMember Get-Project

#BuildType.ps1
Export-ModuleMember Get-AllBuildTypes
Export-ModuleMember Get-BuildType

#Build.ps1
Export-ModuleMember Get-AllBuilds
Export-ModuleMember Get-Build
