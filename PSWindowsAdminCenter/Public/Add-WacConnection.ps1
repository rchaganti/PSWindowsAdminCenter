function Add-WacConnection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $GatewayEndpoint,

        [Parameter(Mandatory = $true)]
        [String]
        $ConnectionName,

        [Parameter(Mandatory = $true)]
        [ValidateSet('msft.sme.connection-type.server','msft.sme.connection-type.cluster','msft.sme.connection-type.hyper-converged-cluster','msft.sme.connection-type.windows-client')]
        [String]
        $ConnectionType,

        [Parameter()]
        [String[]]
        $Tags,

        [Parameter()]
        [PSCredential]
        $Credential,

        [Parameter()]
        [Switch]
        $SharedConnection
    )

    $params = @{
        GatewayEndpoint = $GatewayEndpoint
    }

    if ($Credential)
    {
        $params.Add('Credential',$Credential)
    }

    Write-Verbose -Message 'Retrieving existig connections in WAC ...'
    $existingConections = [PSCustomObject[]](Get-WacConnection @params)
    if ($existingConections.Where({$_.Type -eq $ConnectionType}).Name -contains $ConnectionName)
    {
        throw "$ConnectionName of type $ConnectionType already exists in WAC"
    }

    $params.Add('APIEndpoint', '/api/connections')
    $params.Add('Method','Put')

    Write-Verbose -Message 'Generating request parameters ...'
    $requestParameters = Get-RequestParameter @params

    $connectionObject = @()
    $connectionObject += @{
        name = $ConnectionName
        type = $ConnectionType
        id = "${ConnectionType}!${ConnectionName}"
        tags = $Tags
    }

    if ($SharedConnection)
    {
        Write-Verbose -Message "Adding $ConnectionName as shared connection"
        $connectionObject[0].Add('groupId','global')
    }

    $requestParameters.Add('Body', '[' + $($connectionObject | ConvertTo-Json) + ']')

    Write-Verbose -Message 'Invoking add WAC connection api ...'
    $response = Invoke-WebRequest @requestParameters -ErrorAction SilentlyContinue

    if ($response.StatusCode -eq 200)
    {
        return ($response.Content | ConvertFrom-Json).Changes
    }
    else
    {
        throw "Error adding $ConnectionName of type $ConnectionType"
    }
}
