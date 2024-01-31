function Add-CmdFav {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)]
        [string]$Name,
        [parameter(mandatory = $true,ParameterSetName='Direct',ValueFromPipelineByPropertyName=$true)]
        $CommandLine,
        [parameter(mandatory = $true,ParameterSetName='LastCommand')]
        [switch]$LastCommand,
        [string[]]$Tag,
        [switch]$Force
    )

    begin {
        $cmdCache = Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()
        if (-not $cmdCache) { $cmdCache = @() }
        $prevFav = ($cmdCache | Where-Object name -eq $Name)
        if ($prevFav) {
            if ($force) {
                Write-PSFMessage "Overwriting Favorite, previos command: $($prevFav.CommandLine)"
                $cmdCache = $cmdCache | Where-Object name -ne $Name
            }
            else {
                Stop-PSFFunction  -Level Warning -Message "Favorite Name '$Name' already exists, -Force not used, does not overwrite"
            }
        }
        $newEntry = $PSBoundParameters | ConvertTo-PSFHashtable -IncludeEmpty -Include Name, CommandLine, Tag
        $scriptBlockBuilder = [System.Text.StringBuilder]::new()
    }

    process {
        if (Test-PSFFunctionInterrupt){return}
        If ($PsCmdlet.ParameterSetName -eq 'LastCommand'){
            $CommandLine = Get-History -Count 1 | select-object -ExpandProperty CommandLine
            # $newEntry.CommandLine = Get-History -Count 1 | select-object -ExpandProperty CommandLine
        }
        if ($scriptBlockBuilder.Length -gt 0) { [void]$scriptBlockBuilder.AppendLine() }
        [void]$scriptBlockBuilder.Append($CommandLine)
    }

    end {
        if (Test-PSFFunctionInterrupt) { return }
        $newEntry.CommandLine = $scriptBlockBuilder.ToString()
        Write-PSFMessage "Adding $($newEntry | ConvertTo-Json -Compress) to the cache"
        ([array]$cmdCache) += [PSCustomObject]$newEntry
        $cmdCache = [array]$cmdCache
        Write-PSFMessage "Saving cache to configuration framework"
        Set-PSFConfig -Module 'CmdFav' -Name 'History' -Value ($cmdCache) -AllowDelete
    }
}