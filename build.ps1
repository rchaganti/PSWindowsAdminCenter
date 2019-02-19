Push-Location $PSScriptRoot\Tests
$res = Invoke-Pester -OutputFormat NUnitXml -OutputFile TestsResults.xml -PassThru
Pop-Location
