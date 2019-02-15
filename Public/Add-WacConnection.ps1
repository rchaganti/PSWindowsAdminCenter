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
        [ValidateSet('msft.sme.connection-type.server','msft.sme.connection-type.cluster','msft.sme.connection-type.hyper-converged-cluster')]
        [String]
        $ConnectionType,

        [Parameter()]
        [String[]]
        $Tags,

        [Parameter()]
        [PSCredential]
        $Credential
    )
    
    $params = @{
        GatewayEndpoint = $GatewayEndpoint
    }

    if ($Credential)
    {
        $params.Add('Credential',$Credential)
    }
    
    $existingConections = [PSCustomObject[]](Get-WacConnection @params)
    if ($existingConections.Where({$_.Type -eq $ConnectionType}).Name -contains $ConnectionName)
    {
        throw "$ConnectionName of type $ConnectionType already exists in WAC"
    }
    
    $params.Add('APIEndpoint', '/api/connections')
    $params.Add('Method','Put')

    $requestParameters = Get-RequestParameter @params

    $connectionObject = @()
    $connectionObject += @{
        name = $ConnectionName
        type = $ConnectionType
        id = "${ConnectionType}!${ConnectionName}"
        tags = $Tags
    }

    $requestParameters.Add('Body', '[' + $($connectionObject | ConvertTo-Json) + ']')
    $response = Invoke-WebRequest @requestParameters -ErrorAction Stop

    if ($response.StatusCode -eq 200)
    {
        return ($response.Content | ConvertFrom-Json).Changes
    }
    else
    {
        throw "Error adding $ConnectionName of type $ConnectionType"
    }
}
