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
        if ( $buildData.finishDate )
        {
            $finishDate = $buildData.finishDate | ConvertFrom-DateString -FormatString "yyyyMMddTHHmmsszzz"
        }
        else
        {
            $finishDate = $null
        }
        
        $buildTypeData = $buildData.buildType
        $project = New-Project -Name $buildTypeData.projectName -Id $buildTypeData.projectId
        $buildType = New-BuildType -Id $buildTypeData.id -Name $buildTypeData.name -Href $buildTypeData.href -WebUrl $buildTypeData.webUrl -Project $project
        
        New-Build -Id $buildData.id -Number $buildData.number -Status $buildData.status -Href $buildData.href -WebUrl $buildData.webUrl -Personal $buildData.personal `
            -History $buildData.history -Pinned $buildData.pinned -Properties $properties -StartDate $startDate -FinishDate $finishDate -BuildType $buildType
    }
}