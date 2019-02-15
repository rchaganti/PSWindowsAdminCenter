Function Remove-WacExtension
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
        $Credential
    )

    $getParams = @{
        GatewayEndpoint = $GatewayEndpoint
        ExtensionID = $ExtensionId
    }

    if ($Credential)
    {
        $getParams.Add('Credential',$Credential)
    }

    $existingExtensions = Get-WacExtension @getParams
    if ($existingExtensions.id -contains $ExtensionId)
    {
        if ($existingExtensions.Where({$_.id -eq $ExtensionId}).Status -eq 'Available')
        {
            throw "$ExtensionId is not installed."
        }
    }
    else
    {
        throw "$ExtensionId is not available in the WAC extension list."
    }

    $requestUri = [Uri]"${GatewayEndpoint}/api/extensions"
    $params = @{
        UseBasicParsing = $true
        UserAgent = 'PowerShell'
        Uri = $requestUri.OriginalString
        Method = 'put'
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
}
