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

    $params = @{
        GatewayEndpoint = $GatewayEndpoint
        APIEndpoint = '/api/extensions/configs'
        Method = 'Get'
    }

    if ($Credential)
    {
        $params.Add('Credential',$Credential)
    }

    $requestParameters = Get-RequestParameter @params
    
    $response = Invoke-WebRequest @requestParameters -ErrorAction Stop
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
