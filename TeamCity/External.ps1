#http://gallery.technet.microsoft.com/scriptcenter/5b40075b-caef-45e8-8b12-d882fcd0dd9c
function ConvertFrom-DateString 
{ 
    [OutputType('System.DateTime')] 
    [CmdletBinding(DefaultParameterSetName='Culture')] 

    param( 
        [Parameter( 
            Mandatory=$true, 
            Position=0, 
            ValueFromPipeline=$true, 
            HelpMessage='A string containing a date and time to convert.' 
        )] 
        [System.String]$Value, 

        [Parameter( 
            Mandatory=$true, 
            Position=1, 
            HelpMessage='The required format of the date string value' 
        )] 
        [Alias('format')] 
        [System.String]$FormatString, 
    
        [Parameter(ParameterSetName='Culture')] 
        [System.Globalization.CultureInfo]$Culture=$null, 

        [Parameter(Mandatory=$true,ParameterSetName='InvariantCulture')] 
        [switch]$InvariantCulture 
    ) 

    process 
    { 
       if($PSCmdlet.ParameterSetName -eq 'InvariantCulture') 
        { 
           $Culture = [System.Globalization.CultureInfo]::InvariantCulture 
        } 

       Try 
        {            
                    [System.DateTime]::ParseExact($Value,$FormatString,$Culture) 
        } 
       Catch [System.FormatException] 
        { 
           Write-Error "'$Value' is not in the correct format." 
        } 
       Catch 
        { 
           Write-Error $_        
        } 
    } 
<# 
.SYNOPSIS 
    Converts a string representation of a date. 

.DESCRIPTION 
    Converts the specified string representation of a date and time to its 
    DateTime equivalent using the specified format and culture-specific format 
    information. The format of the string representation must match the specified 
    format exactly. 

.PARAMETER Value 
    A string containing a date and time to convert. 

.PARAMETER FormatString 
    The required format of the date string value. If FormatString defines a 
    date with no time element, the resulting DateTime value has a time of 
    midnight (00:00:00). 
    If FormatString defines a time with no date element, the resulting DateTime 
    value has a date of DateTime.Now.Date. 

    If FormatString is a custom format pattern that does not include date or 
    time separators    (such as "yyyyMMdd HHmm"), use the invariant culture 
    (e.g [System.Globalization.CultureInfo]::InvariantCulture), for the provider 
    parameter and the widest form of each custom format specifier. 
    For example, if you want to specify hours in the format pattern, specify 
    the wider form, "HH", instead of the narrower form, "H". 

    The format parameter is a string that contains either a single standard 
    format specifier, or one or more custom format specifiers that define the 
    required format of StringFormats. For details about valid formatting codes, 
    see 'Standard Date and Time Format Strings' (http://msdn.microsoft.com/en-us/library/az4se3k1.aspx) 
    or 'Custom Date and Time Format Strings' (http://msdn.microsoft.com/en-us/library/8kb3ddd4.aspx). 

.PARAMETER Culture 
     An object that supplies culture-specific formatting information about the 
    date string value. The default value is null. A value of null corresponds 
    to the current culture. 

.PARAMETER InvariantCulture            
    Gets the CultureInfo that is culture-independent (invariant). The invariant 
    culture is culture-insensitive. It is associated with the English language 
    but not with any country/region.             

.EXAMPLE 
    ConvertFrom-DateString -Value 'Sun 15 Jun 2008 8:30 AM -06:00' -FormatString 'ddd dd MMM yyyy h:mm tt zzz' -InvariantCulture 
    
    Sunday, June 15, 2008 5:30:00 PM 
    
    This example converts the date string, 'Sun 15 Jun 2008 8:30 AM -06:00', 
    according to the specifier that defines the required format. 
    The InvariantCulture switch parameter formats the date string in a 
    culture-independent manner. 

.EXAMPLE 
    'jeudi 10 avril 2008 06:30' | ConvertFrom-DateString -FormatString 'dddd dd MMMM yyyy HH:mm' -Culture fr-FR 
    
    Thursday, April 10, 2008 6:30:00 AM 
    
    In this example a date string, in French format (culture). The date string 
    is piped to ConvertFrom-DateString. The input value is bound to the Value 
    parameter. The FormatString value defines the required format of the date 
    string value. The result is a DateTime object that is equivalent to the date 
    and time contained in the Value parameter, as specified by FormatString and 
    Culture parameters. 

.EXAMPLE    
    ConvertFrom-DateString -Value 'Sun 15 Jun 2008 8:30 AM -06:00' -FormatString 'ddd dd MMM yyyy h:mm tt zzz' 

    Sunday, June 15, 2008 5:30:00 PM 
    
    Converts the date string specified in the Value parameter with the 
    custom specifier specified in the FormatString parameter. The result 
    DateTime object format corresponds to the current culture. 


.INPUTS 
    System.String 
    You can pipe a string that contains a date and time to convert. 

.OUTPUTS 
    System.DateTime 

.NOTES 
    Author: Shay Levy 
    Blog   : http://PowerShay.com 

.LINK 
    http://msdn.microsoft.com/en-us/library/w2sa9yss.aspx 
#> 

} 
