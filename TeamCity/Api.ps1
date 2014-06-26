function Set-TeamcityCredentials() 
{
    [CmdletBinding()]
    param (
        [string] $Username = $null, 
        [string] $Password = $null,
        [System.Security.SecureString] $SecureString = $null
    )

    if ( $Username ) {
        if ( $SecureString ) {
            $script:g_TeamcityCredentials = New-Object System.Net.NetworkCredential -argumentList ($Username, $SecureString)
        }
        else {
            $script:g_TeamcityCredentials = New-Object System.Net.NetworkCredential -argumentList ($Username, $Password)
        }
    }
    else {
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


function Set-TeamcityGuestAuth() 
{
    [CmdletBinding()]
    param (
        [string] $Enabled = $true 
    )

    $script:g_TeamcityGuestAuth = $Enabled
<#
.Synopsis
    Set TeamCity guest authorization.

.Description 
    Make all api calls using guest authorization.
    
.Example
    Set-TeamcityGuestAuth
#>
}

function Reset-TeamcityGuestAuth()
{
    $script:g_TeamcityGuestAuth = $null
<#
.Synopsis
    Reset Teamcity guest authorization.

.Description 
    Reset script guest authorization setting.
    
.Example
    Reset-TeamcityGuestAuth
#>
}

function Reset-TeamcityCredentials()
{
    $script:g_TeamcityCredentials = $null
<#
.Synopsis
    Reset Teamcity credentials.

.Description 
    Clear out cached Teamcity credentials.
    
.Example
    Reset-TeamcityCredentials
#>
}

function Set-TeamcityApiBaseUrl() 
{
    param (
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
    param (
        [string] $Url = $null
    )
  
    if ( $Url ) {
        $client = New-Object Net.WebClient
        $client.Headers.Add("Content-Type", "text/xml")

        if ( !$script:g_TeamcityGuestAuth ) {
            $credentials = Get-TeamcityCredentials
            $client.Credentials = $credentials
        }

        $client.DownloadString($Url)
    }
}

function Invoke-TeamcityPostCommand()
{
    [CmdletBinding()]
    param (
        [string] $Url = $null, 
        [string] $Data = $null,
        [string] $ContentType = "text/xml"
    )

    Invoke-TeamcityPostPutCommand -Url $Url -Data $Data -Method "POST" -ContentType $ContentType
}

function Invoke-TeamcityPutCommand() {
    [CmdletBinding()]
    param (
        [string] $Url = $null, 
        [string] $Data = $null,
        [string] $ContentType = "text/plain"
    )

    Invoke-TeamcityPostPutCommand -Url $Url -Data $Data -Method "PUT" -ContentType $ContentType
}

function Invoke-TeamcityPostPutCommand()
{
    [CmdletBinding()]
    param (
        [string] $Url = $null, 
        [string] $Data = $null,
        [string] $Method = $null,
        [string] $ContentType = $null
    )

    if ( $Url -and $Data ) {
        $client = New-Object Net.WebClient
        $client.Headers.Add("Content-Type", $ContentType)

        if ( !$script:g_TeamcityGuestAuth ) {
            $credentials = Get-TeamcityCredentials
            $client.Credentials = $credentials
            $client.UploadString($Url, $Method, $Data)
        }
    }
}

function Invoke-TeamcityDeleteCommand()
{
    [CmdletBinding()]
    param (
        [string] $Url = $null
    )

    $client = [Net.WebRequest]::Create($url)

    if ( !$script:g_TeamcityGuestAuth ) {
        $credentials = Get-TeamcityCredentials
        $username = $credentials.username
        $password = $credentials.password    
        
        $encodedHeader = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${username}:${pass}"))
        $client.Headers.Add("Authorization", "Basic $encodedHeader")
    }

    $resp = $webRequest.GetResponse()
    $rs = $resp.GetResponseStream()
    $sr = New-Object System.IO.StreamReader -argumentList $rs
    $sr.ReadToEnd()
}

function Invoke-TeamcityGetFileCommand() 
{
    [CmdletBinding()]
    param (
        [string] $Url = $null,
		[string] $Path = $pwd.Path 
    )
  
    if ( $Url ) {
        $client = New-Object Net.WebClient

        if ( !$script:g_TeamcityGuestAuth ) {
            $credentials = Get-TeamcityCredentials
            $client.Credentials = $credentials
        }
		[string] $tempFileName = $Path+"\temp" + [guid]::NewGuid() + ".log"
        $client.DownloadFile($Url, $tempFileName)
		
		$header = $client.ResponseHeaders["Content-Disposition"];
		[int] $index = $header.LastIndexOf("filename=");
		if ($index -gt -1)
		{
			$fileName = $header.Substring($index + 9);
			$fileName = $fileName -Replace "["";]", ""
		}
		
		if($fileName)
		{
			Write-Verbose ("tempFile=" + $tempFileName + "; newFileName=" + $fileName)
			Rename-Item -path $tempFileName -NewName $fileName
		}

    }

<#
.Synopsis
    Gets file from Teamcity.

.Description 
    Gets file (f.e. build log, artifact) from Teamcity.

.Parameter Username
    Url Url of the file
	Path Path whare file should be written. If null "$pwd" will be used
    
.Example
    Invoke-TeamcityGetFileCommand -Url "http://teamcity:8111/httpAuth/downloadBuildLog.html?buildId=1" -Path "D:\Logs"
#>
}

################################################

function Get-TeamcityApiBaseUrl()
{
    if ( $null -eq $script:g_TeamcityApiBase ) {
        Set-TeamcityApiBaseUrl
    }

    if ($script:g_TeamcityGuestAuth) {
        "$script:g_TeamcityApiBase/guestAuth/app/rest"
    }
    else {
        "$script:g_TeamcityApiBase/httpAuth/app/rest"
    }
}

function New-TeamcityApiUrl()
{
    [CmdletBinding()]
    param (
        [string]$UrlStub
    )

    $baseUrl = Get-TeamcityApiBaseUrl
    $stub = $UrlStub -Replace "^\/(httpAuth|guestAuth)\/app\/rest", ""
    $baseUrl + $stub
}

function Get-TeamcityCredentials()
{
    if ( $null -eq $script:g_TeamcityCredentials ) {
        trap { Write-Error "ERROR: You must enter your Teamcity credentials for PsTeamcity to work!"; continue }
        $c = Get-Credential
        if ( $c ) {
            $username = $c.GetNetworkCredential().Username
            $password = $c.GetNetworkCredential().Password
            $script:g_TeamcityCredentials = New-Object System.Net.NetworkCredential -argumentList ($username, $password)
        }
    }
    $script:g_TeamcityCredentials
}

function Get-TeamcityBaseUrl()
{
	if ( $null -eq $script:g_TeamcityApiBase ) {
        Set-TeamcityApiBaseUrl
    }
	
	if ($script:g_TeamcityGuestAuth) {
        "$script:g_TeamcityApiBase/guestAuth"
    }
    else {
        "$script:g_TeamcityApiBase/httpAuth"
    }
}

function New-TeamcityBaseUrl()
{
    [CmdletBinding()]
    param (
        [string]$UrlStub
    )

    $baseUrl = Get-TeamcityBaseUrl
    $stub = $UrlStub -Replace "^\/(httpAuth|guestAuth)", ""
    $baseUrl + $stub
}



