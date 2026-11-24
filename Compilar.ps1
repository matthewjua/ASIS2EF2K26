# Compila las bibliotecas heredadas y el ejecutable del examen desde el fork.
param([ValidateSet('Debug', 'Release')][string]$Configuracion = 'Release')
$ErrorActionPreference = 'Stop'
$proyecto = Join-Path $PSScriptRoot 'EmbutidosExamen'
if (!(Test-Path -LiteralPath $proyecto)) {
    & (Join-Path $PSScriptRoot 'Preparar.ps1') -Destino $proyecto
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
}

$compiladorGeneral = Join-Path $proyecto 'COMPILACION_GENERAL_PROYECTO_COMPLETO.bat'
& $compiladorGeneral /auto /sin-color
if ($LASTEXITCODE) {
    Write-Warning 'El compilador general reportó errores. Se intentará compilar el ejecutable del examen con las bibliotecas disponibles.'
}

& (Join-Path $proyecto 'examen-final/Compilar.ps1') -Configuracion $Configuracion
exit $LASTEXITCODE
