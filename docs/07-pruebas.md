# 07. Pruebas y evidencias

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
| Registro de usuario | ✅ |
| Login | ✅ |
| Logout | ✅ |
| Panel de cliente | ✅ |
| Catálogo y detalle | ✅ |
| Crear/editar propiedad como agente | ✅ |
| Bloqueo de edición de propiedad de otra inmobiliaria | ✅ |
| Favoritos | ✅ |
| Crear citas como cliente | ✅ |
| Gestión de citas como agente | ✅ |
| Solicitudes del cliente | ✅ |
| Solicitudes del agente | ✅ |
| Subida de documentos | ✅ |
| Descarga de documentos | ✅ |
| Gestión de usuarios como admin | ✅ |
| Activar/desactivar usuario | ✅ |
| Cambio de rol | ✅ |
| Edición de perfil por admin | ✅ |
| Auditoría | ✅ |
| Cinco reportes SQL | ✅ |

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

## 5. Casos negativos relevantes

- IDs no numéricos en URLs o formularios.
- Fechas de cita anteriores al momento actual.
- Estados de cita inválidos.
- Archivos con extensión o MIME no permitidos.
- Usuario sin inmobiliaria asignada.
- Intento de modificar una propiedad ajena.
- Intento de modificar una cita ajena.

## 6. Evidencias para la sustentación

Se recomienda tomar capturas de:

1. Login y dashboard según rol.
2. Catálogo y detalle.
3. Creación de propiedad por agente.
4. Bloqueo `403` al intentar modificar propiedad ajena.
5. Cliente creando una cita.
6. Agente gestionando una cita.
7. Creación de solicitud.
8. Subida y descarga de documento.
9. Administración de usuarios y roles.
10. Auditoría con registros.
11. Los cinco reportes.
12. Consola Maven con `BUILD SUCCESS` y las 5 pruebas JUnit sin fallos.
