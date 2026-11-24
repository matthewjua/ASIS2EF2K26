-- Matthew Juarez | 0901-23-4250 | 24/11/2026 | LDD y permisos del catalogo.
USE dbsistemaembutidos;

CREATE TABLE IF NOT EXISTS tbl_paciente (
    pk_idPaciente INT NOT NULL,
    nombrePaciente VARCHAR(50),
    apellidoPaciente VARCHAR(50),
    fechaNacimientoPaciente DATE,
    sexoPaciente VARCHAR(15),
    direccionPaciente VARCHAR(30),
    telefonoPaciente VARCHAR(20),
    estadoPaciente INT,
    PRIMARY KEY (pk_idPaciente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tblReporte (
    numeroReporte INT NOT NULL PRIMARY KEY,
    nombreReporte VARCHAR(150) NOT NULL UNIQUE,
    rutaReporte VARCHAR(500) NOT NULL,
    fechaReporte DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblAplicacionReporte (
    idAplicacion INT NOT NULL,
    numeroReporte INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (idAplicacion, numeroReporte),
    FOREIGN KEY (idAplicacion) REFERENCES tblaplicacion (idAplicacion),
    FOREIGN KEY (numeroReporte) REFERENCES tblReporte (numeroReporte)
) ENGINE=InnoDB;

START TRANSACTION;
INSERT INTO tblaplicacion (idAplicacion, idModulo, nombreAplicacion, descripcionAplicacion, is_active)
VALUES (7017, 7000, 'Catálogo de pacientes', 'Mantenimiento y reporte de pacientes', 1)
ON DUPLICATE KEY UPDATE is_active = 1;

INSERT INTO tblrolmoduloaplicacion
    (idRol, idModulo, idAplicacion, derInsertarRolModuloAplicacion,
     derEditarRolModuloAplicacion, derEliminarRolModuloAplicacion, derImprimirRolModuloAplicacion)
SELECT idRol, 7000, 7017, 1, 1, 1, 1
FROM tblrol
WHERE nombreRol = 'Examen Final 0901234250'
ON DUPLICATE KEY UPDATE derInsertarRolModuloAplicacion = 1, derEditarRolModuloAplicacion = 1,
    derEliminarRolModuloAplicacion = 1, derImprimirRolModuloAplicacion = 1;

INSERT INTO tblReporte (numeroReporte, nombreReporte, rutaReporte, fechaReporte)
VALUES (7017, 'Catálogo de pacientes', 'Pacientes.rdlc', '2026-11-24')
ON DUPLICATE KEY UPDATE rutaReporte = VALUES(rutaReporte);

INSERT INTO tblAplicacionReporte (idAplicacion, numeroReporte)
VALUES (7017, 7017)
ON DUPLICATE KEY UPDATE numeroReporte = VALUES(numeroReporte);
COMMIT;
