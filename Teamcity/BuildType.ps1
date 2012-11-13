function Get-AllBuildTypes()
{
    $apiBase = Get-TeamcityApiBaseUrl
	$allBuildTypeData = [xml]$(Invoke-TeamcityGetCommand "$apiBase/httpAuth/app/rest/buildTypes")
    
	$allBuildTypes = @()
	foreach( $buildTypeData in $allBuildTypeData.buildTypes.ChildNodes )
	{
		$buildType = New-BuildType -Id $buildTypeData.id -Name $buildTypeData.name -Href $buildTypeData.href -ProjectName $buildTypeData.projectName -ProjectId $buildTypeData.projectId -WebUrl $buildTypeData.webUrl
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
    param
    (
        [string] $BuildTypeLocator = $null,
        [Parameter(ValueFromPipeline=$true)]
        $BuildType = $null
    )
    
    if ( $BuildType -or $BuildTypeLocator )
    {
        $apiBase = Get-TeamcityApiBaseUrl
        if ( $BuildType )
        {
            $buildTypeUrl = $apiBase + $BuildType.Href
        }
        else
        {
            $buildTypeUrl = "$apiBase/httpAuth/app/rest/buildTypes/$BuildTypeLocator"
        }
        $buildTypeData = [xml]$(Invoke-TeamcityGetCommand $buildTypeUrl)
        
        $parameters = New-PropertyGroup $buildTypeData.buildType.parameters
        $settings = New-PropertyGroup $buildTypeData.buildType.settings

        $snapshotDependencies = @()
        if ( $buildTypeData.buildType.Get_Item("snapshot-dependencies") ) 
        {
            foreach ( $snapshotData in $buildTypeData.buildType.Get_Item("snapshot-dependencies").ChildNodes )
            {
                $properties = New-PropertyGroup $snapshotData.properties
                $snapshot = New-Dependency -Id $snapshotData.id -Type $snapshotData.type -Properties $properties
                $snapshotDependencies = $snapshotDependencies + $snapshot
            }
        }
        
        $artifactDependencies = @()
        if ( $buildTypeData.buildType.Get_Item("artifact-dependencies") ) 
        {
            foreach ( $snapshotData in $buildTypeData.buildType.Get_Item("snapshot-dependencies").ChildNodes )
            {
                $properties = New-PropertyGroup $snapshotData.properties
                $snapshot = New-Dependency -Id $snapshotData.id -Type $snapshotData.type -Properties $properties
                $artifactDependencies = $artifactDependencies + $snapshot
            }
        }
        
        New-BuildType -Id $buildTypeData.buildType.id -Name $buildTypeData.buildType.name -Href $buildTypeData.buildType.href -WebUrl $buildTypeData.buildType.webUrl `
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
