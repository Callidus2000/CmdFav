function Move-CmdFav {
    <#
        .SYNOPSIS
        Moves one or more CmdFav entries to a different repository.

        .DESCRIPTION
        Changes the repository assignment of one or more favorite commands (CmdFavs) to a specified target repository. The name remains unchanged.

        .PARAMETER Name
        The name(s) of the CmdFav(s) to move.

        .PARAMETER Repository
        The target repository name where the CmdFav(s) should be moved to.

        .EXAMPLE
        Move-CmdFav -Name "MyFav" -Repository "TeamRepo"
        Moves the CmdFav named "MyFav" to the repository "TeamRepo".

        .EXAMPLE
        Move-CmdFav -Name "Fav1","Fav2" -Repository "PERSONALDEFAULT"
        Moves multiple CmdFavs to the default repository.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.Names")]
        [PsfValidateSet(ScriptBlock = { (Get-CmdFavCache).Name }, ErrorMessage = "CmdFav with the name {0} does not exist.")]
        [string[]]$Name,
        [Parameter(Mandatory)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.RepoNames")]
        [PsfValidateSet(ScriptBlock = { (Get-CmdFavRepository).Name })]
        [string]$Repository
    )

    # Get all CmdFav entries
    $allFavs = Get-CmdFavCache
    $sourceFav = $allFavs | Where-Object { $_.Name -in $Name }
    if (-not $sourceFav) {
        Write-Error "CmdFav with name '$Name' not found."
        return
    }
    $sourceFav.name| ForEach-Object {
        Edit-CmdFav -Name $_ -Repository $Repository
    }

    # Add to target repository

    Write-PSFMessage -Level Host "CmdFav '$Name' moved to repository '$Repository'."
}