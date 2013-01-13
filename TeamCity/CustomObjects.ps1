function New-Project() 
{
    param (
        [string] $Id, 
        [string] $Name, 
        [string] $Href,
        [string] $WebUrl,
        [string] $Archived,
        [PSObject] $Parameters,
        [PSObject] $BuildTypes
    )

    $obj = New-Object PSObject
    $obj | Add-Member NoteProperty -Name Id -Value $Id
    $obj | Add-Member NoteProperty -Name Name -Value $Name
    $obj | Add-Member NoteProperty -Name Href -Value $Href
    $obj | Add-Member NoteProperty -Name WebUrl -Value $WebUrl
    if ( $Archived -ne "" ) { [bool]$Archived = [System.Convert]::ToBoolean($Archived) }
    $obj | Add-Member NoteProperty -Name Archived -Value $Archived
    $obj | Add-Member NoteProperty -Name Parameters -Value $Parameters
    $obj | Add-Member NoteProperty -Name BuildTypes -Value $BuildTypes
    $obj
}

function New-BuildType()
{
    param (
        [string] $Id,
        [string] $Name,
        [string] $Description,
        [string] $Href,
        [string] $WebUrl,
        [string] $Paused,
        [PSObject] $Project,
        [PSObject] $Settings,
        [PSObject] $Parameters,
        [PSObject] $ArtifactDependencies,
        [PSObject] $SnapshotDependencies,
        [PSObject] $VcsRoots
    )
    
    $obj = New-Object PSObject
    $obj | Add-Member NoteProperty -Name Id -Value $Id
    $obj | Add-Member NoteProperty -Name Name -Value $Name
    $obj | Add-Member NoteProperty -Name Description -Value $Description
    if ( $Id -and ( $Href -eq "" ) ) {
        $Href = "/buildTypes/id:$Id"
    }
    $obj | Add-Member NoteProperty -Name Href -Value $Href
    $obj | Add-Member NoteProperty -Name WebUrl -Value $WebUrl
    if ( $Paused -ne "" ) { [bool]$Paused = [System.Convert]::ToBoolean($Paused) }
    $obj | Add-Member NoteProperty -Name Paused -Value $Paused
    $obj | Add-Member NoteProperty -Name Project -Value $Project
    $obj | Add-Member NoteProperty -Name Settings -Value  $Settings
    $obj | Add-Member NoteProperty -Name Parameters -Value $Parameters
    $obj | Add-Member NoteProperty -Name ArtifactDependencies -Value $ArtifactDependencies
    $obj | Add-Member NoteProperty -Name SnapshotDependencies -Value $SnapshotDependencies
    $obj | Add-Member NoteProperty -Name VcsRoots -Value $VcsRoots
    $obj   
}

function New-BuildStep() 
{
    param (
        [string] $Id,
        [string] $Name, 
        [string] $Type,
        [PSObject] $Properties
    )

    $obj = New-Object PSObject
    $obj | Add-Member NoteProperty -Name Id -Value $Id
    $obj | Add-Member NoteProperty -Name Name -Value $Name
    $obj | Add-Member NoteProperty -Name Type -Value $Type 
    $obj | Add-Member NoteProperty -Name Properties -Value $Properties
    $obj
}

