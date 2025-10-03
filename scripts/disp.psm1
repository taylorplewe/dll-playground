<#
.SYNOPSIS
Output a build step to the console

.PARAMETER fileName
Name of the file being built next

.EXAMPLE
Write-BuildStep "myfile.c"
#>
function Write-BuildStep {
    param (
        [Parameter(Mandatory)]
        [string]$fileName
    )

    Write-Host "`nBuilding " -NoNewline -ForegroundColor Blue
    Write-Host $fileName -NoNewline
    Write-Host "..." -ForegroundColor Blue
}

<#
.SYNOPSIS
Write an error message to the console.

.PARAMETER msg
Error message to print

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

Export-ModuleMember -Function Write-BuildError,Write-BuildStep
