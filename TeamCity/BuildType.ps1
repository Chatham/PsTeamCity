function Get-AllBuildTypes()
{
    $url = New-TeamcityApiUrl "/buildTypes"
    $allBuildTypeData = [xml]$(Invoke-TeamcityGetCommand $url)
    
    $allBuildTypes = @()
    foreach( $buildTypeData in $allBuildTypeData.buildTypes.ChildNodes ) {
        $project = New-Project -Name $buildTypeData.projectName -Id $buildTypeData.projectId
        $buildType = New-BuildType -Id $buildTypeData.id -Name $buildTypeData.name -Href $buildTypeData.href -WebUrl $buildTypeData.webUrl -Project $project
        $allBuildTypes = $allBuildTypes + $buildType
    }
    
    $allBuildTypes
<#
.Synopsis
    Retrieve all build types.

.Description 
    Retrieve summary information for all build types.
    
.Example
    Get-AllBuildTypes
#>
}

function Get-BuildType()
{
    [CmdletBinding()]
    param (
        [string] $BuildTypeLocator = $null,
        [Parameter(ValueFromPipeline=$true)]
        $BuildType = $null
    )
    
    if ( $BuildType -or $BuildTypeLocator ) {
        if ( $BuildType ) {
            $buildTypeUrl = New-TeamcityApiUrl $BuildType.Href
        }
        else {
            $buildTypeUrl = New-TeamcityApiUrl "/buildTypes/$BuildTypeLocator"
        }
        $buildTypeData = $([xml]$(Invoke-TeamcityGetCommand $buildTypeUrl)).buildType
        
        $parameters = New-PropertyGroup $buildTypeData.parameters
        $settings = New-PropertyGroup $buildTypeData.settings

        $snapshotDependencies = @()
        if ( $buildTypeData.Get_Item("snapshot-dependencies") )  {
            foreach ( $snapshotData in $buildTypeData.Get_Item("snapshot-dependencies").ChildNodes ) {
                $properties = New-PropertyGroup $snapshotData.properties
                $snapshot = New-Dependency -Id $snapshotData.id -Type $snapshotData.type -Properties $properties
                $snapshotDependencies = $snapshotDependencies + $snapshot
            }
        }
        
        $artifactDependencies = @()
        if ( $buildTypeData.Get_Item("artifact-dependencies") ) {
            foreach ( $snapshotData in $buildTypeData.Get_Item("snapshot-dependencies").ChildNodes ) {
                $properties = New-PropertyGroup $snapshotData.properties
                $snapshot = New-Dependency -Id $snapshotData.id -Type $snapshotData.type -Properties $properties
                $artifactDependencies = $artifactDependencies + $snapshot
            }
        }
        
        $projectData = $buildTypeData.project
        $project = New-Project -Id $projectData.id -Name $projectData.name -Href $projectData.href
        
        New-BuildType -Id $buildTypeData.id -Name $buildTypeData.name -Href $buildTypeData.href -WebUrl $buildTypeData.webUrl -Project $project -Paused $buildTypeData.paused `
            -Parameters $parameters -Settings $settings -SnapshotDependencies $snapshotDependencies -ArtifactDependencies $artifactDependencies
    }
<#
.Synopsis
    Retrieve a build type.

.Description 
    Retrieve detailed information for a single build type.

.Parameter BuildTypeLocator
    Build type locator.
    
.Parameter BuildType
    A project object.
    
.Example
    Get-BuildType -ProjectLocator "id:bt123"
    Retrieves detailed build type information for id:bt123
#>
}
