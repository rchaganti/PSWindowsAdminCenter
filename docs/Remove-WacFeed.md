# Remove-WacFeed

This command removes an extension feed from Windows Admin Center. 

| Parameter Name  | Description                                                  | Valid Values                                                 |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| GatewayEndpoint | Specifies the web URI at which WAC is running. This parameter is mandatory. | This must be full URI. For example, https://localhost:4040 or https://localhost or https://monitor.my.lab |
| Path            | Specifies the path to a WAC extension feed. This parameter is mandatory. |                                                              |
| Credential      | Specifies the credentials needed to authenticate to WAC.     |                                                              |

## Example 1

```powershell
Remove-WacFeed -GatewayEndpoint https://localhost -Path '\\wac\share'
```

The above command will remove \\\wac\share as an extension feed from Windows Admin Center.

## Example 2

```powershell
Remove-WacFeed -GatewayEndpoint https://localhost -Path '\\wac\share' -Credential (Get-Credential)
```

The above command will remove \\\wac\share as an extension feed from Windows Admin Center. This command uses credentials to authenticate to WAC.

