function Get-AllProjects()
{
    $apiBase = Get-TeamcityApiBaseUrl
    $allProjectData = [xml]$(Invoke-TeamcityGetCommand "$apiBase/httpAuth/app/rest/projects")

    $allProjects = @()
    foreach( $projectData in $allProjectData.projects.ChildNodes )
    {
        $project = New-Project -Id $projectData.id -Name $projectData.name -Href $projectData.href
        $allProjects = $allProjects + $project
    }
    
    $allProjects
<#
.Synopsis
    Retrieve all projects.
.Description 
    Retrieve summary information for all projects.
    
.Example
    Get-AllProjects
#>
}

function Get-Project()
{
    [CmdletBinding()]
    param
    (
        [string] $ProjectLocator = $null,
        [Parameter(ValueFromPipeline=$true)]
        $Project = $null
    )
    
    if ( $Project -or $ProjectLocator )
    {
        $apiBase = Get-TeamcityApiBaseUrl
        if ( $Project )
        {
            $projectUrl = $apiBase + $Project.Href
        }
        else
        {
            $projectUrl = "$apiBase/httpAuth/app/rest/projects/$ProjectLocator"
        }
        $projectData = $([xml]$(Invoke-TeamcityGetCommand $projectUrl)).project
        
        $buildTypes = @()
        if ( $projectData.buildTypes ) 
        {
            foreach ( $buildType in $projectData.buildTypes.ChildNodes )
            {
                $buildType = New-BuildType -Id $buildType.id -Href $buildType.href -Name $buildType.name -WebUrl $buildType.webUrl
                $buildTypes = $buildTypes + $buildType
            }
        }

        $parameters = New-PropertyGroup $projectData.parameters
        
        New-Project -Id $projectData.id -Name $projectData.name -Href $projectData.href -Parameters $parameters -WebUrl $projectData.webUrl`
            -Descripion $projectData.description -Archived $projectData.archived -BuildTypes $buildTypes
    }
<#
.Synopsis
    Retrieve a project.
.Description 
    Retrieves detailed information for a single project.
.Parameter Project
    A project object.
.Parameter ProjectLocator
    Project locator.
    
.Example
    Get-Project -ProjectLocator "id:project1"
    Retrieve detailed project information for id:project1

.Example
    Get-AllProjects | ForEach-Object { $_ | Get-Project }
    Retrieve detailed project information for all projects
#>
}
