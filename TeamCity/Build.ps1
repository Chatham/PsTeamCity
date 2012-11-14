function Get-AllBuilds()
{
    param 
    (
        [int]$Count = 100,
        [int]$Start = 0
    )
    
    $apiBase = Get-TeamcityApiBaseUrl
    $allBuildData = [xml]$(Invoke-TeamcityGetCommand "$apiBase/httpAuth/app/rest/builds?count=$Count&start=$Start")
    
    $allBuilds = @()
    foreach( $buildData in $allBuildData.builds.ChildNodes )
    {
        $buildType = New-BuildType -Id $buildData.buildTypeId
        $build = New-Build -Id $buildData.id -Number $buildData.number -Status $buildData.status -StartData $buildData.startDate -Href $buildData.href -BuildType $buildType
        $allBuilds = $allBuilds + $build
    }
    
    $allBuilds
}

function Get-Build()
{
    [CmdletBinding()]
    param
    (
        [string] $BuildLocator = $null,
        [Parameter(ValueFromPipeline=$true)]
        $Build = $null
    )

    if ( $Build -or $BuildLocator )
    {
        $apiBase = Get-TeamcityApiBaseUrl
        if ( $Build )
        {
            $buildUrl = $apiBase + $Build.Href
        }
        else
        {
            $buildUrl = "$apiBase/httpAuth/app/rest/builds/$BuildLocator"
        }
        $buildData = $([xml]$(Invoke-TeamcityGetCommand $buildUrl)).build
        
        $properties = New-PropertyGroup $buildData.properties
        $startDate = $buildData.startDate | ConvertFrom-DateString -FormatString "yyyyMMddTHHmmsszzz"
        try
        {
            $finishDate = $buildData.finishDate | ConvertFrom-DateString -FormatString "yyyyMMddTHHmmsszzz"
        }
        catch
        {
            $finishDate = $null
        }
        
        $agentData = $buildData.agent
        $agent = New-Agent -Id $agentData.id -Name $agentData.name -Href $agentData.href 
        
        $snapshotDependencies = @()
        if ( $buildData.Get_Item("snapshot-dependencies") )
        {
            foreach ( $depBuildData in $buildData.Get_Item("snapshot-dependencies").ChildNodes )
            {
                $buildType = New-BuildType -Id $depBuildData.buildTypeId
                $build = New-Build -Id $depBuildData.id -Number $depBuildData.number -Status $depBuildData.status -StartData $depBuildData.startDate -Href $depBuildData.href -BuildType $buildType -WebUrl $depBuildData.webUrl
                $snapshotDependencies = $snapshotDependencies + $build            
            }
        }

        $artifactDependencies = @()
        if ( $buildData.Get_Item("artifact-dependencies") )
        {
            foreach ( $depBuildData in $buildData.Get_Item("artifact-dependencies").ChildNodes )
            {
                $buildType = New-BuildType -Id $depBuildData.buildTypeId
                $build = New-Build -Id $depBuildData.id -Number $depBuildData.number -Status $depBuildData.status -StartData $depBuildData.startDate -Href $depBuildData.href -BuildType $buildType -WebUrl $depBuildData.webUrl
                $artifactDependencies = $artifactDependencies + $build            
            }
        }
        
        $tags = @()
        if ( $buildData.tags )
        {
            foreach ( $tag in $buildData.tags.ChildNodes )
            {
                $tags = $tags + $tag.InnerText
            }
        }
        
        $buildTypeData = $buildData.buildType
        $project = New-Project -Name $buildTypeData.projectName -Id $buildTypeData.projectId
        $buildType = New-BuildType -Id $buildTypeData.id -Name $buildTypeData.name -Href $buildTypeData.href -WebUrl $buildTypeData.webUrl -Project $project
        $statusText = $buildData.statusText
        
        New-Build -Id $buildData.id -Number $buildData.number -Status $buildData.status -Href $buildData.href -WebUrl $buildData.webUrl -Personal $buildData.personal `
            -History $buildData.history -Pinned $buildData.pinned -Properties $properties -StartDate $startDate -FinishDate $finishDate -BuildType $buildType `
            -ArtifactDependencies $artifactDependencies -SnapshotDependencies $snapshotDependencies -Agent $agent -Tags $tags -StatusText $statusText
    }
}
