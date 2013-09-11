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

    $ArchivedValueToAssign = $Archived
    
    if ( $Archived -ne "" ) 
    { 
        [bool]$ArchivedValueToAssign = [System.Convert]::ToBoolean($Archived) 
    }
    
    $NewProject = New-Object PSObject -Property @{
        Id = $Id
        Name = $Name
        Href = $Href
        WebUrl = $WebUrl
        Archived = $ArchivedValueToAssign
        Parameters = $Parameters
        BuildTypes = $BuildTypes
    }
    $NewProject
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
    
    $HrefToAssign = $Href
    if( $Id -and ( $Href -eq "" ) ) { $HrefToAssign = "/buildTypes/id:$Id" }
    
    $PausedToAssign = $Paused
    if ( $Paused -ne "" ) { [bool]$pausedToAssign = [System.Convert]::ToBoolean($Paused) }
    
    $NewBuildType = New-Object PSObject -Property @{
        Id = $Id
        Name = $Name
        Description = $Description
        Href = $HrefToAssign
        WebUrl = $WebUrl
        Paused = $PausedToAssign
        Project = $Project
        Settings =  $Settings
        Parameters = $Parameters
        ArtifactDependencies = $ArtifactDependencies
        SnapshotDependencies = $SnapshotDependencies
        VcsRoots = $VcsRoots
    }
    $NewBuildType    
}

function New-BuildStep() 
{
    param (
        [string] $Id,
        [string] $Name, 
        [string] $Type,
        [PSObject] $Properties
    )

    $NewBuildStep = New-Object PSObject -Property @{
        Id = $Id
        Name = $Name
        Type = $Type 
        Properties = $Properties
    }
    $NewBuildStep
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
    $PersonalToAssign = $Personal
    if ( $Personal -ne "" ) { [bool]$PersonalToAssign = [System.Convert]::ToBoolean($Personal) }
    
    $HistoryToAssign = $History
    if ( $History -ne "" ) { [bool]$HistoryToAssign = [System.Convert]::ToBoolean($History) }
    
    $PinnedToAssign = $Pinned
    if ( $Pinned -ne "" ) { [bool]$PinnedToAssign = [System.Convert]::ToBoolean($Pinned) }
    
    $FinishDateToAssign = $FinishDate
    if ( $FinishDate -ne "" ) { [DateTimeOffset]$FinishDateToAssign = $FinishDate }
    
    $NewBuild = New-Object PSObject -Property @{
        Id = $Id
        Number = $Number
        Status = $Status
        StatusText = $StatusText
        Href = $Href
        WebUrl = $WebUrl
        Personal = $Personal
        History = $History
        Pinned = $Pinned
        StartDate = $StartDate
        FinishDate = $FinishDate
        BuildType = $BuildType
        Agent = $Agent
        Tags = $Tags
        Properties = $Properties
        SnapshotDependencies = $SnapshotDependencies
        ArtifactDependencies = $ArtifactDependencies
    }
    $NewBuild
}

function New-Dependency() 
{
    param (
        [string] $Id,
        [string] $Type, 
        [PSObject] $Properties
    )

    $NewDependency = New-Object PSObject -Property @{
        Id = $Id
        Type = $Type 
        Properties = $Properties
    }
    $NewDependency
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

    $AuthorizedToAssign = $Authorized
    if ( $Authorized -ne "" ) { [bool]$AuthorizedToAssign = [System.Convert]::ToBoolean($Authorized) }
    
    $ConnectedToAssign = $Connected
    if ( $Connected -ne "" ) { [bool]$ConnectedToAssign = [System.Convert]::ToBoolean($Connected) }
    
    $EnabledToAssign = $Enabled
    if ( $Enabled -ne "" ) { [bool]$EnabledToAssign = [System.Convert]::ToBoolean($Enabled) }
    
    $UpToDateToAssign = $UpToDate
    if ( $UpToDate -ne "" ) { [bool]$UpToDateToAssign = [System.Convert]::ToBoolean($UpToDate) }
    
    $NewAgent = New-Object PSObject -Property @{
        Id = $Id
        Name = $Name
        Href = $Href
        Ip = $Ip
        Properties = $Properties
        Authorized = $AuthorizedToAssign
        Connected = $ConnectedToAssign
        Enabled = $EnabledToAssign
        UpToDate = $UpToDateToAssign
    }
    $NewAgent
}

function New-PropertyGroup()
{
    param (
        [PSObject] $PropertyGroup 
    )
    
    $Group = @()
    if ( $PropertyGroup ) {
        foreach ( $property in $PropertyGroup.ChildNodes ) {
            $obj = New-Object PSObject -Property @{
                Name = $property.name
                Value = $property.value
            }
            $Group = $Group + $obj
        }
    }
    $Group
}
