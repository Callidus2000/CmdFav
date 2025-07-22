function Edit-CmdFav {
    <#
    .SYNOPSIS
        Edits properties of an existing favorite command.

    .DESCRIPTION
        The Edit-CmdFav function allows you to edit properties of an existing favorite command.
        You can modify the command line, tags, description, and even rename the favorite command.

    .PARAMETER Name
        Specifies the name of the existing favorite command to edit. This parameter is mandatory.

    .PARAMETER CommandLine
        Specifies the new command line to associate with the favorite command.

    .PARAMETER Tag
        Specifies new tags to associate with the favorite command.

    .PARAMETER Description
        Specifies a new description for the favorite command.

    .PARAMETER NewName
        Specifies a new name for the favorite command.

    .EXAMPLE
        Edit-CmdFav -Name "MyFavorite" -CommandLine "Get-Service -Status Running" -Tag "Service" -Description "List running services"

        Edits the existing favorite command named "MyFavorite" with a new command line, tag, and description.

    .EXAMPLE
        Edit-CmdFav -Name "MyFavorite" -NewName "NewFavoriteName"

        Renames the existing favorite command named "MyFavorite" to "NewFavoriteName".


    #>

    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, Position = 1)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.Names")]
        [string]$Name,
        $CommandLine,
        [string[]]$Tag,
        [string]$Description,
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.RepoNames")]
        [string]$Repository = 'PERSONALDEFAULT',
        [string]$NewName
    )

    # Retrieving the cache of favorite commands.
    Restore-CmdFav
    # $cmdCache = Get-PSFConfigValue -FullName 'CmdFav.History' -Fallback @()
    $cmdCache = Get-CmdFavCache

    # Handling the case where no favorite commands are stored.
    if (-not $cmdCache) {
        $cmdCache = @()
    }

    # Retrieving the existing favorite command to edit.
    $prevFav = ($cmdCache | Where-Object name -eq $Name)

    # Handling the case where the specified favorite does not exist.
    if (-not $prevFav) {
        Stop-PSFFunction -Level Critical -Message "Favorite Name '$Name' does not exist"
        return
    }

    # Creating a hashtable of new properties based on provided parameters.
    $newProperties = $PSBoundParameters | ConvertTo-PSFHashtable -Include CommandLine, Tag, Description, Repository

    # Updating the existing favorite command with new properties.
    foreach ($key in $newProperties.Keys) {
        Write-PSFMessage "Setting property $key to value $($newProperties.$key)"
        Add-Member -InputObject $prevFav -MemberType NoteProperty -Name $key -Value $newProperties.$key -Force
    }

    # Renaming the existing favorite command if a new name is provided.
    if (-not [string]::IsNullOrEmpty($NewName)) {
        $prevFav.Name = $NewName
    }

    # Saving the updated cache to the configuration framework.
    Set-CmdFavCache -CmdCache $cmdCache
    # Set-PSFConfig -Module 'CmdFav' -Name 'History' -Value ($cmdCache) -AllowDelete
    Save-CmdFav
}
