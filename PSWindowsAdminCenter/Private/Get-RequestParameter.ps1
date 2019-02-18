function Get-RequestParameter
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $GatewayEndpoint,

        [Parameter()]
        [pscredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [String]
        $ApiEndpoint,

        [Parameter(Mandatory = $true)]
        [String]
        $Method
    )

    $requestUri = [Uri]"${GatewayEndpoint}${ApiEndpoint}"

    $parameters = @{
        UseBasicParsing = $true
        UserAgent = 'PowerShell'
        Uri = $requestUri.OriginalString
        Method = $Method
    }
    
    if ($requestUri.Host -eq 'localhost')
    {
        $certThumbprint = (Get-ItemProperty "HKLM:\Software\Microsoft\ServerManagementGateway").ClientCertificateThumbprint
        if ($certThumbprint)
        {
            $parameters.certificateThumbprint = "$certThumbprint"
        }
    }

    if ($Credential) {
        $parameters.credential = $Credential
    }
    else {
        $parameters.useDefaultCredentials = $True
    }

    return $parameters
}
