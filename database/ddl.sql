-- ============================================================
--  INMOBILIARIA — DDL
--  Módulos de propiedades (Sprints 1 y 2) y autenticación.
--
--  Este archivo es la estructura oficial. Ninguna tabla se
--  modifica directamente en MySQL: primero se cambia aquí y
--  luego se ajusta el código de los DAO.
-- ============================================================

CREATE DATABASE IF NOT EXISTS inmobiliaria
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE inmobiliaria;


-- ------------------------------------------------------------
-- 1. Ciudad
--    Se normaliza para poder llenar el filtro del buscador
--    desde la base de datos en lugar de dejarlo fijo en la JSP.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ciudad (
    id            INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    nombre        VARCHAR(80)     NOT NULL,
    departamento  VARCHAR(80)     NOT NULL,

    CONSTRAINT pk_ciudad PRIMARY KEY (id),
    CONSTRAINT uq_ciudad_nombre_depto UNIQUE (nombre, departamento)
) ENGINE = InnoDB;


-- ------------------------------------------------------------
-- 2. Tipo de inmueble
--    Tabla aparte (y no un ENUM) porque el catálogo puede
--    crecer sin necesidad de un ALTER TABLE.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tipo_inmueble (
    id      TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nombre  VARCHAR(60)       NOT NULL,
    slug    VARCHAR(60)       NOT NULL,   -- valor usado en la URL del buscador

    CONSTRAINT pk_tipo_inmueble PRIMARY KEY (id),
    CONSTRAINT uq_tipo_inmueble_slug UNIQUE (slug)
) ENGINE = InnoDB;


