# 06. Scrum y sprints

Documento de evidencia del proceso Scrum del proyecto **Sistema Web de Administración de Inmobiliaria**.
Todos los commits citados existen en el repositorio `florezramirezk27-star/inmobiliaria` (rama `develop`).

## 1. Equipo

| Rol | Integrante | Correo / cuenta |
|---|---|---|
| Product Owner | Profesor de la asignatura | — |
| Scrum Master | andrey ramirea | `andreyra@gmail.com` |
| Development Team | andrey ramirea | `andreyra@gmail.com` |
| Development Team | Juan Miguel Corrales Mendoza | `Juancorrales24` |
| Development Team | florezramirezk27-star (Propietario del repositorio) | `florezramirezk.27@gmail.com` |

## 2. Tablero Scrum

- **Herramienta:** GitHub Projects / Issues del repositorio.
- **Enlace:** https://github.com/florezramirezk27-star/inmobiliaria/projects
- **Columna de evidencia visual:** captura del tablero por sprint en
  `docs/imagenes/tablero-scrum.png` (se reemplaza por una captura real antes de la entrega).

Cada sprint usó las columnas habituales: *Backlog → To do → In Progress → Review → Done*, con
las historias citadas en cada planeación.

---

# Sprint 1 — Cimientos y acceso

**Duración:** mar 02 sep 2026 – sáb 07 sep 2026.

## Sprint Planning

| Campo | Detalle |
|---|---|
| Fecha | 02 sep 2026 |
| Participantes | andrey ramirea, Juan Miguel Corrales Mendoza, florezramirezk27-star (PO: profesor) |
| Duración de la iteración | 6 días |
| Objetivo | Construir la base técnica del proyecto, el modelo de datos y el ciclo de autenticación: poder instalar, registrarse e iniciar sesión. |

### Historias comprometidas

| ID | Historia | Prioridad | Estimación (SP) |
|---|---|---|---|
| HU-01 | Landing page atractiva y buscador rápido | Alta | 5 |
| HU-02 | Registro con correo único validado | Alta | 5 |
| HU-03 | Inicio/cierre de sesión seguro con redirección por rol | Alta | 8 |
| HU-04 | Asignación y revocación de roles (admin) | Alta | 5 |

**Total estimado del sprint:** 23 SP.

## Historias trabajadas

| HU | Tareas realizadas | Evidencia (commit) |
|---|---|---|
| HU-01 | Proyecto Maven WAR; estilos base; navbar, hero, buscador y catálogo Bootstrap | `88cf69c`, `3e1497b`, `c931eb9` |
| HU-02 | Tablas de autenticación (`usuario`, `rol`, `usuario_rol`, `perfil`); login y registro con hash BCrypt; validación de documento duplicado | `98bde4f`, `0ddbd34`, `b2331af`, `8df4d82`, `03c8788`, `d4b956c`, `db8436d` |
| HU-03 | Sesión `HttpSession`, redirección por rol, logout sin JavaScript, `AuthFilter` con rutas públicas/protegidas, dashboards por rol | `1c808cc`, `72a01df`, `37640bb`, `d4b956c` |
| HU-04 | Consulta de usuarios y asignación de roles (base) | `37640bb` |

**Dificultades del sprint**

1. **Incompatibilidad con Tomcat 8.5:** la Servlet API declarada no coincidía con el entorno;
   se alineó el `web.xml` y se agregaron parámetros JDBC para `caching_sha2_password`
   (`267407c`).
2. **Hash BCrypt de ejemplo roto:** el hash que venía en el DML no correspondía a la
   contraseña documentada, bloqueando el login; corregido en el Sprint 3 (`33f47e3`).
3. **Combinar el catálogo (Juan Miguel) con la autenticación (andrey):** se resolvió con
   ramas `feature/*` e integraciones frecuentes a `develop`.

## Sprint Review

| Campo | Detalle |
|---|---|
| Fecha | 07 sep 2026 |
| Participantes | equipo de desarrollo + PO (profesor) |
| Demo | Instalación limpia (DDL + DML), landing con catálogo, registro desde cero, login con redirect por rol, logout |
| Resultado | Logrado: el sistema se instala, registra e inicia sesión con roles ADMIN/AGENTE/CLIENTE |

**Comentarios del PO:** mantener el correo único y el documento único; el login debe ocultar la
diferencia entre "correo no existe" y "contraseña incorrecta" (ya implementado en `AuthService`).

## Sprint Retrospective