function New-Build()
{
    param (
        [string] $Id,
        [string] $Number,
        [string] $Status,
        [string] $StatusText,
        [string] $Href,
        [string] $WebUrl,
        [string] $Personal,
        [string] $History,
        [string] $Pinned,
        [DateTimeOffset] $StartDate,
        [string] $FinishDate,
        [PSObject] $BuildType,
        [PSObject] $Agent,
        [PSObject] $Tags,
        [PSObject] $Properties,
        [PSObject] $SnapshotDependencies,
        [PSObject] $ArtifactDependencies
    )

    $obj = New-Object PSObject
    $obj | Add-Member NoteProperty -Name Id -Value $Id
    $obj | Add-Member NoteProperty -Name Number -Value $Number
    $obj | Add-Member NoteProperty -Name Status -Value $Status
    $obj | Add-Member NoteProperty -Name StatusText -Value $StatusText
    $obj | Add-Member NoteProperty -Name Href -Value $Href
    $obj | Add-Member NoteProperty -Name WebUrl -Value $WebUrl
    if ( $Personal -ne "" ) { [bool]$Personal = [System.Convert]::ToBoolean($Personal) }
    $obj | Add-Member NoteProperty -Name Personal -Value $Personal
    if ( $History -ne "" ) { [bool]$History = [System.Convert]::ToBoolean($History) }
    $obj | Add-Member NoteProperty -Name History -Value $History
    if ( $Pinned -ne "" ) { [bool]$Pinned = [System.Convert]::ToBoolean($Pinned) }
    $obj | Add-Member NoteProperty -Name Pinned -Value $Pinned
    $obj | Add-Member NoteProperty -Name StartDate -Value $StartDate
    if ( $FinishDate -ne "" ) { [DateTimeOffset]$FinishDate = $FinishDate }
    $obj | Add-Member NoteProperty -Name FinishDate -Value $FinishDate
    $obj | Add-Member NoteProperty -Name BuildType -Value $BuildType
    $obj | Add-Member NoteProperty -Name Agent -Value $Agent
    $obj | Add-Member NoteProperty -Name Tags -Value $Tags
    $obj | Add-Member NoteProperty -Name Properties -Value $Properties
    $obj | Add-Member NoteProperty -Name SnapshotDependencies -Value $SnapshotDependencies
    $obj | Add-Member NoteProperty -Name ArtifactDependencies -Value $ArtifactDependencies
    $obj
}

function New-Dependency() 
{
    param (
        [string] $Id,
        [string] $Type, 
        [PSObject] $Properties
    )

    $obj = New-Object PSObject
    $obj | Add-Member NoteProperty -Name Id -Value $Id
    $obj | Add-Member NoteProperty -Name Type -Value $Type 
    $obj | Add-Member NoteProperty -Name Properties -Value $Properties
    $obj
}
Set-Alias New-Feature New-Dependency
Set-Alias New-Trigger New-Dependency

function New-Agent() 
{
    param (
        [string] $Id,
        [string] $Name, 
        [string] $Href,
        [string] $Ip,
        [string] $Authorized,
        [string] $Connected,
        [string] $Enabled,
        [string] $UpToDate
    )

    $obj = New-Object PSObject
    $obj | Add-Member NoteProperty -Name Id -Value $Id
    $obj | Add-Member NoteProperty -Name Name -Value $Name 
    $obj | Add-Member NoteProperty -Name Href -Value $Href
    $obj | Add-Member NoteProperty -Name Ip -Value $Ip
    $obj | Add-Member NoteProperty -Name Properties -Value $Properties
    if ( $Authorized -ne "" ) { [bool]$Authorized = [System.Convert]::ToBoolean($Authorized) }
    $obj | Add-Member NoteProperty -Name Authorized -Value $Authorized
    if ( $Connected -ne "" ) { [bool]$Connected = [System.Convert]::ToBoolean($Connected) }
    $obj | Add-Member NoteProperty -Name Connected -Value $Connected
    if ( $Enabled -ne "" ) { [bool]$Enabled = [System.Convert]::ToBoolean($Enabled) }
    $obj | Add-Member NoteProperty -Name Enabled -Value $Enabled
    if ( $UpToDate -ne "" ) { [bool]$UpToDate = [System.Convert]::ToBoolean($UpToDate) }
    $obj | Add-Member NoteProperty -Name UpToDate -Value $UpToDate
    $obj
}

function New-PropertyGroup()
{
    param (
        [PSObject] $PropertyGroup 
    )
    
    $group = @()
    if ( $PropertyGroup ) {
        foreach ( $property in $PropertyGroup.ChildNodes ) {
            $obj = New-Object PSObject
            $obj | Add-Member NoteProperty -Name Name -Value $property.name
            $obj | Add-Member NoteProperty -Name Value -Value $property.value
            $group = $group + $obj
        }
    }
    $group
}
