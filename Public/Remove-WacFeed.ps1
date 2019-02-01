Function Remove-WacFeed
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $GatewayEndpoint,

        [Parameter(Mandatory = $true)]
        [String]
        $Path,

        [Parameter()]
        [PSCredential]
        $Credential
    )

    $params = @{
        GatewayEndpoint = $GatewayEndpoint
    }

    if ($Credential)
    {
        $params.Add('Credential', $Credential)
    }

    $feeds = Get-WacFeed @params
    
    if ($feeds.Path -notcontains $Path)
    {
        throw "${Path} does not exist in Windows Admin Center as a feed."       
    }
    else
    {
        $feedObject = [PSCustomObject]@{
            packageFeeds = @($feeds.Path | Where-Object { $_ -ne $Path })
        }
    }

    $requestUri = [Uri]"${GatewayEndpoint}/api/extensions/configs"
    $reqParams = @{
        UseBasicParsing = $true
        UserAgent = 'PowerShell'
        Uri = $requestUri.OriginalString
        Method = 'Put'
        Body = (ConvertTo-Json -InputObject $feedObject)
    }

    if ($requestUri.Host -eq 'localhost')
    {
        $clientCertificateThumbprint = (Get-ItemProperty "HKLM:\Software\Microsoft\ServerManagementGateway").ClientCertificateThumbprint
    }

    if ($clientCertificateThumbprint)
    {
        $reqParams.Add('CertificateThumbprint', "$certificateThumbprint")
    }

    if ($Credential)
    {
        $reqParams.Credential = $Credential
    }
    else
    {
        $reqParams.UseDefaultCredentials = $True
    }

    $response = Invoke-WebRequest @reqParams -ErrorAction Stop
    if ($response.StatusCode -ne 200 )
    {
        throw "Failed to remove the feed from the gateway"
    }
    else
    {
        return (Get-WacFeed -GatewayEndpoint $GatewayEndpoint -Credential $Credential)
    }
}
