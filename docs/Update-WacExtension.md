# Update-WacExtension

This command updates a specified extension in Windows Admin Center. 

| Parameter Name  | Description                                                  | Valid Values                                                 |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| GatewayEndpoint | Specifies the web URI at which WAC is running. This parameter is mandatory. | This must be full URI. For example, https://localhost:4040 or https://localhost or https://monitor.my.lab |
| ExtensionId     | Specifies the extension id that needs to be updated.         |                                                              |
| Credential      | Specifies the credentials needed to authenticate to WAC.     |                                                              |

## Example 1

```powershell
Update-WacExtension -GatewayEndpoint https://localhost -ExtensionId 'ExtensionId'
```

The above command updates the extension 'ExtensionId' to the most recent version in Windows Admin Center.

## Example 2

```powershell
Update-WacExtension -GatewayEndpoint https://localhost -ExtensionId 'ExtensionId' -Credential (Get-Credential)
```

The above command updates the extension 'ExtensionId' to the most recent version in Windows Admin Center. This command uses credentials to authenticate to WAC.



