# 06. Scrum y sprints

La entrega se organiza en tres sprints. La distribución siguiente representa una organización coherente con los módulos desarrollados y debe ajustarse a las fechas y responsables reales que figuren en el tablero Scrum del equipo.

## Sprint 1 — Base del proyecto y catálogo

### Objetivo
Construir la base técnica y el modelo de datos para que la aplicación pueda ejecutarse y mostrar propiedades.

### Trabajo

- Crear proyecto Maven WAR.
- Configurar Java 21 y Tomcat 8.5.
- Configurar JDBC y MySQL.
- Crear DDL, DML y estructura de la base.
- Crear modelos y DAOs de catálogos.
- Crear catálogo, búsqueda y filtros.
- Implementar detalle de propiedad.
- Implementar formulario de propiedades, imágenes y características.

### Resultado
Base funcional del catálogo y gestión de propiedades.

## Sprint 2 — Autenticación, seguridad y perfiles

### Objetivo
Incorporar usuarios, roles y control de acceso.

### Trabajo

- Registro y login.
- Hash BCrypt.
- `HttpSession`.
- `AuthFilter`.
- `CodificacionFilter`.
- Dashboards por rol.
- Perfil de cliente.
- Administración de usuarios.
- Cambio de roles.
- Auditoría administrativa.
- Reportes SQL.

### Resultado
Sistema con autenticación y autorización por roles.

## Sprint 3 — Operación y endurecimiento

### Objetivo
Completar los flujos de operación y validar la seguridad del sistema.

### Trabajo

- Favoritos.
- Citas.
- Solicitudes de compra/arriendo.
- Documentos asociados a solicitudes.
- Gestión de solicitudes del agente.
- Validaciones de pertenencia por usuario/inmobiliaria.
- Protección de operaciones de modificación.
- Pruebas manuales de autorización.
- Pruebas unitarias JUnit.
- Preparación de documentación final.

### Resultado
Flujo integral de cliente-agente-administrador y revisión final de seguridad.

## Retrospectiva propuesta

### Lo que funcionó

- Separación por capas (`model`, `dao`, `service`, `web`).
- Flujo Git `feature -> develop -> main`.
- Pruebas de cada bloque antes del merge.
- Reutilización de DAOs existentes para evitar duplicidad.

### Mejoras para siguientes iteraciones

- Mantener un tablero Scrum actualizado con tareas y responsables.
- Automatizar más pruebas de autorización.
- Mantener diagramas y diccionario sincronizados con cada cambio del DDL.
