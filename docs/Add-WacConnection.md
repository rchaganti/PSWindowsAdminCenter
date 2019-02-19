# Add-WacConnection

This command adds a new connection in Windows Admin Center for management. 

| Parameter Name  | Description                                                  | Valid Values                                                 |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| GatewayEndpoint | Specifies the web URI at which WAC is running. This parameter is mandatory. | This must be full URI. For example, https://localhost:4040 or https://localhost or https://monitor.my.lab |
| ConnectionName  | Specifies the name of the server or cluster to be added. This parameter is mandatory. | This needs to be a Fully-Qualifies Domain Name.              |
| ConnectionType  | Specifies the type of the connection being added. This parameter is mandatory. | 'msft.sme.connection-type.server'<br />'msft.sme.connection-type.cluster'<br />'msft.sme.connection-type.hyper-converged-cluster' |
| Tags            | Specifies any tags that need to be attached to the connection in WAC. |                                                              |
| Credential      | Specifies the credentials needed to authenticate to WAC.     |                                                              |

## Example 1

```powershell
Add-WacConnection -GatewayEndpoint https://localhost -ConnectionName ad.my.lab -ConnectionType 'msft.sme.connection-type.server'
```

The above command will add ad.my.lab as a server connection in Windows Admin Center.

## Example 2

```powershell
Add-WacConnection -GatewayEndpoint https://localhost -ConnectionName cluster.my.lab -ConnectionType 'msft.sme.connection-type.cluster' -Credential (Get-Credential)
```

The above command will add cluster.my.lab as a failover cluster connection in Windows Admin Center. This command uses credentials to authenticate to WAC.

## Example 3

```powershell
Add-WacConnection -GatewayEndpoint https://localhost -ConnectionName hcicluster.my.lab -ConnectionType 'msft.sme.connection-type.hyper-converged-cluster' -Tags 'hci','s2d'
```

The above command will add hcicluster.my.lab as a Hyper-Converged Infrastructure connection in Windows Admin Center. This command also adds tags along with the connection.