# 08. Pruebas y evidencias

## 1. Pruebas de compilación

Comandos usados durante la integración:

```bash
mvn clean package
```

Resultado final validado:

```text
BUILD SUCCESS
```

## 2. Pruebas unitarias JUnit

Se ejecutaron tres clases de prueba:

- `EstadoCitaTest` — 2 pruebas.
- `EstadoSolicitudTest` — 2 pruebas.
- `TipoSolicitudTest` — 1 prueba.

Resultado validado:

```text
Tests run: 5, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```

## 3. Pruebas funcionales

| Prueba | Resultado |
|---|:---:|
| Registro de usuario (con validaciones) | ✅ |
| Login | ✅ |
| Logout | ✅ |
| Panel de cliente | ✅ |
| Catálogo y detalle | ✅ |
| Filtro por características en el catálogo | ✅ |
| Bloqueo de BORRADOR/CERRADA en detalle público | ✅ |
| Crear/editar propiedad como agente | ✅ |
| Bloqueo de edición de propiedad de otra inmobiliaria | ✅ |
| Favoritos | ✅ |
| Crear citas como cliente | ✅ |
| Gestión de citas como agente | ✅ |
| Solicitudes del cliente | ✅ |
| Solicitudes del agente | ✅ |
| Revisión de documentos por el agente (inmobiliaria) | ✅ |
| Subida de documentos | ✅ |
| Descarga de documentos | ✅ |
| Gestión de usuarios como admin | ✅ |
| Activar/desactivar usuario | ✅ |
| Cambio de rol | ✅ |
| Edición de perfil por admin | ✅ |
| Auditoría | ✅ |
| Siete reportes SQL | ✅ |

## 4. Pruebas de autorización

### Sin sesión

Acceso directo a rutas protegidas debe redirigir a login.

```text
/admin/usuarios
/cliente/solicitudes
/inmobiliaria/solicitudes
```

### Cliente -> Admin

El cliente no puede acceder a:

```text
/admin/dashboard
/admin/usuarios
/admin/auditoria
/admin/reportes
```

Resultado validado: `403 Forbidden`.

### Agente -> Admin

El agente no puede administrar usuarios, auditoría ni reportes.

Resultado validado: `403 Forbidden`.

### Cliente -> citas

El cliente puede crear y consultar sus citas, pero no cambiar su estado.

Resultado validado: operación de cambio bloqueada.

### Admin -> citas

El administrador puede consultar la pantalla, pero no crear ni gestionar el estado de una cita.

Resultado validado: operación bloqueada.

### Agente -> citas

El agente solo puede gestionar citas de propiedades pertenecientes a su inmobiliaria.

Resultado validado: recurso ajeno bloqueado con `403`.

### Cliente A -> datos de Cliente B

Se verificó que un cliente no puede consultar documentos asociados a una solicitud de otro cliente manipulando el identificador.

Resultado esperado: `403 Forbidden`.

### Visitante -> BORRADOR / CERRADA

Acceso directo por URL a una propiedad en estado BORRADOR o CERRADA:

```text
/propiedades/detalle?id=X (con X borrador o cerrada)
```

Resultado validado: mensaje "Esta propiedad no está disponible públicamente" para visitante y cliente; el agente/admin sí la abre desde su panel.

## 6. Plan de congelación de código

Fecha de congelación técnica: **miércoles 16 de septiembre de 2026** (cierre del Sprint 3). La entrega académica está programada para el **jueves 17 de septiembre de 2026 a las 14:00**.

Antes de esa fecha se deben cumplir los siguientes pasos:

1. Ejecutar `mvn clean package` y dejar el `BUILD SUCCESS` como evidencia.
2. Ejecutar `mvn test` y confirmar las 5 pruebas JUnit sin fallos.
3. Respaldar la base de datos (archivo SQL exportado desde MySQL).
4. Bloquear cambios: no se aceptan nuevas historias; solo correcciones de errores
   que se prueben y se registren en esta acta.
5. Ejecutar el checklist de QA completo (sección 7) y marcar las casillas.
6. Coordinar con el PO (docente) la revisión final y la sustentación.

## 7. Checklist de QA para la sustentación

### Compilación y pruebas

- [x] `mvn clean package` termina en `BUILD SUCCESS`.
- [x] `mvn test` ejecuta las 5 pruebas JUnit sin fallos (`Tests run: 5, Failures: 0, Errors: 0`).

### Roles y login

- [x] Login con `admin@inmobiliaria.com` / `admin123` entra al panel de admin.
- [x] Login de agente (`agente.centro@inmobiliaria.com` / `Clave123*`) entra al panel de inmobiliaria.
- [x] Login de cliente (`maria.rojas@correo.com` / `Clave123*`) entra al panel de cliente.
- [x] Logout cierra la sesión y evita volver atrás a un panel.
- [x] Cuenta inactiva no puede iniciar sesión.
- [x] Registro rechaza correo con formato inválido, documento no numérico, teléfono inválido y documento vacío.

### Catálogo y detalle

