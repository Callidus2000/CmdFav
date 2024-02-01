function Get-CmdFav {
    <#
    .SYNOPSIS
        Retrieves a favorite command from the cache based on the specified name.

    .DESCRIPTION
        The Get-CmdFav function allows you to retrieve a favorite command from the cache based on the specified name.
        The favorite commands are stored in a cache, and this function retrieves the command line associated with the provided name.
        The found commands are injected into the next commandline

    .PARAMETER Name
        Specifies the name of the favorite command to retrieve. This parameter is mandatory.

    .EXAMPLE
        Get-CmdFav -Name "MyFavorite"

        Retrieves the command line associated with the favorite named "MyFavorite" from the cache.

    .NOTES


    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, Position = 1,ParameterSetName='targeted')]
        # [parameter(mandatory = $false, Position = 1,ParameterSetName='chooser')]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.Names")]
        [string]$Name,
        [parameter(mandatory = $false, ParameterSetName = 'chooser')]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.Tags")]
        [string[]]$Tag
    )

    # Retrieving the favorite commands cache.
    $cmdCache = Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()

    # Handling the case where no favorite commands are stored.
    if (-not $cmdCache) {
        Stop-PSFFunction -Level Warning -Message "No favorite commands stored"
        return
    }
    If ([string]::IsNullOrWhiteSpace($Name)) {
        if(-not [string]::IsNullOrEmpty($Tag)){
            Write-PSFMessage "Filtering existing commands by Tag $Tag"
            $cmdCache = $cmdCache | Where-Object { $_.Tag -contains $Tag }
        }
        if (Get-PSFConfigValue -FullName 'CmdFav.Selector.ConsoleGridView' -Fallback $true){
            $chosenCommand=$cmdCache|Select-Object -Property Name,Tag,CommandLine|Out-ConsoleGridView -OutputMode Single -Title "Choose a favorite command"
        }else{
            $chosenCommand=$cmdCache|Select-Object -Property Name,Tag,CommandLine|Out-GridView -OutputMode Single -Title "Choose a favorite command"
        }
        if (-not $chosenCommand){
            Write-PSFMessage "Nothing chosen"
            return
        }
        $Name=$chosenCommand.name
    }
    # Retrieving the command line for the specified favorite name.
    $command = $cmdCache | Where-Object name -eq $Name | Select-Object -ExpandProperty commandline

    # Displaying the found command line.
    Write-PSFMessage "Found Command for name '$Name': $command"

    # Setting global variables for suggestion and command injection.
    $global:Suggestion = $command
    $global:InjectCommand = Register-EngineEvent -SourceIdentifier PowerShell.OnIdle {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($global:Suggestion)
        Stop-Job $global:InjectCommand
    }
}

Set-Alias -Name "gcf" -Value "Get-CmdFav"