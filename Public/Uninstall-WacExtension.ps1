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

        $requestParameters = Get-RequestParameter @params

        $response = Invoke-WebRequest @requestParameters
    }
    else
    {
        throw ("{0} is not installed" -f $ExtensionId)
    }
}
