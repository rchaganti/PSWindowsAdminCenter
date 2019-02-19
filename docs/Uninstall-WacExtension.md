# Uninstall-WacExtension

This command uninstalls a specified extension in Windows Admin Center. 

| Parameter Name  | Description                                                  | Valid Values                                                 |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| GatewayEndpoint | Specifies the web URI at which WAC is running. This parameter is mandatory. | This must be full URI. For example, https://localhost:4040 or https://localhost or https://monitor.my.lab |
| ExtensionId     | Specifies the extension id that needs to be uninstalled.     |                                                              |
| Credential      | Specifies the credentials needed to authenticate to WAC.     |                                                              |
| Version         | Specifies the version of the extension to install.           |                                                              |

## Example 1

```powershell
Uninstall-WacExtension -GatewayEndpoint https://localhost -ExtensionId 'ExtensionId'
```

The above command uninstalls the extension 'ExtensionId' in Windows Admin Center.

## Example 2

```powershell
Uninstall-WacExtension -GatewayEndpoint https://localhost -ExtensionId 'ExtensionId' -Credential (Get-Credential)
```

The above command uninstalls the extension 'ExtensionId' in Windows Admin Center. This command uses credentials to authenticate to WAC.

## Example 3

```powershell
Uninstall-WacExtension -GatewayEndpoint https://localhost -ExtensionId 'ExtensionId' -version 0.59.0
```

The above command uninstalls the extension 'ExtensionId' with version 0.59.0 in Windows Admin Center.

