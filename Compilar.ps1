# Matthew Juarez | 0901-23-4250 | 24/11/2026 | Compilacion del examen.
param([switch]$SoloEjecutable)
$ErrorActionPreference = 'Stop'
if (!$SoloEjecutable) {
    & (Join-Path $PSScriptRoot 'COMPILACION_GENERAL_PROYECTO_COMPLETO.bat') /auto /sin-color
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
}
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
$msbuild = & $vswhere -latest -products '*' -requires Microsoft.Component.MSBuild -find 'MSBuild/Current/Bin/MSBuild.exe' | Select-Object -First 1
if (!$msbuild) { throw 'Instale el componente Desarrollo de escritorio de .NET de Visual Studio.' }
$solucion = Join-Path $PSScriptRoot 'codigo/modulos/ventas/Ejecutable_Ventas/Ejecucion_Ventas.sln'
& $msbuild $solucion -restore -m -p:RestorePackagesConfig=true -p:Configuration=Release -verbosity:minimal
exit $LASTEXITCODE
