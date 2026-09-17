# 🏠 Sistema de Gestión Inmobiliaria

Aplicación web desarrollada en **Java** para la gestión integral de procesos inmobiliarios, permitiendo consultar propiedades, administrar usuarios, gestionar citas, solicitudes, documentos, favoritos y procesos internos según el rol de cada usuario.

Proyecto académico desarrollado para la asignatura **Programación en Java — Primer Corte**.

---

## 📌 Estado del proyecto

El sistema se encuentra en una versión funcional y consolidada para entrega académica.

- ✅ Aplicación web desarrollada con Java, JSP y Servlets.
- ✅ Arquitectura organizada mediante capas y patrón MVC.
- ✅ Persistencia de información con MySQL y JDBC.
- ✅ Autenticación mediante correo y contraseña.
- ✅ Contraseñas protegidas con BCrypt.
- ✅ Control de sesiones mediante `HttpSession`.
- ✅ Control de acceso según roles.
- ✅ Catálogo público de propiedades.
- ✅ Gestión de favoritos.
- ✅ Gestión de citas.
- ✅ Gestión de solicitudes.
- ✅ Gestión documental.
- ✅ Administración de propiedades.
- ✅ Reportes.
- ✅ Auditoría y administración de usuarios.
- ✅ Pruebas automatizadas con JUnit.
- ✅ Empaquetado mediante Maven en formato WAR.
- ✅ Despliegue probado en Apache Tomcat.
- ✅ Diseño responsive para escritorio, tablet y dispositivos móviles.

### Versión final

```text
v1.0-entrega-final
```

---

# 📑 Tabla de contenidos

