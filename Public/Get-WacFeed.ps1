Function Get-WacFeed
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $GatewayEndpoint,

        [Parameter()]
        [PSCredential]
        $Credential
    )

    $requestUri = [Uri]"${GatewayEndpoint}/api/extensions/configs"
    $params = @{
        UseBasicParsing = $true
        UserAgent = 'PowerShell'
        Uri = $requestUri.OriginalString
        Method = 'Get'
    }

    if ($requestUri.Host -eq 'localhost')
    {
        $clientCertificateThumbprint = (Get-ItemProperty "HKLM:\Software\Microsoft\ServerManagementGateway").ClientCertificateThumbprint
    }

    if ($clientCertificateThumbprint)
    {
        $params.Add('CertificateThumbprint', "$certificateThumbprint")
    }

    if ($Credential)
    {
        $params.Credential = $Credential
    }
    else
    {
        $params.UseDefaultCredentials = $True
    }

    $response = Invoke-WebRequest @params -ErrorAction Stop
    $feeds = ConvertFrom-Json -InputObject $response.Content

    $feedObject = @()
    foreach ($feed in $feeds.packageFeeds)
    {
        $feedHash = [PsCustomObject]@{
            Path = $feed
        }

        $feedObject += $feedHash
    }

    return $feedObject
}
