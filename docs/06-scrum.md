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
- **Evidencia visual:** captura final del tablero Scrum disponible en
  `docs/imagenes/tablero-scrum.png`.

Cada sprint usó las columnas habituales: *Backlog → To do → In Progress → Review → Done*, con
las historias citadas en cada planeación.

**Criterio de calendario:** el equipo inició la planificación y el trabajo desde finales de agosto de 2026. Para la evidencia académica se documentan tres iteraciones consecutivas de 7 días: Sprint 1 del 27 de agosto al 2 de septiembre, Sprint 2 del 3 al 9 de septiembre y Sprint 3 del 10 al 16 de septiembre. La actividad visible en Git comienza el 2 de septiembre y se utiliza como evidencia de implementación, no como fecha de inicio de toda la planificación.

---

# Sprint 1 — Cimientos y acceso

**Duración:** jue 27 ago 2026 – mié 02 sep 2026 (7 días).

## Sprint Planning

| Campo | Detalle |
|---|---|
| Fecha | 27 ago 2026 |
| Participantes | andrey ramirea, Juan Miguel Corrales Mendoza, florezramirezk27-star (PO: profesor) |
| Duración de la iteración | 7 días (27 ago – 02 sep) |
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
| Fecha | 02 sep 2026 |
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

**Duración:** jue 03 sep 2026 – mié 09 sep 2026 (7 días).

## Sprint Planning

| Campo | Detalle |
|---|---|
| Fecha | 03 sep 2026 |
| Participantes | andrey ramirea, Juan Miguel Corrales Mendoza, florezramirezk27-star |
| Duración de la iteración | 7 días (03 – 09 sep) |
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
| Fecha | 09 sep 2026 |
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

**Duración:** jue 10 sep 2026 – mié 16 sep 2026 (7 días).

## Sprint Planning

| Campo | Detalle |
|---|---|
| Fecha | 10 sep 2026 |
| Participantes | andrey ramirea, Juan Miguel Corrales Mendoza, florezramirezk27-star |
| Duración de la iteración | 7 días (10 – 16 sep) |
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
| HU-11 cierre final | Aprobación/rechazo individual de documentos, persistencia de estado y aislamiento por inmobiliaria | `bf209e2` |
| HU-12 | Reportes 6 (citas por estado) y 7 (solicitudes por inmobiliaria), sin eliminar los 5 obligatorios | `0bf63b7` |
| HU-02 | Validaciones de servidor: documento obligatorio, formato de correo, documento y teléfono en `RegistroServlet` | `0bf63b7` |
| UI | Rediseño completo del frontend + imágenes demo | `e6a9bfb`, `5713076`, `4297971` |
| Documentación | Columna `descripcion` documentada en diccionario y modelo | `f75b313` |
| SCRUM/docs | Planning/Review/Retro de los 3 sprints; diagramas MER, modelo relacional y casos de uso exportados a PNG; checklist QA y plan de congelación | `0bf63b7` |

**Dificultades previstas / en curso**

1. **Coordinación de sesiones:** los miembros trabajan en equipos distintos; el flujo
   `feature → develop` con rebase (`33f47e3`) evitó colisiones.
2. **Exportación de diagramas:** la versión final del MER se exportó con Graphviz Online y el modelo relacional con dbdiagram.io en PDF.
3. **No romper el buscador al filtrar por características:** se resolvió con una subconsulta
   `IN (SELECT id_propiedad ... GROUP BY id_propiedad HAVING COUNT(DISTINCT id_caracteristica) = N)`
   sobre `propiedad_caracteristica`, en lugar de tocar la consulta base de `v_propiedad_catalogo`.

## Sprint Review

| Campo | Detalle |
|---|---|
| Fecha | 16 sep 2026 |
| Participantes | equipo de desarrollo + PO |
| Demo | QA completo del checklist; recorrido ADMIN, AGENTE, CLIENTE y rutas prohibidas |
| Resultado | Completado: regresión integral ejecutada sin fallas funcionales detectadas |

## Sprint Retrospective

**Resultado de la retrospectiva:** se completó el cierre técnico el 16 de septiembre de 2026. Se verificaron compilación, pruebas JUnit, controles de acceso por rol, aislamiento por inmobiliaria, documentos privados, reportes y regresión integral. La entrega académica está programada para el jueves 17 de septiembre de 2026 a las 14:00.

---

## 3. Evidencias de Git por sprint (rama `develop`)

Los commits se agrupan según la fecha registrada por Git dentro de las tres ventanas académicas de 7 días.

### Sprint 1 (27 ago – 02 sep 2026)