- **Qué funcionó**
  - Separación por capas (`model`, `dao`, `service`, `web`) verificada en la integración.
  - Flujo Git `feature → develop` con pull requests (#1–#6) sin conflictos graves.
  - Pantallas validadas en navegador antes del merge.
- **Qué mejorar**
  - Documentar credenciales de prueba para que el equipo y el PO no dependan de probar a ciegas.
  - Tener el tablero con responsables desde el primer día (no solo en el repo).

**Acciones:** subir credenciales al README; habilitar el tablero GitHub Projects con las HUs mapeadas.

---

# Sprint 2 — Núcleo del negocio

**Duración:** lun 08 sep 2026 – sáb 12 sep 2026.

## Sprint Planning

| Campo | Detalle |
|---|---|
| Fecha | 08 sep 2026 |
| Participantes | andrey ramirea, Juan Miguel Corrales Mendoza, florezramirezk27-star |
| Duración de la iteración | 5 días |
| Objetivo | Completar el funcionamiento del negocio: perfiles, propiedades, favoritos, citas, solicitudes con documentos y reportes. |

### Historias comprometidas

| ID | Historia | Prioridad | Estimación (SP) |
|---|---|---|---|
| HU-05 | Perfil del cliente (consultar y editar) | Media | 5 |
| HU-06 | Gestión de propiedades del agente + baja lógica | Alta | 13 |
| HU-07 | Buscador y filtros por ciudad, tipo, precio y características | Alta | 8 |
| HU-08 | Favoritos del cliente | Media | 5 |
| HU-09 | Citas: agendar y gestionar estados | Media | 8 |
| HU-10 | Solicitudes de compra/arriendo y documentos | Media | 8 |
| HU-11 | Gestión de solicitudes del agente | Media | 8 |
| HU-12 | Reportes SQL de agregación | Media | 5 |
| HU-13 | Auditoría administrativa | Baja | 5 |

**Total estimado del sprint:** 65 SP.

## Historias trabajadas

| HU | Tareas realizadas | Evidencia (commit) |
|---|---|---|
| HU-05 | Consulta y edición de perfil | `7cddc53`, `f9361ed` |
| HU-06 | Formulario de creación/edición con validación server-side; ficha de detalle; imágenes y características; baja lógica (`cambiarEstado` + `estado=CERRADA`) | `3604b04`, `157f072`, `b09101e`, `9aff3da`, `f6dc0b2` |
| HU-07 | Catálogo dinámico con filtros (ciudad, tipo, precio) sobre `v_propiedad_catalogo` | `b09101e`, `9aff3da` |
| HU-08 | Marcar/quitar favoritos y página "Mis favoritos"; fix de sesión real en el detalle | `bec9652`, `39516f1` |
| HU-09 | Agendar visitas, confirmar/rechazar/cancelar, página "Mis citas" | `bdbfb14`, `9c4e5b0` |
| HU-10 | Solicitudes de compra/arriendo con documentos; protección de acceso por propietario | `831c98b`, `9e535d2` |
| HU-11 | Gestión de solicitudes del agente (aprobación/rechazo) con validación de pertenencia a la inmobiliaria | `831c98b`, `35cea69` |
| HU-12 | Reporte de propiedades por ciudad y estado con agregación | `35cea69` |
| HU-13 | Registro y consulta de auditoría | `f6dc0b2` |

**Dificultades del sprint**

1. **Favoritos con sesión real:** el detalle público marcaba favoritos usando un id mal
   resuelto; fix dedicado `39516f1` para leer `usuarioId` de la sesión.
2. **Acceso a documentos:** un documento podía descargarse desde otra solicitud;
   `9e535d2` restringe la descarga al propietario.
3. **Pertenencia de recursos:** definir reglas claras "el agente solo gestiona las
   solicitudes de su inmobiliaria" requirió consultas con `usuario → inmobiliaria → propiedad`.
4. **Rediseño de la interfaz:** el refresco visual demandó más tiempo del estimado al
   integrarse con todo el flujo (más tarde `e6a9bfb`).

## Sprint Review

| Campo | Detalle |
|---|---|
| Fecha | 12 sep 2026 |
| Participantes | equipo de desarrollo + PO |
| Demo | Perfil, alta/edición/baja lógica de propiedades, catálogo con filtros, favoritos, cita con cruce de horarios, solicitud con documentos, aprobación del agente, reporte y auditoría |
| Resultado | Logrado con alcance parcial: el flujo completo opera, pero quedan pendientes por endurecer la seguridad y cerrar la documentación |

**Comentarios del PO:** el agente debe poder **ver los documentos de las solicitudes de sus
propiedades** (HU-11 incompleta); registrar los reportes necesarios.

## Sprint Retrospective

- **Qué funcionó**
  - Reutilización de DAOs existentes para evitar duplicidad.
  - Validaciones server-side en formularios y pertenencia de recursos.
  - Merge frecuente a `develop` evitó integración dolorosa al final.
- **Qué mejorar**
  - No mezclar "cambios funcionales" con "cambios de diseño" en el mismo sprint; separarlos.
  - Deduplicar el criterio *"no disponible"* del catálogo (los estados `BORRADOR`/`CERRADA`).
  - Terminar la revisión de documentos del agente (HU-11).

**Acciones:** completar HU-11 (documentos del agente); endurecer `AuthFilter` y estado de
solicitudes; cerrar el logger de auditoría faltante.

---

# Sprint 3 — Endurecimiento y cierre

**Duración:** dom 13 sep 2026 – jue 18 sep 2026 *(en curso; congelación de código el jueves
temprano y QA posterior)*.

## Sprint Planning

| Campo | Detalle |
|---|---|
| Fecha | 13 sep 2026 |
| Participantes | andrey ramirea, Juan Miguel Corrales Mendoza, florezramirezk27-star |
| Duración de la iteración | 6 días (cierre) |
| Objetivo | Endurecer la seguridad, cerrar las historias pendientes, completar reportes y documentación; **no agregar funcionalidad nueva después del jueves**. |

### Historias comprometidas

| ID | Historia | Prioridad | Estimación (SP) |
|---|---|---|---|
| HU-03 | Rutas privadas protegidas por el `AuthFilter` (favoritos, citas) | Alta | 5 |
| HU-06 | Impedir ver propiedades `BORRADOR`/`CERRADA` por URL directa | Alta | 5 |
| HU-07 | Filtro por características en el catálogo (sin romper búsqueda) | Media | 5 |
| HU-11 | **Revisión de documentos por el agente** en solicitudes de sus propiedades | Media | 8 |
| HU-12 | Reportes: citas por estado y solicitudes por inmobiliaria (sin eliminar los 5 obligatorios) | Media | 8 |
| HU-02 | Validaciones de servidor: documento, correo y teléfono | Media | 5 |
| Documentación | SCRUM completo (planning/review/retro), diagramas exportados a PNG/PDF | Alta | 8 |
| QA | Checklist de ADMIN, AGENTE, CLIENTE, catálogo, propiedad, favoritos, cita, solicitud, documentos, reportes, logout y URLs prohibidas | Alta | 5 |

**Total estimado del sprint:** 49 SP.

## Historias trabajadas (registro de avance al 15 sep 2026)

| HU | Tareas realizadas | Evidencia (commit) |
|---|---|---|
| Seguridad | Hashes BCrypt de prueba correctos y verificables (`Clave123*` / `admin123`); documentado en README | `33f47e3` |
| HU-06 | CRUD admin de ciudades/tipos/características y baja lógica de propiedades | `f6dc0b2` |
| HU-03 | Ampliación del `AuthFilter`: reglas de rol por ruta (`/propiedades/favorito`, `/favoritos`, `/citas` = CLIENTE; `/propiedades/citas/estado` = AGENTE; `/propiedades/citas` = solo sesión) | `0bf63b7` |
| HU-06 | Bloqueo de `BORRADOR`/`CERRADA` en el detalle público por URL directa | `0bf63b7` |
| HU-07 | Filtro por características en el catálogo (HAVING sobre `propiedad_caracteristica`, sin romper el buscador) | `0bf63b7` |
| HU-11 | Acceso del agente a los documentos de sus solicitudes (`/inmobiliaria/solicitudes/documentos`, solo lectura) | `0bf63b7` |
| HU-12 | Reportes 6 (citas por estado) y 7 (solicitudes por inmobiliaria), sin eliminar los 5 obligatorios | `0bf63b7` |
| HU-02 | Validaciones de servidor: documento obligatorio, formato de correo, documento y teléfono en `RegistroServlet` | `0bf63b7` |
| UI | Rediseño completo del frontend + imágenes demo | `e6a9bfb`, `5713076`, `4297971` |
| Documentación | Columna `descripcion` documentada en diccionario y modelo | `f75b313` |
| SCRUM/docs | Planning/Review/Retro de los 3 sprints; diagramas MER, modelo relacional y casos de uso exportados a PNG; checklist QA y plan de congelación | `0bf63b7` |

**Dificultades previstas / en curso**

1. **Coordinación de sesiones:** los miembros trabajan en equipos distintos; el flujo
   `feature → develop` con rebase (`33f47e3`) evitó colisiones.
2. **Exportación de diagramas:** convertir los diagramas Mermaid/ASCII del `.md` a PNG/PDF requiere
   una herramienta externa (documentado con instrucciones abajo).
3. **No romper el buscador al filtrar por características:** se resolvió con una subconsulta
   `IN (SELECT id_propiedad ... GROUP BY id_propiedad HAVING COUNT(DISTINCT id_caracteristica) = N)`
   sobre `propiedad_caracteristica`, en lugar de tocar la consulta base de `v_propiedad_catalogo`.

## Sprint Review

| Campo | Detalle |
|---|---|
| Fecha | jue 18 sep 2026 (programada) |
| Participantes | equipo de desarrollo + PO |
| Demo | QA completo del checklist; recorrido ADMIN, AGENTE, CLIENTE y rutas prohibidas |
| Resultado | Pendiente de ejecutarse al cierre del sprint |

## Sprint Retrospective

*Se ejecuta el jueves 18 sep 2026, después de la Review, una vez congelado el código.
Pendiente de llenado final.*

---

## 3. Evidencias de Git por sprint (rama `develop`)

Repositorio: https://github.com/florezramirezk27-star/inmobiliaria

### Sprint 1 (02–07 sep 2026)

| Commit | Autor | Mensaje |
|---|---|---|
| `88cf69c` | andrey ramirea | Crear proyecto Java Web base |
| `0ddbd34` | andrey ramirea | Autenticación con BCrypt |
| `3e1497b` | Juan Miguel C. | Estilos base |
| `c931eb9` | Juan Miguel C. | Landing, navbar, hero, buscador y catálogo |
| `98bde4f` | Juan Miguel C. | DDL y DML del módulo de propiedades |
| `b2331af` | andrey ramirea | DAOs de usuario, rol y perfil |
| `03c8788` | andrey ramirea | Tablas usuario, rol, usuario_rol, perfil |
| `267407c` | Juan Miguel C. | Alinear Servlet API y web.xml a Tomcat 8.5 + JDBC caching_sha2_password |
| `3604b04` | Juan Miguel C. | Formulario de propiedades con validación server-side |
| `d4b956c` | andrey ramirea | Login, registro y cierre de sesión |
| `157f072` | Juan Miguel C. | Ficha de detalle, imágenes/características, UTF-8 |
| `1c808cc` | andrey ramirea | Dashboards protegidos por rol |
| `37640bb` | andrey ramirea | Merge feature/auth-security |

### Sprint 2 (08–12 sep 2026)

| Commit | Autor | Mensaje |
|---|---|---|
| `9aff3da` | andrey ramirea | Landing dinámica, favoritos, logout sin JS, rediseño paneles admin |
| `f9361ed` | andrey ramirea | Mejora de dashboards |
| `b75d0f6` | andrey ramirea | Documentación técnica |
| `f892e15` | andrey ramirea | Pruebas unitarias de enums |
| `9c4e5b0` | andrey ramirea | Asegurar citas y solicitudes |
| `35cea69` | andrey ramirea | Reporte dinámico de características de propiedades |
| `bec9652` | Juan Miguel C. | Favoritos: marcar/quitar y "Mis favoritos" |
| `bdbfb14` | Juan Miguel C. | Citas: agendar, confirmar/rechazar, "Mis citas" |
| `831c98b` | andrey ramirea | Gestión de solicitudes para agentes |
| `9e535d2` | andrey ramirea | Protección de documentos por propietario |
| `db8436d` | andrey ramirea | Validar documento duplicado al registrar |

### Sprint 3 (13–18 sep 2026, en curso)

| Commit | Autor | Mensaje |
|---|---|---|
| `f6dc0b2` | andrey ramirea | CRUD admin de catálogos, baja lógica de propiedades y docs Scrum |
| `f75b313` | andrey ramirea | Documentar columna descripcion (diccionario y modelo) |
| `e6a9bfb` | Juan Miguel C. | Rediseño completo del frontend |
| `5713076` | Juan Miguel C. | Merge feature/imagenes-demo |
| `4297971` | Juan Miguel C. | Merge develop (coordinación entre sesiones) |
| `33f47e3` | andrey ramirea | Corregir hashes BCrypt de prueba y documentar |
| `0bf63b7` | andrey ramirea | Filtro por características, bloqueo de no publicadas, reportes 6-7, validaciones de servidor y docs de cierre |

## 4. Capturas (evidencia visual)

- **Tablero:** `docs/imagenes/tablero-scrum.png` *(pendiente de colocar captura real)*
- **GitHub:** historial de commits y PRs del repositorio
  https://github.com/florezramirezk27-star/inmobiliaria (capturas de `Insights → Network` y
  lista de `Pull requests` también pueden adjuntarse en `docs/imagenes/`).