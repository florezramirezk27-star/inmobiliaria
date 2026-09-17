# SPRINT 1 — CIMIENTOS Y ACCESO

## 1. Información del Sprint

**Proyecto:** Sistema Web de Administración de Inmobiliaria

**Sprint:** 1 de 3

**Duración:** 7 días

**Objetivo del Sprint:**  
Construir los cimientos técnicos del sistema, implementar la conexión JDBC con la base de datos, desarrollar la página de aterrizaje y establecer el registro, inicio de sesión y control de acceso por roles.

### Roles Scrum

**Product Owner:** Profesor de la asignatura

**Scrum Master:** Integrante asignado por el equipo

**Development Team:** Integrantes encargados del desarrollo del sistema

---

# 2. Sprint Planning

## Objetivo

Definir las historias de usuario que serán desarrolladas durante el Sprint 1 y establecer el alcance funcional y técnico del incremento.

## Historias seleccionadas

### HU-01 — Landing Page

**Historia de usuario:**

Como visitante, quiero una página de aterrizaje atractiva para conocer la inmobiliaria y buscar propiedades rápidamente.

**Prioridad:** Alta

**Estimación:** 5 puntos

### Criterios de aceptación

- La página debe ser pública.
- Debe presentar información de la inmobiliaria.
- Debe disponer de un buscador rápido.
- Debe mostrar publicaciones destacadas.
- Debe incluir acceso al registro.
- Debe incluir acceso al inicio de sesión.
- Debe funcionar en diferentes tamaños de pantalla.

---

### HU-02 — Registro de usuarios

**Historia de usuario:**

Como usuario, quiero registrarme con un correo único y validado para crear mi cuenta sin duplicados en el sistema.

**Prioridad:** Alta

**Estimación:** 5 puntos

### Criterios de aceptación

- El usuario debe proporcionar los campos requeridos.
- El correo debe tener un formato válido.
- El correo no puede estar duplicado.
- La contraseña debe almacenarse mediante hash.
- Debe mostrarse un mensaje comprensible cuando el correo ya exista.
- El usuario debe quedar registrado correctamente.

---

### HU-03 — Autenticación y sesiones

**Historia de usuario:**

Como usuario registrado, quiero iniciar y cerrar sesión de forma segura para que el sistema me lleve al panel que corresponde a mi rol.

**Prioridad:** Alta

**Estimación:** 8 puntos

### Criterios de aceptación

- El sistema debe validar las credenciales contra la base de datos.
- La contraseña debe compararse utilizando el hash almacenado.
- Debe crearse una HttpSession.
- La sesión debe conservar el identificador del usuario.
- La sesión debe conservar los roles asignados.
- El usuario debe ser redirigido al panel correspondiente.
- El cierre de sesión debe invalidar la sesión.

---

### HU-04 — Gestión de roles

**Historia de usuario:**

Como administrador, quiero asignar y revocar roles a los usuarios para controlar los permisos de la aplicación.

**Prioridad:** Alta

**Estimación:** 5 puntos

### Criterios de aceptación

- El administrador puede consultar los usuarios.
- El administrador puede asignar roles.
- El administrador puede revocar roles.
- No deben repetirse relaciones usuario-rol.
- El acceso a las funcionalidades debe estar condicionado por el rol.
- La autorización debe validarse en el servidor.

---

# 3. Tareas técnicas

## Base de datos

- Diseñar el modelo inicial.
- Crear las tablas necesarias.
- Crear llaves primarias.
- Crear llaves foráneas.
- Crear restricciones UNIQUE.
- Insertar datos de prueba.
- Preparar consultas iniciales.

## Conexión JDBC

- Crear la configuración de conexión.
- Centralizar la cadena de conexión.
- Implementar ConnectionFactory.
- Verificar la conexión desde la aplicación.

## Landing

- Diseñar la página principal.
- Crear estructura HTML.
- Aplicar CSS y Bootstrap.
- Crear navegación.
- Agregar buscador.
- Mostrar propiedades destacadas.
- Adaptar la interfaz a diferentes tamaños de pantalla.

## Registro

- Crear formulario.
- Validar campos.
- Validar correo.
- Implementar BCrypt.
- Registrar usuario en la base de datos.
- Manejar correo duplicado.

## Login

- Crear formulario de autenticación.
- Consultar usuario en BD.
- Validar contraseña.
- Crear sesión.
- Obtener roles.
- Redireccionar al dashboard.

