function _init {

    if ( $psversiontable.psedition -eq "Desktop" ) {
        # Add TLS1.2 support
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Ssl3

        ## Define class required for certificate validation override.  Version dependant.
        ## For whatever reason, this does not work when contained within a function?
        $TrustAllCertsPolicy = @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
            }
        }
"@
    
        if ( -not ("TrustAllCertsPolicy" -as [type])) {
            Add-Type $TrustAllCertsPolicy
        }
    
        $script:originalCertPolicy = [System.Net.ServicePointManager]::CertificatePolicy
    }
}

Function Get-CurrentDate {
    $date = Get-Date
    $date.toString('MM/dd/yyyy')
}

function Add-UriQueryParam {
    param (
        [Parameter (Mandatory = $true)]
        [object]$QueryObject,
        [Parameter (Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [string[]]$QueryString
    )

    foreach ($queryToAppend in $QueryString) {
        if ( ($null -ne $QueryObject) -AND ($QueryObject.Length -gt 1) ) {
            if ($QueryObject.contains($queryToAppend)) {
                Write-Verbose "QueryObject already contains $queryToAppend. Not adding."
            }
            else {
                if ($QueryObject.StartsWith('?')) {
                    $QueryObject = $QueryObject.Substring(1) + "&" + $queryToAppend
                }
                else {
                    $QueryObject = $QueryObject + "&" + $queryToAppend
                }
            }
        }
        else {
            $QueryObject = $queryToAppend; 
        }
    }
    $QueryObject
}

Function Get-PLMToken {
    param (
        [Parameter (Mandatory = $True)]
        [ValidateNotNullorEmpty()]
        $Server,
        [Parameter (Mandatory = $True)]
        [ValidateNotNullorEmpty()]
        $Protocol,
        [Parameter (Mandatory = $True)]
        [ValidateNotNullorEmpty()]
        $ClientId,
        [Parameter (Mandatory = $True)]
        [ValidateNotNullorEmpty()]
        $ClientSecret,
        [Parameter (Mandatory = $True)]
        [ValidateNotNullorEmpty()]
        $GrantType
    )

    $headers = @{}
    $headers.Add("Content-Type", "application/json")

    $baseUri = New-Object System.UriBuilder("$($Protocol)://$($Server)")
    $baseUri.path = "/api/auth/v1/tokens"

    $body = @{
        "grant_type"    = $GrantType;
        "client_id"     = $ClientId;
        "client_secret" = $ClientSecret;
    }

    Write-Debug $($headers | ConvertTo-Json -Depth 100)
    Write-Debug $($body | ConvertTo-Json -Depth 100)

    Try {
        $response = Invoke-RestMethod -Method POST -Uri $baseUri.Uri -Headers $headers -Body $($body | ConvertTo-Json -Depth 100)
    }
    Catch {
        Write-Debug $_
        Throw "Unable to retrieve PLM Token."
    }

    Write-Debug $($response | ConvertTo-Json -Depth 100)
    $response
}

Function Get-DateFromString {
    param (
        [Parameter (Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Date
    )
    if ($date) {
        [Datetime]::ParseExact($Date, 'yyyy-MM-dd', $null);
    }
}



function New-PLMProductItem {
    param (
        [Parameter (Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [object[]]$Item,
        [Parameter (Mandatory = $true)]
        [ValidateSet("Supported", "Unsupported")]
        [string]$Status
    )

    foreach ($x in $item) {
        $object = [PSCustomobject]@{
            "Name"     = $x.name;
            "Status"   = $Status;
            
            "GADate"   = Get-DateFromString -Date $x.ga_date;
            "EOSDate"  = Get-DateFromString -Date $x.end_support_date;
    
            "EOTGDate" = Get-DateFromString -Date $x.end_tech_guidance_date;
            "EOADate"  = Get-DateFromString -Date $x.end_availability_date;
    
            "Policy"   = $x.lifecycle_policy.abbreviation
            "Notes"    = $null
        }
        $footnoteArray = New-Object System.Collections.ArrayList
        if ($x.footnotes) {
            foreach ($footnote in $x.footnotes) {
                $footnoteArray.Add($footnote.description) | Out-Null
            }
            $object.Notes = $footnoteArray
        }
        $object
    }
}

Function Invoke-InterestingDateCheck {
    param (
        [Parameter (Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [object]$ProductItem,
        [Parameter (Mandatory = $False)]
        [ValidateNotNullorEmpty()]
        [datetime]$Date
    )

    $currentDate = Get-Date
    $DateFieldNames = $ProductItem | Get-Member -MemberType Properties -Name '*Date*'

    if ($Date.date -lt $currentDate.date) {
        foreach ($DateFieldName in $DateFieldNames.name) {
            if ($ProductItem.$DateFieldName) {
                if (Get-BetweenTwoDates -Date $ProductItem.$DateFieldName -Start $Date.date -End $currentDate.date) {
                    return $True
                }
            }

        }
    }
    elseif ($Date.date -gt $currentDate.date) {
        foreach ($DateFieldName in $DateFieldNames.name) {
            if ($ProductItem.$DateFieldName) {
                if (Get-BetweenTwoDates -Date $ProductItem.$DateFieldName -Start $currentDate.date -End $Date.date) {
                    return $True
                }
            }
        }
    }
    else {
        foreach ($DateFieldName in $DateFieldNames.name) {
            if ($ProductItem.$DateFieldName) {
                if ($(Get-Date $ProductItem.$DateFieldName).date -eq $(Get-Date).date) {
                    return $True
                }
            }
        }
    }
    return $False
}

Function Get-BetweenTwoDates {
    param (
        $Date,
        $Start,
        $End
    )

    if ( ($Date -ge $Start) -AND ($Date -le $End) ) {
        $True
    }
    else {
        $False
    }
}

Function Get-FilteredResults {
    param (
        [Parameter (Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [object[]]$results,
        [Parameter (Mandatory = $true)]
        [ValidateSet("Supported", "Unsupported")]
        [string[]]$Status,
        [Parameter (Mandatory = $False)]
        [ValidateNotNullorEmpty()]
        [string]$Name,
        [Parameter (Mandatory = $False)]
        [ValidateNotNullorEmpty()]
        [datetime]$Date
    )

    foreach ($statusItem in $status ) {
        if ($Name) {
            $item = $results."$statusItem" | Where-Object { $($_.name).trim() -like $Name.trim() }
            if ($item) {
                New-PLMProductItem -Item $item -Status $statusItem
            }
        }
        else {
            foreach ($item in $results."$statusItem") {
                New-PLMProductItem -Item $item -Status $statusItem 
            }
        }
    }
}

Function Get-InterestingResults {
    param (
        [Parameter (Mandatory = $True)]
        [ValidateNotNullorEmpty()]
        [object[]]$results,
        [Parameter (Mandatory = $True)]
        [ValidateNotNullorEmpty()]
        [datetime]$Date
    )

    foreach ($item in $results) {
        if (Invoke-InterestingDateCheck -ProductItem $Item -Date $Date) {
            $Item
        }
    }
}

################################################################################
# Functions to export
################################################################################

Function Connect-PLMServer {
    <#
    .SYNOPSIS
    Creates a connection to the VMware Product Lifecycle Matrix server.

    .DESCRIPTION
    Creates a connection to the VMware Product Lifecycle Matrix server. Once a 
    connection has been established via this cmdlet, the details are saved in a
    connection object called $DefaultPLMConnection with a scope of Global.
    
    .PARAMETER Quiet
    When specified, the resulting connection object is not displayed. This is 
    helpful when being used in a script.
    
    .EXAMPLE
    Connect-PLMServer

    Authenticate to the PLM Authentication server and retrieve the access token
    
    .EXAMPLE
    Connect-PLMServer -Quiet

    Authenticate to the PLM Authentication server and retrieve the access token,
    but do not display the resulting connection object.

    .NOTES
    Author(s):      Dale Coghlan
    Twitter:        @DaleCoghlan
    Github:         dcoghlan  

    Although this cmdlet doesn't require any parameters to be set today (as these
    are currently using default values), it has been written for if/when VMware 
    decideds to allow customers to login to the server and get a curated list of
    products that the customer owns, rather than the customer having to find 
    their own products themselves.

    .LINK
    https://github.com/dcoghlan/VMware.LifecycleMatrix
    #>

    [CmdLetBinding(DefaultParameterSetName = "Unofficial")]

    param (
        [Parameter (Mandatory = $False, ParameterSetName = "Unofficial")]
        [ValidateNotNullorEmpty()]
        [String]$Protocol = "https",
        [Parameter (Mandatory = $False, ParameterSetName = "Unofficial")]
        [ValidateNotNullorEmpty()]
        [String]$Server = "auth.esp.vmware.com",
        [Parameter (Mandatory = $False, ParameterSetName = "Unofficial")]
        [ValidateNotNullorEmpty()]
        [String]$ClientId = 'plm-prod-auth',
        [Parameter (Mandatory = $False, ParameterSetName = "Unofficial")]
        [ValidateNotNullorEmpty()]
        [String]$ClientSecret = '84e0f320-5c9d-4ced-a99b-3cc0a7ad64a9',
        [Parameter (Mandatory = $False, ParameterSetName = "Unofficial")]
        [ValidateNotNullorEmpty()]
        [String]$GrantType = "client_credentials",
        [Parameter (Mandatory = $False, ParameterSetName = "Unofficial")]
        [Switch]$Quiet
        
    )
    
    $TokenResponse = Get-PLMToken -ClientId $ClientId -ClientSecret $ClientSecret -GrantType $GrantType -Server $Server -Protocol $Protocol
    $token = $TokenResponse.access_token

    #Setup the connection object
    $connection = [pscustomObject] @{
        "AuthServer" = $Server;
        "PLMServer"  = "plm.esp.vmware.com";
        "ClientId"   = $ClientId;
        "PLMToken"   = $token;
        "Protocol"   = $Protocol;
        # "DebugLogging"        = $DebugLogging
        # "DebugLogfile"        = $DebugLogFile
    }

    #Set the default connection is required.
    Set-Variable -Name DefaultPLMConnection -Value $connection -Scope Global

    if (!$Quiet) {
        $connection
    }
}

Function Get-PLMProduct {
    <#
    .SYNOPSIS
    Retrieve the list of products available on the VMware Lifecycle Matrix website.
    
    .DESCRIPTION
    Retrieve the list of products available on the VMware Lifecycle Matrix website.
    
    .PARAMETER Supported
    When specified, the -Supported switch will return only products marked by 
    the website as supported. 
    
    .PARAMETER Unsupported
    When specified, the -Unsupported switch will return only products marked by 
    the website as unsupported. 
    
    .PARAMETER Name
    When specified, only the products matching the name will be returned. Can be
    used with the -Supported and -Unsupported switches to further reduce the 
    scope of the search. 
    
    .EXAMPLE
    Get-PLMProduct

    Retrieve all the products listed on the VMware Lifecycle Matix website.
    
    .EXAMPLE
    Get-PLMProduct | FT

    Retrieve all the products listed on the VMware Lifecycle Matix website and 
    display them in a nicely formatted table.

    .EXAMPLE
    Get-PLMProduct -Supported

    Retrieve all the supported products

    .EXAMPLE
    Get-PLMProduct -Unsupported

    Retrieve all the unsupported products

    .EXAMPLE
    Get-PLMProduct -Name 'vSphere Replication 5.1'

    Retrieve details on the product 'vSphere Replication 5.1'

    .EXAMPLE
    Get-PLMProduct -Name '*replication*'

    Retrieve details on all products that have 'replication' in the name

    .EXAMPLE
    Get-PLMProduct -Name '*replication*' -Supported

    Retrieve details on all supported products that have 'replication' in the name

    .EXAMPLE
    Get-PLMProduct -Name 'nsx*'

    Retrieve details on all products where the name starts with 'nsx'

    .NOTES
    Author(s):      Dale Coghlan
    Twitter:        @DaleCoghlan
    Github:         dcoghlan  

    .LINK
    https://github.com/dcoghlan/VMware.LifecycleMatrix
    #>
    [CmdLetBinding(DefaultParameterSetName = "Default")]

    param (
        [Parameter (Mandatory = $False, ParameterSetName = "Default")]
        [Parameter (Mandatory = $False, ParameterSetName = "Name")]
        [ValidateNotNullorEmpty()]
        [switch]$Supported,
        [Parameter (Mandatory = $False, ParameterSetName = "Default")]
        [Parameter (Mandatory = $False, ParameterSetName = "Name")]
        [ValidateNotNullorEmpty()]
        [switch]$Unsupported,
        [Parameter (Mandatory = $True, ParameterSetName = "Name")]
        [ValidateNotNullorEmpty()]
        [string]$Name,
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$Connection = $DefaultPLMConnection

    )

    if (!$Connection) {
        Throw "Unable to connection to PLM Server. Please use Connect-PLMServer first."
    }
    # $headers = New-Object 'System.Collections.Generic.Dictionary[String,object]'
    $headers = @{}
    $headers.Add("Content-Type", "application/json")
    $headers.Add("x-auth-key", $DefaultPLMConnection.PLMToken)

    $baseUri = New-Object System.UriBuilder("$($DefaultPLMConnection.Protocol)://$($DefaultPLMConnection.PLMServer)")
    $baseUri.path = "/api/v1/release_stream/lifecycle_matrix"
    $baseUri.Query = Add-UriQueryParam -QueryObject $baseUri.Query -QueryString "to=$(Get-CurrentDate)"
    try {
        $response = Invoke-RestMethod -Uri $baseUri.Uri -Headers $headers
    }
    catch {
        throw "Unable to retieve Product Lifecycle Matrix data."
    }

    if ($response) {
        Write-Debug $($response | ConvertTo-Json -Depth 100)
        $splat = @{
            "results" = $response
        }
        if ( ($supported) -AND (!$Unsupported) ) {
            Write-Verbose "Get-PLMProduct(): Get filtered results for Supported products"
            $splat['Status'] = "Supported"
            if ($name) {
                Write-Verbose "Get-PLMProduct(): Adding name to filter the results"
                $splat['Name'] = $name
            }
            Get-FilteredResults @splat
        }
        elseif ( ($Unsupported) -AND (!$supported) ) {
            Write-Verbose "Get-PLMProduct(): Get filtered results for unupported products"
            $splat['Status'] = "Unsupported"
            if ($name) {
                Write-Verbose "Get-PLMProduct(): Adding name to filter the results"
                $splat['Name'] = $name
            }
            Get-FilteredResults @splat
        }
        else {
            Write-Verbose "Get-PLMProduct(): Get filtered results for ALL products"
            $splat['Status'] = @("Supported", "Unsupported")
            if ($name) {
                Write-Verbose "Get-PLMProduct(): Adding name to filter the results"
                $splat['Name'] = $name
            }
            Get-FilteredResults @splat
        }
    }
}

Function Get-PLMInterestingEvent {
    <#
    .SYNOPSIS
    A cmdlet to identify any product which has an interesting date between today
    (the day the cmdlet is run) and the days/date specified
    
    .DESCRIPTION
    A cmdlet to identify any product which has an interesting date between today
    (the day the cmdlet is run) and the days/date specified
    
    .PARAMETER Product
    Specifies the products to look through. Generally this is passed through the
    pipeline from Get-PLMProduct.
    
    .PARAMETER Days
    Specifies the number of days to offset from the current date. Each date 
    field provided in the product will be checked to see if the date falls on 
    or between the offset date and todays date.
    
    .PARAMETER Date
    Specifies the date to be used in the search to/from todays date. Each date 
    field provided in the product will be checked to see if the date falls on 
    or between the date specified and todays date.
    
    .EXAMPLE
    Get-PLMProduct | Get-PLMInterestingEvent -days 8 | FT

    Search through all products and return any which has a date that falls between todays date and 8 days in the future

    .EXAMPLE
    Get-PLMProduct | Get-PLMInterestingEvent -date $(Get-date -date "26/1/2022")

    Search through all products and return any which has a date that falls between todays date and 26th Jan 2022

    .EXAMPLE
    Get-PLMProduct | Get-PLMInterestingEvent -date $(Get-date -date "25/12/2019")

    Search through all products and return any which has a date that falls between todays date and 25th Dec 2019. 
    Useful to see which products have recently had an event since a previous date.

    .EXAMPLE
    Get-PLMProduct | Get-PLMInterestingEvent -days -60

    Search through all products and return any which has a date that falls between todays date and 60 days in the past. 
    Useful to see which products have recently had an event in the last x amount of days.

    .NOTES
    Author(s):      Dale Coghlan
    Twitter:        @DaleCoghlan
    Github:         dcoghlan  

    .LINK
    https://github.com/dcoghlan/VMware.LifecycleMatrix
    #>
    param (
        [Parameter (Mandatory = $True, ValueFromPipeline = $true, ParameterSetName = "InterestingDays")]
        [Parameter (Mandatory = $True, ValueFromPipeline = $true, ParameterSetName = "InterestingDate")]
        [ValidateNotNullorEmpty()]
        [object[]]$Product,
        [Parameter (Mandatory = $True, ParameterSetName = "InterestingDays")]
        [ValidateNotNullorEmpty()]
        [Int32]$Days,
        [Parameter (Mandatory = $True, ParameterSetName = "InterestingDate")]
        [ValidateNotNullorEmpty()]
        [datetime]$Date 
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'InterestingDays') {
            $InterestingDate = $(Get-Date).AddDays($days)
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'InterestingDate') {
            $InterestingDate = $Date
        }
        Get-InterestingResults -Results $Product -Date $InterestingDate
    }
}

_init