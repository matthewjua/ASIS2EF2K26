-- Matthew Juarez | 0901-23-4250 | 24/11/2026
-- Prepara el empleado ficticio y el perfil de demostracion de usuariofinal.
USE dbsistemaembutidos;
START TRANSACTION;

INSERT INTO tblmodulo (idModulo, nombreModulo, descripcionModulo, is_active)
VALUES (7000, 'Ventas y Cuentas por Cobrar', 'Modulo de Ventas para el examen', 1)
ON DUPLICATE KEY UPDATE idModulo = idModulo;

INSERT INTO tblaplicacion (idAplicacion, idModulo, nombreAplicacion, descripcionAplicacion, is_active)
VALUES (7001, 7000, 'Principal', 'Contenedor de Ventas', 1)
ON DUPLICATE KEY UPDATE idAplicacion = idAplicacion;

-- El proyecto de clase tiene una variante de Seguridad y otra integrada con RR. HH.
SET @altaEmpleadoFinal = IF(
    EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tblempleado' AND COLUMN_NAME = 'puestoEmpleado'),
    'INSERT INTO tblempleado
        (codigoEmpleado, dpiEmpleado, nitEmpleado, nombresEmpleado, apellidosEmpleado,
         puestoEmpleado, generoEmpleado, fechaNacimientoEmpleado, fechaContratacionEmpleado,
         telefonoEmpleado, correoEmpleado)
     VALUES (''EF-0901234250'', ''0000901234250'', ''EF09012342'', ''Usuario'', ''Final'',
             ''Demostracion'', ''M'', ''1998-01-01'', ''2026-11-24'', ''00000000'', ''usuariofinal@example.invalid'')
     ON DUPLICATE KEY UPDATE codigoEmpleado = codigoEmpleado',
    'INSERT INTO tblempleado
        (codigoEmpleado, dpiEmpleado, nitEmpleado, nombresEmpleado, apellidosEmpleado,
         idDepartamento, idJornada, salarioEmpleado, generoEmpleado, fechaNacimientoEmpleado,
         fechaContratacionEmpleado, telefonoEmpleado, correoEmpleado)
     SELECT ''EF-0901234250'', ''0000901234250'', ''EF09012342'', ''Usuario'', ''Final'',
            e.idDepartamento, e.idJornada, 0, ''M'', ''1998-01-01'', ''2026-11-24'',
            ''00000000'', ''usuariofinal@example.invalid''
     FROM tblempleado e WHERE e.is_active = 1 ORDER BY e.idEmpleado LIMIT 1
     ON DUPLICATE KEY UPDATE codigoEmpleado = tblempleado.codigoEmpleado');
PREPARE altaEmpleadoFinal FROM @altaEmpleadoFinal;
EXECUTE altaEmpleadoFinal;
DEALLOCATE PREPARE altaEmpleadoFinal;

INSERT INTO tblrol (nombreRol, descripcionRol, is_active)
VALUES ('Examen Final 0901234250', 'Acceso a bitacora y catalogo de pacientes', 1)
ON DUPLICATE KEY UPDATE is_active = 1;

-- Si se define @hash_usuariofinal como un hash bcrypt valido, crea la cuenta.
-- Alternativamente, cree usuariofinal desde Seguridad con el empleado EF-0901234250.
INSERT INTO tblusuario (idEmpleado, nombreUsuario, contrasenaUsuario, ultimoAccesoUsuario)
SELECT idEmpleado, 'usuariofinal', @hash_usuariofinal, NOW()
FROM tblempleado
WHERE codigoEmpleado = 'EF-0901234250'
  AND CHAR_LENGTH(@hash_usuariofinal) = 60
  AND LEFT(@hash_usuariofinal, 4) IN ('$2a$', '$2b$', '$2y$')
ON DUPLICATE KEY UPDATE nombreUsuario = nombreUsuario;

INSERT INTO tblusuariorol (idUsuario, idRol, fechaAsignacionUsuarioRol)
SELECT u.idUsuario, r.idRol, CURRENT_DATE()
FROM tblusuario u CROSS JOIN tblrol r
WHERE u.nombreUsuario = 'usuariofinal' AND r.nombreRol = 'Examen Final 0901234250'
ON DUPLICATE KEY UPDATE fechaAsignacionUsuarioRol = fechaAsignacionUsuarioRol;

INSERT INTO tblrolmoduloaplicacion
    (idRol, idModulo, idAplicacion, derImprimirRolModuloAplicacion)
SELECT r.idRol, a.idModulo, a.idAplicacion, 1
FROM tblrol r CROSS JOIN tblaplicacion a
WHERE r.nombreRol = 'Examen Final 0901234250' AND a.idModulo = 4 AND a.idAplicacion = 12
ON DUPLICATE KEY UPDATE derImprimirRolModuloAplicacion = 1;
-- Requiere el catalogo de aplicaciones de Ventas antes de otorgar acceso al MDI.
INSERT INTO tblrolmoduloaplicacion
    (idRol, idModulo, idAplicacion, derImprimirRolModuloAplicacion)
SELECT r.idRol, a.idModulo, a.idAplicacion, 1
FROM tblrol r CROSS JOIN tblaplicacion a
WHERE r.nombreRol = 'Examen Final 0901234250' AND a.idModulo = 7000 AND a.idAplicacion = 7001
ON DUPLICATE KEY UPDATE derImprimirRolModuloAplicacion = 1;
COMMIT;
