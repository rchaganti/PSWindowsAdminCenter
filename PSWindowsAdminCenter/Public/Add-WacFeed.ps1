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

    Write-Verbose -Message 'Getting existing WAC feeds ...'
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

    Write-Verbose -Message 'Generating request parameters ...'
    $requestParameters = Get-RequestParameter @params
    $requestParameters.Add('Body', (ConvertTo-Json -InputObject $feedObject))

    Write-Verbose -Message 'Invoking add WAC feed api ...'
    $response = Invoke-WebRequest @requestParameters -ErrorAction SilentlyContinue

    if ($response.StatusCode -ne 200 )
    {
        throw "Failed to add the feed in the gateway"
    }
    else
    {
        return (Get-WacFeed -GatewayEndpoint $GatewayEndpoint -Credential $Credential)
    }
}
