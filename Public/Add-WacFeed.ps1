function Add-WacFeed
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
    
    if ($feeds.Path -Contains $Path)
    {
        throw "${Path} exists in Windows Admin Center as a feed."       
    }
    else
    {
        $feedObject = [PSCustomObject]@{
            packageFeeds = $($feeds.Path),$Path
        }
    }

    $params.Add('APIEndpoint','/api/extensions/configs')
    $params.Add('Method','Put')

    $requestParameters = Get-RequestParameter @params
    $requestParameters.Add('Body', (ConvertTo-Json -InputObject $feedObject))

    $response = Invoke-WebRequest @requestParameters -ErrorAction Stop
    if ($response.StatusCode -ne 200 )
    {
        throw "Failed to add the feed in the gateway"
    }
    else
    {
        return (Get-WacFeed -GatewayEndpoint $GatewayEndpoint -Credential $Credential)
    }
}
