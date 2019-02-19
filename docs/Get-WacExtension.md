# Get-WacExtension

This command gets a specified or all (installed or available) extensions available in Windows Admin Center. 

| Parameter Name  | Description                                                  | Valid Values                                                 |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| GatewayEndpoint | Specifies the web URI at which WAC is running. This parameter is mandatory. | This must be full URI. For example, https://localhost:4040 or https://localhost or https://monitor.my.lab |
| ExtensionId     | Specifies the extension id for which the details needs to be retrieved. |                                                              |
| Credential      | Specifies the credentials needed to authenticate to WAC.     |                                                              |
| Status          | Specifies if only installed or available extensions should be retrieved or all. | All<br />Installed<br />Available                            |

## Example 1

```powershell
Get-WacExtension -GatewayEndpoint https://localhost
```

The above command will all extensions (installed and available) from Windows Admin Center.

## Example 2

```powershell
Get-WacExtension -GatewayEndpoint https://localhost -Credential (Get-Credential)
```

The above command will all extensions (installed and available) from Windows Admin Center. This command uses credentials to authenticate to WAC.

## Example 3

```powershell
Get-WacExtension -GatewayEndpoint https://localhost -Status Installed
```

The above command will get only installed extensions.

## Example 4

```powershell
Get-WacExtension -GatewayEndpoint https://localhost -Status Available
```

The above command will get only available extensions.

## Example 5

Get-WacExtension -GatewayEndpoint https://localhost -ExtensionId 'ExtensionId'

The above command will retrieve details only about the extension with an id ExtensionId.

