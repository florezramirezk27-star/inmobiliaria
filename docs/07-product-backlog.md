# Product Backlog - Sistema Inmobiliaria

**PRODUCT BACKLOG**

**Sistema Web de Administración de Inmobiliaria**

## 1. Información general

| Campo | Valor |
|---|---|
| Proyecto | Sistema Web de Administración de Inmobiliaria |
| Metodología | Scrum |
| Duración | 3 Sprints de 7 días cada uno |
| Product Owner | Profesor |
| Development Team | Integrantes del proyecto |
| Scrum Master | Integrante asignado por el equipo |

## 2. Product Backlog

| ID | Historia de Usuario | Prioridad | Estimación |
|---|---|---|---|
| HU-01 | Como visitante, quiero una página de aterrizaje atractiva para conocer la inmobiliaria y buscar propiedades rápidamente. | Alta | 5 |
| HU-02 | Como usuario, quiero registrarme con un correo único y validado para crear mi cuenta sin duplicados en el sistema. | Alta | 5 |
| HU-03 | Como usuario registrado, quiero iniciar y cerrar sesión de forma segura para que el sistema me lleve al panel que corresponde a mi rol. | Alta | 8 |
| HU-04 | Como administrador, quiero asignar y revocar roles a los usuarios para controlar los permisos de la aplicación. | Alta | 5 |
| HU-05 | Como cliente, quiero completar mi perfil con documento, teléfono y dirección asociados a mi cuenta para agilizar mis trámites. | Media | 5 |
| HU-06 | Como agente de la inmobiliaria, quiero registrar y editar propiedades con fotos, características y precio para mantener el catálogo actualizado. | Alta | 13 |
| HU-07 | Como cliente, quiero buscar y filtrar propiedades por ciudad, tipo, precio y características para encontrar las opciones que se ajusten a mis necesidades. | Alta | 8 |
| HU-08 | Como cliente, quiero marcar propiedades como favoritas para consultarlas más adelante sin tener que buscarlas de nuevo. | Media | 5 |
| HU-09 | Como cliente, quiero solicitar una cita en un horario disponible para visitar el inmueble sin que se crucen las agendas. | Media | 8 |
| HU-10 | Como cliente, quiero radicar los documentos de compra o arriendo y consultar el estado de mi solicitud. | Media | 8 |
| HU-11 | Como agente de la inmobiliaria, quiero aprobar o rechazar las solicitudes y sus documentos para dar trámite a la negociación. | Media | 8 |
| HU-12 | Como administrador, quiero un reporte de propiedades por ciudad y estado, generado con consultas de agregación, para tomar decisiones. | Media | 5 |
| HU-13 | Como administrador, quiero consultar la auditoría de accesos y cambios para hacer seguimiento a la operación del sistema. | Baja | 5 |
| HU-14 | Como usuario, quiero contar con funcionalidades adicionales como mapas, notificaciones, comparador o chat para mejorar la experiencia del sistema. | Baja | 8 |
| HU-15 | Como agente de la inmobiliaria, quiero consultar reportes de ventas, arriendos y solicitudes de mis propiedades para hacer seguimiento a la operación. | Media | 5 |

## 3. Criterios de aceptación y Definition of Done

### HU-01 - Landing Page

**Historia:**

Como visitante, quiero una página de aterrizaje atractiva para conocer la inmobiliaria y buscar propiedades rápidamente.

**Criterios de aceptación**

- La página debe ser accesible sin autenticación.
- Debe presentar información de la inmobiliaria.
- Debe incluir un buscador rápido de propiedades.
- Debe mostrar publicaciones destacadas.
- Debe disponer de accesos a registro e inicio de sesión.
- Debe funcionar correctamente en computador, tableta y celular.

**Definition of Done**

- La landing está implementada.
- El diseño es responsivo.
- El buscador funciona.
- Los accesos de autenticación funcionan.
- La funcionalidad fue probada en el navegador.
- El código fue integrado al proyecto.

### HU-02 - Registro de usuarios

**Historia:**

Como usuario, quiero registrarme con un correo único y validado para crear mi cuenta sin duplicados en el sistema.

**Criterios de aceptación**

- El usuario debe proporcionar los datos obligatorios.
- El correo debe tener formato válido.
- El correo no puede estar repetido.
- La contraseña no debe almacenarse en texto plano.
- Debe mostrarse un mensaje claro cuando el correo ya exista.
- La cuenta debe quedar registrada correctamente.

