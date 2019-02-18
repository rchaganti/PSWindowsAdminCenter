Function Update-WacExtension
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
        [PSCredential]
        $Credential
    )

    # Check if extension is in the installed list
    $extension = Get-WacExtension -GatewayEndpoint $GatewayEndpoint -Status Installed -ExtensionId $ExtensionId

    if ($extension)
    {
        $extensionVersion = $extension.version

        $params = @{
            GatewayEndpoint = $GatewayEndpoint
            APIEndpoint = "/api/extensions/$($extensionId)/versions/$($extensionVersion)/update" 
            Method = 'Post'  
        }    

        if ($Credential)
        {
            $params.Add('Credential',$Credential)
        }

        $requestParameters = Get-RequestParameter @params

        $response = Invoke-WebRequest @requestParameters
        return $response
    }
    else
    {
        throw ("{0} is not installed" -f $ExtensionId)
    }
}
