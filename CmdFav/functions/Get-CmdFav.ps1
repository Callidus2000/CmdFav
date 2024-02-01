function Get-CmdFav {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true,Position=1)]
        [string]$Name
    )
    $cmdCache = Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()
    if (-not $cmdCache) {
        Stop-PSFFunction -Level Warning -Message "No favorite commands stored"
        return
    }
    $command = $cmdCache | Where-Object name -eq $Name | Select-Object -ExpandProperty commandline
    Write-PSFMessage "Found Command for name '$Name': $command"
    $global:Suggestion = $command
    $global:InjectCommand = Register-EngineEvent -SourceIdentifier PowerShell.OnIdle {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($global:Suggestion)
        Stop-Job $global:InjectCommand
    }
}