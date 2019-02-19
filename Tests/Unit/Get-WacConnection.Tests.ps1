$script:moduleName = 'PSWindowsAdminCenter'

# Import the PSAdminCenter module
Import-Module $PSScriptRoot\..\..\PSWindowsAdminCenter\PSWindowsAdminCenter.psd1 -Force

InModuleScope $moduleName {
    Describe 'Get-WacConnection Tests' {
        BeforeAll {
            mock Get-ItemProperty
        }
        mock -CommandName Invoke-WebRequest -MockWith {
            param
            (
                [Parameter()]
                [Bool]
                $UseBasicParsing = $true,

                [Parameter()]
                [Bool]
                $UseDefaultCredentials = $true,

                [Parameter()]
                [String]
                $UserAgent = 'PowerShell',

                [Parameter()]
                [String]
                $Uri,

                [Parameter()]
                [string]
                $Method
            )

            $content = @{
                Content = @{
                    Value = @()
                }
            }

            return @{
                Content = (ConvertTo-Json -InputObject $content)
                StatusCode = 200
            }
        } -Verifiable

        #Invoke-WebRequest mock
        Context 'Get WAC connection with no credentials' {
            $inputParams = @{
                GatewayEndpoint = 'https://localhost'
            }
        
            It 'No WAC connections exist' {
                $connections = Get-WacConnection @inputParams
                $connections | Should BeNullOrEmpty
            }

            Assert-VerifiableMock
        }
    }
}
