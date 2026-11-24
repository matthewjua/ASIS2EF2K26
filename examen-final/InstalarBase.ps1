# Matthew Juarez | 0901-23-4250 | 24/11/2026 | Instala el catalogo y los permisos por ODBC.
param(
    [Security.SecureString]$Clave,
    [ValidateSet('Debug', 'Release')][string]$Configuracion = 'Release'
)
$ErrorActionPreference = 'Stop'
$conexion = [System.Data.Odbc.OdbcConnection]::new('Dsn=asis22k26')
try {
    $conexion.Open()
    $comando = $conexion.CreateCommand()
    $comando.CommandText = 'SELECT DATABASE()'
    if ($comando.ExecuteScalar() -ne 'dbsistemaembutidos') {
        throw 'El DSN asis22k26 debe apuntar a dbsistemaembutidos.'
    }

    if ($Clave) {
        $bin = Join-Path $PSScriptRoot "../codigo/modulos/ventas/Ejecutable_Ventas/Ejecutable_Ventas/bin/$Configuracion"
        Add-Type -Path (Join-Path $bin 'BCrypt-Net-Next.dll')
        $credencial = [PSCredential]::new('usuariofinal', $Clave)
        $comando.CommandText = 'SET @hash_usuariofinal = ?'
        $null = $comando.Parameters.Add('hash', [System.Data.Odbc.OdbcType]::VarChar, 60)
        $comando.Parameters[0].Value = [BCrypt.Net.BCrypt]::HashPassword($credencial.GetNetworkCredential().Password)
        $null = $comando.ExecuteNonQuery()
        $comando.Parameters.Clear()
    }

    foreach ($archivo in '01-usuario-final.sql', '02-pacientes.sql') {
        $sql = Get-Content (Join-Path $PSScriptRoot $archivo) -Raw -Encoding UTF8
        $sql = $sql -replace '(?m)^\s*--[^\r\n]*', ''
        foreach ($sentencia in ($sql -split ';')) {
            if ($sentencia.Trim()) {
                $comando.CommandText = $sentencia.Trim()
                $null = $comando.ExecuteNonQuery()
            }
        }
    }
    $comando.CommandText = "SELECT COUNT(*) FROM tblusuario WHERE nombreUsuario='usuariofinal'"
    if ($comando.ExecuteScalar() -ne 1) {
        Write-Warning 'Cree usuariofinal desde Seguridad o ejecute de nuevo con -Clave.'
    }
    Write-Output 'Catálogo y permisos instalados a través del DSN asis22k26.'
} finally {
    $conexion.Dispose()
}