- [x] El buscador por operación, ciudad, tipo y precio funciona.
- [x] El filtro por características exige que se cumplan todas las marcadas.
- [x] El filtro por características combinado con el buscador no rompe la búsqueda.
- [x] Un visitante no abre propiedades en BORRADOR o CERRADA por URL.
- [x] Cliente y visitante ven el detalle de propiedades PUBLICADA.
- [x] Agente y admin abren borradores/cerradas desde su panel.

### Favoritos y citas

- [x] Solo el cliente puede marcar/quitar favoritos.
- [x] El cliente agenda cita; el agente la gestiona; el admin solo la consulta.
- [x] No se puede agendar cita en el pasado.
- [x] El agente no gestiona citas de propiedades de otra inmobiliaria.

### Solicitudes y documentos

- [x] El cliente crea una solicitud con su tipo correspondiente.
- [x] El agente ve las solicitudes de sus propiedades (no las ajenas).
- [x] El agente abre y descarga documentos de sus solicitudes y puede aprobarlos o rechazarlos individualmente; no puede subir archivos.
- [x] El cliente sube y descarga documentos de sus solicitudes.
- [x] Un cliente no ve documentos de una solicitud de otro cliente (`403`).

### Administración y reportes

- [x] El admin gestiona usuarios, roles, auditoría y los 7 reportes.
- [x] Los reportes 6 (citas por estado) y 7 (solicitudes por inmobiliaria) muestran datos.
- [x] Las rutas protegidas sin sesión redirigen a login.

## 8. Casos negativos relevantes

- IDs no numéricos en URLs o formularios.
- Fechas de cita anteriores al momento actual.
- Estados de cita inválidos.
- Archivos con extensión o MIME no permitidos.
- Usuario sin inmobiliaria asignada.
- Intento de modificar una propiedad ajena.
- Intento de modificar una cita ajena.
- Correo, documento y teléfono inválidos en el registro.

## 9. Evidencias para la sustentación

Se recomienda tomar capturas de:

1. Login y dashboard según rol.
2. Catálogo, buscador y filtro por características.
3. Detalle público y bloqueo de una propiedad BORRADOR/CERRADA por URL.
4. Creación de propiedad por agente.
5. Bloqueo `403` al intentar modificar propiedad ajena.
6. Cliente creando una cita.
7. Agente gestionando una cita.
8. Creación de solicitud.
9. Agente revisando/descargando documentos de sus solicitudes.
10. Subida y descarga de documento por el cliente.
11. Administración de usuarios y roles.
12. Auditoría con registros.
13. Los siete reportes (incluidos citas por estado y solicitudes por inmobiliaria).
14. Consola Maven con `BUILD SUCCESS` y las 5 pruebas JUnit sin fallos.
15. Captura del tablero Scrum con las historias y su estado final.


## 9. Regresión final integral - 16 de septiembre de 2026

Se ejecutó una regresión final sobre un WAR generado desde cero y desplegado limpiamente en Tomcat 8.5.

### Resultado de compilación

- `mvn clean package`: **BUILD SUCCESS**.
- Pruebas JUnit: **5 ejecutadas, 0 fallos, 0 errores, 0 omitidas**.

### Validaciones runtime completadas

- ✅ Landing, catálogo, detalle e imágenes públicas.
- ✅ Visitante redirigido al login al intentar acceder a rutas privadas.
- ✅ Login, dashboard, perfil, favoritos, citas, solicitudes y documentos del CLIENTE.
- ✅ Un cliente no puede consultar documentos de solicitudes ajenas (`403`).
- ✅ Login y módulos de los agentes Centro y Norte.
- ✅ Un agente puede editar propiedades propias y no puede editar propiedades de otra inmobiliaria (`403`).
- ✅ Un agente gestiona citas únicamente de propiedades de su inmobiliaria.
- ✅ Un agente revisa documentos únicamente de solicitudes pertenecientes a su inmobiliaria.
- ✅ El agente propietario puede cambiar un documento de `PENDIENTE` a `APROBADO` o `RECHAZADO` y el estado queda persistido en MySQL.
- ✅ Un agente de otra inmobiliaria recibe `403` al intentar modificar el estado del documento y el registro permanece sin cambios.
- ✅ Reportes del agente protegidos por rol y filtrados por inmobiliaria.
- ✅ Reportes de Centro y Norte contrastados contra consultas directas en MySQL.
- ✅ Login y módulos administrativos verificados.
- ✅ Cuenta inactiva rechazada durante el login.
- ✅ Documentos privados inaccesibles mediante URL pública directa.
- ✅ Logout invalida la sesión y obliga a autenticarse nuevamente.
- ✅ No quedaron propiedades, solicitudes ni documentos temporales de las pruebas.
- ✅ Los documentos privados permanecen fuera del webroot.
- ✅ La rama `develop` quedó sincronizada con `origin/develop`.
- ✅ Repositorio limpio al terminar la regresión.

**Resultado final:** regresión integral completada sin fallas funcionales detectadas.
