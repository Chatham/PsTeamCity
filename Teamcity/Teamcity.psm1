#requires -Version 2.0

Set-StrictMode -Version Latest

Push-Location $psScriptRoot
. ./Api.ps1
. ./CustomObjects.ps1
. ./Project.ps1
. ./BuildType.ps1
Pop-Location

$script:g_TeamcityCredentials = $null
$script:g_TeamcityApiBase = $null

#Shared.ps1
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
