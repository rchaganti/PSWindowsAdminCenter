<#
#>
Function Install-WacExtension
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
        $Credential,

        [Parameter()]
        [String]
        $Version
    )

    # Check if extension is in the available list
    Write-Verbose -Message 'Getting available WAC extensions ...'
    $extension = Get-WacExtension -GatewayEndpoint $GatewayEndpoint -Status Available -ExtensionId $ExtensionId | Select-Object id, @{l='version';e={[System.Version]$_.version}} | Sort-Object -Property Version

    if ($extension)
    {
        #If version is specified check if it exists in the available extension list
        if ($Version)
        {
            if ($extension.version -contains $Version)
            {
                $extensionVersion = $Version
            }
            else
            {
                throw "${extensionId} with specified version ${version} is not available for install"
            }
        }
        else
        {
            #if version is not specified, get the most recent version from the available list
            $extensionVersion = $extension[0].version.ToString()
        }

        $params = @{
            GatewayEndpoint = $GatewayEndpoint
            APIEndpoint = "/api/extensions/$($extensionId)/versions/$($extensionVersion)/install"
            Method = 'Post'
        }

        if ($Credential)
        {
            $params.Add('Credential',$Credential)
        }

        Write-Verbose -Message 'Generating request parameters ...'
        $requestParameters = Get-RequestParameter @params

        Write-Verbose -Message 'Invoking install WAC extension api ...'
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
        throw ("{0} is not available for install" -f $ExtensionId)
    }
}