**Definition of Done**

- Formulario de registro funcional.
- Validaciones implementadas.
- BCrypt implementado.
- Restricción UNIQUE en correo.
- Manejo de duplicados.
- Pruebas realizadas.

### HU-03 - Autenticación y sesiones

**Historia:**

Como usuario registrado, quiero iniciar y cerrar sesión de forma segura para que el sistema me lleve al panel que corresponde a mi rol.

**Criterios de aceptación**

- El sistema valida las credenciales contra la base de datos.
- La contraseña se compara utilizando el hash almacenado.
- Se crea una HttpSession.
- La sesión almacena el identificador del usuario y sus roles.
- El usuario es redirigido al panel correspondiente.
- El cierre de sesión invalida la sesión.
- Los usuarios no autenticados no pueden acceder a rutas privadas.

**Definition of Done**

- Login funcional.
- Logout funcional.
- Sesiones implementadas.
- Redirección por rol implementada.
- Pruebas de acceso directo por URL realizadas.
- Filtro de seguridad funcionando.

### HU-04 - Gestión de roles

**Historia:**

Como administrador, quiero asignar y revocar roles a los usuarios para controlar los permisos de la aplicación.

**Criterios de aceptación**

- El administrador puede consultar usuarios.
- El administrador puede asignar roles.
- El administrador puede revocar roles.
- No deben repetirse relaciones usuario-rol.
- Un usuario solo puede acceder a las opciones permitidas por sus roles.
- Las validaciones deben existir en el servidor.

**Definition of Done**

- Gestión de usuarios implementada.
- Gestión de roles implementada.
- Tabla usuario_rol funcionando.
- Restricción de integridad implementada.
- Pruebas de permisos realizadas.

### HU-05 - Perfil del cliente

**Historia:**

Como cliente, quiero completar mi perfil con documento, teléfono y dirección asociados a mi cuenta para agilizar mis trámites.

**Criterios de aceptación**

- El cliente puede consultar su perfil.
- El cliente puede actualizar sus datos personales.
- El perfil debe estar asociado a un único usuario.
- El documento debe validarse.
- Los datos actualizados deben almacenarse correctamente.

**Definition of Done**

- Perfil implementado.
- Relación 1:1 funcionando.
- Validaciones realizadas.
- Actualización probada.
- Restricción UNIQUE de perfil.id_usuario funcionando.

### HU-06 - Gestión de propiedades

**Historia:**

Como agente de la inmobiliaria, quiero registrar y editar propiedades con fotos, características y precio para mantener el catálogo actualizado.

**Criterios de aceptación**

- El agente puede crear propiedades.
- El agente puede editar propiedades.
- Debe existir información del precio.
- Debe poder asociar características.
- Debe poder cargar imágenes.
- Debe existir una imagen principal.
- La matrícula inmobiliaria no puede repetirse.
- El agente solo puede gestionar las propiedades de su inmobiliaria.
- Debe existir baja lógica del inmueble.

**Definition of Done**

- CRUD de propiedades implementado.
- Imágenes funcionando.
- Características funcionando.
- Restricciones UNIQUE implementadas.
- Control de pertenencia implementado.
- Baja lógica funcionando.
- Pruebas realizadas.

### HU-07 - Buscador y filtros

**Historia:**

Como cliente, quiero buscar y filtrar propiedades por ciudad, tipo, precio y características para encontrar las opciones que se ajusten a mis necesidades.

**Criterios de aceptación**

- Se pueden consultar propiedades disponibles.
- Se puede filtrar por ciudad.
- Se puede filtrar por tipo.
- Se puede filtrar por precio.
- Se pueden consultar características.
- Los filtros pueden combinarse.
- Las propiedades cerradas o no disponibles no deben mostrarse como disponibles.

**Definition of Done**

- Buscador implementado.
- Filtros implementados.
- Consultas SQL funcionando.
- Resultados comprobados.
- Diseño responsivo.

### HU-08 - Favoritos

**Historia:**

Como cliente, quiero marcar propiedades como favoritas para consultarlas más adelante sin tener que buscarlas de nuevo.

**Criterios de aceptación**

