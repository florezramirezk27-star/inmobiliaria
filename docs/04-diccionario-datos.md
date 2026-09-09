# 04. Diccionario de datos

Fuente principal: `database/ddl.sql`.

## 1. usuario

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_usuario | INT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador del usuario |
| correo | VARCHAR(180) | No | UNIQUE | Correo para autenticación |
| password_hash | VARCHAR(255) | No | — | Hash BCrypt de la contraseña |
| estado | ENUM | No | DEFAULT ACTIVO | Estado de la cuenta |
| fecha_creacion | TIMESTAMP | No | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |
| fecha_ultimo_acceso | TIMESTAMP | Sí | — | Último inicio de sesión |

## 2. rol

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_rol | SMALLINT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador del rol |
| nombre | VARCHAR(60) | No | UNIQUE | Nombre del rol |
| descripcion | VARCHAR(200) | Sí | — | Descripción funcional |

## 3. usuario_rol

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_usuario | INT UNSIGNED | No | PK/FK | Usuario relacionado |
| id_rol | SMALLINT UNSIGNED | No | PK/FK | Rol relacionado |
| fecha_asignacion | TIMESTAMP | No | DEFAULT CURRENT_TIMESTAMP | Fecha de asignación |

## 4. perfil

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_perfil | INT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador del perfil |
| id_usuario | INT UNSIGNED | No | FK, UNIQUE | Usuario propietario |
| nombres | VARCHAR(80) | No | — | Nombres |
| apellidos | VARCHAR(80) | No | — | Apellidos |
| documento | VARCHAR(30) | No | UNIQUE | Documento de identidad |
| telefono | VARCHAR(30) | Sí | — | Teléfono |
| direccion | VARCHAR(180) | Sí | — | Dirección |
| foto | VARCHAR(255) | Sí | — | Ruta de fotografía |

## 5. ciudad

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_ciudad | INT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador de ciudad |
| nombre | VARCHAR(80) | No | UNIQUE junto con departamento | Nombre de ciudad |
| departamento | VARCHAR(80) | No | UNIQUE junto con nombre | Departamento |

## 6. tipo_propiedad

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_tipo_propiedad | TINYINT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador de tipo |
| nombre | VARCHAR(60) | No | — | Nombre del tipo |
| slug | VARCHAR(60) | No | UNIQUE | Identificador amigable |

## 7. inmobiliaria

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_inmobiliaria | INT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador de inmobiliaria |
| nombre_comercial | VARCHAR(120) | No | — | Nombre comercial |
| nit | VARCHAR(20) | No | UNIQUE | NIT |
| telefono | VARCHAR(20) | Sí | — | Teléfono |
| id_usuario | INT UNSIGNED | No | FK, UNIQUE | Agente responsable |

## 8. propiedad

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_propiedad | INT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador |
| codigo | VARCHAR(20) | No | UNIQUE | Código comercial |
| matricula_inmobiliaria | VARCHAR(30) | No | UNIQUE | Matrícula inmobiliaria |
| titulo | VARCHAR(150) | No | — | Título de publicación |
| descripcion | TEXT | Sí | — | Descripción |
| operacion | ENUM | No | ARRIENDO / VENTA | Tipo de operación |
| estado | ENUM | No | Borrador/publicada/etc. | Estado de publicación |
| id_tipo_propiedad | TINYINT UNSIGNED | No | FK | Tipo de propiedad |
| id_ciudad | INT UNSIGNED | No | FK | Ciudad |
| id_inmobiliaria | INT UNSIGNED | No | FK | Inmobiliaria que publica |
| id_usuario | INT UNSIGNED | No | FK | Usuario que registra |
| precio | DECIMAL(15,2) | No | CHECK > 0 | Precio |
| administracion | DECIMAL(12,2) | No | DEFAULT 0 | Valor de administración |
| area_construida | DECIMAL(8,2) | Sí | — | Área construida |
| area_lote | DECIMAL(10,2) | Sí | — | Área de lote |
| habitaciones | TINYINT UNSIGNED | No | DEFAULT 0 | Número de habitaciones |
| banos | TINYINT UNSIGNED | No | DEFAULT 0 | Número de baños |
| parqueaderos | TINYINT UNSIGNED | No | DEFAULT 0 | Número de parqueaderos |
| estrato | TINYINT UNSIGNED | Sí | CHECK 1..6 | Estrato |
| antiguedad_anios | SMALLINT UNSIGNED | Sí | — | Antigüedad en años |
| direccion | VARCHAR(180) | No | — | Dirección |
| barrio | VARCHAR(100) | Sí | — | Barrio |
| latitud | DECIMAL(10,7) | Sí | — | Latitud |
| longitud | DECIMAL(10,7) | Sí | — | Longitud |
| creado_en | TIMESTAMP | No | DEFAULT CURRENT_TIMESTAMP | Creación |
| actualizado_en | TIMESTAMP | No | AUTO UPDATE | Última actualización |

