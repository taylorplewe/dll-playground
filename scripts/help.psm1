<#
.SYNOPSIS
Print program's help doc to the console

.EXAMPLE
Write-Help
#>

$helpText = @"
Usage: \build [options]

Options:
 --main       Build main C file into a PE executable (.exe)
 --c-dll      Build C DLL file
 --asm-dll    Build x86 assembly DLL file
 --all        Build the main file and both DLLs (default)
 --nologo     Pass '/nologo' to the compilers, removing the Microsoft signature from the top of build outputs
 --help, -h   Print this help text and exit
"@

function Write-Help {
    Write-Host $helpText
}

Export-ModuleMember -Function Write-Help
