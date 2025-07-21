function Register-CmdFavRepository {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'addOnRepo')]
        [string]$Name,
        [Parameter(Mandatory, ParameterSetName = 'addOnRepo')]
        [string]$Prefix,

        [Parameter(Mandatory, ParameterSetName = 'defaultRepository')]
        [switch]$Default,

        [Parameter(Mandatory, ParameterSetName = 'addOnRepo')]
        [Parameter(Mandatory, ParameterSetName = 'defaultRepository')]
        [PsfNewFile]$Path,
        [Parameter(Mandatory=$false, ParameterSetName = 'addOnRepo')]
        [ValidateRange(0,999)]
        $Priority = 500
    )
    if($Default) {
        $Name = 'PERSONALDEFAULT'
        $Prefix=''
    }
    Write-PSFMessage -Level Verbose -Message "Registering CmdFav repository '$Name' at '$Path' with prefix '$Prefix'"
    Set-PSFConfig -Module CmdFav -Name "Repository.$Name.Path" -Value $Path -Validation 'string' -Description "CmdFav repository '$Name' at '$Path'" -AllowDelete -PassThru|Register-PSFConfig -Scope UserDefault
    Set-PSFConfig -Module CmdFav -Name "Repository.$Name.Prefix" -Value $Prefix -Validation 'string' -Description "Prefix for CmdFav repository '$Name' at '$Path'" -AllowDelete -PassThru | Register-PSFConfig -Scope UserDefault
    Set-PSFConfig -Module CmdFav -Name "Repository.$Name.Priority" -Value $Priority -Validation integer -Description "Priority for CmdFav repository '$Name' at '$Path'" -AllowDelete -PassThru | Register-PSFConfig -Scope UserDefault
    if(test-path)
}