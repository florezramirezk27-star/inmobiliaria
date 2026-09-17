# SPRINT 3 — OPERACIÓN Y CIERRE

## 1. Información del Sprint

**Proyecto:** Sistema Web de Administración de Inmobiliaria

**Sprint:** 3 de 3

**Duración:** 7 días

**Objetivo del Sprint:**  
Completar las operaciones principales del sistema mediante la gestión de citas, solicitudes y documentos, consolidar los reportes, realizar pruebas unitarias, verificar la seguridad y preparar la documentación y el despliegue final.

### Roles Scrum

**Product Owner:** Profesor de la asignatura

**Scrum Master:** Integrante asignado por el equipo

**Development Team:** Integrantes encargados del desarrollo del sistema

---

# 2. Sprint Planning

## Objetivo

Planificar las actividades finales necesarias para completar la operación del sistema inmobiliario y preparar su entrega.

## Historias seleccionadas

### HU-09 — Gestión de citas

**Historia de usuario:**

Como cliente, quiero solicitar una cita en un horario disponible para visitar el inmueble sin que se crucen las agendas.

**Prioridad:** Media

**Estimación:** 8 puntos

### Criterios de aceptación

- El cliente puede solicitar una cita.
- Debe seleccionar la propiedad.
- Debe seleccionar una fecha y hora.
- No se deben permitir citas duplicadas para la misma propiedad y horario.
- El cliente puede consultar sus citas.
- El agente puede consultar las citas de sus propiedades.
- Deben existir estados para las citas.
- Deben respetarse las restricciones de autorización.

---

### HU-10 — Solicitudes y documentos

**Historia de usuario:**

Como cliente, quiero radicar los documentos de compra o arriendo y consultar el estado de mi solicitud.

**Prioridad:** Media

**Estimación:** 8 puntos

### Criterios de aceptación

- El cliente puede crear una solicitud.
- La solicitud debe indicar el tipo de trámite.
- El cliente puede adjuntar documentos.
- El cliente puede consultar el estado de su solicitud.
- Los documentos quedan relacionados con la solicitud.
- El cliente solo puede consultar sus propias solicitudes.

---

### HU-11 — Aprobación de solicitudes

**Historia de usuario:**

Como agente de la inmobiliaria, quiero aprobar o rechazar las solicitudes y sus documentos para dar trámite a la negociación.

**Prioridad:** Media

**Estimación:** 8 puntos

### Criterios de aceptación

- El agente puede consultar solicitudes relacionadas con sus propiedades.
- Puede revisar los documentos.
- Puede aprobar solicitudes.
- Puede rechazar solicitudes.
- El sistema actualiza el estado correspondiente.
- El agente no puede gestionar solicitudes de otra inmobiliaria.

---

### HU-12 — Reportes

**Historia de usuario:**

Como administrador, quiero un reporte de propiedades por ciudad y estado, generado con consultas de agregación, para tomar decisiones.

**Prioridad:** Media

**Estimación:** 5 puntos

### Criterios de aceptación

- El administrador puede consultar los reportes.
- Los reportes utilizan información de la base de datos.
- Se utilizan consultas que involucran varias tablas.
- Existe una consulta con GROUP BY.
- Existe una consulta con HAVING.
- Los resultados son comprensibles.

---

### HU-13 — Auditoría

**Historia de usuario:**

Como administrador, quiero consultar la auditoría de accesos y cambios para hacer seguimiento a la operación del sistema.

**Prioridad:** Baja

**Estimación:** 5 puntos

### Criterios de aceptación

- Las acciones relevantes quedan registradas.
- Se identifica el usuario que realizó la acción.
- Se identifica la operación realizada.
- Se identifica la entidad afectada cuando corresponde.
- El administrador puede consultar los registros.
- Los demás roles no pueden acceder a la auditoría.

---

# 3. Tareas técnicas

## Citas

- Crear solicitudes de cita.
- Validar fecha.
- Validar hora.
- Evitar horarios duplicados.
- Consultar citas del cliente.
- Consultar citas del agente.
- Implementar estados de cita.
- Validar autorización.

## Solicitudes

- Crear solicitudes.
- Consultar solicitudes del cliente.
- Consultar solicitudes para el agente.
- Implementar estados.
- Validar autorización.

## Documentos

- Implementar carga de documentos.
- Validar tipo de archivo.
- Validar tamaño.
- Asociar documentos con solicitudes.
- Permitir consulta o descarga.
- Restringir acceso según usuario y rol.

## Aprobación y rechazo

- Implementar acciones del agente.
- Actualizar estado de solicitud.
- Registrar las operaciones en auditoría.
- Validar que el agente pertenezca a la inmobiliaria correspondiente.

## Reportes

- Implementar consulta de propiedades por ciudad.
- Implementar consulta de citas por estado.
- Implementar consulta de solicitudes por inmobiliaria.
- Implementar consultas con INNER JOIN.
- Implementar consulta N:M.
- Implementar consulta LEFT JOIN.
- Implementar consulta GROUP BY y HAVING.