## 9. imagen_propiedad

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_imagen | INT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador |
| id_propiedad | INT UNSIGNED | No | FK | Propiedad relacionada |
| ruta | VARCHAR(255) | No | — | Ruta del archivo |
| texto_alt | VARCHAR(150) | Sí | — | Texto alternativo |
| es_portada | BOOLEAN | No | DEFAULT FALSE | Indica portada |
| orden | TINYINT UNSIGNED | No | DEFAULT 0 | Orden de la imagen |
| creado_en | TIMESTAMP | No | DEFAULT CURRENT_TIMESTAMP | Fecha de carga |

## 10. caracteristica

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_caracteristica | SMALLINT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador |
| nombre | VARCHAR(60) | No | UNIQUE | Nombre de característica |
| categoria | ENUM | No | INTERIOR/EXTERIOR/CONJUNTO/SEGURIDAD | Categoría |

## 11. propiedad_caracteristica

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_propiedad | INT UNSIGNED | No | PK/FK | Propiedad |
| id_caracteristica | SMALLINT UNSIGNED | No | PK/FK | Característica |
| cantidad | TINYINT UNSIGNED | No | DEFAULT 1 | Cantidad de esa característica |

## 12. favorito

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_usuario | INT UNSIGNED | No | PK/FK | Usuario |
| id_propiedad | INT UNSIGNED | No | PK/FK | Propiedad favorita |
| creado_en | TIMESTAMP | No | DEFAULT CURRENT_TIMESTAMP | Fecha de marcado |

## 13. cita

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_cita | INT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador |
| id_propiedad | INT UNSIGNED | No | FK | Propiedad visitada |
| id_cliente | INT UNSIGNED | No | FK | Cliente que agenda |
| fecha_hora | DATETIME | No | UNIQUE junto con id_propiedad | Fecha y hora |
| estado | ENUM | No | Solicitud/confirmación/etc. | Estado de la cita |
| observacion | VARCHAR(255) | Sí | — | Observación |
| creado_en | TIMESTAMP | No | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

## 14. solicitud

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_solicitud | INT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador |
| id_propiedad | INT UNSIGNED | No | FK | Propiedad solicitada |
| id_cliente | INT UNSIGNED | No | FK | Cliente solicitante |
| tipo | ENUM | No | COMPRA / ARRIENDO | Tipo de solicitud |
| estado | ENUM | No | PENDIENTE/EN_REVISION/APROBADA/RECHAZADA | Estado |
| comentario | VARCHAR(255) | Sí | — | Comentario del cliente |
| creado_en | TIMESTAMP | No | DEFAULT CURRENT_TIMESTAMP | Creación |
| actualizado_en | TIMESTAMP | No | AUTO UPDATE | Última actualización |

## 15. documento_solicitud

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_documento | INT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador |
| id_solicitud | INT UNSIGNED | No | FK | Solicitud asociada |
| nombre_archivo | VARCHAR(150) | No | — | Nombre del archivo |
| ruta | VARCHAR(255) | No | — | Ruta de almacenamiento |
| subido_en | TIMESTAMP | No | DEFAULT CURRENT_TIMESTAMP | Fecha de carga |

## 16. auditoria

| Campo | Tipo | Null | Clave / restricción | Descripción |
|---|---|---|---|---|
| id_auditoria | BIGINT UNSIGNED | No | PK, AUTO_INCREMENT | Identificador |
| id_usuario | INT UNSIGNED | Sí | FK | Usuario que ejecutó la acción |
| accion | VARCHAR(60) | No | — | Acción registrada |
| tabla_afectada | VARCHAR(60) | Sí | — | Tabla relacionada |
| id_registro | INT UNSIGNED | Sí | — | Registro afectado |
| detalle | VARCHAR(255) | Sí | — | Información adicional |
| creado_en | TIMESTAMP | No | DEFAULT CURRENT_TIMESTAMP | Fecha y hora |
