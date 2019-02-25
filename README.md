# PS Windows Admin Center

> **Note**: This works with Windows Admin Center 1809.5 and above

This module contains a set of commands to manage connections, feeds, and extensions in Windows Admin Center.

This module can be installed from PowerShell Gallery:

```powershell
Install-Module -Name PSWindowsAdminCenter 
```

| Command                | Description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| Get-WacConnection      | Gets connections added to Windows admin Center for management. This command supports shared connections introduced in 1902 insider preview. |
| Add-WacConnection      | Adds a new connection to Windows Admin Center for management. This command supports shared connections introduced in 1902 insider preview. |
| Remove-WacConnection   | Removes connection to Windows Admin Center for management. This command supports shared connections introduced in 1902 insider preview. |
| Get-WacFeed            | Gets all extension feeds available in Windows Admin Center.  |
| Add-WacFeed            | Adds an extension feed to Windows Admin Center.              |
| Remove-WacFeed         | Removes an extension feed from Windows Admin Center.         |
| Get-WacExtension       | Gets all extensions available or installed in Windows Admin Center. |
| Install-WacExtension   | Installs an extension.                                       |
| Uninstall-WacExtension | Uninstalls an extension.                                     |
| Update-WacExtension    | Updates an extension.                                        |

