function Add-CmdFav {
    <#
    .SYNOPSIS
        Adds a favorite command to a cache for future use.

    .DESCRIPTION
        The Add-CmdFav function allows you to add a favorite command to a cache, making it easily accessible for future use.
        You can specify a custom name, command line, tags, and choose whether to use the last executed command as the favorite.

    .PARAMETER Name
        Specifies the name of the favorite command. This parameter is mandatory.

    .PARAMETER CommandLine
        Specifies the command line to be associated with the favorite. This parameter is mandatory unless -LastCommand is used.

    .PARAMETER Description
        The description of the command

    .PARAMETER LastCommand
        Indicates that the last executed command should be used as the favorite command line. If this switch is used, the CommandLine parameter is ignored.

    .PARAMETER Tag
        Specifies tags to help categorize and organize the favorite commands.

    .PARAMETER Force
        Forces overwriting an existing favorite with the same name.

    .EXAMPLE
        Add-CmdFav -Name "MyFavorite" -CommandLine "Get-Process" -Tag "Monitoring"

        Adds a favorite command named "MyFavorite" with the command line "Get-Process" and a tag "Monitoring" to the cache.

    .EXAMPLE
        Add-CmdFav -Name "LastCommandFavorite" -LastCommand -Tag "Recent"

        Adds a favorite command named "LastCommandFavorite" with the last executed command line and a tag "Recent" to the cache.

    .EXAMPLE
        Get-History -Id 22 -Count 2|Add-CmdFav -Name "ScriptblockFromHistory"

        Adds a favorite command named "ScriptblockFromHistory" with the executed command lines 21-22 from the command history

    .NOTES


    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, Position = 1)]
        [string]$Name,
        [parameter(mandatory = $true, ParameterSetName = 'Direct', ValueFromPipelineByPropertyName = $true)]
        $CommandLine,
        [parameter(mandatory = $true, ParameterSetName = 'LastCommand')]
        [switch]$LastCommand,
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.Tags")]
        [string[]]$Tag,
        [string]$Description,
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
        $newEntry = $PSBoundParameters | ConvertTo-PSFHashtable -IncludeEmpty -Include Name, CommandLine, Tag, Description
        $scriptBlockBuilder = [System.Text.StringBuilder]::new()
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        If ($PsCmdlet.ParameterSetName -eq 'LastCommand') {
            $CommandLine = Get-History -Count 1 | select-object -ExpandProperty CommandLine
            # $newEntry.CommandLine = Get-History -Count 1 | select-object -ExpandProperty CommandLine
        }
        if ($scriptBlockBuilder.Length -gt 0) { [void]$scriptBlockBuilder.Append("`n") }
        # if ($scriptBlockBuilder.Length -gt 0) { [void]$scriptBlockBuilder.AppendLine() }
        [void]$scriptBlockBuilder.Append($CommandLine)
    }

    end {
        if (Test-PSFFunctionInterrupt) { return }
        $newEntry.CommandLine = $scriptBlockBuilder.ToString()
        Write-PSFMessage "Adding $($newEntry | ConvertTo-Json -Compress) to the cache"
        ([array]$cmdCache) += [PSCustomObject]$newEntry
        $cmdCache = [array]$cmdCache
        Write-PSFMessage "Saving cache to configuration framework"
        Set-PSFConfig -Module 'CmdFav' -Name 'History' -Value ($cmdCache) -AllowDelete -PassThru | Register-PSFConfig -Scope FileUserShared
    }
}
Set-Alias -Name "acf" -Value "Add-CmdFav"
