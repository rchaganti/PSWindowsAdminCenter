<#

#>
function Remove-WacConnection
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

    Write-Verbose -Message 'Retrieving existig connections in WAC ...'
    $existingConections = [PSCustomObject[]](Get-WacConnection @params)
    $desiredConnection = $existingConections.Where({($_.Type -eq $ConnectionType) -and ($_.Name -eq $ConnectionName)})
    
    if (-not $desiredConnection)
    {
        throw "$ConnectionName of type $ConnectionType does not exist in WAC"
    }

    if ($desiredConnection.IsSharedConnection)
    {
        Write-Verbose -Message "$ConnectionName is a shared connection"
        $apiEndpoint = "/api/connections/${connectionType}!${connectionName}!global"
    }
    else
    {
        $apiEndpoint = "/api/connections/${connectionType}!${connectionName}"
    }

    $params.Add('APIEndpoint', $apiEndpoint)
    $params.Add('Method', 'Delete')

    Write-Verbose -Message 'Generating request parameters ...'
    $requestParameters = Get-RequestParameter @params

    Write-Verbose -Message 'Invoking remove WAC connection api ...'
    $response = Invoke-WebRequest @requestParameters -ErrorAction SilentlyContinue

    if (-not ($response.StatusCode -eq 204))
    {
        throw "Error removing $ConnectionName of type $ConnectionType"
    }
}
