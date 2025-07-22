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

        .EXAMPLE
        Register-CmdFavRepository -Name "Work" -Path "C:\newlocation\work.xml" -Move
        Moves the current repository file to the new location and updates the registration.

        .EXAMPLE
        Register-CmdFavRepository -Name "Work" -Path "C:\existing\work.xml" -Force
        Registers the repository to use the file at the target location, ignoring the previous file.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'addOnRepo')]
        [string]$Name,

        [Parameter(Mandatory, ParameterSetName = 'defaultRepository')]
        [Parameter(Mandatory, ParameterSetName = 'resetDefaultRepository')]
        [switch]$Default,

        [Parameter(Mandatory, ParameterSetName = 'addOnRepo')]
        [Parameter(Mandatory, ParameterSetName = 'defaultRepository')]
        # [PsfNewFile]
        $Path,
        [Parameter(ParameterSetName = 'addOnRepo')]
        [Parameter(ParameterSetName = 'defaultRepository')]
        [Parameter(ParameterSetName = 'resetDefaultRepository')]
        [switch]$Move,
        [Parameter(ParameterSetName = 'addOnRepo')]
        [Parameter(ParameterSetName = 'defaultRepository')]
        [Parameter(ParameterSetName = 'resetDefaultRepository')]
        [switch]$Force,
        # [Parameter(ParameterSetName = 'defaultRepository')]
        [Parameter(ParameterSetName = 'defaultRepository')]
        [Parameter(Mandatory, ParameterSetName = 'resetDefaultRepository')]
        [switch]$Reset
    )
    if ($Default) {
        $Name = 'PERSONALDEFAULT'
        if ($Reset) {
            $defaultPath = Join-Path $env:AppData 'PowerShell\PSFramework\Config\cmdfav.xml'
            $Path = $defaultPath
            Write-PSFMessage -Level Host -Message "Resetting default repository to '$defaultPath'"
        }
    }

    $repoConfig = Get-CmdFavRepository -Name $Name
    if ($Move -and $Force) {
        Stop-PSFFunction -Level Warning -Message "-Move and -Force cannot be used together. Please choose only one option."
        return
    }
    if ($repoConfig) {
        if (-not $Move -and -not $Force) {
            Stop-PSFFunction -Level Warning -Message "Repository '$Name' already exists. Use -Move to relocate the repository file or -Force to use the file at the target location."
            return
        }
        if ($Move) {
            $oldPath = $repoConfig.Path
            if ((Test-Path -Path $oldPath) -and (Test-Path -Path $Path)) {
                Stop-PSFFunction -Level Warning -Message "Repository file '$oldPath' already exists at the new location '$Path'. Stop instead Overwriting."
                return
            }
            elseif (Test-Path -Path $oldPath) {
                Write-PSFMessage -Level Host -Message "Moving repository file from '$oldPath' to '$Path'"
                Move-Item -Path $oldPath -Destination $Path -Force
            }
            else {
                Write-PSFMessage -Level Host "Old repository file '$oldPath' does not exist. Only config will be updated."
            }
        }
        # Force is set
        Write-PSFMessage -Level Host -Message "Forcing repository registration to use file at '$Path'. Old file will be ignored."
        # No file move, just update config
    }

    Write-PSFMessage -Level Verbose -Message "Registering CmdFav repository '$Name' at '$Path'"
    Set-PSFConfig -Module CmdFav -Name "Repository.$Name.Path" -Value $Path -Validation 'string' -Description "CmdFav repository '$Name' at '$Path'" -AllowDelete -PassThru | Register-PSFConfig -Scope UserDefault
    if (Test-Path -Path $Path) {
        Restore-CmdFav -mode 'Append'
    }
    Save-cmdFav
}