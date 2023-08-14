###
 # Check the version of the Function App that is running in the given slot.
 ##

 param(
    [Parameter(Mandatory=$true, HelpMessage='The URI of the endpoint from which to get the version.')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${Uri},

    [Parameter(Mandatory=$true, HelpMessage='The value of the authentication header.')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${AuthHeaderValue},

    [Parameter(Mandatory=$true, HelpMessage='The name of the authentication header.')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${AuthHeaderName},

    [Parameter(DontShow, HelpMessage='The build number to check for.')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${BuildNumber} = $Env:BUILD_BUILDNUMBER,

    [Parameter(DontShow, HelpMessage='The maximum amount of tries to make.')]
    [ValidateNotNullOrEmpty()]
    [System.Int32]
    ${MaxTries} = 5,
 
    [Parameter(DontShow, HelpMessage='The number of seconds to wait between tries.')]
    [ValidateNotNullOrEmpty()]
    [System.Int32]
    ${RetryWaitSeconds} = 15
)

Write-Output ("Querying pipeline artefact version deployed to Function App -`n├─ URI: {0}`n├─ Header: {1}`n└─ Expected Version: {2}" -f $Uri, $AuthHeaderName, $BuildNumber)

$tryCount = 0
$checkComplete = $false
While (($checkComplete -eq $false) -and ($tryCount -lt 5))
{
    try
    {
        ### Query the artefact version.
        $response = Invoke-RestMethod -Method Get -Uri $Uri -Headers @{ $AuthHeaderName = $AuthHeaderValue }
        Write-Verbose "========== HTTP RESPONSE =========="
        Write-Verbose ($response | ConvertTo-Json)

        ### Tell the user how things went.
        if ($BuildNumber -ceq $response.version)
        {
            Write-Output "[Success] The expected pipeline artefact version is running."
            $exitCode = 0
        }
        else
        {
            Write-Output ("[Error] Pipeline artefact version was {0} while expected {1}." -f $response.version, $BuildNumber)
            $exitCode = 1
        }
        $checkComplete = $true
    }
    catch
    {
        $tryCount++
        Write-Output ("{0}/{1} {2}" -f $tryCount, $MaxTries, $_.Exception.Message)
        $exitCode = 1
        if ($tryCount -lt $MaxTries)
        {
            Start-Sleep -Seconds $RetryWaitSeconds
        }        
    }
}

if ($exitCode -ne 0)
{
    Write-Output ("[Error] Failing task since return code was {0} while expected 0." -f $exitCode)
}
[Environment]::Exit($exitCode)