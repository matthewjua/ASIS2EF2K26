# Matthew Juarez | 0901-23-4250 | 24/11/2026 | Reconstruye el proyecto de clase con los cambios del examen.
param([string]$Destino = (Join-Path $PSScriptRoot 'EmbutidosExamen'), [string]$BaseLocal)
$ErrorActionPreference = 'Stop'
$revision = '9841ecc797eda40639a29ba9d1d5a3d34ad519f6'
$url = 'https://github.com/jtorresm6/proyectoasis22k26-Navegador.git'
if (Test-Path -LiteralPath $Destino) { throw 'Indique un destino nuevo para reconstruir el proyecto.' }
if ($BaseLocal) {
    git clone --no-checkout --shared -- $BaseLocal $Destino
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
    git -C $Destino checkout --detach $revision
} else {
    git init $Destino
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
    git -C $Destino fetch --depth=1 $url $revision
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
    git -C $Destino checkout --detach FETCH_HEAD
}
if ($LASTEXITCODE) { exit $LASTEXITCODE }
$parche = Join-Path $PSScriptRoot 'Cambios-examen.patch'
git -C $Destino apply --check $parche
if ($LASTEXITCODE) { exit $LASTEXITCODE }
git -C $Destino apply $parche
if ($LASTEXITCODE) { exit $LASTEXITCODE }
Write-Output "Solución reconstruida en $Destino"
