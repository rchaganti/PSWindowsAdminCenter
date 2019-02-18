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

    Write-Verbose -Message 'Generating request parameters ...'
    $requestParameters = Get-RequestParameter @params

    Write-Verbose -Message 'Invoking get WAC feed api ...'
    $response = Invoke-WebRequest @requestParameters -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200)
    {
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
    else
    {
        throw 'Error invoking get WAC feed api ...'
    }
}
