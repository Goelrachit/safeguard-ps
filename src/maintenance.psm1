# Helper
function Test-SupportForClusterPatch
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    $local:ApplianceVersion = (Get-SafeguardVersion -Appliance $Appliance -Insecure:$Insecure)
    if ($local:ApplianceVersion.Major -gt 2 -or ($local:ApplianceVersion.Major -eq 2 -and $local:ApplianceVersion.Minor -gt 0))
    {
        $true
    }
    else
    {
        $false
    }
}

<#
.SYNOPSIS
Get the current status of Safeguard appliance via the Web API.

.DESCRIPTION
Get the current status of Safeguard appliance which will include version
information, current state, previous state, maintenance status, cluster
status, and primary appliance IP address.

This cmdlet is DEPRECATED.  Use Get-SafeguardApplianceAvailability instead.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardStatus

.EXAMPLE
Get-SafeguardStatus -Appliance 10.5.32.54 -Insecure
#>
function Get-SafeguardStatus
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    # Remove the IsClustered property since it is deprecated and inaccurate
    Invoke-SafeguardMethod -Anonymous -Appliance $Appliance -Insecure:$Insecure Notification GET Status | Select-Object -Property * -ExcludeProperty IsClustered
}

<#
.SYNOPSIS
Get the current availability of Safeguard appliance via the Web API.

.DESCRIPTION
Get the current availability of Safeguard appliance which will include version
information, current state, previous state, maintenance status, cluster
status, and primary appliance IP address.  It will also give the availability
of individual services from this appliance such as password or session requests,
password check/change management, policy/configuration changes, etc.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardApplianceAvailability

.EXAMPLE
Get-SafeguardApplianceAvailability -Appliance 10.5.32.54 -Insecure
#>
function Get-SafeguardApplianceAvailability
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -Anonymous -Appliance $Appliance -Insecure:$Insecure Notification GET "Status/Availability"
}


<#
.SYNOPSIS
Get the current state of Safeguard appliance via the Web API.

.DESCRIPTION
This cmdlet only returns this appliance's state via the Web API.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardApplianceState

.EXAMPLE
Get-SafeguardApplianceState -Appliance 10.5.32.54 -Insecure
#>
function Get-SafeguardApplianceState
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -Anonymous -Appliance $Appliance -Insecure:$Insecure Notification GET "Status/State"
}

<#
.SYNOPSIS
Get the version of a Safeguard appliance via the Web API.

.DESCRIPTION
Get the version information from a Safeguard appliance which will 
be returned as an object containing major.minor.revision.build
portions separated into different properties.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardVersion

.EXAMPLE
Get-SafeguardVersion -Appliance 10.5.32.54 -Insecure
#>
function Get-SafeguardVersion
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -Anonymous -Appliance $Appliance -Insecure:$Insecure Appliance GET Version
}

<#
.SYNOPSIS
Test whether the version of a Safeguard appliance is greater than
or equal to a minimum version via the Web API.

.DESCRIPTION
Get the version information from a Safeguard appliance and compare
whether it is greater than or equal to a minimum version provided
as a string in x.y format.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.PARAMETER MinVersion
A string containing the desired minimum major and minor version in x.y format.

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Test-SafeguardVersion 2.3

.EXAMPLE
Test-SafeguardVersion -Appliance 10.5.32.54 -Insecure 2.6
#>
function Test-SafeguardVersion
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$true,Position=0)]
        [ValidatePattern("^\d+\.\d+$")]
        [string]$MinVersion
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Import-Module -Name "$PSScriptRoot\sg-utilities.psm1" -Scope Local
    Test-SafeguardMinVersionInternal -Appliance $Appliance -Insecure:$Insecure -MinVersion $MinVersion
}

<#
.SYNOPSIS
Get the system verification information on a Safeguard appliance via the Web API.

.DESCRIPTION
System verification information about a Safeguard appliance used during
manufacturing.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardApplianceVerification

.EXAMPLE
Get-SafeguardApplianceVerification -Appliance 10.5.32.54 -Insecure
#>
function Get-SafeguardApplianceVerification
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -Anonymous -Appliance $Appliance -Insecure:$Insecure Notification GET SystemVerification/Manufacturing
}

<#
.SYNOPSIS
Get the current time on a Safeguard appliance via the Web API.

.DESCRIPTION
Get the current time on a Safeguard appliance which will be returned in
UTC format, e.g. 2017-09-07T19:11:37.2995203Z

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardTime

.EXAMPLE
Get-SafeguardTime -Appliance 10.5.32.54 -Insecure
#>
function Get-SafeguardTime
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -Anonymous -Appliance $Appliance -Insecure:$Insecure Appliance GET SystemTime
}

<#
.SYNOPSIS
Get the current uptime on a Safeguard appliance via the Web API.

.DESCRIPTION
Get the current uptime on a Safeguard appliance which will be returned as
an object with days, hours, minutes, seconds, total seconds, and composite string.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardApplianceUptime

.EXAMPLE
Get-SafeguardApplianceUptime -Appliance 10.5.32.54 -Insecure
#>
function Get-SafeguardApplianceUptime
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    $local:Os = (Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance GET OperatingSystem)
    $local:Ts =  [timespan]::FromSeconds($local:Os.UptimeInSeconds)
    New-Object -TypeName PSObject -Property @{
        TotalSeconds = $local:Ts.TotalSeconds;
        Days = $local:Ts.Days;
        Hours = $local:Ts.Hours;
        Minutes = $local:Ts.Minutes;
        Seconds = $local:Ts.Seconds;
        Value = $local:Ts.ToString("c")
    }
}

<#
.SYNOPSIS
Get the current health of Safeguard appliance via the Web API.

.DESCRIPTION
Get the current health of Safeguard appliance which will include several
components: AuditLog, ClusterCommunication, ClusterConnectivity, AccessWorkflow,
PolicyData.  Additional information is provided about NetworkInformation,
ResourceUsage, Uptime, Version, and ApplianceState.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate.

