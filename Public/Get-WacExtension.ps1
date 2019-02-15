Function Get-WacExtension
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $GatewayEndpoint,

        [Parameter()]
        [String]
        $ExtensionId,

        [Parameter()]
        [PSCredential]
        $Credential,

        [Parameter()]
        [ValidateSet('Installed','Available','All')]
        [String]
        $Status = 'All'
    )

    $requestUri = [Uri]"${GatewayEndpoint}/api/extensions"
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
    $extensions = (ConvertFrom-Json -InputObject $response.Content).Values

    $extensionObject = @()
    foreach ($extension in $extensions)
    {
        $extensionHash = [PSCustomObject]@{}
        foreach ($property in $extension.psobject.properties)
        {
            $propertyName = $property.Name
            $extensionHash | Add-Member -MemberType NoteProperty -Name $propertyName -Value $extension.$propertyName
        }

        $extensionObject += $extensionHash
    }
    
    if ($Status -ne 'All')
    {
        return $extensionObject.Where({$_.Status -eq $Status})
    }
    else
    {
        return $extensionObject
    }
}
