# Author: @reg0bs
# https://github.com/reg0bs/Find-Responder
# Credits go to the original author of asker.py: Erik V (https://github.com/eavalenzuela)

# This script checks if responses to arbitrary LLMNR requests are sent to detect responder like attacks

Param (
    [Parameter(Mandatory=$False)]
    [String[]]
    $Names,

    [Parameter(Mandatory=$False)]
    [Switch]
    $Authenticate = $False,

    [Parameter(Mandatory=$False)]
    [String]
    $Username = 'Administrator',

    [Parameter(Mandatory=$False)]
    [String]
    $Pass = -join (1..8 | ForEach-Object {[char]((97..122) + (48..57) | Get-Random)})
)

$ErrorActionPreference = 'Ignore'

function Write-Log {
    Param (
        [Parameter(Mandatory=$True)]
        [Int]
        $EventId,
        
        [Parameter(Mandatory=$True)]
        [String]
        $EventMessage
    )
    $Timestamp = (Get-Date).toString('yyyy/MM/dd HH:mm:ss')
    $LogMessage = $Timestamp + ' event_id=' + $EventId + ' event_message=' + $EventMessage
    Write-Output $LogMessage
}

function Send-Hash {
    Param (
        [Parameter(Mandatory=$True)]
        [String]
        $IpAddress
    )
    Write-Verbose 'Sending hashes...'
    $RemotePath = '\\' + $IpAddress + '\c$'
    New-SmbMapping -RemotePath $RemotePath -UserName $Username -Password $Pass -ErrorAction $ErrorActionPreference
    Write-Log -EventId 2 -EventMessage "`"authenticated to possible responder`" dest_ip=$IpAddress user=$Username"
}

function Find-Responder {
    Write-Verbose "Starting Respwnder..."
    If (!$Names) {
        $Names = -join (1..12 | ForEach-Object {[char]((97..122) + (48..57) | Get-Random)})
    }
    # Use specified names to check for responder
    foreach ($Name in $Names) {
        Write-Verbose "Resolving $Name..."
        $Responses = Resolve-DnsName -LlmnrOnly -Name $Name
        foreach ($Response in $Responses) {
            Write-Verbose 'Found possible responder...'
            $IpAddress = $Response.IPAddress
            Write-Log -EventId 1 -EventMessage "`"possible responder detected`" query=$Name answer=$IpAddress"
            If ($Authenticate) {
                Send-Hash -IPAddress $Response.IPAddress
            }
        }
    }
}

Find-Responder
