Function Uninstall-WacExtension
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $GatewayEndpoint,

        [Parameter(Mandatory = $true)]
        [String]
        $ExtensionId,

        [Parameter()]
        [String]
        $Version,

        [Parameter()]
        [PSCredential]
        $Credential
    )

    # Check if extension is in the installed list
    Write-Verbose -Message 'Getting installed WAC extensions ...'
    $extension = Get-WacExtension -GatewayEndpoint $GatewayEndpoint -Status Installed -ExtensionId $ExtensionId | Select-Object id, @{l='version';e={[System.Version]$_.version}} | Sort-Object -Property Version

    if ($extension)
    {
        #If version is specified check if it exists in the installed extension list
        if ($Version)
        {
            if ($extension.version -contains $Version)
            {
                $extensionVersion = $Version
            }
            else
            {
                throw "${extensionId} with specified version ${version} is not installed"
            }
        }
        else
        {
            #if version is not specified, get the most recent version from the available list
            $extensionVersion = $extension[0].version.toString()
        }

        $params = @{
            GatewayEndpoint = $GatewayEndpoint
            APIEndpoint = "/api/extensions/$($extensionId)/versions/$($extensionVersion)/uninstall" 
            Method = 'Post'  
        }    

        if ($Credential)
        {
            $params.Add('Credential',$Credential)
        }

        Write-Verbose -Message 'Generating request parameters ...'
        $requestParameters = Get-RequestParameter @params

        Write-Verbose -Message 'Invoking uninstall WAC extension api ...'
        $response = Invoke-WebRequest @requestParameters

        if ($response.StatusCode -eq 200)
        {
            $getParams = @{
                GatewayEndpoint = $GatewayEndpoint
                extensionId = $ExtensionId
                Status = 'Available'
            }
            
            if ($Credential)
            {
                $getParams.Add('Credential', $Credential)
            }

            return (Get-WacExtension @getParams)
        }
        else
        {
            throw 'Error invoking install WAC extension api ...'    
        }
    }
    else
    {
        throw ("{0} is not installed" -f $ExtensionId)
    }
}
