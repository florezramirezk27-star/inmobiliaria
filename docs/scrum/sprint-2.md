# SPRINT 2 — NÚCLEO DEL NEGOCIO

## 1. Información del Sprint

**Proyecto:** Sistema Web de Administración de Inmobiliaria

**Sprint:** 2 de 3

**Duración:** 7 días

**Objetivo del Sprint:**  
Implementar el núcleo funcional de la inmobiliaria: gestión de propiedades, imágenes, características, búsqueda y filtros, perfil del usuario y paneles diferenciados por rol.

### Roles Scrum

**Product Owner:** Profesor de la asignatura

**Scrum Master:** Integrante asignado por el equipo

**Development Team:** Integrantes encargados del desarrollo del sistema

---

# 2. Sprint Planning

## Objetivo

Definir las historias de usuario que serán desarrolladas durante el Sprint 2 y establecer las actividades necesarias para implementar el catálogo y las funcionalidades principales de las propiedades.

## Historias seleccionadas

### HU-05 — Perfil del cliente

**Historia de usuario:**

Como cliente, quiero completar mi perfil con documento, teléfono y dirección asociados a mi cuenta para agilizar mis trámites.

**Prioridad:** Media

**Estimación:** 5 puntos

### Criterios de aceptación

- El cliente puede consultar su información personal.
- El cliente puede actualizar sus datos.
- El perfil está asociado a su usuario.
- Un usuario no puede tener dos perfiles.
- El documento debe cumplir las validaciones correspondientes.
- Los cambios deben almacenarse correctamente.

---

### HU-06 — Gestión de propiedades

**Historia de usuario:**

Como agente de la inmobiliaria, quiero registrar y editar propiedades con fotos, características y precio para mantener el catálogo actualizado.

**Prioridad:** Alta

**Estimación:** 13 puntos

### Criterios de aceptación

- El agente puede registrar propiedades.
- El agente puede editar propiedades.
- La propiedad debe contener la información requerida.
- La matrícula inmobiliaria debe ser única.
- La propiedad debe estar asociada a una inmobiliaria.
- El agente puede administrar imágenes.
- El agente puede asociar características.
- Debe existir una imagen principal.
- Debe existir baja lógica del inmueble.
- Un agente no puede modificar propiedades de otra inmobiliaria.

---

### HU-07 — Buscador y filtros

**Historia de usuario:**

Como cliente, quiero buscar y filtrar propiedades por ciudad, tipo, precio y características para encontrar las opciones que se ajusten a mis necesidades.

**Prioridad:** Alta

**Estimación:** 8 puntos

### Criterios de aceptación

- Se pueden consultar propiedades publicadas.
- Se puede filtrar por ciudad.
- Se puede filtrar por tipo de propiedad.
- Se puede filtrar por rango de precio.
- Se pueden consultar características.
- Se pueden combinar filtros.
- Los resultados corresponden a los criterios seleccionados.
- Las propiedades no disponibles no deben mostrarse como disponibles.

---

### HU-08 — Favoritos

**Historia de usuario:**

Como cliente, quiero marcar propiedades como favoritas para consultarlas más adelante sin tener que buscarlas de nuevo.

**Prioridad:** Media

**Estimación:** 5 puntos

### Criterios de aceptación

- El cliente puede agregar propiedades a favoritos.
- El cliente puede eliminar favoritos.
- El cliente puede consultar sus favoritos.
- No se puede registrar dos veces el mismo favorito.
- Un cliente solo puede consultar sus propios favoritos.

---

# 3. Tareas técnicas

## Perfil

- Consultar información del perfil.
- Crear o actualizar información personal.
- Validar documento.
- Validar teléfono.
- Mantener relación 1:1 con usuario.
- Comprobar restricción UNIQUE.

## Propiedades

- Crear formulario de propiedades.
- Implementar creación.
- Implementar edición.
- Consultar propiedades.
- Implementar filtros.
- Validar precio.
- Validar datos obligatorios.
- Validar matrícula inmobiliaria.
- Implementar estados de la propiedad.
- Implementar baja lógica.
- Restringir modificación a propiedades de la inmobiliaria correspondiente.

## Imágenes

- Implementar carga de imágenes.
- Validar archivos.
- Asociar imágenes con propiedades.
- Identificar imagen principal.
- Permitir eliminar imágenes.

## Características

- Consultar catálogo de características.
- Asociar características a propiedades.
- Quitar características.
- Mantener relación N:M mediante `propiedad_caracteristica`.

## Buscador

- Implementar búsqueda por ciudad.
- Implementar búsqueda por tipo.
- Implementar filtros de precio.
- Implementar filtro por características.
- Combinar filtros.
- Mostrar resultados correctamente.