.PARAMETER ForceUpdate
Force health checks to run and wait to get up-to-date information.

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardHealth

.EXAMPLE
Get-SafeguardHealth -Appliance 10.5.32.54 -AccessToken $token -Insecure
#>
function Get-SafeguardHealth
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false)]
        [switch]$ForceUpdate
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    if ($ForceUpdate)
    {
        (Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Core GET "Cluster/Members/Self" `
            -RetryUrl "ClusterMembers/Self").Health
    }
    else
    {
        Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance GET ApplianceStatus/Health
    }
}

<#
.SYNOPSIS
Get user-defined name of a Safeguard appliance via the Web API.

.DESCRIPTION
Get user-defined name of a Safeguard appliance. This name can be specified
using the Set-SafeguardName cmdlet. Each appliance in a cluster can have a
unique name.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardName

.EXAMPLE
Get-SafeguardName -Appliance 10.5.32.54 -Insecure
#>
function Get-SafeguardApplianceName
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    (Invoke-SafeguardMethod -Anonymous -Appliance $Appliance -Insecure:$Insecure Notification GET Status).ApplianceName
}

<#
.SYNOPSIS
Set user-defined name of a Safeguard appliance via the Web API.

.DESCRIPTION
Set user-defined name of a Safeguard appliance. Each appliance in a
cluster can have a unique name.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.PARAMETER Name
A string containing the name to give the appliance.

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardName

.EXAMPLE
Get-SafeguardName -Appliance 10.5.32.54 -AccessToken $token -Insecure
#>
function Set-SafeguardApplianceName
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Name
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance PUT ApplianceStatus/Name -Body $Name
}

<#
.SYNOPSIS
Send a command to a Safeguard appliance to shut down via the Web API.

.DESCRIPTION
This command will shut down the Safeguard appliance.  The only way to
get Safeguard running again is to manually turn the power back on.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.PARAMETER Reason
A string containing the name to give the appliance.

.PARAMETER Force
Do not prompt for confirmation.

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Invoke-SafeguardApplianceShutdown -Reason "Because I said so."

.EXAMPLE
Get-SafeguardName -Appliance 10.5.32.54 -AccessToken $token -Insecure -Force "Because I said so."
#>
function Invoke-SafeguardApplianceShutdown
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Reason,
        [Parameter(Mandatory=$false)]
        [switch]$Force
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }
    Import-Module -Name "$PSScriptRoot\ps-utilities.psm1" -Scope Local

    if ($Force)
    {
        $local:Confirmed = $true
    }
    else
    {
        Write-Host -ForegroundColor Yellow "You will be required to MANUALLY power the appliance on again!"
        $local:Confirmed = (Get-Confirmation "Safeguard Appliance Shutdown" "Do you want to initiate shutdown on this Safeguard appliance?" `
                                             "Initiates shutdown immediately." "Cancels this operation.")
    }

    if ($local:Confirmed)
    {
        Write-Host "Sending shutdown command..."
        Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance POST ApplianceStatus/Shutdown -Body $Reason
    }
    else
    {
        Write-Host -ForegroundColor Yellow "Operation canceled."
    }
}

<#
.SYNOPSIS
Send a command to a Safeguard appliance to reboot via the Web API.

.DESCRIPTION
This command will reboot the Safeguard appliance.  Safeguard will be
unavailable via the API for a period of time.  To determine if Safeguard
is back online you may poll the appliance status using Get-SafeguardStatus.
Look at the ApplianceCurrentState property.  When it says Online then
Safeguard is completely rebooted.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.PARAMETER Reason
A string containing the name to give the appliance.

.PARAMETER Force
Do not prompt for confirmation.

.PARAMETER NoWait
Specify this flag to continue immediately without waiting for the patch to install to the connected appliance.

.PARAMETER Timeout
A timeout value in seconds, only used if waiting (default: 30 minutes or 1800 seconds).

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Invoke-SafeguardApplianceShutdown -Reason "Because I said so."

.EXAMPLE
Get-SafeguardName -Appliance 10.5.32.54 -AccessToken $token -Insecure -Force "Because I said so."
#>
function Invoke-SafeguardApplianceReboot
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Reason,
        [Parameter(Mandatory=$false)]
        [switch]$Force,
        [Parameter(Mandatory=$false)]
        [switch]$NoWait = $false,
        [Parameter(Mandatory=$false)]
        [int]$Timeout = 1800
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }
    Import-Module -Name "$PSScriptRoot\ps-utilities.psm1" -Scope Local

    if ($Force)
    {
        $local:Confirmed = $true
    }
    else
    {
        Write-Host -ForegroundColor Yellow "There will be a period of time when Safeguard is unavailable via the API while it reboots."
        $local:Confirmed = (Get-Confirmation "Safeguard Appliance Reboot" "Do you want to initiate reboot on this Safeguard appliance?" `
                                             "Initiates reboot immediately." "Cancels this operation.")
    }

    if ($local:Confirmed)
    {
        if (-not $NoWait)
        {
            Import-Module -Name "$PSScriptRoot\sg-utilities.psm1" -Scope Local
            $local:CurrentState = (Get-SafeguardStatus -Appliance $Appliance -Insecure:$Insecure).ApplianceCurrentState
        }
        Write-Host "Sending reboot command..."
        Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance `
            POST ApplianceStatus/Reboot -Body $Reason

        if (-not $NoWait)
        {
            Wait-ForSafeguardStatus -Appliance $Appliance -Insecure:$Insecure -Timeout $Timeout -DesiredStatus $local:CurrentState
        }
    }
    else
    {
        Write-Host -ForegroundColor Yellow "Operation canceled."
    }
}

<#
.SYNOPSIS
Send a command to a Safeguard appliance to factory reset via the Web API.

.DESCRIPTION
This command will revert the Safeguard appliance to its initial factory
state.  This will drop all data stored on the appliance.  This should
generally only be done as a last resort.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.PARAMETER Reason
A string containing the name to give the appliance.

