# Inmobiliaria

Aplicación web Java (JSP + Servlets + MySQL) para la gestión de una inmobiliaria.

Proyecto académico del curso **Programación en Java** — 1º Corte.

---

## Tabla de contenidos

1. [Descripción del proyecto](#descripción-del-proyecto)
2. [Tecnologías utilizadas](#tecnologías-utilizadas)
3. [Estructura del proyecto](#estructura-del-proyecto)
4. [Requisitos previos](#requisitos-previos)
5. [Configuración de la base de datos](#configuración-de-la-base-de-datos)
6. [Cómo compilar el proyecto](#cómo-compilar-el-proyecto)
7. [Cómo ejecutar la aplicación](#cómo-ejecutar-la-aplicación)
8. [Cómo funciona la conexión a la base de datos](#cómo-funciona-la-conexión-a-la-base-de-datos)
9. [Prueba de conexión](#prueba-de-conexión)
10. [Buenas prácticas implementadas](#buenas-prácticas-implementadas)

---

## Descripción del proyecto

Este es el punto de partida de un sistema de **inmobiliaria**. Actualmente el proyecto
cuenta con la base inicial: un proyecto **Maven** con empaquetado **WAR** (listo para
ejecutarse en un servidor web como Apache Tomcat), la configuración para conectarse a
una base de datos **MySQL** y una primera página de bienvenida.

La funcionalidad de negocio (gestión de propiedades, clientes, ventas, etc.) se irá
agregando en las siguientes etapas del curso.

---

## Tecnologías utilizadas

| Tecnología | Descripción |
|------------|-------------|
| **Java 21** | Lenguaje de programación |
| **Maven** | Herramienta de construcción y gestión de dependencias |
| **JSP / Servlet** | Tecnologías web de Java (Java EE) |
| **MySQL** | Motor de base de datos relacional |
| **MySQL Connector/J** | Driver JDBC para conectar Java con MySQL |
| **Tomcat 8.5+** | Servidor de aplicaciones web donde se despliega el proyecto |

---

## Estructura del proyecto

```
inmobiliaria/
│
├── pom.xml                              # Configuración de Maven (dependencias y plugins)
│
└── src/
    ├── main/
    │   ├── java/
    │   │   └── com/inmobiliaria/config/
    │   │       ├── ConnectionFactory.java   # Fábrica de conexiones a MySQL
    │   │       └── DatabaseTest.java         # Clase de prueba de conexión
    │   │
    │   ├── resources/
    │   │   └── db.properties                # Datos de conexión a la BD
    │   │
    │   └── webapp/
    │       ├── index.jsp                    # Página de bienvenida
    │       └── WEB-INF/
    │           └── web.xml                  # Descriptor de la aplicación web
    │
    └── test/                               # (aún sin contenido - se agregará luego)
```

### Descripción de cada archivo

| Archivo | Función |
|---------|---------|
| `pom.xml` | Declara las dependencias (servlet, JSP, JSTL, MySQL, BCrypt, JUnit) y los plugins de compilación y empaquetado. |
| `ConnectionFactory.java` | Clase encargada de leer la config y devolver conexiones a la base de datos. |
| `DatabaseTest.java` | Ejecutable que comprueba si la conexión a MySQL funciona. |
| `db.properties` | Archivo de configuración con la URL, usuario y contraseña de la BD. |
| `index.jsp` | Página de bienvenida que se muestra al abrir la aplicación. |
| `web.xml` | Descriptor de despliegue de la aplicación web (actualmente mínimo). |

---

## Requisitos previos

Antes de compilar y ejecutar el proyecto necesitas tener instalados:

1. **JDK 21** (o superior compatible)
   - Verificar con: `java -version`
2. **Maven 3.8+**
   - Verificar con: `mvn -version`
3. **MySQL Server** corriendo localmente en el puerto 3306
4. **Apache Tomcat 8.5+** (para ejecutar la aplicación web)

---

## Configuración de la base de datos

1. Crea la base de datos en MySQL:

```sql
CREATE DATABASE inmobiliaria;
```

2. Configura los datos de conexión en el archivo
   `src/main/resources/db.properties`:

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

> **OJO:** Si tu usuario de MySQL tiene contraseña, debes escribirla en `db.password`.

---

## Cómo compilar el proyecto

Desde la carpeta raíz del proyecto (donde está el `pom.xml`), ejecuta:

```bash
mvn clean compile
```

Si todo está bien, verás `BUILD SUCCESS`.

Para generar el archivo ejecutable **WAR** (sin correr los tests):

```bash
mvn package -DskipTests
```

El archivo se generará en:

```
target/inmobiliaria.war
```

---

## Cómo ejecutar la aplicación

### Opción A: Desde Tomcat (despliegue web)

1. Copia el archivo `target/inmobiliaria.war` dentro de la carpeta `webapps` de Tomcat.
2. Inicia Tomcat.
3. Abre en el navegador:

```
http://localhost:8080/inmobiliaria/
```

Deberías ver la página de bienvenida: **"Inmobiliaria — Aplicación Java Web funcionando correctamente."**

### Opción B: Directamente desde una IDE (NetBeans recomendado)

1. Abre el proyecto en la IDE.
2. Configura un servidor Tomcat.
3. Haz clic en **Run** / **Ejecutar**.

---

## Cómo funciona la conexión a la base de datos

La conexión a MySQL se maneja a través de la clase
`ConnectionFactory` (`com.inmobiliaria.config.ConnectionFactory`).

### `ConnectionFactory.java`

Al cargar la clase (bloque `static`):

1. Lee el archivo `db.properties` desde el classpath mediante la clase loader.
2. Carga el driver con `Class.forName(...)`.
3. Guarda los valores en un objeto `Properties`.

Luego, el método estático `getConnection()`:

```java
public static Connection getConnection() throws SQLException {
    return DriverManager.getConnection(
            properties.getProperty("db.url"),
            properties.getProperty("db.username"),
            properties.getProperty("db.password")
    );
}
```

Devuelve una conexión activa a la base de datos usando `DriverManager`.

---

## Prueba de conexión

Existe una clase de prueba ejecutable: `DatabaseTest.java`.

Para probar que la conexión a MySQL funciona:

```bash
mvn exec:java -Dexec.mainClass="com.inmobiliaria.config.DatabaseTest"
```

O desde una IDE ejecutando el método `main` de la clase `DatabaseTest`.

### Resultado esperado (si la conexión es correcta):

```
=================================
CONEXIÓN EXITOSA
Base de datos conectada correctamente
=================================
```

### Si hay un error, verás:

```
=================================
ERROR DE CONEXIÓN
=================================
```

y luego el detalle del error (`stack trace`).

---

## Buenas prácticas implementadas

- **Gestión de dependencias con Maven:** las librerías (como el driver de MySQL)
  se declaran en el `pom.xml` y Maven las descarga y empaqueta automáticamente.
  No es necesario guardar los `.jar` manualmente en el proyecto.

- **Configuración externa:** los datos sensibles de la BD se guardan en un archivo
  `db.properties`, no están "quemados" en el código.

- **Separación de responsabilidades:** la lógica de conexión está aislada en una
  clase propia (`ConnectionFactory`), lista para ser reutilizada por futuros DAO.

- **Empleo de try-with-resources:** en `DatabaseTest` la conexión se abre dentro
  de un `try` con recursos, de modo que se cierra automáticamente.

- **Lenguaje y codificación UTF-8:** tanto en las páginas web como en los mensajes,
  se usa UTF-8 para soportar caracteres en español (tildes, ñ, etc.).

---

## Notas finales

Este proyecto va creciendo por etapas. En los siguientes cortes se espera agregar:

- Modelos y DAOs para las entidades del negocio (propiedades, clientes, agentes).
- Servlets / Controladores con la lógica de las peticiones.
- Vistas JSP para el CRUD.
- Autenticación y manejo de sesiones (BCrypt ya está incluido en el `pom.xml`).
- Tests unitarios con JUnit.