## Auditoría

- Registrar acciones relevantes.
- Consultar registros.
- Mostrar información de auditoría al administrador.
- Restringir acceso.

## Pruebas

- Ejecutar pruebas unitarias.
- Probar autenticación.
- Probar autorización.
- Probar duplicados.
- Probar citas.
- Probar solicitudes.
- Probar carga de documentos.
- Probar reportes.
- Verificar el comportamiento responsivo.

## Cierre

- Revisar documentación.
- Revisar MER.
- Revisar modelo relacional.
- Revisar diccionario de datos.
- Revisar scripts SQL.
- Revisar Product Backlog.
- Revisar documentación Scrum.
- Preparar el despliegue.
- Verificar el funcionamiento final.

---

# 4. Definition of Done

Una historia del Sprint se considera terminada cuando:

- La funcionalidad está implementada.
- El código compila correctamente.
- La funcionalidad fue probada.
- Se cumplen los criterios de aceptación.
- Los datos se almacenan correctamente.
- Las validaciones funcionan.
- Los permisos se validan en servidor.
- Los errores se muestran de forma comprensible.
- La documentación está actualizada.

---

# 5. Incremento del Sprint

Al finalizar el Sprint se espera disponer de:

- Gestión de citas.
- Gestión de solicitudes.
- Gestión de documentos.
- Aprobación y rechazo.
- Favoritos funcionando.
- Reportes.
- Auditoría.
- Pruebas unitarias.
- Documentación final.
- Aplicación preparada para despliegue.

---

# 6. Sprint Review

## Objetivo

Presentar el incremento final y comprobar el funcionamiento de las operaciones principales del sistema.

## Demostración

### Citas

Se demuestra:

- selección de una propiedad;
- selección de fecha;
- selección de hora;
- creación de la cita;
- consulta de la cita;
- actualización del estado.

También se realiza una prueba intentando registrar una cita en un horario ya ocupado.

---

### Solicitudes

Se demuestra:

- creación de una solicitud de compra o arriendo;
- consulta del estado;
- relación entre cliente y propiedad;
- consulta desde el panel correspondiente.

---

### Documentos

Se demuestra:

- carga de documentos;
- validación del archivo;
- asociación con la solicitud;
- consulta o descarga;
- protección del acceso.

---

### Aprobación y rechazo

Se ingresa con un usuario de tipo agente.

Se demuestra:

- consulta de solicitudes;
- revisión de documentos;
- aprobación;
- rechazo;
- actualización de estados.

---

### Reportes

Se presentan las consultas consolidadas del sistema:

- propiedades disponibles por ciudad;
- citas por estado;
- solicitudes por inmobiliaria.

También se demuestra el uso de consultas SQL con varias tablas.

---

### Auditoría

Se muestran registros generados por acciones del sistema.

Se verifica:

- usuario;
- acción;
- entidad;
- registro afectado;
- fecha.

---

### Pruebas unitarias

Se ejecutan las pruebas unitarias disponibles en el proyecto y se verifica que no presenten errores.

---

# 7. Resultado del Sprint Review

El Sprint permite completar las operaciones principales del sistema inmobiliario.

Las funcionalidades de citas, solicitudes, documentos, aprobación, reportes y auditoría fueron implementadas y verificadas mediante pruebas funcionales.

El sistema queda preparado para la entrega y sustentación.

---

# 8. Sprint Retrospective

## ¿Qué salió bien?

- Se completaron las operaciones de citas.
- Se implementaron las solicitudes.
- Se integraron los documentos.
- Se implementó la aprobación y rechazo.
- Se incorporaron los reportes.
- Se mantuvo el control de acceso por roles.
- Se implementó la auditoría.
- Se realizaron pruebas del sistema.

## ¿Qué dificultades se presentaron?

- Integración entre citas, propiedades y usuarios.
- Manejo de documentos.
- Validación de permisos.
- Construcción de consultas SQL consolidadas.
- Verificación de todos los flujos antes del cierre.
- Organización de la documentación final.

## ¿Qué se puede mejorar?

- Ampliar la cobertura de pruebas unitarias.
- Mejorar los mensajes de validación.
- Mejorar la interfaz de algunos módulos.
- Registrar con mayor detalle los resultados de cada prueba.
- Mantener la documentación actualizada durante todo el desarrollo.

## Acciones de mejora

- Mantener pruebas antes de cada integración.
- Revisar las restricciones de seguridad.
- Documentar las consultas SQL.
- Mantener actualizado el tablero Scrum.
- Realizar una revisión completa antes de la sustentación.

---

# 9. Cierre del proyecto

Con la finalización del Sprint 3 se completa el ciclo de desarrollo definido para el proyecto.

El sistema cuenta con autenticación, control de acceso por roles, gestión de propiedades, imágenes, características, búsqueda, perfil, favoritos, citas, solicitudes, documentos, reportes y auditoría.

Se procede a preparar la documentación final, evidencias del tablero Scrum, modelos de base de datos, pruebas y material necesario para la sustentación.