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
    Write-Verbose -Message 'Getting installed WAC extensions ...'
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
        
        Write-Verbose -Message 'Generating request parameters ...'
        $requestParameters = Get-RequestParameter @params

        Write-Verbose -Message 'Invoking update WAC extension api ...'        
        $response = Invoke-WebRequest @requestParameters
        if ($response.StatusCode -eq 200)
        {
            $getParams = @{
                GatewayEndpoint = $GatewayEndpoint
                extensionId = $ExtensionId
                Status = 'Installed'
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
