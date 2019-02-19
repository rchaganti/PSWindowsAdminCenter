function Get-WacConnection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $GatewayEndpoint,

        [Parameter()]
        [String]
        $ConnectionName,

        [Parameter()]
        [PSCredential]
        $Credential
    )

    $params = @{
        GatewayEndpoint = $GatewayEndpoint
        Method = 'Get'
        APIEndpoint = '/api/connections'
    }

    if ($Credential)
    {
        $params.Add('Credential', $Credential)
    }

    Write-Verbose -Message 'Generating request parameters ...'
    $requestParameters = Get-RequestParameter @params

    Write-Verbose -Message 'Invoking get WAC connection api ...'
    $response = Invoke-WebRequest @requestParameters -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200)
    {
        $allConnections = (ConvertFrom-Json -InputObject $response.Content).Value.Properties

        if ($ConnectionName)
        {
            $connections = $allConnections.Where({$_.Name -eq $ConnectionName})
        }
        else
        {
            $connections = $allConnections
        }

        $connectionObject = @()
        foreach ($conn in $connections)
        {
            $connHash = [PSCustomObject] @{}
            $connHash | Add-Member -MemberType NoteProperty -Name Name -Value $conn.name
            $connHash | Add-Member -MemberType NoteProperty -Name id -Value $conn.id
            $connHash | Add-Member -MemberType NoteProperty -Name type -Value $conn.type
            $connHash | Add-Member -MemberType NoteProperty -Name tags -Value $conn.tags

            foreach ($property in $conn.properties.psobject.Properties)
            {
                $propertyName = $property.Name
                $connHash | Add-Member -MemberType NoteProperty -Name $propertyName -Value $conn.properties.$propertyName
            }

            $connectionObject += $connHash
        }

        return $connectionObject
    }
    else
    {
        throw 'Failed invoking get WAC connection api ...'
    }
}