## Seguridad

- Crear AuthFilter.
- Proteger rutas privadas.
- Validar roles.
- Bloquear acceso mediante URL directa.
- Crear página de acceso denegado.

---

# 4. Definition of Done

Una historia del Sprint se considera terminada cuando:

- La funcionalidad está implementada.
- El código compila correctamente.
- La información se almacena correctamente.
- Las validaciones funcionan.
- Los errores se muestran mediante mensajes comprensibles.
- Los permisos se verifican en el servidor.
- La funcionalidad fue probada.
- La interfaz funciona correctamente.
- La documentación correspondiente fue actualizada.

---

# 5. Incremento del Sprint

Al finalizar el Sprint se espera contar con:

- Modelo inicial de base de datos.
- Conexión JDBC funcionando.
- Landing page funcionando.
- Registro funcionando.
- Login funcionando.
- Logout funcionando.
- Contraseñas protegidas mediante hash.
- HttpSession funcionando.
- Control de acceso por roles.
- Primeros dashboards diferenciados.
- Filtro de seguridad funcionando.

---

# 6. Sprint Review

## Objetivo

Presentar el incremento desarrollado durante el Sprint y verificar el cumplimiento de las historias seleccionadas.

## Demostración

Durante la revisión se demostrará:

### Landing Page

Se presenta la página pública de la inmobiliaria.

Se verifica:

- navegación;
- buscador;
- publicaciones destacadas;
- registro;
- inicio de sesión;
- comportamiento responsivo.

### Registro

Se realiza un registro de prueba.

Se verifica:

- validación del formulario;
- correo único;
- almacenamiento de la contraseña mediante hash;
- creación correcta del usuario.

También se realiza una prueba con un correo existente para verificar el mensaje de duplicidad.

### Login

Se realiza el ingreso con credenciales válidas.

Se verifica:

- consulta de credenciales;
- validación de contraseña;
- creación de sesión;
- identificación del rol;
- redirección al dashboard correspondiente.

### Control de acceso

Se realiza una prueba intentando acceder directamente mediante URL a una ruta restringida.

Se verifica que el usuario sin los permisos necesarios no pueda acceder.

### Cierre de sesión

Se selecciona la opción de cerrar sesión.

Se verifica la invalidación de la sesión y el bloqueo posterior de las rutas privadas.

---

# 7. Resultado del Sprint Review

Las historias seleccionadas fueron implementadas y sometidas a pruebas funcionales.

El incremento permite contar con la estructura inicial del sistema, autenticación y control de acceso necesarios para continuar con el desarrollo de los módulos del negocio.

Las observaciones realizadas durante la revisión se registrarán como mejoras o tareas posteriores.

---

# 8. Sprint Retrospective

## ¿Qué salió bien?

- Se estableció la estructura inicial del proyecto.
- Se consiguió la conexión entre Java y la base de datos.
- Se implementó el registro.
- Se implementó la autenticación.
- Se incorporó protección de contraseñas.
- Se implementó el control de acceso mediante filtros.
- Se consiguió una primera versión funcional de la landing.

## ¿Qué dificultades se presentaron?

- Configuración inicial del proyecto Java EE.
- Configuración de la conexión JDBC.
- Integración de la autenticación con la sesión.
- Organización inicial de las rutas protegidas.
- Ajustes de la interfaz para diferentes tamaños de pantalla.

## ¿Qué se puede mejorar?

- Mejorar la organización inicial de las tareas.
- Mantener commits frecuentes y descriptivos.
- Documentar las decisiones técnicas durante el desarrollo.
- Realizar pruebas de cada funcionalidad antes de integrarla.
- Establecer con mayor precisión las tareas del siguiente Sprint.

## Acciones de mejora

- Dividir las tareas grandes en actividades más pequeñas.
- Mantener actualizada la documentación.
- Registrar las pruebas realizadas.
- Revisar los criterios de aceptación antes de cerrar cada historia.
- Preparar con anticipación las tareas del Sprint 2.

---

# 9. Conclusión del Sprint

El Sprint 1 establece los cimientos técnicos y de seguridad del sistema inmobiliario.

El incremento obtenido permite continuar con el desarrollo del núcleo del negocio en el Sprint 2, especialmente la gestión de propiedades, imágenes, características, búsqueda, perfil y paneles diferenciados.