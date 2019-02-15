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
        $Name,

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

    $requestParameters = Get-RequestParameter @params

    $response = Invoke-WebRequest @requestParameters -ErrorAction Stop
    $allConnections = (ConvertFrom-Json -InputObject $response.Content).Value.Properties
   
    if ($Name)
    {
        $connections = $allConnections.Where({$_.Name -eq $Name})
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
