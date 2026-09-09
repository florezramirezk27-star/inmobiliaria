# 02. Modelo relacional

## Convención

Las claves primarias se indican como **PK** y las claves foráneas como **FK**.
Las restricciones `UNIQUE`, `CHECK` y las acciones `ON DELETE / ON UPDATE` se encuentran en `database/ddl.sql`.

## Relaciones

```text
USUARIO(
  id_usuario PK,
  correo UNIQUE,
  password_hash,
  estado,
  fecha_creacion,
  fecha_ultimo_acceso
)

ROL(
  id_rol PK,
  nombre UNIQUE,
  descripcion
)

USUARIO_ROL(
  id_usuario PK/FK -> USUARIO,
  id_rol PK/FK -> ROL,
  fecha_asignacion
)

PERFIL(
  id_perfil PK,
  id_usuario FK -> USUARIO UNIQUE,
  nombres,
  apellidos,
  documento UNIQUE,
  telefono,
  direccion,
  foto
)

CIUDAD(
  id_ciudad PK,
  nombre,
  departamento,
  UNIQUE(nombre, departamento)
)

TIPO_PROPIEDAD(
  id_tipo_propiedad PK,
  nombre,
  slug UNIQUE
)

INMOBILIARIA(
  id_inmobiliaria PK,
  nombre_comercial,
  nit UNIQUE,
  telefono,
  id_usuario FK -> USUARIO UNIQUE
)

PROPIEDAD(
  id_propiedad PK,
  codigo UNIQUE,
  matricula_inmobiliaria UNIQUE,
  titulo,
  descripcion,
  operacion,
  estado,
  id_tipo_propiedad FK -> TIPO_PROPIEDAD,
  id_ciudad FK -> CIUDAD,
  id_inmobiliaria FK -> INMOBILIARIA,
  id_usuario FK -> USUARIO,
  precio,
  administracion,
  area_construida,
  area_lote,
  habitaciones,
  banos,
  parqueaderos,
  estrato,
  antiguedad_anios,
  direccion,
  barrio,
  latitud,
  longitud,
  creado_en,
  actualizado_en
)

IMAGEN_PROPIEDAD(
  id_imagen PK,
  id_propiedad FK -> PROPIEDAD,
  ruta,
  texto_alt,
  es_portada,
  orden,
  creado_en
)

CARACTERISTICA(
  id_caracteristica PK,
  nombre UNIQUE,
  categoria
)

PROPIEDAD_CARACTERISTICA(
  id_propiedad PK/FK -> PROPIEDAD,
  id_caracteristica PK/FK -> CARACTERISTICA,
  cantidad
)

FAVORITO(
  id_usuario PK/FK -> USUARIO,
  id_propiedad PK/FK -> PROPIEDAD,
  creado_en
)

CITA(
  id_cita PK,
  id_propiedad FK -> PROPIEDAD,
  id_cliente FK -> USUARIO,
  fecha_hora,
  estado,
  observacion,
  creado_en,
  UNIQUE(id_propiedad, fecha_hora)
)

SOLICITUD(
  id_solicitud PK,
  id_propiedad FK -> PROPIEDAD,
  id_cliente FK -> USUARIO,
  tipo,
  estado,
  comentario,
  creado_en,
  actualizado_en
)

DOCUMENTO_SOLICITUD(
  id_documento PK,
  id_solicitud FK -> SOLICITUD,
  nombre_archivo,
  ruta,
  subido_en
)

AUDITORIA(
  id_auditoria PK,
  id_usuario FK -> USUARIO NULL,
  accion,
  tabla_afectada,
  id_registro,
  detalle,
  creado_en
)
```

## Vista de apoyo

`v_propiedad_catalogo` combina `propiedad`, `tipo_propiedad`, `ciudad`, `inmobiliaria` y la imagen de portada para facilitar el catálogo. La vista filtra propiedades con estado `PUBLICADA`.

## Integridad referencial

Las relaciones utilizan claves foráneas. El DDL define `CASCADE`, `RESTRICT` o `SET NULL` según el caso para controlar qué ocurre ante eliminaciones o actualizaciones de registros relacionados.
