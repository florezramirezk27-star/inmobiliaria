# 05. Casos de uso

> **Exportación visual:** `docs/05-casos-de-uso.png`.

## Actores

### Visitante
Usuario que no ha iniciado sesión.

Casos principales:

- Consultar catálogo.
- Buscar y filtrar propiedades.
- Ver detalle de una propiedad.
- Ir al registro o inicio de sesión.

### Cliente
Usuario autenticado con rol `CLIENTE`.

Casos principales:

- Consultar propiedades.
- Marcar y quitar favoritos.
- Crear citas.
- Consultar sus citas.
- Crear solicitudes de compra o arriendo.
- Consultar sus solicitudes.
- Subir y descargar documentos de sus solicitudes.
- Consultar y actualizar su perfil.

### Agente
Usuario autenticado con rol `AGENTE`.

Casos principales:

- Crear y editar propiedades de su propia inmobiliaria.
- Gestionar imágenes y características de sus propiedades.
- Consultar solicitudes de sus propiedades.
- Aprobar o rechazar solicitudes de sus propiedades.
- **Revisar y descargar los documentos de las solicitudes de sus propiedades.**
- Gestionar el estado de citas asociadas a propiedades de su inmobiliaria.

### Administrador
Usuario autenticado con rol `ADMIN`.

Casos principales:

- Consultar usuarios.
- Activar o desactivar usuarios.
- Cambiar roles.
- Consultar y editar perfiles.
- Consultar auditoría.
- Consultar los siete reportes SQL.

## Matriz de casos de uso

| Caso de uso | Visitante | Cliente | Agente | Admin |
|---|:---:|:---:|:---:|:---:|
| Ver catálogo | ✅ | ✅ | ✅ | ✅ |
| Ver detalle de una propiedad `PUBLICADA` | ✅ | ✅ | ✅ | ✅ |
| Ver detalle de una propiedad `BORRADOR`/`CERRADA` | ❌ | ❌ | ✅* | ✅ |
| Gestionar favoritos | ❌ | ✅ | ❌ | ❌ |
| Crear cita | ❌ | ✅ | ❌ | ❌ |
| Consultar mis citas | ❌ | ✅ | ❌ | ❌ |
| Gestionar estado de citas | ❌ | ❌ | ✅* | ❌ |
| Crear solicitud | ❌ | ✅ | ❌ | ❌ |
| Ver mis solicitudes | ❌ | ✅ | ❌ | ❌ |
| Subir/descargar documentos propios | ❌ | ✅ | ❌ | ❌ |
| **Revisar/descargar documentos de las solicitudes de sus propiedades** | ❌ | ❌ | ✅* | ✅ |
| Gestionar propiedades | ❌ | ❌ | ✅* | ✅ |
| Gestionar solicitudes | ❌ | ❌ | ✅* | ❌ |
| Gestión de usuarios | ❌ | ❌ | ❌ | ✅ |
| Gestión de roles | ❌ | ❌ | ❌ | ✅ |
| Auditoría | ❌ | ❌ | ❌ | ✅ |
| Reportes | ❌ | ❌ | ❌ | ✅ |

`*` El acceso del agente está limitado a los recursos de su propia inmobiliaria.
`**` El detalle de `BORRADOR`/`CERRADA` por URL directa se bloquea en
`PropiedadDetalleServlet` para visitantes y clientes; los empleados lo abren desde su
panel. La subida de documentos por el agente responde `405` (solo lectura).

## Flujo de solicitud

```text
CLIENTE
  |
  v
Selecciona propiedad
  |
  v
Crea solicitud (COMPRA / ARRIENDO)
  |
  v
PENDIENTE
  |
  v
AGENTE revisa
  |
  +------------------+
  |                  |
  v                  v
APROBADA          RECHAZADA
  |
  v
CLIENTE adjunta/consulta documentos
```

## Flujo de cita

```text
CLIENTE
  |
  v
Selecciona propiedad
  |
  v
Solicita fecha/hora
  |
  v
SOLICITADA
  |
  v
AGENTE de la inmobiliaria gestiona el estado
```
