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

    $requestUri = [Uri]"${GatewayEndpoint}/api/connections"
    $params = @{
        UseBasicParsing = $true
        UserAgent = 'PowerShell'
        Uri = $requestUri.OriginalString
        Method = 'Get'
    }

    if ($requestUri.Host -eq 'localhost')
    {
        $clientCertificateThumbprint = (Get-ItemProperty "HKLM:\Software\Microsoft\ServerManagementGateway").ClientCertificateThumbprint
    }

    if ($clientCertificateThumbprint)
    {
        $params.Add('CertificateThumbprint', "$certificateThumbprint")
    }

    if ($Credential)
    {
        $params.Credential = $Credential
    }
    else
    {
        $params.UseDefaultCredentials = $True
    }

    $response = Invoke-WebRequest @params -ErrorAction Stop
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

        foreach ($property in $conn.properties.psobject.Properties)
        {
            $propertyName = $property.Name
            $connHash | Add-Member -MemberType NoteProperty -Name $propertyName -Value $conn.properties.$propertyName
        }

        $connectionObject += $connHash
    }

    return $connectionObject
}