- El cliente puede agregar una propiedad a favoritos.
- El cliente puede quitar una propiedad de favoritos.
- El cliente puede consultar sus favoritos.
- Un mismo cliente no puede registrar dos veces el mismo favorito.
- Los favoritos pertenecen al usuario que los creó.

**Definition of Done**

- CRUD de favoritos implementado.
- Restricción de duplicados implementada.
- Vista de favoritos funcionando.
- Control de acceso comprobado.

### HU-09 - Citas

**Historia:**

Como cliente, quiero solicitar una cita en un horario disponible para visitar el inmueble sin que se crucen las agendas.

**Criterios de aceptación**

- El cliente puede solicitar una cita.
- Debe seleccionar una propiedad.
- Debe seleccionar fecha y hora.
- No deben existir dos citas para la misma propiedad en el mismo horario.
- Las citas deben almacenarse correctamente.
- El agente puede revisar las citas relacionadas con sus propiedades.
- Debe existir control de estados.

**Definition of Done**

- Agendamiento implementado.
- Restricción de fecha y hora funcionando.
- Restricción UNIQUE correspondiente implementada.
- Gestión de estados funcionando.
- Pruebas realizadas.

### HU-10 - Solicitudes y documentos

**Historia:**

Como cliente, quiero radicar los documentos de compra o arriendo y consultar el estado de mi solicitud.

**Criterios de aceptación**

- El cliente puede crear una solicitud.
- Debe especificar si corresponde a compra o arriendo.
- Puede adjuntar documentos.
- Puede consultar el estado de la solicitud.
- Los documentos deben quedar asociados a la solicitud.
- El cliente solo puede consultar sus propias solicitudes.

**Definition of Done**

- Solicitudes implementadas.
- Documentos implementados.
- Control de acceso implementado.
- Estados funcionando.
- Carga y descarga probadas.

### HU-11 - Aprobación de solicitudes

**Historia:**

Como agente de la inmobiliaria, quiero aprobar o rechazar las solicitudes y sus documentos para dar trámite a la negociación.

**Criterios de aceptación**

- El agente puede consultar solicitudes de sus propiedades.
- Puede aprobar una solicitud.
- Puede rechazar una solicitud.
- Puede revisar y descargar los documentos.
- Puede aprobar o rechazar individualmente los documentos.
- Cada documento conserva estado `PENDIENTE`, `APROBADO` o `RECHAZADO`.
- No puede gestionar solicitudes ni documentos de otra inmobiliaria.
- Los estados deben actualizarse correctamente.

**Definition of Done**

- Gestión de solicitudes funcionando.
- Revisión y descarga de documentos funcionando.
- Aprobación y rechazo de solicitudes funcionando.
- Aprobación y rechazo individual de documentos funcionando.
- Persistencia del estado documental verificada en MySQL.
- Control de autorización e intento IDOR entre inmobiliarias probado con respuesta `403`.

### HU-12 - Reportes

**Historia:**

Como administrador, quiero un reporte de propiedades por ciudad y estado, generado con consultas de agregación, para tomar decisiones.

**Criterios de aceptación**

- Debe existir un reporte de propiedades por ciudad.
- Debe permitir consultar el estado de las propiedades.
- Debe utilizar consultas SQL de varias tablas.
- Debe existir una consulta de agregación con GROUP BY.
- Debe existir una consulta utilizando HAVING.
- Los resultados deben ser comprensibles para el administrador.

**Definition of Done**

- Reportes implementados.
- Consultas SQL documentadas.
- GROUP BY implementado.
- HAVING implementado.
- Resultados comprobados.

### HU-13 - Auditoría

**Historia:**

Como administrador, quiero consultar la auditoría de accesos y cambios para hacer seguimiento a la operación del sistema.

**Criterios de aceptación**

- Los eventos relevantes deben quedar registrados.
- La auditoría debe identificar al usuario que realizó la acción.
- Debe registrar la acción realizada.
- Debe permitir consultar los registros desde el panel administrativo.
- El acceso a auditoría debe estar restringido al administrador.

**Definition of Done**

- Tabla auditoria funcionando.
- Registro de acciones implementado.
- Consulta de auditoría implementada.
- Protección por rol verificada.

### HU-14 - Funcionalidades adicionales

**Historia:**

