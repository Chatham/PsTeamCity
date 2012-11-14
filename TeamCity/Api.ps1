function Set-TeamcityCredentials()
{
    [CmdletBinding()]
    param
    (
        [string] $Username = $null, 
        [string] $Password = $null,
        [System.Security.SecureString] $SecureString = $null
    )

    if ( $Username )
    {
        if ( $SecureString )
        {
            $script:g_TeamcityCredentials = New-Object System.Net.NetworkCredential -argumentList ($Username, $SecureString)
        }
        else
        {
            $script:g_TeamcityCredentials = New-Object System.Net.NetworkCredential -argumentList ($Username, $Password)
        }
    }
    else
    {
        $creds = Get-TeamcityCredentials
    }
<#
.Synopsis
    Sets Teamcity credentials.
.Description 
    Explicitly set credentials or be prompted to enter credentials.
.Parameter Username
    Teamcity username.
.Parameter Password
    Teamcity password.
.Parameter SecureString
    Secure string representation of Teamcity password.
    
.Example
    Set-TeamcityCredentials
    Prompt for username and password

.Example
    Set-TeamcityCredentials -Username user -Password pass
    Sets username and password explicitly

.Example
    Set-TeamcityCredentials -Username user -SecureString securepass
    Sets username and password from a secure string
#>
}

function Reset-TeamcityCredentials()
{
    $script:g_TeamcityCredentials = $null
<#
.Synopsis
    Resets Teamcity credentials.
.Description 
    Clears out cached Teamcity credentials.
    
.Example
    Reset-TeamcityCredentials
#>
}

function Set-TeamcityApiBaseUrl()
{
    param 
    (
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match "\w*://.*[^/]`$" })]
        [string] $BaseUrl = "http://teamcity:8111"
    )

    $script:g_TeamcityApiBase = $BaseUrl
<#
.Synopsis
    Sets Teamcity API URL.
.Description 
    Specify the base url for API requests.
.Parameter Username
    BaseUrl Base API Url.
    
.Example
    Set-TeamcityApiBase "http://teamcity:8111"
#>
}

function Invoke-TeamcityGetCommand()
{
    [CmdletBinding()]
    param
    (
        [string] $Url = $null
    )
  
    if ( $Url )
    {
        $credentials = Get-TeamcityCredentials
        $client = New-Object Net.WebClient
        $client.Credentials = $credentials
        $client.DownloadString($url)
    }
}

function Invoke-TeamcityPutCommand()
{
    [CmdletBinding()]
    param
    (
        [string] $Url = $null, 
        [string] $Data = $null,
        [string] $ContentType = "text/xml"
    )

    Invoke-TeamcityPostPutCommand -Url $Url -Data $Data -Method "POST" -ContentType $ContentType
}

function Invoke-TeamcityPutCommand()
{
    [CmdletBinding()]
    param
    (
        [string] $Url = $null, 
        [string] $Data = $null,
        [string] $ContentType = "text/plain"
    )

    Invoke-TeamcityPostPutCommand -Url $Url -Data $Data -Method "PUT" -ContentType $ContentType
}

function Invoke-TeamcityPostPutCommand()
{
    [CmdletBinding()]
    param
    (
        [string] $Url = $null, 
        [string] $Data = $null,
        [string] $Method = $null,
        [string] $ContentType = $null
    )

    if ( $Url -and $Data )
    {
        $credentials = Get-TeamcityCredentials
        $client = New-Object Net.WebClient
        $client.Credentials = $credentials
        $client.Headers.Add("Content-Type", $ContentType)
        $client.UploadString($Url, $Method, $Data)
    }
}

function Invoke-TeamcityDeleteCommand()
{
    [CmdletBinding()]
    param
    (
        [string] $Url = $null
    )

    $credentials = Get-TeamcityCredentials
    $username = $credentials.username
    $password = $credentials.password    
    
    $client = [Net.WebRequest]::Create($url)
    $encodedHeader = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${username}:${pass}"))
    $client.Headers.Add("Authorization", "Basic $encodedHeader")
    $resp = $webRequest.GetResponse()
    $rs = $resp.GetResponseStream()
    $sr = New-Object System.IO.StreamReader -argumentList $rs
    $sr.ReadToEnd()
}

################################################

function Get-TeamcityApiBaseUrl()
{
    if ( $null -eq $script:g_TeamcityApiBase )
    {
        Set-TeamcityApiBaseUrl
    }
    $script:g_TeamcityApiBase
}

function Get-TeamcityCredentials()
{
    if ( $null -eq $script:g_TeamcityCredentials )
    {
        trap { Write-Error "ERROR: You must enter your Teamcity credentials for PsTeamcity to work!"; continue }
        $c = Get-Credential
        if ( $c )
        {
            $username = $c.GetNetworkCredential().Username
            $password = $c.GetNetworkCredential().Password
            $script:g_TeamcityCredentials = New-Object System.Net.NetworkCredential -argumentList ($username, $password)
        }
    }
    $script:g_TeamcityCredentials
}
