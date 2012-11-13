function New-Project() 
{
    param 
    (
        [string] $Id, 
        [string] $Name, 
        [string] $Href,
        [string] $WebUrl,
        [bool] $Archived,
        $Parameters,
        $BuildTypes
    )

    $obj = New-Object PSObject
    if ( $Id )                 { $obj | Add-Member NoteProperty -Name Id -Value $Id }
    if ( $Name )               { $obj | Add-Member NoteProperty -Name Name -Value $Name }
    if ( $Href )               { $obj | Add-Member NoteProperty -Name Href -Value $Href }
    if ( $WebUrl )             { $obj | Add-Member NoteProperty -Name WebUrl -Value $WebUrl }
    if ( $Archived -ne $null ) { $obj | Add-Member NoteProperty -Name Archived -Value $Archived }
    if ( $Parameters )         { $obj | Add-Member NoteProperty -Name Parameters -Value $Parameters }
    if ( $BuildTypes )         { $obj | Add-Member NoteProperty -Name BuildTypes -Value $BuildTypes }
    $obj
}

function New-BuildType()
{
    param
    (
        [string] $Id,
        [string] $Name,
        [string] $Description,
        [string] $Href,
        [string] $ProjectName,
        [string] $ProjectId,
        [string] $WebUrl,
        [bool] $Paused,
        $Settings,
        $Parameters,
        $ArtifactDependencies,
        $SnapshotDependencies,
        $VcsRoots
    )
    
    $obj = New-Object PSObject
    if ( $Id )                   { $obj | Add-Member NoteProperty -Name Id -Value $Id }
    if ( $Name )                 { $obj | Add-Member NoteProperty -Name Name -Value $Name }
    if ( $Description )          { $obj | Add-Member NoteProperty -Name Description -Value $Description }
    if ( $Href )                 { $obj | Add-Member NoteProperty -Name Href -Value $Href }
    if ( $ProjectName )          { $obj | Add-Member NoteProperty -Name ProjectName -Value $ProjectName }
    if ( $ProjectId )            { $obj | Add-Member NoteProperty -Name ProjectId -Value $ProjectId }
    if ( $WebUrl )               { $obj | Add-Member NoteProperty -Name WebUrl -Value $WebUrl }
    if ( $Paused -ne $null )     { $obj | Add-Member NoteProperty -Name Paused -Value $Paused }
    if ( $Settings )             { $obj | Add-Member NoteProperty -Name Settings -Value  $Settings }
    if ( $Parameters )           { $obj | Add-Member NoteProperty -Name Parameters -Value $Parameters }
    if ( $ArtifactDependencies ) { $obj | Add-Member NoteProperty -Name ArtifactDependencies -Value $ArtifactDependencies }
    if ( $SnapshotDependencies ) { $obj | Add-Member NoteProperty -Name SnapshotDependencies -Value $SnapshotDependencies }
    if ( $VcsRoots )             { $obj | Add-Member NoteProperty -Name VcsRoots -Value $VcsRoots }
    $obj   
}

function New-BuildStep() 
{
    param 
    (
        [string] $Id,
        [string] $Name, 
        [string] $Type,
        $Properties
    )

    $obj = New-Object PSObject
    if ( $Id )         { $obj | Add-Member NoteProperty -Name Id -Value $Id }
    if ( $Name )         { $obj | Add-Member NoteProperty -Name Name -Value $Name }
    if ( $Type )       { $obj | Add-Member NoteProperty -Name Type -Value $Type } 
    if ( $Properties ) { $obj | Add-Member NoteProperty -Name Properties -Value $Properties }
    $obj
}

function New-Dependency() 
{
    param 
    (
        [string] $Id,
        [string] $Type, 
        $Properties
    )

    $obj = New-Object PSObject
    if ( $Id )         { $obj | Add-Member NoteProperty -Name Id -Value $Id }
    if ( $Type )       { $obj | Add-Member NoteProperty -Name Type -Value $Type } 
    if ( $Properties ) { $obj | Add-Member NoteProperty -Name Properties -Value $Properties }
    $obj
}
Set-Alias New-Feature New-Dependency
Set-Alias New-Trigger New-Dependency

function New-PropertyGroup()
{
    param ( $PropertyGroup )
    
    $group = @()
    if ( $PropertyGroup )
    {
        foreach ( $property in $PropertyGroup.ChildNodes )
        {
            $obj = New-Object PSObject
            $obj | Add-Member NoteProperty -Name Name -Value $property.name
            if ( $property.value ) { $obj | Add-Member NoteProperty -Name Value -Value $property.value }
            $group = $group + $obj
        }
    }
    $group
}
