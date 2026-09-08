# Inmobiliaria

Aplicación web Java (JSP + Servlets + MySQL) para la gestión de una inmobiliaria:
publicación de propiedades, catálogo/búsqueda, autenticación por roles y gestión
de solicitudes con documentos adjuntos.

Proyecto académico del curso **Programación en Java** — 1º Corte.

---

## Tabla de contenidos

1. [Descripción del proyecto](#descripción-del-proyecto)
2. [Módulos implementados](#módulos-implementados)
3. [Tecnologías utilizadas](#tecnologías-utilizadas)
4. [Estructura del proyecto](#estructura-del-proyecto)
5. [Requisitos previos](#requisitos-previos)
6. [Configuración de la base de datos](#configuración-de-la-base-de-datos)
7. [Cómo compilar el proyecto](#cómo-compilar-el-proyecto)
8. [Cómo ejecutar la aplicación](#cómo-ejecutar-la-aplicación)
9. [Credenciales de acceso](#credenciales-de-acceso)
10. [Flujos web y controladores](#flujos-web-y-controladores)
11. [Cómo funciona la conexión a la base de datos](#cómo-funciona-la-conexión-a-la-base-de-datos)
12. [Buenas prácticas implementadas](#buenas-prácticas-implementadas)

---

## Descripción del proyecto

Sistema de inmobiliaria construido con **Maven** (empaquetado **WAR**, desplegable en
Apache Tomcat), **JDBC** contra **MySQL** y vistas **JSP**. El proyecto está organizado
en capas: `model` (entidades), `dao` (acceso a datos), `service` (lógica de negocio
como la autenticación) y `web` (servlets/filtros).

Lo que llevamos hasta ahora:

- **Catálogo de propiedades** con búsqueda, filtros y fichas de detalle, respaldado por
  una vista `v_propiedad_catalogo`.
- **Formulario de propiedades** con creación/edición, asignación de características y
  subida de imágenes (multipart). Restringido al rol **AGENTE** y validación de
  pertenencia: solo la inmobiliaria dueña de la propiedad puede editarla.
- **Autenticación y sesiones** con BCrypt, roles (ADMIN / AGENTE / CLIENTE) y filtros
  de protección por URL.
- **Módulo de solicitudes del agente**: una inmobiliaria consulta y aprueba/rechaza las
  solicitudes de las propiedades que administra.
- **Módulo de solicitudes del cliente** (parcial): registrar solicitudes y adjuntar
  documentos — los modelos, DAOs y servlets están creados; falta montar sus vistas JSP.

---

## Tabla de contenidos de módulos

### 1. Autenticación (completo)

- **Modelo:** `Usuario`, `Rol`, `Perfil`, `UsuarioRol`.
- **DAOs:** `UsuarioDAO`, `RolDAO`, `PerfilDAO`, `UsuarioRolDAO`.
- **Servicio:** `AuthService`, `LoginResult`.
- **Servlets/filtros:** `LoginServlet`, `LogoutServlet`, `RegistroServlet`,
  `PerfilServlet`, `AuthFilter`, `CodificacionFilter`.
- **Vistas:** `login.jsp`, `registro.jsp`, `perfil.jsp` (en `/WEB-INF/views/auth/` y
  `/cliente/`).

### 2. Catálogo y gestión de propiedades (completo)

- **Modelo:** `Propiedad`, `ImagenPropiedad`, `Caracteristica`, `Ciudad`,
  `TipoPropiedad`, `Inmobiliaria`, enums `Operacion` y `EstadoPropiedad`.
- **DAOs:** `PropiedadDAO`, `ImagenPropiedadDAO`, `CaracteristicaDAO`, `CiudadDAO`,
  `TipoPropiedadDAO`, `InmobiliariaDAO`, `FiltroPropiedad`, `DuplicidadException`.
- **Servlets:** `PropiedadServlet`, `PropiedadDetalleServlet`, `PropiedadFormServlet`,
  `FavoritoServlet`.
- **Vistas:** `index.jsp`, `catalogo.jsp`, `detalle-propiedad.jsp`,
  `formulario-propiedad.jsp`, `favoritos.jsp`.

**Protección del formulario de propiedades:** el servlet `PropiedadFormServlet` está
mapeado a `/inmobiliaria/propiedades/formulario`, por lo que `AuthFilter` exige siempre
el rol **AGENTE** para crear/editarla. Además, el GET de edición valida pertenencia con
`perteneceAlAgente(propiedadId, usuarioId)`: localiza la inmobiliaria del usuario
autenticado (`InmobiliariaDAO.buscarPorUsuario()`) y comprueba que la propiedad esté
entre las listadas para esa inmobiliaria (`PropiedadDAO.listarPorInmobiliaria()`). Si el
usuario no es el agente dueño responde `403 Forbidden`.

### 3. Solicitudes y documentos (parcial)

- **Modelo:** `Solicitud`, `Documento`, enums `TipoSolicitud`, `EstadoSolicitud`.
- **DAOs:** `SolicitudDAO`, `DocumentoDAO`.
- **Servlets:** `SolicitudServlet` (cliente), `DocumentoServlet` (cliente),
  `AgenteSolicitudServlet` (inmobiliaria).

| Pieza | Estado |
|-------|--------|
| Modelos (`Solicitud`, `Documento`, enums) | ✅ Creados |
| DAOs (`SolicitudDAO`, `DocumentoDAO`) | ✅ Creados |
| `InmobiliariaDAO.buscarPorUsuario()` | ✅ Agregado |
| `PropiedadDAO.listarPorInmobiliaria()` | ✅ Agregado |
| `AgenteSolicitudServlet` | ✅ Creado |
| Vista `inmobiliaria/solicitudes.jsp` | ✅ Creada |
| Enlace en `inmobiliaria/dashboard.jsp` | ✅ Agregado |
| Vistas de cliente (`formulario-solicitud.jsp`, `mis-solicitudes.jsp`, `documentos.jsp`) | ⏳ Pendientes |
| Módulo de auditoría (`auditoria` en BD) | ⏳ Tabla lista, sin DAO/servlet |

---

## Tecnologías utilizadas

| Tecnología | Descripción |
|------------|-------------|
| **Java 21** | Lenguaje de programación |
| **Maven** | Herramienta de construcción y gestión de dependencias |
| **JSP / Servlet 3.1** | Tecnologías web de Java (Java EE), Tomcat 8.5 |
| **MySQL** | Motor de base de datos relacional |
| **MySQL Connector/J** | Driver JDBC para conectar Java con MySQL |
| **BCrypt (jbcrypt)** | Hash seguro de contraseñas |
| **Bootstrap 5.3** | Framework CSS para las vistas |
| **Tomcat 8.5+** | Servidor de aplicaciones web donde se despliega el proyecto |

---

## Estructura del proyecto

```
inmobiliaria/
│
├── pom.xml                                  # Dependencias y plugins de Maven
│
├── database/
│   ├── ddl.sql                              # Esquema completo (crea BD, tablas y vista)
│   ├── dml.sql                              # Datos de prueba (usuarios, propiedades, etc.)
│   └── consultas.sql                        # Consultas obligatorias del enunciado
│
└── src/
    ├── main/
    │   ├── java/com/inmobiliaria/
    │   │   ├── config/
    │   │   │   ├── ConnectionFactory.java   # Fábrica de conexiones a MySQL
    │   │   │   └── DatabaseTest.java         # Prueba de conexión
    │   │   │
    │   │   ├── model/                        # Entidades (POJOs) y enums
    │   │   │   ├── Usuario, Rol, Perfil, UsuarioRol
    │   │   │   ├── Propiedad, ImagenPropiedad, Caracteristica, Ciudad,
    │   │   │   │   TipoPropiedad, Inmobiliaria, Favorito
    │   │   │   ├── Solicitud, Documento
    │   │   │   └── Operacion, EstadoPropiedad, TipoSolicitud, EstadoSolicitud
    │   │   │
    │   │   ├── dao/                          # Acceso a datos
    │   │   │   ├── UsuarioDAO, RolDAO, PerfilDAO, UsuarioRolDAO
    │   │   │   ├── PropiedadDAO, ImagenPropiedadDAO, CaracteristicaDAO,
    │   │   │   │   CiudadDAO, TipoPropiedadDAO, InmobiliariaDAO, FavoritoDAO
    │   │   │   ├── SolicitudDAO, DocumentoDAO
    │   │   │   └── FiltroPropiedad, DuplicidadException, PruebaPropiedadDAO
    │   │   │
    │   │   ├── service/
    │   │   │   ├── AuthService.java          # Autenticación y registro
    │   │   │   └── LoginResult.java
    │   │   │
    │   │   └── web/                          # Servlets y filtros
    │   │       ├── Login, Logout, Registro, Perfil, AuthFilter, CodificacionFilter
    │   │       ├── Propiedad, PropiedadDetalle, PropiedadForm, Favorito
    │   │       ├── AdminDashboard, ClienteDashboard, InmobiliariaDashboard
    │   │       ├── AgenteSolicitud
    │   │       └── Solicitud, Documento
    │   │
    │   ├── resources/
    │   │   └── db.properties                 # Datos de conexión a la BD
    │   │
    │   └── webapp/
    │       ├── index.jsp, catalogo.jsp, detalle-propiedad.jsp,
    │       │   formulario-propiedad.jsp, login.jsp, registro.jsp
    │       ├── css/estilos.css
    │       └── WEB-INF/
    │           ├── web.xml                   # Descriptor (Servlet 3.1)
    │           ├── includes/                 # navbar.jspf, footer.jspf
    │           └── views/
    │               ├── admin/dashboard.jsp
    │               ├── auth/login.jsp, registro.jsp
    │               ├── cliente/dashboard.jsp, favoritos.jsp, perfil.jsp
    │               └── inmobiliaria/dashboard.jsp, solicitudes.jsp
    │
    └── test/                                # (pendiente de ampliar)
```

---

## Requisitos previos

1. **JDK 21** (o superior compatible) — verificar con `java -version`.
2. **Maven 3.8+** — verificar con `mvn -version`.
3. **MySQL Server** corriendo localmente en el puerto 3306 (ej. XAMPP).
4. **Apache Tomcat 8.5+** — para ejecutar la aplicación web.

---

## Configuración de la base de datos

1. Ejecuta el esquema y los datos de prueba en orden (sobre una BD vacía):

```bash
mysql -u root < database/ddl.sql
mysql -u root < database/dml.sql
```

> `ddl.sql` crea la base `inmobiliaria` si no existe, todas las tablas y la vista
> `v_propiedad_catalogo`. `dml.sql` inserta los datos de prueba.

2. Configura los datos de conexión en `src/main/resources/db.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/inmobiliaria
db.username=root
db.password=
db.driver=com.mysql.cj.jdbc.Driver
```

| Clave | Valor por defecto | Descripción |
|-------|-------------------|-------------|
| `db.url` | `jdbc:mysql://localhost:3306/inmobiliaria` | Dirección de la BD |
| `db.username` | `root` | Usuario de MySQL |
| `db.password` | *(vacío)* | Contraseña del usuario |
| `db.driver` | `com.mysql.cj.jdbc.Driver` | Clase del driver JDBC |

> **OJO:** Si tu usuario de MySQL tiene contraseña, escríbela en `db.password`.

---

## Cómo compilar el proyecto

Desde la raíz del proyecto (donde está el `pom.xml`):

```bash
mvn clean compile
```

Si todo está bien verás `BUILD SUCCESS`. Para generar el **WAR** (sin correr los tests):

```bash
mvn package -DskipTests
```

El archivo se generará en `target/inmobiliaria.war`.

---

## Cómo ejecutar la aplicación

### Opción A: Desde Tomcat

1. Copia `target/inmobiliaria.war` a la carpeta `webapps` de Tomcat.
2. Inicia Tomcat y abre:
   ```
   http://localhost:8080/inmobiliaria/
   ```
3. Verás el catálogo de propiedades (página de inicio).

### Opción B: Desde una IDE (NetBeans recomendado)

Abre el proyecto, configura un servidor Tomcat y ejecuta.

---

## Credenciales de acceso

Los datos de prueba del DML incluyen usuarios con los roles:

| Rol | Correo | Contraseña |
|-----|--------|------------|
| **ADMIN** | `admin@inmobiliaria.com` | `admin123` |
| **AGENTE** (inmobiliaria 1) | `agente.centro@inmobiliaria.com` | `Clave123*` |
| **AGENTE** (inmobiliaria 2) | `agente.norte@inmobiliaria.com` | *(ver nota)* |
| **CLIENTE** | `maria.rojas@correo.com` (u otro usuario 4-9) | *(ver nota)* |

> **Nota importante sobre contraseñas:** el DML original guardaba para los usuarios
> 2-10 un hash BCrypt "de ejemplo" que **no corresponde a ninguna contraseña real**
> (por eso el login daba "Correo o contraseña incorrectos"). En esta sesión se regeneró
> y actualizó en la BD la contraseña del **agente 1** a `Clave123*`. Los demás usuarios
> (agente 2 y clientes) aún tienen el hash roto; para usarlos hay que regenerar su hash
> BCrypt y actualizar `password_hash` en la tabla `usuario`.

---

## Flujos web y controladores

Cada servlet es un controlador mapeado por anotación `@WebServlet`. Los principales:

| URL | Servlet | Descripción |
|-----|---------|-------------|
| `/` | — | `index.jsp` → catálogo público |
| `/propiedades` | `PropiedadServlet` | Búsqueda/listado del catálogo |
| `/propiedades/detalle` | `PropiedadDetalleServlet` | Ficha de una propiedad |
| `/inmobiliaria/propiedades/formulario` | `PropiedadFormServlet` | Crear/editar propiedad + imágenes |
| `/login`, `/logout`, `/registro` | `Login`, `Logout`, `Registro` | Autenticación |
| `/cliente/dashboard` | `ClienteDashboardServlet` | Panel del cliente |
| `/cliente/favoritos` | `FavoritoServlet` | Favoritos del cliente |
| `/cliente/perfil` | `PerfilServlet` | Perfil del cliente |
| `/cliente/solicitudes` | `SolicitudServlet` | Solicitudes del cliente |
| `/cliente/solicitudes/documentos` | `DocumentoServlet` | Subida/descarga de documentos |
| `/inmobiliaria/dashboard` | `InmobiliariaDashboardServlet` | Panel de la inmobiliaria |
| `/inmobiliaria/solicitudes` | `AgenteSolicitudServlet` | Aprobar/rechazar solicitudes |
| `/admin/dashboard` | `AdminDashboardServlet` | Panel del admin |

### Protección por URL (AuthFilter)

El filtro `AuthFilter` exige sesión y rol según el prefijo de la URL:

| Prefijo de URL | Rol requerido |
|----------------|---------------|
| `/admin/*` | ADMIN |
| `/agente/*`, `/inmobiliaria/*` | AGENTE |
| `/cliente/*` | CLIENTE |
| Otros | acceso público |

Además del filtro, el servlet revalida autorización a nivel de recurso: el GET de
edición de `PropiedadFormServlet` responde `403` si el agente autenticado no es dueño
de la propiedad editada (por ejemplo, `agente.norte` no puede editar propiedades de la
inmobiliaria 1). Esta validación es independiente del rol exigido por URL.

### Flujo del módulo de solicitudes (agente)

1. El agente inicia sesión (`/login`) → entra a `/inmobiliaria/dashboard`.
2. Desde el dashboard pulsa **"Gestionar solicitudes"** → `/inmobiliaria/solicitudes`.
3. `AgenteSolicitudServlet` localiza la inmobiliaria del usuario con
   `InmobiliariaDAO.buscarPorUsuario()`, obtiene sus propiedades con
   `PropiedadDAO.listarPorInmobiliaria()` y junta las solicitudes de cada una con
   `SolicitudDAO.listarPorPropiedad()`.
4. La vista `inmobiliaria/solicitudes.jsp` lista cada solicitud con botones
   **Aprobar** / **Rechazar** (POST).
5. El POST valida que la solicitud pertenezca a una propiedad de la inmobiliaria del
   agente y cambia el estado con `SolicitudDAO.cambiarEstado()` (solo permite
   `APROBADA` o `RECHAZADA`).

---

## Cómo funciona la conexión a la base de datos

Toda la conexión pasa por `ConnectionFactory` (`com.inmobiliaria.config.ConnectionFactory`).

Al cargar la clase (bloque `static`) lee `db.properties` del classpath y carga el driver.
Luego el método estático:

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

## Buenas prácticas implementadas

- **Separación en capas:** `model` / `dao` / `service` / `web` (servlets). El DAO habla
  con la base de datos; el servlet habla con el mundo exterior (HTTP, disco).
- **Seguridad contra inyección SQL:** todos los valores del usuario viajan como
  parámetros de `PreparedStatement` (text blocks `"""..."""` para SQL); nunca se
  concatena entrada del usuario en la consulta.
- **Contraseñas con BCrypt:** nunca en texto plano; se verifican con `BCrypt.checkpw()`.
- **Autorización por recurso:** además de los roles por URL (`AuthFilter`), los
  servlets revalidan la pertenencia del dato (p. ej. `PropiedadFormServlet`
  comprueba con `perteneceAlAgente()` que la propiedad pertenezca a la inmobiliaria
  del agente autenticado antes de dejarlo editar).
- **Manejo de duplicados:** la excepción `DuplicidadException` traduce las violaciones
  UNIQUE de MySQL a mensajes claros para el usuario.
- **Validación en servlets:** mensajes de error en español, sin exponer excepciones
  crudas de Java.
- **UTF-8 en todo:** `web.xml` fuerza `page-encoding` UTF-8 para `.jsp` y `.jspf`, y
  `CodificacionFilter` garantiza la codificación de los requests.
- **Subida de archivos con multipart:** imágenes de propiedades y documentos de
  solicitudes usan `@MultipartConfig` y se guardan en disco con nombres únicos
  (UUID), conservando solo la ruta en la BD.

---

## Notas finales

Pendiente en siguientes pasos:

- Crear las vistas JSP de cliente para solicitudes y documentos
  (`formulario-solicitud.jsp`, `mis-solicitudes.jsp`, `documentos.jsp`).
- Módulo de auditoría: DAO/servlet sobre la tabla `auditoria` (ya existe en el esquema).
- Regenerar contraseñas BCrypt de los usuarios de prueba restantes (agente 2 y clientes).
- Tests unitarios con JUnit (dependencia ya incluida en `pom.xml`).