-- ------------------------------------------------------------
-- 3. Propiedad
--    Entidad central del módulo.
--    `precio` es DECIMAL y no DOUBLE: los valores en pesos no
--    admiten el error de redondeo del punto flotante.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS propiedad (
    id                INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    codigo            VARCHAR(20)       NOT NULL,   -- código público, ej. BUC-0001
    titulo            VARCHAR(150)      NOT NULL,
    descripcion       TEXT              NULL,

    operacion         ENUM('ARRIENDO','VENTA')                        NOT NULL,
    estado            ENUM('BORRADOR','PUBLICADA','RESERVADA','CERRADA')
                      NOT NULL DEFAULT 'BORRADOR',

    tipo_inmueble_id  TINYINT UNSIGNED  NOT NULL,
    ciudad_id         INT UNSIGNED      NOT NULL,
    usuario_id        INT UNSIGNED      NOT NULL,   -- quien publica el inmueble

    precio            DECIMAL(15,2)     NOT NULL,
    administracion    DECIMAL(12,2)     NOT NULL DEFAULT 0,

    area_construida   DECIMAL(8,2)      NULL,
    area_lote         DECIMAL(10,2)     NULL,
    habitaciones      TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    banos             TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    parqueaderos      TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    estrato           TINYINT UNSIGNED  NULL,       -- 1 a 6
    antiguedad_anios  SMALLINT UNSIGNED NULL,

    direccion         VARCHAR(180)      NOT NULL,
    barrio            VARCHAR(100)      NULL,
    latitud           DECIMAL(10,7)     NULL,
    longitud          DECIMAL(10,7)     NULL,

    creado_en         TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en    TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP
                                        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_propiedad PRIMARY KEY (id),
    CONSTRAINT uq_propiedad_codigo UNIQUE (codigo),

    CONSTRAINT fk_propiedad_tipo
        FOREIGN KEY (tipo_inmueble_id) REFERENCES tipo_inmueble (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_propiedad_ciudad
        FOREIGN KEY (ciudad_id) REFERENCES ciudad (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT ck_propiedad_precio  CHECK (precio > 0),
    CONSTRAINT ck_propiedad_estrato CHECK (estrato IS NULL OR estrato BETWEEN 1 AND 6)
) ENGINE = InnoDB;

-- Índices pensados para las consultas del buscador
CREATE INDEX ix_propiedad_busqueda ON propiedad (estado, operacion, ciudad_id, tipo_inmueble_id);
CREATE INDEX ix_propiedad_precio   ON propiedad (precio);
CREATE INDEX ix_propiedad_reciente ON propiedad (creado_en DESC);


-- ------------------------------------------------------------
-- 4. Imágenes de la propiedad          (1 : N)
--    Una propiedad tiene varias fotos; cada foto pertenece a
--    una sola propiedad.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS imagen_propiedad (
    id            INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    propiedad_id  INT UNSIGNED      NOT NULL,
    ruta          VARCHAR(255)      NOT NULL,   -- ruta relativa dentro de webapp
    texto_alt     VARCHAR(150)      NULL,       -- descripción para accesibilidad
    es_portada    BOOLEAN           NOT NULL DEFAULT FALSE,
    orden         TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    creado_en     TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_imagen_propiedad PRIMARY KEY (id),

    CONSTRAINT fk_imagen_propiedad
        FOREIGN KEY (propiedad_id) REFERENCES propiedad (id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE INDEX ix_imagen_propiedad ON imagen_propiedad (propiedad_id, orden);


-- ------------------------------------------------------------
-- 5. Catálogo de características
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS caracteristica (
    id         SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre     VARCHAR(60)       NOT NULL,
    categoria  ENUM('INTERIOR','EXTERIOR','CONJUNTO','SEGURIDAD') NOT NULL,

    CONSTRAINT pk_caracteristica PRIMARY KEY (id),
    CONSTRAINT uq_caracteristica_nombre UNIQUE (nombre)
) ENGINE = InnoDB;


-- ------------------------------------------------------------
-- 6. Propiedad — Característica       (N : M)
--    Una propiedad tiene muchas características y una misma
--    característica (por ejemplo "Piscina") se repite en muchas
--    propiedades. Esa doble multiplicidad obliga a una tabla
--    intermedia con llave primaria compuesta.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS propiedad_caracteristica (
    propiedad_id      INT UNSIGNED      NOT NULL,
    caracteristica_id SMALLINT UNSIGNED NOT NULL,

    CONSTRAINT pk_propiedad_caracteristica
        PRIMARY KEY (propiedad_id, caracteristica_id),

    CONSTRAINT fk_pc_propiedad
        FOREIGN KEY (propiedad_id) REFERENCES propiedad (id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_pc_caracteristica
        FOREIGN KEY (caracteristica_id) REFERENCES caracteristica (id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE INDEX ix_pc_caracteristica ON propiedad_caracteristica (caracteristica_id);


-- ------------------------------------------------------------
-- 7. Favoritos                        (N : M usuario ↔ propiedad)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS favorito (
    usuario_id    INT UNSIGNED NOT NULL,
    propiedad_id  INT UNSIGNED NOT NULL,
    creado_en     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_favorito PRIMARY KEY (usuario_id, propiedad_id),

    CONSTRAINT fk_favorito_propiedad
        FOREIGN KEY (propiedad_id) REFERENCES propiedad (id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;


-- ------------------------------------------------------------
-- 8. Vista de apoyo para el catálogo
--    Evita repetir el mismo JOIN en cada consulta del DAO.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_propiedad_catalogo AS
SELECT
    p.id,
    p.codigo,
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
    t.nombre       AS tipo_nombre,
    t.slug         AS tipo_slug,
    c.nombre       AS ciudad_nombre,
    c.departamento AS ciudad_departamento,
    (SELECT i.ruta
       FROM imagen_propiedad i
      WHERE i.propiedad_id = p.id
      ORDER BY i.es_portada DESC, i.orden ASC
      LIMIT 1)    AS ruta_portada
FROM propiedad p
JOIN tipo_inmueble t ON t.id = p.tipo_inmueble_id
JOIN ciudad        c ON c.id = p.ciudad_id
WHERE p.estado = 'PUBLICADA';


-- ============================================================
-- 9. Módulo de autenticación
--
--    Tablas que dan soporte al login y al registro. Las usan
--    UsuarioDAO, RolDAO y PerfilDAO. Deben crearse ANTES de
--    las llaves foráneas de la sección 10.
-- ============================================================

-- ------------------------------------------------------------
-- 9.1 Usuario
-- ------------------------------------------------------------
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


-- ------------------------------------------------------------
-- 9.2 Rol
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rol (
    id_rol       SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(60)       NOT NULL,
    descripcion  VARCHAR(200)      NULL,

    CONSTRAINT pk_rol PRIMARY KEY (id_rol),
    CONSTRAINT uq_rol_nombre UNIQUE (nombre)
) ENGINE = InnoDB;


-- ------------------------------------------------------------
-- 9.3 Usuario — Rol                 (N : M)
-- ------------------------------------------------------------
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


-- ------------------------------------------------------------
-- 9.4 Perfil                       (1 : 1 con usuario)
-- ------------------------------------------------------------
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
-- 10. Llaves foráneas hacia `usuario`
--
--     Se ejecutan tras crear el módulo de autenticación.
-- ============================================================

ALTER TABLE propiedad
    ADD CONSTRAINT fk_propiedad_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario (id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE favorito
    ADD CONSTRAINT fk_favorito_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario (id_usuario)
    ON DELETE CASCADE ON UPDATE CASCADE;
