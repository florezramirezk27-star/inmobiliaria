-- ============================================================
--  INMOBILIARIA — DDL v3
--
--  Reescribe el módulo de propiedades con la convención de
--  nombres id_<entidad> (id_propiedad, id_ciudad, id_usuario...),
--  para que coincida con la que ya está en producción en el
--  módulo de autenticación (usuario, rol, usuario_rol, perfil,
--  sección 9 de este mismo archivo) y con la que usa literalmente
--  el enunciado del profesor.
--
--  La sección 9 (autenticación) NO se modifica: es la que ya
--  está mergeada en develop y usan UsuarioDAO/RolDAO/PerfilDAO.
--  Se reproduce aquí tal cual para que el archivo siga siendo
--  ejecutable de una sola pasada sobre una base vacía.
-- ============================================================

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS inmobiliaria
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_general_ci;

USE inmobiliaria;


-- ============================================================
-- MÓDULO DE AUTENTICACIÓN  (sin cambios — ya en producción)
-- ============================================================

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario          INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    correo              VARCHAR(180)      NOT NULL,
    password_hash       VARCHAR(255)      NOT NULL,   -- hash BCrypt
    estado              ENUM('ACTIVO','INACTIVO','BLOQUEADO')
                        NOT NULL DEFAULT 'ACTIVO',
    fecha_creacion      TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_ultimo_acceso TIMESTAMP         NULL,

    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_correo UNIQUE (correo)
) ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS rol (
    id_rol       SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(60)       NOT NULL,
    descripcion  VARCHAR(200)      NULL,

    CONSTRAINT pk_rol PRIMARY KEY (id_rol),
    CONSTRAINT uq_rol_nombre UNIQUE (nombre)
) ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS usuario_rol (
    id_usuario        INT UNSIGNED      NOT NULL,
    id_rol            SMALLINT UNSIGNED NOT NULL,
    fecha_asignacion  TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_usuario_rol PRIMARY KEY (id_usuario, id_rol),

    CONSTRAINT fk_ur_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_ur_rol
        FOREIGN KEY (id_rol) REFERENCES rol (id_rol)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE INDEX ix_usuario_rol_rol ON usuario_rol (id_rol);


CREATE TABLE IF NOT EXISTS perfil (
    id_perfil   INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    id_usuario  INT UNSIGNED    NOT NULL,
    nombres     VARCHAR(80)     NOT NULL,
    apellidos   VARCHAR(80)     NOT NULL,
    documento   VARCHAR(30)     NOT NULL,
    telefono    VARCHAR(30)     NULL,
    direccion   VARCHAR(180)    NULL,
    foto        VARCHAR(255)    NULL,

    CONSTRAINT pk_perfil PRIMARY KEY (id_perfil),
    CONSTRAINT uq_perfil_documento UNIQUE (documento),
    CONSTRAINT uq_perfil_usuario UNIQUE (id_usuario),

    CONSTRAINT fk_perfil_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;


-- ============================================================
-- MÓDULO DE NEGOCIO — CATÁLOGOS
-- ============================================================

CREATE TABLE IF NOT EXISTS ciudad (
    id_ciudad     INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    nombre        VARCHAR(80)     NOT NULL,
    departamento  VARCHAR(80)     NOT NULL,

    CONSTRAINT pk_ciudad PRIMARY KEY (id_ciudad),
    CONSTRAINT uq_ciudad_nombre_depto UNIQUE (nombre, departamento)
) ENGINE = InnoDB;


-- Nombre alineado con el enunciado (antes: tipo_inmueble).
CREATE TABLE IF NOT EXISTS tipo_propiedad (
    id_tipo_propiedad TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(60)      NOT NULL,
    slug              VARCHAR(60)      NOT NULL,

    CONSTRAINT pk_tipo_propiedad PRIMARY KEY (id_tipo_propiedad),
    CONSTRAINT uq_tipo_propiedad_slug UNIQUE (slug)
) ENGINE = InnoDB;


-- Relación 1:N exigida: "una inmobiliaria publica muchas propiedades".
-- id_usuario es el agente responsable; UNIQUE porque una cuenta
-- administra una sola agencia en este modelo.
CREATE TABLE IF NOT EXISTS inmobiliaria (
    id_inmobiliaria   INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nombre_comercial  VARCHAR(120)  NOT NULL,
    nit               VARCHAR(20)   NOT NULL,
    telefono          VARCHAR(20)   NULL,
    id_usuario        INT UNSIGNED  NOT NULL,

    CONSTRAINT pk_inmobiliaria PRIMARY KEY (id_inmobiliaria),
    CONSTRAINT uq_inmobiliaria_nit UNIQUE (nit),
    CONSTRAINT uq_inmobiliaria_usuario UNIQUE (id_usuario),

    CONSTRAINT fk_inmobiliaria_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;


-- ============================================================
-- MÓDULO DE NEGOCIO — PROPIEDADES
-- ============================================================

CREATE TABLE IF NOT EXISTS propiedad (
    id_propiedad          INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    codigo                VARCHAR(20)       NOT NULL,   -- código comercial visible al público
    matricula_inmobiliaria VARCHAR(30)      NOT NULL,   -- folio de registro; UNIQUE exigida por el enunciado
    titulo                VARCHAR(150)      NOT NULL,
    descripcion           TEXT              NULL,

    operacion             ENUM('ARRIENDO','VENTA')                        NOT NULL,
    estado                ENUM('BORRADOR','PUBLICADA','RESERVADA','CERRADA')
                          NOT NULL DEFAULT 'BORRADOR',

    id_tipo_propiedad     TINYINT UNSIGNED  NOT NULL,
    id_ciudad             INT UNSIGNED      NOT NULL,
    id_inmobiliaria       INT UNSIGNED      NOT NULL,   -- quién publica (relación 1:N exigida)
    id_usuario            INT UNSIGNED      NOT NULL,   -- usuario que registró la fila (auditoría)

    precio                DECIMAL(15,2)     NOT NULL,
    administracion        DECIMAL(12,2)     NOT NULL DEFAULT 0,

    area_construida       DECIMAL(8,2)      NULL,
    area_lote             DECIMAL(10,2)     NULL,
    habitaciones          TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    banos                 TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    parqueaderos          TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    estrato               TINYINT UNSIGNED  NULL,       -- 1 a 6
    antiguedad_anios      SMALLINT UNSIGNED NULL,

    direccion             VARCHAR(180)      NOT NULL,
    barrio                VARCHAR(100)      NULL,
    latitud               DECIMAL(10,7)     NULL,
    longitud              DECIMAL(10,7)     NULL,

    creado_en             TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en        TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP
                                            ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_propiedad PRIMARY KEY (id_propiedad),
    CONSTRAINT uq_propiedad_codigo UNIQUE (codigo),
    -- UNIQUE exigida por el enunciado: evita publicar dos veces el mismo inmueble.
    CONSTRAINT uq_propiedad_matricula UNIQUE (matricula_inmobiliaria),

    CONSTRAINT fk_propiedad_tipo
        FOREIGN KEY (id_tipo_propiedad) REFERENCES tipo_propiedad (id_tipo_propiedad)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_propiedad_ciudad
        FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_propiedad_inmobiliaria
        FOREIGN KEY (id_inmobiliaria) REFERENCES inmobiliaria (id_inmobiliaria)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_propiedad_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT ck_propiedad_precio  CHECK (precio > 0),
    CONSTRAINT ck_propiedad_estrato CHECK (estrato IS NULL OR estrato BETWEEN 1 AND 6)
) ENGINE = InnoDB;

CREATE INDEX ix_propiedad_busqueda ON propiedad (estado, operacion, id_ciudad, id_tipo_propiedad);
CREATE INDEX ix_propiedad_precio   ON propiedad (precio);
CREATE INDEX ix_propiedad_reciente ON propiedad (creado_en DESC);


CREATE TABLE IF NOT EXISTS imagen_propiedad (
    id_imagen     INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    id_propiedad  INT UNSIGNED      NOT NULL,
    ruta          VARCHAR(255)      NOT NULL,
    texto_alt     VARCHAR(150)      NULL,
    es_portada    BOOLEAN           NOT NULL DEFAULT FALSE,
    orden         TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    creado_en     TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_imagen_propiedad PRIMARY KEY (id_imagen),

    CONSTRAINT fk_imagen_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad (id_propiedad)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE INDEX ix_imagen_propiedad ON imagen_propiedad (id_propiedad, orden);


CREATE TABLE IF NOT EXISTS caracteristica (
    id_caracteristica SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(60)       NOT NULL,
    categoria         ENUM('INTERIOR','EXTERIOR','CONJUNTO','SEGURIDAD') NOT NULL,

    CONSTRAINT pk_caracteristica PRIMARY KEY (id_caracteristica),
    CONSTRAINT uq_caracteristica_nombre UNIQUE (nombre)
) ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS propiedad_caracteristica (
    id_propiedad      INT UNSIGNED      NOT NULL,
    id_caracteristica SMALLINT UNSIGNED NOT NULL,
    cantidad          TINYINT UNSIGNED  NOT NULL DEFAULT 1,   -- atributo propio de la relación N:M

    CONSTRAINT pk_propiedad_caracteristica
        PRIMARY KEY (id_propiedad, id_caracteristica),

    CONSTRAINT fk_pc_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad (id_propiedad)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_pc_caracteristica
        FOREIGN KEY (id_caracteristica) REFERENCES caracteristica (id_caracteristica)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE INDEX ix_pc_caracteristica ON propiedad_caracteristica (id_caracteristica);


CREATE TABLE IF NOT EXISTS favorito (
    id_usuario    INT UNSIGNED NOT NULL,
    id_propiedad  INT UNSIGNED NOT NULL,
    creado_en     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_favorito PRIMARY KEY (id_usuario, id_propiedad),

    CONSTRAINT fk_favorito_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_favorito_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad (id_propiedad)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;


-- ============================================================
-- MÓDULO DE OPERACIÓN — CITAS Y SOLICITUDES (Sprint 3)
-- Se diseñan aquí porque el enunciado exige el modelo COMPLETO
-- desde el corte 1; la funcionalidad se construye en el Sprint 3.
-- ============================================================

CREATE TABLE IF NOT EXISTS cita (
    id_cita       INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad  INT UNSIGNED  NOT NULL,
    id_cliente    INT UNSIGNED  NOT NULL,   -- usuario.id_usuario del cliente que agenda
    fecha_hora    DATETIME      NOT NULL,
    estado        ENUM('SOLICITADA','CONFIRMADA','RECHAZADA','REALIZADA','CANCELADA')
                  NOT NULL DEFAULT 'SOLICITADA',
    observacion   VARCHAR(255)  NULL,
    creado_en     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_cita PRIMARY KEY (id_cita),
    -- UNIQUE sugerida por el enunciado: evita agendar dos visitas a la
    -- misma propiedad en el mismo horario.
    CONSTRAINT uq_cita_propiedad_horario UNIQUE (id_propiedad, fecha_hora),

    CONSTRAINT fk_cita_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad (id_propiedad)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_cita_cliente
        FOREIGN KEY (id_cliente) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS solicitud (
    id_solicitud  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_propiedad  INT UNSIGNED  NOT NULL,
    id_cliente    INT UNSIGNED  NOT NULL,
    tipo          ENUM('COMPRA','ARRIENDO') NOT NULL,
    estado        ENUM('PENDIENTE','EN_REVISION','APROBADA','RECHAZADA')
                  NOT NULL DEFAULT 'PENDIENTE',
    comentario    VARCHAR(255)  NULL,
    creado_en     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_solicitud PRIMARY KEY (id_solicitud),

    CONSTRAINT fk_solicitud_propiedad
        FOREIGN KEY (id_propiedad) REFERENCES propiedad (id_propiedad)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_solicitud_cliente
        FOREIGN KEY (id_cliente) REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS documento_solicitud (
    id_documento    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_solicitud    INT UNSIGNED  NOT NULL,
    nombre_archivo  VARCHAR(150)  NOT NULL,
    ruta            VARCHAR(255)  NOT NULL,
    subido_en       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_documento_solicitud PRIMARY KEY (id_documento),

    CONSTRAINT fk_documento_solicitud
        FOREIGN KEY (id_solicitud) REFERENCES solicitud (id_solicitud)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS auditoria (
    id_auditoria    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_usuario      INT UNSIGNED    NULL,   -- NULL si la acción fue del sistema
    accion          VARCHAR(60)     NOT NULL,
    tabla_afectada  VARCHAR(60)     NULL,
    id_registro     INT UNSIGNED    NULL,
    detalle         VARCHAR(255)    NULL,
    creado_en       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_auditoria PRIMARY KEY (id_auditoria),

    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE INDEX ix_auditoria_usuario ON auditoria (id_usuario, creado_en DESC);


-- ============================================================
-- VISTA DE APOYO PARA EL CATÁLOGO
-- ============================================================
CREATE OR REPLACE VIEW v_propiedad_catalogo AS
SELECT
    p.id_propiedad,
    p.codigo,
    p.matricula_inmobiliaria,
    p.titulo,
    p.operacion,
    p.precio,
    p.administracion,
    p.area_construida,
    p.habitaciones,
    p.banos,
    p.parqueaderos,
    p.estrato,
    p.direccion,
    p.barrio,
    p.creado_en,
    p.id_ciudad,
    p.id_tipo_propiedad,
    p.id_inmobiliaria,
    p.id_usuario,
    t.nombre       AS tipo_nombre,
    t.slug         AS tipo_slug,
    c.nombre       AS ciudad_nombre,
    c.departamento AS ciudad_departamento,
    i.nombre_comercial AS inmobiliaria_nombre,
    (SELECT im.ruta
       FROM imagen_propiedad im
      WHERE im.id_propiedad = p.id_propiedad
      ORDER BY im.es_portada DESC, im.orden ASC
      LIMIT 1)    AS ruta_portada
FROM propiedad p
JOIN tipo_propiedad t ON t.id_tipo_propiedad = p.id_tipo_propiedad
JOIN ciudad         c ON c.id_ciudad = p.id_ciudad
JOIN inmobiliaria   i ON i.id_inmobiliaria = p.id_inmobiliaria
WHERE p.estado = 'PUBLICADA';