.PARAMETER Force
Do not prompt for confirmation.

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Invoke-SafeguardApplianceShutdown -Reason "Because I said so."

.EXAMPLE
Get-SafeguardName -Appliance 10.5.32.54 -AccessToken $token -Insecure -Force "Because I said so."
#>
function Invoke-SafeguardApplianceFactoryReset
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Reason,
        [Parameter(Mandatory=$false)]
        [switch]$Force
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }
    Import-Module -Name "$PSScriptRoot\ps-utilities.psm1" -Scope Local

    if ($Force)
    {
        $local:Confirmed = $true
    }
    else
    {
        Write-Host -ForegroundColor Red "This operation will remove existing data stored on this appliance."
        Write-Host -ForegroundColor Red "In order to not lose data, you must have an existing replica or a backup you can restore."
        Write-Host -ForegroundColor Yellow "As Safeguard is performing the factory reset, progress information is only available via the LCD."
        Write-Host -ForegroundColor Yellow "The factory reset process can take up to an hour."
        Write-Host -ForegroundColor Yellow "Please do not touch any of the LCD buttons during factory reset!"
        Write-Host -ForegroundColor Magenta "When Safeguard completes the factory reset process it will have the default IP address."
        Write-Host -ForegroundColor Magenta "You will have to set the X0 IP address just as if you had just purchased the appliance."
        $local:Confirmed = (Get-Confirmation "Safeguard Appliance Factory Reset" "Do you want to initiate factory reset on this Safeguard appliance?" `
                                             "Initiates factory reset immediately." "Cancels this operation.")
    }

    if ($local:Confirmed)
    {
        Write-Host "Sending factory reset command..."
        Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance POST ApplianceStatus/FactoryReset -Body $Reason
    }
    else
    {
        Write-Host -ForegroundColor Yellow "Operation canceled."
    }
}

<#
.SYNOPSIS
Get a support bundle from a Safeguard appliance via the Web API.

.DESCRIPTION
Save a support bundle from the Safeguard appliance as a ZIP file to the
file system. If a file path is not specified, one will be generated in
the current directory.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.PARAMETER OutFile
A string containing the path to store the support bundle (default: SG-<id>-<date>.zip).

.PARAMETER Version
Version of the Web API you are using (default: 2).

.PARAMETER Timeout
A timeout value in seconds (default timeout depends on options specified).

.PARAMETER IncludeExtendedEventLog
Whether to include extended event logs (increases size and generation time).

.PARAMETER IncludeExtendedSessionsLog
Whether to include extended sessions logs (dramatically increases generation time).

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardSupportBundle -Appliance 10.5.32.54 -AccessToken $token
#>
function Get-SafeguardSupportBundle
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [string]$OutFile,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false)]
        [int]$Version = 3,
        [Parameter(Mandatory=$false)]
        [int]$Timeout,
        [Parameter(Mandatory=$false)]
        [switch]$IncludeExtendedEventLog,
        [Parameter(Mandatory=$false)]
        [switch]$IncludeExtendedSessionsLog
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }
    Import-Module -Name "$PSScriptRoot\sslhandling.psm1" -Scope Local

    if ($SafeguardSession)
    {
        $Insecure = $SafeguardSession["Insecure"]
    }
    if (-not ($PSBoundParameters.ContainsKey("Version")) -and $SafeguardSession)
    {
        $Version = $SafeguardSession["Version"]
    }
    if (-not $Appliance -and $SafeguardSession)
    {
        $Appliance = $SafeguardSession["Appliance"]
    }
    if (-not $AccessToken -and $SafeguardSession)
    {
        $AccessToken = $SafeguardSession["AccessToken"]
    }
    if (-not $Appliance)
    {
        $Appliance = (Read-Host "Appliance")
    }
    if (-not $AccessToken)
    {
        $AccessToken = (Connect-Safeguard -Appliance $Appliance -Insecure:$Insecure -NoSessionVariable)
    }
    if (-not $OutFile)
    {
        $OutFile = (Join-Path (Get-Location) "SG-$Appliance-$((Get-Date).ToString("MMddTHHmmssZz")).zip")
    }

    # Handle options and timeout
    $DefaultTimeout = 1200
    $Url = "https://$Appliance/service/appliance/v$Version/SupportBundle"
    if ($IncludeExtendedEventLog)
    {
        $DefaultTimeout = 1800
        $Url += "?includeEventLogs=true"
    }
    else
    {
        $Url += "?includeEventLogs=false"
    }
    if ($IncludeExtendedSessionsLog)
    {
        $DefaultTimeout = 3600
        $Url += "&IncludeSessions=true"
    }
    else
    {
        $Url += "&IncludeSessions=false"
    }
    if (-not $Timeout)
    {
        $Timeout = $DefaultTimeout
    }

    try
    {
        Edit-SslVersionSupport
        if ($Insecure)
        {
            Disable-SslVerification
            if ($global:PSDefaultParameterValues) { $PSDefaultParameterValues = $global:PSDefaultParameterValues.Clone() }
        }
        # Use the WebClient class to avoid the content scraping slow down from Invoke-RestMethod as well as timeout issues
        Import-Module -Name "$PSScriptRoot\ps-utilities.psm1" -Scope Local
        Add-ExWebClientExType

        $WebClient = (New-Object Ex.WebClientEx -ArgumentList @($Timeout))
        $WebClient.Headers.Add("Accept", "application/octet-stream")
        $WebClient.Headers.Add("Content-type", "application/json")
        $WebClient.Headers.Add("Authorization", "Bearer $AccessToken")
        Write-Host "This operation may take several minutes..."
        Write-Host "Downloading support bundle to: $OutFile"
        $WebClient.DownloadFile($Url, $OutFile)
    }
    catch [System.Net.WebException]
    {
        Import-Module -Name "$PSScriptRoot\sg-utilities.psm1" -Scope Local
        Out-SafeguardExceptionIfPossible $_.Exception
    }
    catch
    {
        Write-Error $_
        throw "Failed to GET support bundle from Safeguard"
    }
    finally
    {
        if ($Insecure)
        {
            Enable-SslVerification
            if ($global:PSDefaultParameterValues) { $PSDefaultParameterValues = $global:PSDefaultParameterValues.Clone() }
        }
    }
}

<#
.SYNOPSIS
Get patch that is currently staged on an appliance via the Web API.

.DESCRIPTION
Get the patch that is currently staged on the Safeguard appliance if there
is one.  This cmdlet returns the metadata associated with the patch.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate.

.INPUTS
None.

.OUTPUTS
Script output as strings.

.EXAMPLE
Get-SafeguardPatch

.EXAMPLE
Get-SafeguardPatch -AccessToken $token -Appliance 10.5.32.54.
#>
function Get-SafeguardPatch
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    (Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance GET Patch).Metadata
}

<#
.SYNOPSIS
Remove patch that is currently staged on an appliance via the Web API.

.DESCRIPTION
Remove the patch that is currently staged on the Safeguard appliance if there
is one.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate.

.INPUTS
None.

.OUTPUTS
Script output as strings.

.EXAMPLE
Clear-SafeguardPatch

.EXAMPLE
Clear-SafeguardPatch -AccessToken $token -Appliance 10.5.32.54.
#>
function Clear-SafeguardPatch
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    if (Test-SupportForClusterPatch -Appliance $Appliance -Insecure:$Insecure)
    {
        if ((Invoke-SafeguardMethod -Appliance $Appliance -AccessToken $AccessToken -Insecure:$Insecure Core GET "Cluster/Members" `
            -RetryUrl "ClusterMembers").Count -gt 1)
        {
            Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance DELETE Patch/Distribute
        }
    }
    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance DELETE Patch
}