Como usuario, quiero contar con funcionalidades adicionales como mapas, notificaciones, comparador o chat para mejorar la experiencia del sistema.

**Estado final:** `BACKLOG`. Historia adicional propuesta por el equipo que no fue incorporada al alcance implementado de los tres Sprints. El enunciado académico presenta este punto como espacio para otras historias propuestas por el equipo.

**Criterios de aceptación**

- Se debe seleccionar al menos una funcionalidad adicional.
- La funcionalidad debe integrarse sin afectar los módulos existentes.
- Debe ser accesible según el rol correspondiente.
- Debe ser probada antes de considerarse terminada.

**Definition of Done**

- Funcionalidad adicional implementada.
- Integración comprobada.
- Pruebas realizadas.
- Documentación actualizada.

### HU-15 - Reportes de la inmobiliaria

**Historia:**

Como agente de la inmobiliaria, quiero consultar reportes de ventas, arriendos y solicitudes de mis propiedades para hacer seguimiento a la operación.

**Criterios de aceptación**

- El reporte se consulta desde el panel del agente.
- Los resultados se filtran por la inmobiliaria asociada al usuario autenticado.
- Se muestran indicadores de propiedades de venta y arriendo.
- Se muestran solicitudes agrupadas por tipo y estado.
- Se muestran negociaciones aprobadas.
- Un agente no puede consultar información consolidada de otra inmobiliaria.
- Visitantes y clientes no pueden acceder a los reportes del agente.

**Definition of Done**

- Reportes del agente implementados.
- Aislamiento por inmobiliaria comprobado.
- Control de acceso por rol verificado.
- Resultados contrastados contra MySQL.
- Pruebas runtime realizadas con las dos inmobiliarias demo.
- Documentación actualizada.

## 4. Definition of Done general del proyecto

Una historia se considera terminada cuando cumple todos los siguientes puntos:

- El desarrollo está implementado.
- El código compila correctamente.
- La funcionalidad fue probada.
- Las validaciones requeridas funcionan.
- Los mensajes de error son comprensibles.
- Se respetan los permisos y roles.
- La información se almacena correctamente en la base de datos.
- La interfaz funciona correctamente.
- El código está integrado al proyecto.
- La documentación correspondiente está actualizada.
- La funcionalidad fue revisada por el equipo.

## 5. Priorización

**Alta prioridad**

- HU-01 Landing Page
- HU-02 Registro
- HU-03 Autenticación
- HU-04 Gestión de roles
- HU-06 Gestión de propiedades
- HU-07 Buscador y filtros

**Prioridad media**

- HU-05 Perfil
- HU-08 Favoritos
- HU-09 Citas
- HU-10 Solicitudes y documentos
- HU-11 Aprobación de solicitudes
- HU-12 Reportes
- HU-15 Reportes de la inmobiliaria

**Prioridad baja**

- HU-13 Auditoría
- HU-14 Funcionalidades adicionales

## 6. Relación propuesta con los Sprints

### Sprint 1 - Cimientos y acceso

- HU-01 Landing Page
- HU-02 Registro
- HU-03 Autenticación
- HU-04 Gestión de roles

**Objetivo:** construir la base del sistema, la autenticación y el control de acceso.

### Sprint 2 - Núcleo del negocio

- HU-05 Perfil
- HU-06 Gestión de propiedades
- HU-07 Buscador y filtros
- HU-08 Favoritos

**Objetivo:** implementar el catálogo inmobiliario y las funcionalidades principales relacionadas con propiedades.

### Sprint 3 - Operación y cierre

- HU-09 Citas
- HU-10 Solicitudes y documentos
- HU-11 Aprobación de solicitudes
- HU-12 Reportes
- HU-15 Reportes de la inmobiliaria
- HU-13 Auditoría

**Historia no incorporada al Sprint 3:** HU-14 Funcionalidades adicionales permanece en `BACKLOG`.

**Objetivo:** completar la operación del sistema, generar reportes, fortalecer la trazabilidad y cerrar la documentación y pruebas.

## 7. Resumen

El Product Backlog organiza las funcionalidades del sistema en historias de usuario priorizadas y estimadas. Cada historia dispone de criterios de aceptación y una Definition of Done para determinar cuándo puede considerarse terminada.

La planificación se distribuye en tres Sprints de siete días, siguiendo la propuesta establecida para el proyecto de la asignatura.