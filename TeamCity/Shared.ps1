function Get-AllParameters()
{
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        $Object
    )
    
    $apiBase = Get-TeamcityApiBaseUrl
    $parameterUrl = $apiBase + $Object.Href + "/parameters"
    $parameters = $([xml]$(Invoke-TeamcityGetCommand $parameterUrl)).properties
    New-PropertyGroup $parameters    
}

function Get-Parameter()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Parameter,
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        $Object
    )
    
    $apiBase = Get-TeamcityApiBaseUrl
    $parameterUrl = $apiBase + $Object.Href + "/parameters/$Parameter"
    Invoke-TeamcityGetCommand $parameterUrl
}
