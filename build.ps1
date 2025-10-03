# 2025 Taylor Plewe
#
# This project contains 2 DLLs--one compiled from C and the other from x86_64 assembly--and a main C file.
# The C DLL is *implicitly* linked; it uses a middle-man "helper.lib" which is a small file just containing info about the DLL basically, and that must be compiled alongside the main C file. You essentially just call the DLL's functions, and the compiler will see those function calls and smartly do the dynamically linking. So you don't have to call LoadLibrary() and FreeLibrary() from the Win32 API. That's how I understand it.
# The ASM DLL is *explicitly* linked; as I understand it this is the classic way of doing it. You define the function signature in the main C file, and call Win32 API functions (LoadLibrary, FreeLibrary, GetProcAddress) to interact with the DLL at runtime.
# More on this: https://learn.microsoft.com/en-us/cpp/build/linking-an-executable-to-a-dll?view=msvc-170
# 
# In the spirit of separating compiled artifacts into chunks (i.e. DLLs), each can be built separately:
#   > ./build --asm-dll
#   > ./build --c-dll
#   > ./build --main
#   > ./build --all
# No options passed is the same as passing --all.

function Write-BuildStep {
    param (
        [Parameter(Mandatory)]
        [string]$stepName
    )

    Write-Host "`nBuilding " -NoNewline -ForegroundColor Blue
    Write-Host $stepName -NoNewline
    Write-Host "..." -ForegroundColor Blue
}

<#
.DESCRIPTION
Write an error message to the console.

.EXAMPLE
Write-BuildError "uh-oh spaghetti-oh's"
#>
function Write-BuildError {
    param (
        [Parameter(Mandatory)]
        [string]$msg
    )

    Write-Host "Error: " -NoNewline -ForegroundColor Red
    Write-Host $msg
}

if (-not (Test-Path "bin")) {
    Write-Host "bin" -NoNewline
    Write-Host " directory does not exist, creating it..." -ForegroundColor Blue
    New-Item -ItemType Directory -Path "bin"
}

if (-not (Get-Command "cl" -ErrorAction SilentlyContinue)) {
    Write-BuildError "'cl' command not found. Are you in a Developer PowerShell for Visual Studio?"
    return
}
if (-not (Get-Command "ml64" -ErrorAction SilentlyContinue)) {
    Write-BuildError "'ml64' command not found. Are you in a Developer PowerShell for Visual Studio?"
    return
}
if (-not (Get-Command "link" -ErrorAction SilentlyContinue)) {
    Write-BuildError "'link' command not found. Are you in a Developer PowerShell for Visual Studio?"
    return
}

# set options based on args
$noLogoOption = $args.Contains("--nologo") ? '/nologo' : ''
$options = @{
    asmDll = $false
    cDll   = $false
    main   = $false
}
if ($args.Contains("--c-dll") -or $args.Contains("--all") -or $args.Count -eq 0) {
    $options["cDll"] = $true
}
if ($args.Contains("--asm-dll") -or $args.Contains("--all") -or $args.Count -eq 0) {
    $options["asmDll"] = $true
}
if ($args.Contains("--main") -or $args.Contains("--all") -or $args.Count -eq 0) {
    $options["main"] = $true
}

# helper.dll
if ($options["cDll"]) {
    Write-BuildStep "helper.c"
    cl helper.c /LD $noLogoOption
}
if ($LASTEXITCODE -ne 0) { return }

# asmhelper.dll
if ($options["asmDll"]) {
    Write-BuildStep "asmhelper.s"
    ml64 asmhelper.s /c $noLogoOption
    link asmhelper.obj /dll /noentry $noLogoOption
}
if ($LASTEXITCODE -ne 0) { return }

# main.c
if ($options["main"]) {
    Write-BuildStep "main.c"
    cl main.c helper.lib $noLogoOption
}

