param(
    [Parameter(Mandatory=$true, HelpMessage='The name of the Resource Group.')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${ResourceGroupName},

    [Parameter(Mandatory=$true, HelpMessage='The name of the Function App.')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${FunctionAppName},

    [Parameter(Mandatory=$true, HelpMessage='The slot to target.')]
    [ValidateNotNullOrEmpty()]
    [System.String]
    ${Slot}
)

$ErrorActionPreference = "Stop"

try
{
    ### Get all of the existing App Settings.
    $command = "(Get-AzWebAppSlot -Name {0} -ResourceGroupName {1} -Slot {2} -ErrorAction Stop).SiteConfig.AppSettings" -f $FunctionAppName, $ResourceGroupName, $Slot
    Write-Output ("Querying Function App Settings -`n├─ Resource Group: {0}`n├─ Function App: {1}`n└─ `Slot: {2}" -f $ResourceGroupName, $FunctionAppName, $Slot)
    Write-Verbose $command
    $appSettings = Invoke-Expression $command
    $appSettings | Format-Table

    ### If they exist, get the values of 'WEBSITE_CONTENTSHARE' and 'AzureFunctionsWebHost:hostID'.
    $desiredSettings = @("WEBSITE_CONTENTSHARE", "AzureFunctionsWebHost:hostID")
    $existingSettings = @($appSettings).GetEnumerator() | Where-Object { $_.Name -cin  $desiredSettings }
    
    foreach ($setting in $desiredSettings)
    {
        if ($setting -cin ($existingSettings | Select-Object -ExpandProperty Name))
        {
            $value = ($existingSettings | Where-Object { $_.Name -ceq $setting }).Value
            Write-Output ("[Info] Found App Setting '{0}' with value '{1}'." -f $setting, $value)
        }
        else
        {
            if ($setting -eq  'AzureFunctionsWebHost:hostID') {
                $functionAppNameSubstringLength = ($FunctionAppName.Length, 27)[$FunctionAppName.Length -ge 27]
                $functionAppNamePart = [RegEx]::Replace($FunctionAppName.Substring(0, $functionAppNameSubstringLength), "[^a-z0-9]$", "")
                $randomStringPart = -join ((48..57) + (97..122) | Get-Random -Count 4 | ForEach-Object { [char]$_ })
            }
            else {
                $functionAppNameSubstringLength = ($FunctionAppName.Length, 54)[$FunctionAppName.Length -ge 54]
                $functionAppNamePart = [RegEx]::Replace($FunctionAppName.Substring(0, $functionAppNameSubstringLength), "[^a-z0-9-]$", "")
                $randomStringPart = -join ((48..57) + (97..122) | Get-Random -Count 8 | ForEach-Object { [char]$_ })
            }
            $value = "{0}-{1}" -f $functionAppNamePart, $randomStringPart

            Write-Output ("[Info] App Setting '{0}' does not exist, will use generated value '{1}'." -f $setting, $value)
        }

        ### Output the App Setting value to a variable.
        $setting = $setting -replace ':',''
        Write-Output ("##vso[task.setvariable variable={0};isOutput=true]{1}" -f $setting, $value)
    }
}
catch {
    Write-Output ("[Error] {0}" -f $_.Exception.Message)
    [Environment]::Exit($exitCode)
}