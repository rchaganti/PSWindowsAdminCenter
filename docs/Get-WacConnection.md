# Get-WacConnection

This command gets a specified or all connections available in Windows Admin Center for management. 

| Parameter Name  | Description                                                  | Valid Values                                                 |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| GatewayEndpoint | Specifies the web URI at which WAC is running. This parameter is mandatory. | This must be full URI. For example, https://localhost:4040 or https://localhost or https://monitor.my.lab |
| ConnectionName  | Specifies the name of the connection to retrieve.            |                                                              |
| Credential      | Specifies the credentials needed to authenticate to WAC.     |                                                              |

## Example 1

```powershell
Get-WacConnection -GatewayEndpoint https://localhost -ConnectionName ad.my.lab
```

The above command will get details of the ad.my.lab as a server connection from Windows Admin Center.

## Example 2

```powershell
Get-WacConnection -GatewayEndpoint https://localhost -ConnectionName ad.my.lab -Credential (Get-Credential)
```

The above command will get details of the ad.my.lab as a server connection from Windows Admin Center. This command uses credentials to authenticate to WAC.

## Example 3

```powershell
Get-WacConnection -GatewayEndpoint https://localhost
```

The above command will get all connections added to WAC for management.