| Commit | Fecha | Autor | Mensaje |
|---|---|---|---|
| `88cf69c` | 2026-09-02 | andrey ramirea | chore: crear proyecto Java Web base |
| `0ddbd34` | 2026-09-02 | andrey ramirea | feat: implementar autenticacion con BCrypt |
| `3e1497b` | 2026-09-02 | Juan Miguel Corrales Mendoza | Add base stylesheet for real estate application |
| `c931eb9` | 2026-09-02 | Juan Miguel Corrales | feat(landing): navbar, hero, buscador y catalogo con Bootstrap |
| `a7a24f4` | 2026-09-02 | Juan Miguel Corrales Mendoza | Merge pull request #1 from florezramirezk27-star/feature/propiedades |

### Sprint 2 (03 – 09 sep 2026)

| Commit | Fecha | Autor | Mensaje |
|---|---|---|---|
| `98bde4f` | 2026-09-03 | Juan Miguel Corrales | feat(bd): DDL y DML del modulo de propiedades, ignorar db.properties |
| `a1d751b` | 2026-09-03 | Juan Miguel Corrales Mendoza | Merge pull request #2 from florezramirezk27-star/feature/bd-propiedades |
| `34590c7` | 2026-09-03 | andrey ramirea | Merge remote-tracking branch 'origin/develop' into feature/auth-security |
| `8df4d82` | 2026-09-03 | andrey ramirea | feat(auth): completar modelos de usuario y roles |
| `b2331af` | 2026-09-03 | andrey ramirea | feat(auth): implementar DAOs de usuario, rol y perfil |
| `03c8788` | 2026-09-03 | andrey ramirea | fix(bd): agregar tablas usuario, rol, usuario_rol, perfil |
| `d1f982c` | 2026-09-03 | florezramirezk27-star | Merge pull request #4 from florezramirezk27-star/feature/auth-fix |
| `b09101e` | 2026-09-03 | Juan Miguel Corrales | feat(propiedades): DDL v3, servlet y catalogo dinamico con convencion id_entidad |
| `319f213` | 2026-09-03 | Juan Miguel Corrales Mendoza | Merge pull request #5 from florezramirezk27-star/feature/propiedades-v3 |
| `584d42c` | 2026-09-03 | andrey ramirea | Merge branch 'develop' into feature/auth-security :wq |
| `267407c` | 2026-09-03 | Juan Miguel Corrales | fix(entorno): alinear Servlet API y web.xml a Tomcat 8.5, agregar parametros JDBC para caching_sha2_password |
| `52577bd` | 2026-09-03 | Juan Miguel Corrales Mendoza | Merge pull request #6 from florezramirezk27-star/fix/entorno-tomcat85 |
| `752a69e` | 2026-09-03 | andrey ramirea | fix: correct method name crear -> crearUsuario in AuthService |
| `3604b04` | 2026-09-03 | Juan Miguel Corrales | feat(propiedades): formulario de creacion y edicion con validacion server-side |
| `a4ea017` | 2026-09-03 | Juan Miguel Corrales Mendoza | Merge pull request #8 from florezramirezk27-star/feature/formulario-propiedades |
| `3a84e06` | 2026-09-03 | andrey ramirea | Merge branch 'develop' of https://github.com/florezramirezk27-star/inmobiliaria into feature/auth-security |
| `d4b956c` | 2026-09-04 | andrey ramirea | feat(auth): implementar login, registro y cierre de sesion |
| `157f072` | 2026-09-04 | Juan Miguel Corrales | feat(propiedades): ficha de detalle, gestion de imagenes/caracteristicas, fix codificacion UTF-8 y responsive |
| `ec84468` | 2026-09-04 | Juan Miguel Corrales Mendoza | Merge pull request #9 from florezramirezk27-star/feature/ficha-detalle |
| `72a01df` | 2026-09-04 | andrey ramirea | Merge branch 'develop' into feature/auth-security |
| `1c808cc` | 2026-09-04 | andrey ramirea | feat(auth): proteger dashboards por rol |
| `7cddc53` | 2026-09-04 | andrey ramirea | feat(perfil): implementar consulta y edicion de perfil |
| `bec9652` | 2026-09-04 | Juan Miguel Corrales | feat(favoritos): marcar y quitar favoritos, pagina Mis favoritos |
| `598af3b` | 2026-09-04 | Juan Miguel Corrales Mendoza | Merge pull request #10 from florezramirezk27-star/feature/favoritos |
| `bdbfb14` | 2026-09-04 | Juan Miguel Corrales | feat(citas): agendar visitas, confirmar/rechazar, pagina Mis citas |
| `f4219e4` | 2026-09-04 | Juan Miguel Corrales Mendoza | Merge pull request #11 from florezramirezk27-star/feature/citas |
| `831c98b` | 2026-09-05 | andrey ramirea | feat(solicitudes): agregar gestion de solicitudes para agentes |
| `9e535d2` | 2026-09-05 | andrey ramirea | fix(documentos): proteger acceso por propietario |
| `37640bb` | 2026-09-05 | andrey ramirea | merge: feature/auth-security into develop |
| `35cea69` | 2026-09-07 | andrey ramirea | feat: dynamic property characteristics report |
| `9c4e5b0` | 2026-09-08 | andrey ramirea | feat: secure appointments and complete requests |
| `f892e15` | 2026-09-08 | andrey ramirea | test: add unit tests for domain enums |
| `b75d0f6` | 2026-09-08 | andrey ramirea | docs: add project technical documentation |
| `f9361ed` | 2026-09-08 | andrey ramirea | style: improve role dashboards |
| `9aff3da` | 2026-09-08 | andrey ramirea | feat: landing dinamica, favoritos y logout sin JavaScript, y rediseno de paneles admin |
| `39516f1` | 2026-09-09 | Juan Miguel Corrales | fix(favoritos): usar sesion real en la ficha de detalle, igual que en el catalogo |
| `90c913d` | 2026-09-09 | Juan Miguel Corrales Mendoza | Merge pull request #12 from florezramirezk27-star/fix/detalle-favoritos-sesion |
| `9afa354` | 2026-09-09 | andrey ramirea | chore: eliminar INSTRUCCIONES.txt del repositorio |
| `1a45669` | 2026-09-09 | andrey ramirea | Merge branch 'develop' of https://github.com/florezramirezk27-star/inmobiliaria into develop |