<#
.SYNOPSIS
Install patch on Safeguard appliance via the Web API.

.DESCRIPTION
Upload a patch to a Safeguard appliance via the Web API, and then call
the POST action to install it.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate.

.PARAMETER Version
Version of the Web API you are using (default: 2).

.PARAMETER Patch
A string containing the path to a patch file.

.PARAMETER Timeout
A timeout value in seconds for uploading; also used to wait for installation (default: 5400s or 90m)

.PARAMETER UseStagedPatch
Use the currently staged patch rather than uploading a new one.

.PARAMETER NoWait
Specify this flag to continue immediately without waiting for the patch to install to the connected appliance.

.PARAMETER Force
Do not prompt for confirmation.

.INPUTS
None.

.OUTPUTS
Script output as strings.

.EXAMPLE
Install-SafeguardPatch -AccessToken $token -Patch XX.sgp -Appliance 10.5.32.54.
#>
function Install-SafeguardPatch
{
    [CmdletBinding(DefaultParameterSetName="NewPatch")]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false)]
        [int]$Version = 3,
        [Parameter(ParameterSetName="NewPatch",Mandatory=$true,Position=0)]
        [string]$Patch,
        [Parameter(ParameterSetName="NewPatch",Mandatory=$false)]
        [int]$Timeout = 5400,
        [Parameter(ParameterSetName="UseExisting",Mandatory=$false)]
        [switch]$UseStagedPatch = $false,
        [Parameter(Mandatory=$false)]
        [switch]$NoWait,
        [Parameter(Mandatory=$false)]
        [switch]$Force
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }
    
    if ($SafeguardSession)
    {
        $Insecure = $SafeguardSession["Insecure"]
    }
    if (-not ($PSBoundParameters.ContainsKey("Version")) -and $SafeguardSession)
    {
        $Version = $SafeguardSession["Version"]
    }
    if (-not $Appliance -and $SafeguardSession)
    {
        $Appliance = $SafeguardSession["Appliance"]
    }
    if (-not $AccessToken -and $SafeguardSession)
    {
        $AccessToken = $SafeguardSession["AccessToken"]
    }
    if (-not $Appliance)
    {
        $Appliance = (Read-Host "Appliance")
    }
    if (-not $AccessToken)
    {
        $AccessToken = (Connect-Safeguard -Appliance $Appliance -Insecure:$Insecure -NoSessionVariable -Version $Version)
    }

    if (-not $UseStagedPatch)
    {
        $Response = (Get-SafeguardPatch -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure)
        if ($Response)
        {
            Write-Host "Removing currently staged patch..."
            Clear-SafeguardPatch -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure
            $Response = (Get-SafeguardPatch -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure)
            if ($Response)
            {
                throw "Failed to delete existing patch"
            }
        }

        try
        {
            # https://github.com/OneIdentity/safeguard-ps/issues/142
			# Upload the patch file in a separate powershell process, so the memory can be released after the patch upload is complete.
			# Note, the "Insecure" argument here is being passed as a string, because we cannot send a switch type argument in Start-Process command
            $UploadProcess = start-process powershell -NoNewWindow -PassThru -Wait -ArgumentList "$PSScriptRoot\uploadPatch.ps1 -Patch $Patch -Appliance $Appliance -AccessToken $AccessToken -Version $Version -Timeout $Timeout -Insecure $Insecure"
            if($UploadProcess.ExitCode -ne 0)
            {
                throw "Failed to POST patch to Safeguard"
            }
        }
        finally
        {
            if ($Insecure)
            {
                Import-Module -Name "$PSScriptRoot\sslhandling.psm1" -Scope Local
                Enable-SslVerification
                if ($global:PSDefaultParameterValues) { $PSDefaultParameterValues = $global:PSDefaultParameterValues.Clone() }
            }
        }
    }

    $local:StagedPatch = (Get-SafeguardPatch -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure)

    Import-Module -Name "$PSScriptRoot\sg-utilities.psm1" -Scope Local

    if (Test-SupportForClusterPatch -Appliance $Appliance -Insecure:$Insecure)
    {
        Write-Host "Distributing patch to cluster..."
        Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance POST Patch/Distribute

        Wait-ForPatchDistribution -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure
    }

    if ($Force)
    {
        $local:Confirmed = $true
    }
    else
    {
        Import-Module -Name "$PSScriptRoot\ps-utilities.psm1" -Scope Local
        $local:Confirmed = (Get-Confirmation "Install Safeguard Patch" `
                                            "Do you want to install $($local:StagedPatch.Title) on this cluster?" `
                                            "Starts cluster patch immediately." `
                                            "Cancels this operation.")
    }
    if ($local:Confirmed)
    {
        Write-Host "Starting patch install..."
        $local:MetaData = (Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance POST Patch/Install)
        if ($? -ne 0 -or $LastExitCode -eq 0)
        {
            Write-Host "Patch is currently installing..."
            if ($local:MetaData.Metadata)
            {
                $local:MetaData.Metadata
            }
            if ($NoWait)
            {
                Write-Host "Use Get-SafeguardStatus to monitor patching progress."
            }
            else
            {
                Wait-ForSafeguardOnlineStatus -Appliance $Appliance -Insecure:$Insecure -Timeout $Timeout
            }
        }
    }
    else
    {
        Write-Host "Patch installation canceled."
    }
}


<#
.SYNOPSIS
Create a new backup on a Safeguard appliance via the Web API.

.DESCRIPTION
This cmdlet will initiate the creation of a new backup on a Safeguard
appliance.  The backup can be downloaded using the Export-SafeguardBackup
cmdlet or archived using the Save-SafeguardBackupToArchive cmdlet. The
Import-SafeguardBackup cmdlet can be used to upload the backup later
to a Safeguard appliance. The Restore-SafeguardBackup cmdlet can be used
to restore a backup that has been uploaded.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
New-SafeguardBackup

.EXAMPLE
New-SafeguardBackup -Appliance 10.5.32.54 -AccessToken $token -Insecure
#>
function New-SafeguardBackup
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Write-Host "Starting a backup operation..."
    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance POST Backups
}

<#
.SYNOPSIS
Delete a backup from a Safeguard appliance via the Web API.

.DESCRIPTION
This cmdlet will delete a backup stored on a Safeguard appliance.  Only
delete backups that you have either downloaded or archived.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate.

.PARAMETER BackupId
A string containing a backup ID, which is a GUID.

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Remove-SafeguardBackup -BackupId "c6f9a3b4-7a75-406d-ba5a-830e44c1c94d"

.EXAMPLE
Remove-SafeguardBackup -Appliance 10.5.32.54 -AccessToken $token -Insecure
#>
function Remove-SafeguardBackup
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false,Position=0)]
        [string]$BackupId
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    if (-not $BackupId)
    {
        $local:CurrentBackupIds = (Get-SafeguardBackup -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure).Id -join ", "
        Write-Host "Available Backups: [ $($local:CurrentBackupIds) ]"
        $BackupId = (Read-Host "BackupId")
    }

    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance DELETE "Backups/$BackupId"
}

<#
.SYNOPSIS
Download signed, encrypted backup from Safeguard appliance via the Web API.

.DESCRIPTION
Download signed, encrypted backup for safe storage offline so that it can be
uploaded to this appliance or another appliance in the future to recover data.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate.

.PARAMETER Version
Version of the Web API you are using (default: 2).

.PARAMETER BackupId
A string containing a backup ID, which is a GUID.

.PARAMETER OutFile
A string containing the path to store the backup (default: SG-<id>-backup-<backup date>.sgb)

.PARAMETER Timeout
A timeout value in seconds for uploading (default: 1200s or 20m)

.INPUTS
None.

.OUTPUTS
Script output as strings.

.EXAMPLE
Export-SafeguardBackup -AccessToken $token -Appliance 10.5.32.54 f1f42734-e0ea-4edb-80f3-9f018b1b8afd sg-backup.sgb
#>
function Export-SafeguardBackup
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false)]
        [int]$Version = 3,
        [Parameter(Mandatory=$false,Position=0)]
        [string]$BackupId,
        [Parameter(Mandatory=$false,Position=1)]
        [string]$OutFile,
        [Parameter(Mandatory=$false)]
        [int]$Timeout = 1200
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }
    Import-Module -Name "$PSScriptRoot\sslhandling.psm1" -Scope Local

    if ($SafeguardSession)
    {
        $Insecure = $SafeguardSession["Insecure"]
    }
    if (-not ($PSBoundParameters.ContainsKey("Version")) -and $SafeguardSession)
    {
        $Version = $SafeguardSession["Version"]
    }
    if (-not $Appliance -and $SafeguardSession)
    {
        $Appliance = $SafeguardSession["Appliance"]
    }
    if (-not $AccessToken -and $SafeguardSession)
    {
        $AccessToken = $SafeguardSession["AccessToken"]
    }
    if (-not $Appliance)
    {
        $Appliance = (Read-Host "Appliance")
    }
    if (-not $AccessToken)
    {
        $AccessToken = (Connect-Safeguard -Appliance $Appliance -Insecure:$Insecure -NoSessionVariable)
    }

    if (-not $BackupId)
    {
        $local:CurrentBackupIds = (Get-SafeguardBackup -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure).Id -join ", "
        Write-Host "Available Backups: [ $($local:CurrentBackupIds) ]"
        $BackupId = (Read-Host "BackupId")
    }
    if (-not $OutFile)
    {
        $CreatedOn = (Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance GET Backups/$BackupId).CreatedOn
        $FileName = "SG-$Appliance-backup-$((Get-Date $CreatedOn).ToString("MMddyyyyTHHmmZ")).sgb"
        $OutFile = (Join-Path (Get-Location) $FileName)
    }

    try
    {
        Edit-SslVersionSupport
        if ($Insecure)
        {
            Disable-SslVerification
            if ($global:PSDefaultParameterValues) { $PSDefaultParameterValues = $global:PSDefaultParameterValues.Clone() }
        }
        # Use the WebClient class to avoid the content scraping slow down from Invoke-RestMethod as well as timeout issues
        Import-Module -Name "$PSScriptRoot\ps-utilities.psm1" -Scope Local
        Add-ExWebClientExType

        $WebClient = (New-Object Ex.WebClientEx -ArgumentList @($Timeout))
        $WebClient.Headers.Add("Accept", "application/octet-stream")
        $WebClient.Headers.Add("Content-type", "application/json")
        $WebClient.Headers.Add("Authorization", "Bearer $AccessToken")
        Write-Host "This operation may take several minutes..."
        Write-Host "Downloading Safeguard backup to: $OutFile"
        $WebClient.DownloadFile("https://$Appliance/service/appliance/v$Version/Backups/$BackupId/Download", $OutFile)
    }
    catch [System.Net.WebException]
    {
        Import-Module -Name "$PSScriptRoot\sg-utilities.psm1" -Scope Local
        Out-SafeguardExceptionIfPossible $_.Exception
    }
    catch
    {
        Write-Error $_
        throw "Failed to GET backup to Safeguard"
    }
    finally
    {
        if ($Insecure)
        {
            Enable-SslVerification
            if ($global:PSDefaultParameterValues) { $PSDefaultParameterValues = $global:PSDefaultParameterValues.Clone() }
        }
    }

}

<#
.SYNOPSIS
Upload backup file to Safeguard appliance via the Web API.

.DESCRIPTION
Upload a backup to a Safeguard appliance via the Web API.  Once it is
uploaded, you can call the Restore-SafeguardBackup cmdlet to restore it.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.PARAMETER Version
Version of the Web API you are using (default: 2).

.PARAMETER BackupFile
A string containing the path to a backup file.

.PARAMETER Timeout
A timeout value in seconds for uploading (default: 1200s or 20m)

.INPUTS
None.

.OUTPUTS
Script output as strings.

.EXAMPLE
Import-SafeguardBackup -AccessToken $token -Appliance 10.5.32.54 sg-backup.sgb
#>
function Import-SafeguardBackup
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false)]
        [int]$Version = 3,
        [Parameter(Mandatory=$true,Position=0)]
        [string]$BackupFile,
        [Parameter(Mandatory=$false)]
        [int]$Timeout = 1200
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }
    Import-Module -Name "$PSScriptRoot\sslhandling.psm1" -Scope Local

    if ($SafeguardSession)
    {
        $Insecure = $SafeguardSession["Insecure"]
    }
    if (-not ($PSBoundParameters.ContainsKey("Version")) -and $SafeguardSession)
    {
        $Version = $SafeguardSession["Version"]
    }
    if (-not $Appliance -and $SafeguardSession)
    {
        $Appliance = $SafeguardSession["Appliance"]
    }
    if (-not $AccessToken -and $SafeguardSession)
    {
        $AccessToken = $SafeguardSession["AccessToken"]
    }
    if (-not $Appliance)
    {
        $Appliance = (Read-Host "Appliance")
    }
    if (-not $AccessToken)
    {
        $AccessToken = (Connect-Safeguard -Appliance $Appliance -Insecure:$Insecure -NoSessionVariable)
    }

    try
    {
        Edit-SslVersionSupport
        if ($Insecure)
        {
            Disable-SslVerification
            if ($global:PSDefaultParameterValues) { $PSDefaultParameterValues = $global:PSDefaultParameterValues.Clone() }
        }
        # Use the WebClient class to avoid the content scraping slow down from Invoke-RestMethod as well as timeout issues
        Import-Module -Name "$PSScriptRoot\ps-utilities.psm1" -Scope Local
        Add-ExWebClientExType

        $WebClient = (New-Object Ex.WebClientEx -ArgumentList @($Timeout))
        $WebClient.Headers.Add("Accept", "application/json")
        $WebClient.Headers.Add("Content-type", "application/octet-stream")
        $WebClient.Headers.Add("Authorization", "Bearer $AccessToken")
        Write-Host "POSTing backup to Safeguard. This operation may take several minutes..."

        $Bytes = [System.IO.File]::ReadAllBytes($BackupFile);
        $ResponseBytes = $WebClient.UploadData("https://$Appliance/service/appliance/v$Version/Backups/Upload", "POST", $Bytes) | Out-Null
        if ($ResponseBytes)
        {
            [System.Text.Encoding]::UTF8.GetString($ResponseBytes)
        }
    }
    catch [System.Net.WebException]
    {
        Import-Module -Name "$PSScriptRoot\sg-utilities.psm1" -Scope Local
        Out-SafeguardExceptionIfPossible $_.Exception
    }
    catch
    {
        Write-Error $_
        throw "Failed to POST backup to Safeguard"
    }
    finally
    {
        if ($Insecure)
        {
            Enable-SslVerification
            if ($global:PSDefaultParameterValues) { $PSDefaultParameterValues = $global:PSDefaultParameterValues.Clone() }
        }
    }
}

<#
.SYNOPSIS
Restore a backup that was created on or uploaded to a Safeguard appliance via the Web API.

.DESCRIPTION
This cmdlet will restore a backup stored on a Safeguard appliance. The backup
needs to already be on the appliance

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate.

.PARAMETER BackupId
A string containing a backup ID, which is a GUID.

.PARAMETER NoWait
Specify this flag to continue immediately without waiting for the restore to complete.

.PARAMETER Timeout
A timeout value in seconds for restore (default: 3600s or 60m)

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Restore-SafeguardBackup -BackupId "c6f9a3b4-7a75-406d-ba5a-830e44c1c94d"

.EXAMPLE
Restore-SafeguardBackup -Appliance 10.5.32.54 -AccessToken $SafeguardSession.AccessToken -Insecure -NoWait
#>
function Restore-SafeguardBackup
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false,Position=0)]
        [string]$BackupId,
        [Parameter(Mandatory=$false)]
        [switch]$NoWait,
        [Parameter(ParameterSetName="NewPatch",Mandatory=$false)]
        [int]$Timeout = 3600
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    if (-not $BackupId)
    {
        $CurrentBackupIds = (Get-SafeguardBackup -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure).Id -join ", "
        Write-Host "Available Backups: [ $CurrentBackupIds ]"
        $BackupId = (Read-Host "BackupId")
    }

    Write-Host "Starting restore operation for backup..."
    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance POST "Backups/$BackupId/Restore"

    if (-not $NoWait)
    {
        Write-Host "Waiting for operation to complete..."
        Import-Module -Name "$PSScriptRoot\sg-utilities.psm1" -Scope Local
        Wait-ForSafeguardStatus -Appliance $Appliance -Insecure:$Insecure -Timeout $Timeout -DesiredStatus "StandaloneReadOnly"
        Write-Host "Safeguard is currently standalone readonly. You might need to login again, and you will need to use Enable-SafeguardClusterPrimary to go online."
    }
    else
    {
        Write-Host "Not waiting for operation to complete, this Safeguard appliance will not be available as it processes in the background."
    }
}

<#
.SYNOPSIS
Delete a backup from a Safeguard appliance via the Web API.

.DESCRIPTION
This cmdlet will delete a backup stored on a Safeguard appliance.  Only
delete backups that you have either downloaded or archived.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate.

.PARAMETER BackupId
A string containing a backup ID, which is a GUID.

.PARAMETER ArchiveServerId
An integer containing the archive server ID.

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Save-SafeguardBackupToArchive -BackupId "c6f9a3b4-7a75-406d-ba5a-830e44c1c94d"

.EXAMPLE
Save-SafeguardBackupToArchive -Appliance 10.5.32.54 -AccessToken $token -Insecure "c6f9a3b4-7a75-406d-ba5a-830e44c1c94d" 12
#>
function Save-SafeguardBackupToArchive
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false,Position=0)]
        [string]$BackupId,
        [Parameter(Mandatory=$false,Position=1)]
        [int]$ArchiveServerId
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    if (-not $BackupId)
    {
        $CurrentBackupIds = (Get-SafeguardBackup -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure).Id -join ", "
        Write-Host "Available Backups: [ $CurrentBackupIds ]"
        $BackupId = (Read-Host "BackupId")
    }

    if (-not $ArchiveServerId)
    {
        $ArchiveServerIds = ((Get-SafeguardArchiveServer -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure) | ForEach-Object { "$($_.Id): $($_.Name)" }) -join ", "
        Write-Host "Archive servers: [ $ArchiveServerIds ]"
        $ArchiveServerId = (Read-Host "ArchiveServerId")
    }

    Write-Host "Moving backup to archive server..."
    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance POST "Backups/$BackupId/Archive" -Body @{
            ArchiveServerId = $ArchiveServerId
    }
}

<#
.SYNOPSIS
Get backups on a Safeguard appliance via the Web API.

.DESCRIPTION
This cmdlet will return information about backups that have occurred on
the appliance. Backups that are archived are no longer stored on Safeguard.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardBackup "c6f9a3b4-7a75-406d-ba5a-830e44c1c94d"

.EXAMPLE
Get-SafeguardBackup -Appliance 10.5.32.54 -AccessToken $token -Insecure
#>
function Get-SafeguardBackup
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false,Position=0)]
        [string]$BackupId
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    if ($BackupId)
    {
        Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance GET "Backups/$BackupId"
    }
    else
    {
        Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance GET Backups
    }
}

<#
.SYNOPSIS
Get BMC configuration of a Safeguard appliance via the Web API.

.DESCRIPTION
Get the BMC network settings and enable state.  The AdminPassword field
returned will always be blank.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Get-SafeguardBmcConfiguration -Appliance 10.5.32.54 -AccessToken $token -Insecure
#>
function Get-SafeguardBmcConfiguration
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance GET BmcConfiguration
}

<#
.SYNOPSIS
Enable BMC configuration of a Safeguard appliance via the Web API.

.DESCRIPTION
Set the BMC to enabled and provide network settings and ADMIN password.  The AdminPassword field
in the object returned will always be blank.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.PARAMETER Ipv4Address
A string containing the new address.

.PARAMETER Ipv4NetMask
A string containing the netmask (e.g. 255.255.255.0).

.PARAMETER Ipv4Gateway
A string containing the address of a gateway.

.PARAMETER Password
SecureString containing the password for the ADMIN account.

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Enable-SafeguardBmcConfiguration 10.10.10.233 255.255.255.0 10.10.10.1

.EXAMPLE
Enable-SafeguardBmcConfiguration 10.10.10.233 255.255.255.0 10.10.10.1 -Password (ConvertTo-SecureString -AsPlainText -Force "reallylongpass")
#>
function Enable-SafeguardBmcConfiguration
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false,Position=0)]
        [string]$Ipv4Address,
        [Parameter(Mandatory=$false,Position=1)]
        [string]$Ipv4NetMask,
        [Parameter(Mandatory=$false,Position=2)]
        [string]$Ipv4Gateway,
        [Parameter(Mandatory=$false,Position=3)]
        [SecureString]$Password
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    $local:Body = @{
        Enabled = $true
    }
    if ($PSBoundParameters.ContainsKey("Ipv4Address") `
        -or $PSBoundParameters.ContainsKey("Ipv4NetMask") `
        -or $PSBoundParameters.ContainsKey("Ipv4Gateway"))
    {
        $local:Body.NetworkConfiguration = @{}
        if ($PSBoundParameters.ContainsKey("Ipv4Address")) { $local:Body.NetworkConfiguration.Ipv4Address = $Ipv4Address }
        if ($PSBoundParameters.ContainsKey("Ipv4NetMask")) { $local:Body.NetworkConfiguration.Netmask = $Ipv4NetMask }
        if ($PSBoundParameters.ContainsKey("Ipv4Gateway")) { $local:Body.NetworkConfiguration.DefaultGateway = $Ipv4Gateway }
    }
    if ($PSBoundParameters.ContainsKey("Password"))
    {
        $local:PasswordPlainText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        $local:Body.AdminPassword = $local:PasswordPlainText
    }

    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance PUT BmcConfiguration -Body $local:Body
}

<#
.SYNOPSIS
Disable BMC configuration of a Safeguard appliance via the Web API.

.DESCRIPTION
Disable the BMC by returning network settings to default and scrambling the password.
The AdminPassword field in the object returned will always be blank.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Disable-SafeguardBmcConfiguration -Appliance 10.5.32.54 -AccessToken $token -Insecure
#>
function Disable-SafeguardBmcConfiguration
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance PUT BmcConfiguration -Body @{
        Enabled = $false
    }
}

<#
.SYNOPSIS
Set password for BMC configuration of a Safeguard appliance via the Web API.

.DESCRIPTION
Set the BMC ADMIN password. The AdminPassword field in the object returned will always be blank.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.PARAMETER Password
SecureString containing the password for the ADMIN account.

.INPUTS
None.

.OUTPUTS
JSON response from Safeguard Web API.

.EXAMPLE
Set-SafeguardBmcAdminPassword -Appliance 10.5.32.54 -AccessToken $token -Insecure

.EXAMPLE
Set-SafeguardBmcAdminPassword (ConvertTo-SecureString -AsPlainText -Force "reallylongpass")
#>
function Set-SafeguardBmcAdminPassword
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure,
        [Parameter(Mandatory=$false,Position=0)]
        [SecureString]$Password
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    $local:Body = (Get-SafeguardBmcConfiguration -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure)
    if (-not $local:Body.Enabled)
    {
        throw "Unable to set admin password, this appliance does not have BMC enabled."
    }

    if (-not $Password)
    {
        $Password = Read-Host -AsSecureString "Password"
    }

    $local:PasswordPlainText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
    $local:Body.AdminPassword = $local:PasswordPlainText

    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance PUT BmcConfiguration -Body $local:Body
}

<#
.SYNOPSIS
Get current status of TLS 1.2 Only setting in Safeguard via the Web API.

.DESCRIPTION
TLS 1.2 Only means Safeguard will only negotiate TLS 1.2+ connections when
clients access the Web API and Web UI.  This cmdlet reports the current
status of that setting: true or false.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
Boolean from Safeguard Web API.

.EXAMPLE
Get-SafeguardTls12OnlyStatus -Appliance 10.5.32.54 -AccessToken $token -Insecure

.EXAMPLE
Get-SafeguardTls12OnlyStatus
#>
function Get-SafeguardTls12OnlyStatus
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance GET "ApplianceStatus/SecureSsl"
}

<#
.SYNOPSIS
Enable the TLS 1.2 Only setting in Safeguard via the Web API.

.DESCRIPTION
TLS 1.2 Only means Safeguard will only negotiate TLS 1.2+ connections when
clients access the Web API and Web UI.  This cmdlet sets the setting to true.

Running this cmdlet requires a Safeguard reboot for the setting to take effect.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
Boolean from Safeguard Web API.

.EXAMPLE
Enable-SafeguardTls12Only -Appliance 10.5.32.54 -AccessToken $token -Insecure

.EXAMPLE
Enable-SafeguardTls12Only
#>
function Enable-SafeguardTls12Only
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance PUT "ApplianceStatus/SecureSsl" -Body $true
    Import-Module -Name "$PSScriptRoot\ps-utilities.psm1" -Scope Local

    Write-Host -ForegroundColor Yellow "In order for this setting to take effect you need to reboot the Safeguard appliance."
    $local:Confirmed = (Get-Confirmation "Safeguard Appliance Reboot" "Do you want to initiate reboot on this Safeguard appliance?" `
                                         "Initiates reboot immediately." "Reboot manually later.")
    if ($local:Confirmed)
    {
        Invoke-SafeguardApplianceReboot -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure -Reason "Enable TLS 1.2 Only" -Force
    }
}

