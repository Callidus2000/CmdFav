function Copy-CmdFav {
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
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.Names")]
        [PsfValidateSet(ScriptBlock = { (Get-CmdFavCache).Name }, ErrorMessage = "CmdFav with the name {0} does not exist.")]
        [string]$Name,
        [Parameter(Mandatory)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("CmdFav.RepoNames")]
        [PsfValidateSet(ScriptBlock = { (Get-CmdFavRepository).Name })]
        [string]$Repository,
        [Parameter(Mandatory)]
        [PSFValidateScript({ $_ -notin ((Get-CmdFavCache).Name) }, ErrorMessage = "The CmdFav with the name {0} already exists in the cache.")]
        [string]$NewName
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

    # Prepare new entry
    $newFav = $sourceFav | ConvertTo-PSFHashtable
    $newFav.Name = $NewName
    $newFav.Repository = $Repository

    # Add to target repository
    Add-CmdFav @newFav # -Name $newFav.Name -CommandLine $newFav.CommandLine -Tag $newFav.Tag -Repository $Repository

    Write-PSFMessage -Level Host "CmdFav '$Name' copied to '$NewName' in repository '$Repository'."
}