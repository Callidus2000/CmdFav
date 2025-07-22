function Move-CmdFav {
    <#
        .SYNOPSIS
        Copies an existing CmdFav entry to a new name in a specified repository.

        .DESCRIPTION
        Duplicates a CmdFav (favorite command/scriptblock) identified by its name into a target repository under a new name.

        .PARAMETER Name
        The name of the CmdFav to copy.

        .PARAMETER NewName
        The new name for the copied CmdFav.

        .PARAMETER Repository
        The target repository name where the CmdFav should be copied to.

        .EXAMPLE
        Copy-CmdFav -Name "oldFav" -NewName "newFav" -Repository "PERSONALDEFAULT"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.Names")]
        [PsfValidateSet(ScriptBlock = { (Get-CmdFavCache).Name }, ErrorMessage = "CmdFav with the name {0} does not exist.")]
        [string]$Name,
        [Parameter(Mandatory)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.RepoNames")]
        [PsfValidateSet(ScriptBlock = { (Get-CmdFavRepository).Name })]
        [string]$Repository
    )

    # Get all CmdFav entries
    $allFavs = Get-CmdFavCache
    if ($allFavs | where-object { $_.Name -eq $NewName }) {
        Stop-PSFFunction -Level Warning -Message "CmdFav with name '$NewName' already exists"
        return
    }
    $sourceFav = $allFavs | Where-Object { $_.Name -eq $Name }
    if (-not $sourceFav) {
        Write-Error "CmdFav with name '$Name' not found."
        return
    }
    Edit-CmdFav -Name $Name -Repository $Repository

    # Add to target repository

    Write-PSFMessage -Level Host "CmdFav '$Name' moved to '$NewName' in repository '$Repository'."
}