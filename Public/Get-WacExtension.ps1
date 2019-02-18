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

    $params = @{
        GatewayEndpoint = $GatewayEndpoint
        APIEndpoint = '/api/extensions'
        Method = 'Get'
    }

    if ($Credential)
    {
        $params.Add('Credential',$Credential)
    }

    $requestParameters = Get-RequestParameter @params

    $response = Invoke-WebRequest @requestParameters -ErrorAction Stop
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
        $extensions = $extensionObject.Where({$_.Status -eq $Status})
    }
    else
    {
        $extensions = $extensionObject
    }

    if ($ExtensionId)
    {
        return ($extensions | Where-Object { $_.id -eq $ExtensionId })
    }
    else
    {
        return $extensions
    }
}
