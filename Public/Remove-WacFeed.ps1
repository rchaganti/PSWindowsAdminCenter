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

    $params.Add('APIEndpoint', $APIEndpoint)
    $params.Add('Method','Put')
    
    $requestParameters = Get-RequestParameter @params    
    $requestParameters.Add('Body', (ConvertTo-Json -InputObject $feedObject))
    
    $response = Invoke-WebRequest @requestParameters -ErrorAction Stop
    if ($response.StatusCode -ne 200 )
    {
        throw "Failed to remove the feed from the gateway"
    }
    else
    {
        return (Get-WacFeed -GatewayEndpoint $GatewayEndpoint -Credential $Credential)
    }
}