## Favoritos

- Registrar favoritos.
- Consultar favoritos del cliente.
- Eliminar favoritos.
- Evitar duplicados.

## Paneles

- Diferenciar las opciones disponibles según el rol.
- Mostrar información correspondiente al usuario.
- Mantener las validaciones de autorización en servidor.

---

# 4. Definition of Done

Una historia se considera terminada cuando:

- La funcionalidad está implementada.
- El código compila correctamente.
- Los datos se almacenan correctamente.
- Las validaciones funcionan.
- Se manejan los errores de forma comprensible.
- Se cumplen las restricciones de autorización.
- La interfaz funciona correctamente.
- La funcionalidad ha sido probada.
- La documentación ha sido actualizada.

---

# 5. Incremento del Sprint

Al finalizar el Sprint se espera contar con:

- Perfil del usuario funcionando.
- CRUD de propiedades funcionando.
- Gestión de imágenes funcionando.
- Gestión de características funcionando.
- Relación N:M funcionando.
- Buscador funcionando.
- Filtros funcionando.
- Favoritos funcionando.
- Paneles diferenciados por rol.
- Baja lógica de propiedades funcionando.

---

# 6. Sprint Review

## Objetivo

Presentar las funcionalidades implementadas durante el Sprint 2 y verificar que cumplen los criterios de aceptación definidos durante el Planning.

## Demostración

### Perfil

Se ingresa al perfil del cliente.

Se demuestra:

- consulta de datos;
- actualización;
- validaciones;
- asociación con el usuario.

### Gestión de propiedades

Se demuestra:

- creación;
- edición;
- consulta;
- estados;
- validación de matrícula;
- baja lógica.

También se comprueba que un agente no pueda modificar propiedades pertenecientes a otra inmobiliaria.

### Imágenes

Se demuestra:

- carga de imágenes;
- visualización;
- selección de imagen principal;
- eliminación.

### Características

Se demuestra la asociación de características con una propiedad.

Ejemplo:

- Piscina
- Parqueadero
- Ascensor
- Gimnasio

Se muestra que una propiedad puede tener varias características y que una característica puede estar asociada a varias propiedades.

### Buscador

Se realizan búsquedas:

- por ciudad;
- por tipo;
- por precio;
- por características;
- combinando filtros.

### Favoritos

Se demuestra:

- agregar favorito;
- consultar favoritos;
- quitar favorito.

### Paneles

Se comprueba que cada usuario visualice las opciones correspondientes a su rol.

---

# 7. Resultado del Sprint Review

El Sprint permite disponer del núcleo funcional de la aplicación inmobiliaria.

Las funcionalidades principales relacionadas con propiedades, catálogo, perfil, búsqueda y favoritos fueron implementadas y verificadas mediante pruebas funcionales.

Las observaciones encontradas durante la revisión serán registradas para el Sprint siguiente o como tareas de mejora.

---

# 8. Sprint Retrospective

## ¿Qué salió bien?

- Se completó el núcleo del catálogo inmobiliario.
- Se implementó el CRUD de propiedades.
- Se integraron imágenes y características.
- Se implementó la búsqueda y filtrado.
- Se implementó la relación N:M de propiedades y características.
- Se implementaron los favoritos.
- Se fortaleció la separación de funcionalidades por rol.

## ¿Qué dificultades se presentaron?

- Manejo de imágenes y archivos.
- Integración de características con propiedades.
- Construcción de consultas con diferentes filtros.
- Validación de permisos sobre propiedades.
- Coordinación entre los módulos de propiedades, perfil y favoritos.

## ¿Qué se puede mejorar?

- Mejorar la experiencia de los formularios.
- Reducir duplicación de código.
- Mejorar los mensajes de validación.
- Documentar las consultas SQL más importantes.
- Realizar pruebas de autorización con diferentes roles.

## Acciones de mejora

- Revisar los filtros con diferentes combinaciones.
- Incrementar las pruebas de los casos límite.
- Verificar periódicamente la seguridad de las rutas.
- Mantener documentación actualizada.
- Preparar las funcionalidades de citas y solicitudes para el Sprint 3.

---

# 9. Conclusión del Sprint

El Sprint 2 permite disponer del núcleo funcional del sistema inmobiliario.

Se incorporan las propiedades, imágenes, características, búsqueda, filtros, perfil, favoritos y paneles diferenciados.

Con este incremento, el sistema queda preparado para continuar con las operaciones de negocio del Sprint 3: citas, solicitudes, documentos, reportes, pruebas y cierre del proyecto.