1. [Descripción general](#-descripción-general)
2. [Objetivo del sistema](#-objetivo-del-sistema)
3. [Roles del sistema](#-roles-del-sistema)
4. [Funcionalidades principales](#-funcionalidades-principales)
5. [Arquitectura del proyecto](#-arquitectura-del-proyecto)
6. [Tecnologías utilizadas](#-tecnologías-utilizadas)
7. [Estructura general](#-estructura-general)
8. [Base de datos](#-base-de-datos)
9. [Configuración de conexión](#-configuración-de-conexión)
10. [Compilación](#-compilación)
11. [Pruebas](#-pruebas)
12. [Despliegue](#-despliegue)
13. [Seguridad](#-seguridad)
14. [Documentación del proyecto](#-documentación-del-proyecto)
15. [Metodología de trabajo](#-metodología-de-trabajo)
16. [Buenas prácticas implementadas](#-buenas-prácticas-implementadas)
17. [Estado final de la entrega](#-estado-final-de-la-entrega)

---

# 📖 Descripción general

El **Sistema de Gestión Inmobiliaria** es una aplicación web que centraliza diferentes procesos relacionados con la administración y comercialización de inmuebles.

El sistema permite que visitantes consulten propiedades disponibles y que los usuarios registrados accedan a funcionalidades específicas según su rol.

La aplicación contempla procesos relacionados con:

- publicación y consulta de propiedades;
- clientes;
- agentes e inmobiliarias;
- favoritos;
- programación de visitas;
- solicitudes inmobiliarias;
- documentos;
- aprobación o rechazo de información;
- reportes;
- usuarios;
- auditoría;
- seguridad y autorización.

La aplicación fue desarrollada utilizando tecnologías Java Web tradicionales, aplicando conceptos de programación orientada a objetos, JDBC, arquitectura por capas y patrón MVC.

### Módulos implementados

Sistema de inmobiliaria construido con **Maven** (empaquetado **WAR**, desplegable en
Apache Tomcat), **JDBC** contra **MySQL** y vistas **JSP**. El proyecto está organizado
en capas: `model` (entidades), `dao` (acceso a datos), `service` (lógica de negocio
como la autenticación) y `web` (servlets/filtros).

- **Catálogo de propiedades** con búsqueda, filtros y fichas de detalle, respaldado por
  una vista `v_propiedad_catalogo`.
- **Página de inicio dinámica**: `IndexServlet` (`/index`, welcome-file del `web.xml`)
  muestra las 6 propiedades más recientes con marcadores de favoritos de la sesión.
- **Formulario de propiedades** con creación/edición, asignación de características y
  subida de imágenes (multipart). Restringido al rol **AGENTE** y validación de
  pertenencia: solo la inmobiliaria dueña de la propiedad puede editarla.
- **Autenticación y sesiones** con BCrypt, roles (ADMIN / AGENTE / CLIENTE) y filtros
  de protección por URL. El cierre de sesión pide confirmación en el servidor
  (`GET /logout` muestra una página, solo `POST /logout` invalida la sesión).
- **Filtro por características:** el catálogo combina el buscador (operación, ciudad,
  tipo, precio máximo, texto) con casillas de características que se exigen *todas*,
  resuelto con una subconsulta sobre `propiedad_caracteristica` y un
  `HAVING COUNT(DISTINCT id_caracteristica) = N`. El detalle público solo abre
  propiedades en estado `PUBLICADA`.
- **Solicitudes de compra/arriendo**: el cliente crea solicitudes y adjunta/descarga
  documentos; la inmobiliaria las consulta y aprueba/rechaza.
- **Citas**: el cliente agenda visitas a propiedades y el agente gestiona su estado.
- **Reportes de inmobiliaria**: cada agente consulta indicadores de ventas, arriendos,
  solicitudes y negociaciones aprobadas exclusivamente de su propia inmobiliaria.
- **Administración**: gestiona usuarios, roles, perfiles, auditoría y siete reportes SQL.
- **Seguridad**: validación de pertenencia de recursos por usuario/inmobiliaria.
- **Pruebas unitarias JUnit** sobre los enums de dominio (5 pruebas).

---

# 🎯 Objetivo del sistema

El objetivo principal es desarrollar una aplicación web que permita administrar de manera organizada los procesos básicos de una inmobiliaria.

El sistema busca facilitar:

- la publicación y consulta de inmuebles;
- la interacción entre clientes y agentes;
- el seguimiento de solicitudes;
- la programación de visitas;
- la carga y revisión de documentos;
- la administración de usuarios;
- el control de información según los permisos de cada rol.

---

# 👥 Roles del sistema

La aplicación maneja diferentes niveles de acceso.

## 1. Visitante

Un visitante puede navegar por las funcionalidades públicas del sistema sin necesidad de iniciar sesión.

Entre sus posibilidades se encuentran:

- consultar propiedades disponibles;
- utilizar filtros de búsqueda;
- consultar propiedades en venta;
- consultar propiedades en arriendo;
- filtrar por ciudad;
- filtrar por tipo de inmueble;
- filtrar por presupuesto;
- filtrar por características;
- consultar el detalle de una propiedad.

La información sensible o las acciones privadas requieren autenticación.

---

## 2. Cliente

El cliente es un usuario registrado interesado en una o varias propiedades.

Puede realizar acciones como:

- iniciar sesión;
- acceder a su panel personal;
- modificar su perfil;
- consultar el catálogo;
- agregar propiedades a favoritos;
- eliminar propiedades de favoritos;
- consultar sus favoritos;
- programar visitas;
- consultar sus citas;
- crear solicitudes;
- consultar el estado de sus solicitudes;
- cargar documentos asociados a sus procesos;
- consultar documentos;
- cerrar sesión.

---

## 3. Agente / Inmobiliaria

El agente dispone de herramientas relacionadas con la gestión comercial y administrativa de las propiedades asignadas a su inmobiliaria.

Entre sus funciones se encuentran:

- acceder a su panel;
- consultar sus propiedades;
- publicar propiedades;
- editar propiedades autorizadas;
- administrar información del inmueble;
- gestionar imágenes;
- consultar solicitudes;
- gestionar citas;
- consultar documentos;
- revisar documentos;
- aprobar documentos;
- rechazar documentos;
- consultar reportes relacionados con su operación.

El sistema aplica controles para evitar que un agente pueda modificar información perteneciente a otra inmobiliaria.

---

## 4. Administrador

El administrador dispone del nivel de acceso más amplio del sistema.

Puede gestionar y supervisar diferentes componentes, entre ellos:

- dashboard administrativo;
- usuarios;
- perfiles;
- citas;
- auditoría;
- reportes;
- información general del sistema.

El módulo administrativo permite realizar seguimiento global a la operación de la aplicación.

---

# ⚙️ Funcionalidades principales

## 🌐 Catálogo público

La aplicación cuenta con un catálogo de propiedades accesible desde la página principal.

El usuario puede buscar propiedades utilizando criterios como:

- operación: venta o arriendo;
- ciudad;
- tipo de inmueble;
- precio máximo;
- características del inmueble.

También se presenta información resumida de cada propiedad mediante tarjetas.

---

## 🏘️ Detalle de propiedades

Cada propiedad dispone de una vista donde se presenta información relevante sobre el inmueble.

Dependiendo de la propiedad, pueden mostrarse datos como:

- título;
- ubicación;
- precio;
- operación;
- habitaciones;
- baños;
- área;
- características;
- imágenes;
- información adicional.

---

## ❤️ Favoritos

Los clientes autenticados pueden guardar propiedades de interés.

El módulo permite:

- agregar una propiedad;
- consultar favoritos;
- eliminar una propiedad;
- continuar navegando por el catálogo.

---

## 📅 Citas

El sistema permite gestionar visitas relacionadas con propiedades.

El cliente puede programar una cita para una fecha futura y posteriormente consultar sus citas.

Los perfiles autorizados también pueden consultar y gestionar información relacionada con las visitas.

El administrador cuenta con una vista general de citas del sistema.

---

## 📄 Solicitudes

Los clientes pueden iniciar solicitudes relacionadas con propiedades.

Estas solicitudes permiten llevar un seguimiento del proceso inmobiliario.

El sistema contempla:

- creación;
- consulta;
- estado de la solicitud;
- administración por perfiles autorizados.

---

## 📎 Documentos

Las solicitudes pueden requerir documentos.

El sistema permite:

- cargar documentos;
- almacenarlos fuera del directorio público de la aplicación;
- consultar documentos autorizados;
- descargarlos de forma controlada;
- aprobarlos;
- rechazarlos.

Los controles de autorización evitan que usuarios sin permisos accedan a archivos que no les corresponden.

---

## 👤 Perfil del cliente

Cada cliente cuenta con información de perfil que puede actualizar.

Entre los datos administrados se encuentran:

- nombres;
- apellidos;
- documento;
- teléfono;
- dirección;
- referencia de foto de perfil.

---

## 📊 Reportes

El sistema incorpora consultas y reportes para apoyar el seguimiento de información de la inmobiliaria.

Los reportes utilizan información almacenada en la base de datos y respetan los permisos definidos para cada tipo de usuario.

---

## 🛡️ Administración

El módulo administrativo centraliza herramientas para supervisar el funcionamiento del sistema.

Incluye funcionalidades relacionadas con:

- usuarios;
- perfiles;
- citas;
- auditoría;
- reportes;
- control general de la aplicación.

---

# 🏗️ Arquitectura del proyecto

El proyecto utiliza una arquitectura organizada en diferentes responsabilidades.

De forma general:

```text
Navegador
    │
    ▼
Servlet / Controlador
    │
    ▼
DAO
    │
    ▼
JDBC
    │
    ▼
MySQL
```

Para la presentación de información:

```text
Servlet
   │
   ├── procesa la solicitud
   ├── consulta DAO
   ├── prepara atributos
   │
   ▼
JSP
   │
   ▼
HTML + CSS + Bootstrap
```

---

## Modelo

Contiene las clases que representan entidades del negocio.

Ejemplos:

- Usuario
- Propiedad
- Cita
- Solicitud
- Documento
- Inmobiliaria
- Perfil

---

## DAO

La capa DAO se encarga del acceso a la base de datos.

Su objetivo es mantener las consultas SQL separadas de las vistas y de la lógica de presentación.

Los DAO utilizan JDBC para ejecutar operaciones como:

```text
SELECT
INSERT
UPDATE
DELETE
```

---

## Controladores

Los Servlets reciben las solicitudes HTTP.

Entre sus responsabilidades se encuentran:

1. recibir parámetros;
2. validar información;
3. consultar los DAO;
4. verificar permisos;
5. crear o modificar información;
6. enviar resultados a las vistas JSP;
7. realizar redirecciones cuando corresponde.

---

## Vistas

Las vistas están desarrolladas principalmente con JSP.

Su función es presentar al usuario la información preparada por los controladores.

Se complementan con:

- HTML5;
- CSS3;
- Bootstrap;
- Bootstrap Icons;
- JavaScript.

---

# 🧰 Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| **Java 21** | Lenguaje principal |
| **Maven** | Construcción y dependencias |
| **JSP** | Vistas dinámicas |
| **Servlets** | Controladores HTTP |
| **JSTL** | Renderizado y lógica básica en JSP |
| **JDBC** | Comunicación con la base de datos |
| **MySQL** | Base de datos relacional |
| **MySQL Connector/J** | Driver JDBC |
| **BCrypt** | Protección de contraseñas |
| **JUnit** | Pruebas automatizadas |
| **Apache Tomcat 8.5+** | Servidor web |
| **HTML5** | Estructura de la interfaz |
| **CSS3** | Diseño visual |
| **Bootstrap** | Componentes y responsive |
| **Bootstrap Icons** | Iconografía |
| **JavaScript** | Interacciones del lado del cliente |
| **Git** | Control de versiones |
| **GitHub** | Repositorio colaborativo |

---

# 📂 Estructura general

La estructura principal sigue el estándar Maven:

```text
inmobiliaria/
│
├── pom.xml
│
├── README.md
├── GUIA.md
│
├── docs/
│   ├── 01-MER.md
│   ├── 02-modelo-relacional.md
│   ├── 03-normalizacion-3FN.md
│   ├── 04-diccionario-datos.md
│   ├── 05-casos-de-uso.md
│   ├── 06-scrum.md
│   ├── 07-product-backlog.md
│   ├── 08-pruebas.md
│   ├── diccionario-datos.docx
│   ├── scrum/
│   │   ├── sprint-1.md
│   │   ├── sprint-2.md
│   │   └── sprint-3.md
│   └── imagenes/
│
├── database/
│   ├── ddl.sql
│   ├── dml.sql
│   └── consultas.sql
│
└── src/
    ├── main/
    │   ├── java/
    │   │   └── com/inmobiliaria/
    │   │       ├── config/
    │   │       ├── dao/
    │   │       ├── model/
    │   │       └── web/
    │   │
    │   ├── resources/
    │   │   └── db.properties
    │   │
    │   └── webapp/
    │       ├── css/
    │       ├── index.jsp
    │       ├── catalogo.jsp
    │       └── WEB-INF/
    │           └── views/
    │
    └── test/
        └── java/
```

---

# 🗄️ Base de datos

La aplicación utiliza **MySQL** como sistema gestor de base de datos relacional.

El modelo fue diseñado buscando mantener una organización normalizada de la información y separar entidades de acuerdo con sus responsabilidades.

La documentación del modelo se encuentra en la carpeta:

```text
docs/
```

Allí se incluye información relacionada con:

- Modelo Entidad-Relación;
- modelo relacional;
- diccionario de datos;
- relaciones;
- estructura de las entidades.

---

# 🔌 Configuración de conexión

La conexión se administra de forma centralizada mediante:

```text
ConnectionFactory
```

La configuración se obtiene desde:

```text
src/main/resources/db.properties
```

Ejemplo:

```properties
db.url=jdbc:mysql://localhost:3306/inmobiliaria
db.username=root
db.password=TU_CONTRASENA
db.driver=com.mysql.cj.jdbc.Driver
```

> ⚠️ Los valores anteriores son únicamente un ejemplo. No se deben publicar contraseñas reales en el repositorio.

La clase `ConnectionFactory` centraliza la creación de conexiones para que los DAO no tengan que repetir la configuración.

### Cómo funciona la conexión a la base de datos

Al cargar la clase `ConnectionFactory` (bloque `static`) se lee `db.properties` del
classpath y se carga el driver. Luego el método estático:

```java
public static Connection getConnection() throws SQLException {
    return DriverManager.getConnection(
            properties.getProperty("db.url"),
            properties.getProperty("db.username"),
            properties.getProperty("db.password")
    );
}
```

Los DAO usan `ConnectionFactory.getConnection()` dentro de un `try-with-resources`,
de modo que la conexión (y el `PreparedStatement`/`ResultSet`) se cierran solos.

Para probar la conexión de forma aislada existe la clase `DatabaseTest`.

---

# 🔌 Requisitos previos

1. **JDK 21** (o superior compatible) — verificar con `java -version`.
2. **Maven 3.8+** — verificar con `mvn -version`.
3. **MySQL Server** corriendo localmente en el puerto 3306 (ej. XAMPP).
4. **Apache Tomcat 8.5+** — para ejecutar la aplicación web.

---

# 👥 Credenciales de acceso

Los datos de prueba del DML incluyen usuarios con los roles:

| Rol | Correo | Contraseña |
|-----|--------|------------|
| **ADMIN** | `admin@inmobiliaria.com` | `admin123` |
| **AGENTE** (inmobiliaria 1) | `agente.centro@inmobiliaria.com` | `Clave123*` |
| **AGENTE** (inmobiliaria 2) | `agente.norte@inmobiliaria.com` | `Clave123*` |
| **CLIENTE** | `maria.rojas@correo.com`, `juan.paez@correo.com`, `laura.gomez@correo.com`, `carlos.diaz@correo.com`, `ana.suarez@correo.com`, `felipe.torres@correo.com` | `Clave123*` |

> **Contraseñas:** el usuario admin usa `admin123`. Los usuarios 2-10 (2 agentes y
> 7 clientes) usan `Clave123*`. Cada hash BCrypt del DML es único (sal aleatoria
> por usuario) y corresponde realmente a esa contraseña, por lo que el login
> funciona sin regenerar nada.

---

# 🔧 Compilación

Ubícate en la carpeta raíz del proyecto:

```bash
cd inmobiliaria
```

Ejecuta:

```bash
mvn clean package
```

Este comando:

1. limpia compilaciones anteriores;
2. compila las clases Java;
3. compila las pruebas;
4. ejecuta las pruebas;
5. empaqueta la aplicación;
6. genera el WAR.

Si todo funciona correctamente deberá aparecer:

```text
BUILD SUCCESS
```

El archivo generado se encuentra en:

```text
target/inmobiliaria.war
```

---

# 🧪 Pruebas

El proyecto incorpora pruebas automatizadas utilizando **JUnit**.

En la versión final se ejecutan:

```text
Tests run: 5
Failures: 0
Errors: 0
Skipped: 0
```

Las pruebas verifican comportamientos relacionados con estados importantes del sistema, incluyendo:

- estados de citas;
- estados de solicitudes;
- tipos de solicitudes.

La documentación adicional de pruebas se encuentra en:

```text
docs/08-pruebas.md
```

---

# 🚀 Despliegue

La aplicación se empaqueta como archivo:

```text
inmobiliaria.war
```

Para desplegarla manualmente en Apache Tomcat:

1. Compilar:

```bash
mvn clean package
```

2. Copiar:

```text
target/inmobiliaria.war
```

a:

```text
TOMCAT_HOME/webapps/
```

3. Iniciar Apache Tomcat.

4. Abrir la aplicación utilizando el puerto configurado en el servidor:

```text
http://localhost:PUERTO/inmobiliaria/
```

Por ejemplo:

```text
http://localhost:8080/inmobiliaria/
```

El puerto puede variar según la configuración local de Tomcat.

---

# 🔀 Flujos web y controladores

Cada servlet es un controlador mapeado por anotación `@WebServlet`. Los principales:

| URL | Servlet | Descripción |
|-----|---------|-------------|
| `/` | `IndexServlet` | Landing dinámica (6 recientes + favoritos de sesión); welcome-file `index` |
| `/propiedades` | `PropiedadServlet` | Búsqueda/listado del catálogo |
| `/propiedades/detalle` | `PropiedadDetalleServlet` | Ficha de una propiedad |
| `/inmobiliaria/propiedades/formulario` | `PropiedadFormServlet` | Crear/editar propiedad + imágenes |
| `/propiedades/favorito` | `FavoritoServlet` | Alternar favorito (POST server-side) |
| `/login`, `/registro` | `Login`, `Registro` | Autenticación |
| `/logout` | `LogoutServlet` | `GET` muestra confirmación; `POST` invalida la sesión |
| `/cliente/dashboard` | `ClienteDashboardServlet` | Panel del cliente |
| `/cliente/favoritos` | `FavoritoServlet` | Favoritos del cliente |
| `/cliente/perfil` | `PerfilServlet` | Perfil del cliente |
| `/cliente/solicitudes` | `SolicitudServlet` | Solicitudes del cliente |
| `/cliente/solicitudes/documentos` | `DocumentoServlet` | Subida/descarga de documentos (cliente) |
| `/inmobiliaria/dashboard` | `InmobiliariaDashboardServlet` | Panel de la inmobiliaria |
| `/inmobiliaria/solicitudes` | `AgenteSolicitudServlet` | Aprobar/rechazar solicitudes |
| `/inmobiliaria/reportes` | `AgenteReporteServlet` | Reportes de ventas, arriendos y solicitudes de la inmobiliaria autenticada |
| `/inmobiliaria/solicitudes/documentos` | `DocumentoServlet` | Revisión, descarga y aprobación/rechazo de documentos de la propia inmobiliaria |
| `/propiedades/citas`, `/propiedades/citas/estado`, `/citas` | `CitaServlet` | Citas del cliente y gestión del agente |
| `/admin/dashboard` | `AdminDashboardServlet` | Panel del admin |
| `/admin/usuarios` | `AdminUsuariosServlet` | Activar/desactivar y cambiar roles |
| `/admin/usuarios/perfil` | `AdminPerfilServlet` | Edición de perfil por admin |
| `/admin/auditoria` | `AuditoriaServlet` | Registro de auditoría |
| `/admin/reportes` | `ReporteServlet` | Siete reportes SQL |

### Protección por URL (AuthFilter)

El filtro `AuthFilter` exige sesión y rol según el prefijo de la URL, con reglas
explícitas para operaciones concretas:

| Prefijo / ruta | Rol requerido |
|----------------|---------------|
| `/admin/*` | ADMIN |
| `/agente/*`, `/inmobiliaria/*` | AGENTE |
| `/cliente/*` | CLIENTE |
| `/propiedades/favorito`, `/favoritos`, `/citas` | CLIENTE |
| `/propiedades/citas/estado` | AGENTE |
| `/propiedades/citas` | cualquier usuario autenticado (solo sesión: el cliente agenda y el agente gestiona) |
| Otros | acceso público |

Además del filtro, el servlet revalida autorización a nivel de recurso: el GET de
edición de `PropiedadFormServlet` responde `403` si el agente autenticado no es dueño
de la propiedad editada (por ejemplo, `agente.norte` no puede editar propiedades de la
inmobiliaria 1). Esta validación es independiente del rol exigido por URL. Y el detalle
público (`/propiedades/detalle`) bloquea por URL las propiedades `BORRADOR`/`CERRADA`
salvo para usuarios con rol ADMIN o AGENTE.

---

# 🧭 Despliegue rápido

1. Copia `target/inmobiliaria.war` a la carpeta `webapps` de Tomcat.
2. Inicia Tomcat y abre:
   ```
   http://localhost:8080/inmobiliaria/
   ```
3. Verás el catálogo de propiedades (página de inicio).

También es posible ejecutar el proyecto desde una IDE (NetBeans recomendado): abre el
proyecto, configura un servidor Tomcat y ejecuta.

---

# 🔐 Seguridad

La aplicación implementa diferentes controles de seguridad.

## BCrypt

Las contraseñas no deben compararse directamente como texto plano.

Para protegerlas se utiliza BCrypt.

De forma conceptual:

```text
Contraseña
    │
    ▼
BCrypt
    │
    ▼
Hash almacenado
```

Durante el inicio de sesión se valida la contraseña utilizando el mecanismo de comparación proporcionado por BCrypt.

---

## Sesiones

Después de una autenticación correcta se utiliza:

```java
HttpSession
```

para mantener la información del usuario durante su navegación.

---

## Control de acceso

El sistema restringe rutas según:

- existencia de sesión;
- rol;
- relación del usuario con el recurso solicitado.

Por ejemplo, si un cliente intenta acceder directamente a una ruta administrativa, el sistema debe impedir el acceso.

---

## Protección de recursos

Se implementaron controles para reducir problemas de acceso directo a recursos mediante identificadores.

Esto evita escenarios donde un usuario pueda intentar consultar o modificar información que pertenece a otro usuario o a otra inmobiliaria.

---

## Archivos

Los documentos privados no se almacenan como recursos públicos dentro de la aplicación web.

Las descargas se realizan mediante rutas controladas por la aplicación y sujetas a autorización.

---

# 📚 Documentación del proyecto

La carpeta `docs/` contiene material complementario de la entrega.

Entre los principales documentos se encuentran:

```text
docs/01-MER.md
docs/02-modelo-relacional.md
docs/05-casos-de-uso.md
docs/06-scrum.md
docs/07-product-backlog.md
docs/08-pruebas.md
docs/diccionario-datos.docx
```

También se incluyen evidencias visuales dentro de:

```text
docs/imagenes/
```

---

# 🔄 Metodología de trabajo

El proyecto se organizó utilizando principios de **Scrum**.

Se trabajó con:

- Product Backlog;
- historias de usuario;
- criterios de aceptación;
- planificación por Sprint;
- asignación de actividades;
- tablero Scrum;
- seguimiento de tareas;
- control de versiones mediante Git.

La información detallada se encuentra en:

```text
docs/06-scrum.md
docs/07-product-backlog.md
```

---

# ✅ Buenas prácticas implementadas

## Separación de responsabilidades

La aplicación divide:

- modelo;
- acceso a datos;
- controladores;
- vistas.

Esto facilita el mantenimiento del proyecto.

---

## Configuración centralizada

Los datos de conexión se administran desde un único punto mediante `ConnectionFactory`.

---

## DAO

Las operaciones SQL se concentran principalmente en clases DAO y no directamente dentro de las vistas.

---

## PreparedStatement

Para las consultas parametrizadas se utiliza JDBC con parámetros, reduciendo el uso de SQL construido directamente mediante concatenación de valores proporcionados por el usuario.

---

## Manejo de recursos

Las conexiones y recursos JDBC se administran procurando su cierre correcto, incluyendo el uso de `try-with-resources` cuando corresponde.

---

## UTF-8

La aplicación utiliza codificación UTF-8 para soportar correctamente caracteres en español.

---

## Control de versiones

El desarrollo fue administrado mediante Git y GitHub.

El historial del repositorio permite identificar:

- nuevas funcionalidades;
- correcciones;
- mejoras;
- cambios de seguridad;
- documentación.

---

## Diseño responsive

La interfaz fue adaptada para diferentes tamaños de pantalla.

Se utilizan:

- Bootstrap;
- media queries;
- layouts flexibles;
- grids;
- componentes responsive.

---

# 🎨 Interfaz

La versión final utiliza una identidad visual consistente basada en:

- verde oscuro;
- tonos secundarios verdes;
- fondos claros;
- acentos dorados;
- tarjetas;
- componentes editoriales;
- diseño limpio y profesional.

Se trabajaron específicamente:

- página de inicio;
- catálogo;
- inicio de sesión;
- dashboard de cliente;
- perfil;
- favoritos;
- citas;
- solicitudes;
- documentos.

---

# 📦 Empaquetado

Maven genera una aplicación web estándar:

```text
target/inmobiliaria.war
```

El archivo contiene:

- clases compiladas;
- JSP;
- CSS;
- configuraciones;
- dependencias necesarias;
- vistas;
- recursos de la aplicación.

---

# 🏁 Estado final de la entrega

La versión final fue validada realizando:

- compilación limpia;
- ejecución de pruebas;
- generación del WAR;
- despliegue limpio en Tomcat;
- prueba del HOME;
- prueba del catálogo;
- comprobaciones de rutas protegidas;
- integración del trabajo colaborativo;
- validación del repositorio Git;
- publicación de la versión final.

Resultado de pruebas:

```text
Tests run: 5
Failures: 0
Errors: 0
Skipped: 0
```

Resultado de construcción:

```text
BUILD SUCCESS
```

Tag de entrega:

```text
v1.0-entrega-final
```

---

# 📌 Consideraciones académicas

Este proyecto fue desarrollado como ejercicio académico para aplicar conceptos de:

- Java;
- programación orientada a objetos;
- desarrollo web con Servlets y JSP;
- bases de datos relacionales;
- JDBC;
- arquitectura MVC;
- seguridad;
- control de sesiones;
- diseño responsive;
- pruebas;
- trabajo colaborativo;
- Scrum;
- Git y GitHub.

---

# 👨‍💻 Repositorio

El historial completo del desarrollo puede consultarse directamente en el repositorio GitHub del proyecto.

Para obtener una copia:

```bash
git clone https://github.com/florezramirezk27-star/inmobiliaria.git
```

Luego:

```bash
cd inmobiliaria
```

y compilar:

```bash
mvn clean package
```

---

# 📌 Notas finales

La documentación del proyecto está en `docs/` (`01-MER.md` a `08-pruebas.md`)
y se mantiene sincronizada con `database/ddl.sql`.

Cierre técnico validado el 16 de septiembre de 2026:

- `mvn clean package`: **BUILD SUCCESS**.
- 5 pruebas JUnit ejecutadas sin fallos.
- Regresión integral de roles, permisos, IDOR, documentos y reportes completada.
- Rama `develop` sincronizada con `origin/develop`.

Evidencia documental incorporada para la entrega:

- Evidencia visual del tablero Scrum disponible en `docs/imagenes/tablero-scrum.png`.

---

**Sistema de Gestión Inmobiliaria — Programación en Java**