<#
.SYNOPSIS
Disable the TLS 1.2 Only setting in Safeguard via the Web API.

.DESCRIPTION
TLS 1.2 Only means Safeguard will only negotiate TLS 1.2+ connections when
clients access the Web API and Web UI.  This cmdlet sets the setting to false.

Running this cmdlet requires a Safeguard reboot for the setting to take effect.

.PARAMETER Appliance
IP address or hostname of a Safeguard appliance.

.PARAMETER AccessToken
A string containing the bearer token to be used with Safeguard Web API.

.PARAMETER Insecure
Ignore verification of Safeguard appliance SSL certificate

.INPUTS
None.

.OUTPUTS
Boolean from Safeguard Web API.

.EXAMPLE
Disable-SafeguardTls12Only -Appliance 10.5.32.54 -AccessToken $token -Insecure

.EXAMPLE
Disable-SafeguardTls12Only
#>
function Disable-SafeguardTls12Only
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Appliance,
        [Parameter(Mandatory=$false)]
        [object]$AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$Insecure
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey("Verbose")) { $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference") }

    Invoke-SafeguardMethod -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure Appliance PUT "ApplianceStatus/SecureSsl" -Body $false
    Import-Module -Name "$PSScriptRoot\ps-utilities.psm1" -Scope Local

    Write-Host -ForegroundColor Yellow "In order for this setting to take effect you need to reboot the Safeguard appliance."
    $local:Confirmed = (Get-Confirmation "Safeguard Appliance Reboot" "Do you want to initiate reboot on this Safeguard appliance?" `
                                         "Initiates reboot immediately." "Reboot manually later.")
    if ($local:Confirmed)
    {
        Invoke-SafeguardApplianceReboot -AccessToken $AccessToken -Appliance $Appliance -Insecure:$Insecure -Reason "Disable TLS 1.2 Only" -Force
    }
}
