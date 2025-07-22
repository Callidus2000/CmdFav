function Register-CmdFavRepository {
    <#
        .SYNOPSIS
        Registers a new CmdFav repository or sets the default repository.

        .DESCRIPTION
        Adds a new CmdFav repository with the specified name and path, or sets
        the default repository if the -Default switch is used. If the repository file exists, its
        entries are appended to the current CmdFav cache.

        .PARAMETER Name
        The name of the repository to register.

        .PARAMETER Path
        The file path for the repository.

        .PARAMETER Priority
        # Removed: The priority for the repository (0-999). Default is 500.

        .PARAMETER Default
        If specified, registers the default repository.

        .EXAMPLE
        Register-CmdFavRepository -Name "myRepo" -Path "C:\cmdfav\myrepo.xml"
        Registers a new repository named "myRepo" with the specified path.

        .EXAMPLE
        Register-CmdFavRepository -Default -Path "C:\cmdfav\default.xml"
        Registers the default repository at the specified path.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'addOnRepo')]
        [string]$Name,

        [Parameter(Mandatory, ParameterSetName = 'defaultRepository')]
        [switch]$Default,

        [Parameter(Mandatory, ParameterSetName = 'addOnRepo')]
        [Parameter(Mandatory, ParameterSetName = 'defaultRepository')]
        [PsfNewFile]$Path
    )
    if($Default) {
        $Name = 'PERSONALDEFAULT'
    }
    Write-PSFMessage -Level Verbose -Message "Registering CmdFav repository '$Name' at '$Path'"
    Set-PSFConfig -Module CmdFav -Name "Repository.$Name.Path" -Value $Path -Validation 'string' -Description "CmdFav repository '$Name' at '$Path'" -AllowDelete -PassThru|Register-PSFConfig -Scope UserDefault
    if(test-path -Path $Path) {
        Restore-CmdFav -mode 'Append'
    }
    Save-cmdFav
}