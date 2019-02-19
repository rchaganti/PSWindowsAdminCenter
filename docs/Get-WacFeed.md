# Get-WacFeed

This command gets an extension feed available in Windows Admin Center. 

| Parameter Name  | Description                                                  | Valid Values                                                 |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| GatewayEndpoint | Specifies the web URI at which WAC is running. This parameter is mandatory. | This must be full URI. For example, https://localhost:4040 or https://localhost or https://monitor.my.lab |
| Credential      | Specifies the credentials needed to authenticate to WAC.     |                                                              |

## Example 1

```powershell
Get-WacFeed -GatewayEndpoint https://localhost
```

The above command retrieves all extension feeds in Windows Admin Center.

## Example 2

```powershell
Get-WacFeed -GatewayEndpoint https://localhost -Credential (Get-Credential)
```

The above command retrieves all extension feeds in Windows Admin Center. This command uses credentials to authenticate to WAC.