### Sprint 3 (10 – 16 sep 2026)

| Commit | Fecha | Autor | Mensaje |
|---|---|---|---|
| `db8436d` | 2026-09-12 | andrey ramirea | feat(auth): validar documento duplicado al registrar usuario |
| `f6dc0b2` | 2026-09-15 | andrey ramirea | feat: CRUD admin de catalogos, baja logica de propiedades y docs Scrum |
| `f75b313` | 2026-09-15 | andrey ramirea | docs: documentar columna descripcion en tipo_propiedad (diccionario y modelo) |
| `e6a9bfb` | 2026-09-15 | Juan Miguel Corrales | feat(ui): rediseño completo frontend |
| `5713076` | 2026-09-15 | Juan Miguel Corrales | Merge feature/imagenes-demo: rediseño UI completo + imágenes demo |
| `4297971` | 2026-09-15 | Juan Miguel Corrales | Merge branch 'develop' of https://github.com/florezramirezk27-star/inmobiliaria into develop |
| `33f47e3` | 2026-09-15 | andrey ramirea | fix(security): corregir hashes BCrypt de usuarios de prueba (Clave123*) y documentar |
| `0bf63b7` | 2026-09-15 | andrey ramirea | feat: filtro por caracteristicas, bloqueo de no publicadas, reportes 6-7, validaciones de servidor y docs de cierre |
| `103f61e` | 2026-09-15 | andrey ramirea | docs: registrar commit de cierre del sprint 3 en scrum |
| `b4e8c65` | 2026-09-15 | andrey ramirea | feat(ui): rediseñar panel del cliente con componentes unificados |
| `0560d44` | 2026-09-15 | Juan Miguel Corrales | fix(db): sincronizar propiedades y caracteristicas de datos demo |
| `987a6a8` | 2026-09-15 | Juan Miguel Corrales | fix(security): reforzar acceso por roles y credenciales demo |
| `bc10398` | 2026-09-15 | Juan Miguel Corrales | fix(cliente): proteger favoritos y privacidad de citas |
| `7a7bc87` | 2026-09-15 | Juan Miguel Corrales | fix(cliente): validar propiedades publicadas en solicitudes |
| `d20ffbb` | 2026-09-15 | Juan Miguel Corrales | fix(security): proteger almacenamiento de documentos privados |
| `b46fcbb` | 2026-09-15 | Juan Miguel Corrales | fix(cliente): validar carga y consistencia de documentos |
| `0504a97` | 2026-09-15 | Juan Miguel Corrales | fix(propiedades): persistir imagenes fuera del war |
| `c67dd64` | 2026-09-16 | Juan Miguel Corrales | fix(propiedades): asignar inmobiliaria desde sesion |
| `e37b62e` | 2026-09-16 | Juan Miguel Corrales | fix(security): aislar gestion de propiedades y citas |
| `6230840` | 2026-09-16 | Juan Miguel Corrales | feat(reportes): agregar reportes por inmobiliaria |

## 4. Capturas (evidencia visual)

- **Tablero:** `docs/imagenes/tablero-scrum.png` *(captura final incorporada al repositorio)*
- **GitHub:** historial de commits y PRs del repositorio
  https://github.com/florezramirezk27-star/inmobiliaria (capturas de `Insights → Network` y
  lista de `Pull requests` también pueden adjuntarse en `docs/imagenes/`).