# 03. Normalización hasta Tercera Forma Normal (3FN)

## Objetivo

El esquema separa entidades, catálogos y relaciones para evitar duplicidad de datos y dependencias innecesarias. La estructura está diseñada para que cada atributo no clave dependa de la clave de su propia relación.

## Primera Forma Normal (1FN)

Se cumplen las condiciones básicas de 1FN:

- Cada tabla tiene una clave primaria.
- Los atributos representan valores individuales y no listas almacenadas dentro de una sola columna.
- Los grupos repetitivos se separan en tablas independientes.

Ejemplos:

- Las imágenes se almacenan en `imagen_propiedad`, no como `imagen1`, `imagen2`, `imagen3` dentro de `propiedad`.
- Los documentos se almacenan en `documento_solicitud`, permitiendo varios documentos por solicitud.
- Los roles de un usuario se separan en `usuario_rol`.

## Segunda Forma Normal (2FN)

Las relaciones con clave compuesta se utilizan para asociaciones N:M y sus atributos dependen de la combinación completa de la clave.

### `usuario_rol`

Clave primaria: `(id_usuario, id_rol)`.

`fecha_asignacion` describe la asignación de ese rol a ese usuario, por lo que depende de la combinación de ambas claves.

### `propiedad_caracteristica`

Clave primaria: `(id_propiedad, id_caracteristica)`.

`cantidad` pertenece a la asociación concreta entre una propiedad y una característica.

### `favorito`

Clave primaria: `(id_usuario, id_propiedad)`.

`creado_en` describe el momento en que ese usuario marcó esa propiedad como favorita.

## Tercera Forma Normal (3FN)

La estructura evita almacenar en una misma relación datos que dependen de otras entidades.

### Ejemplo 1: propiedad

En `propiedad` se guardan las claves:

- `id_ciudad`
- `id_tipo_propiedad`
- `id_inmobiliaria`
- `id_usuario`

No se repiten allí los nombres de ciudad, tipo, inmobiliaria o correo del usuario.

Por eso los datos descriptivos permanecen en sus propias tablas:

```text
PROPIEDAD -> CIUDAD
PROPIEDAD -> TIPO_PROPIEDAD
PROPIEDAD -> INMOBILIARIA
PROPIEDAD -> USUARIO
```

### Ejemplo 2: solicitud y documentos

La solicitud conserva la información de la operación y referencia al cliente y a la propiedad. Los datos de cada archivo se mantienen en `documento_solicitud`, evitando repetirlos dentro de `solicitud`.

### Ejemplo 3: autenticación y perfil

Los datos de autenticación se encuentran en `usuario`, mientras que los datos personales están en `perfil`. Esto evita mezclar credenciales, roles y atributos personales en una sola relación.

## Conclusión

El modelo está estructurado para cumplir el objetivo académico de 3FN: separar catálogos y entidades, resolver relaciones N:M mediante tablas intermedias y mantener las dependencias de los atributos respecto de las claves de sus propias relaciones.
