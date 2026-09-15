# Guía de entrega — Rediseño UI Inmobiliaria

Proyecto: Programación en Java · Sustentación jueves 17 de septiembre de 2026

---

## 1. Instalación

```bash
mv ~/Downloads/rediseno-completo.zip ~/inmobiliaria/
cd ~/inmobiliaria
unzip -o rediseno-completo.zip
./INSTALAR.sh
```

El script hace las 4 cosas en orden: respalda (commit de Git o copia de `src/`), unifica tipografía e iconos en las 13 pantallas restantes, compila con Maven y despliega el WAR limpiando el caché de Tomcat.

Al terminar, reinicia Tomcat 8.5 desde el **Tomcat Control**: detener → esperar rojo → iniciar → esperar verde.

Abre `http://localhost:8081/inmobiliaria/`

---

## 2. Archivos modificados (20)

### Reescritos a mano (13)

| Archivo | Cambio |
|---|---|
| `css/estilos.css` | Hoja única. Inter, paleta definitiva, todas las clases viejas conservadas |
| `WEB-INF/includes/navbar.jspf` | 72px, logo con marca, correo del usuario, hamburguesa animada |
| `WEB-INF/includes/footer.jspf` | 3 columnas, verde oscuro, compacto |
| `index.jsp` | Hero + CTA, sección de confianza, tarjetas 16:10 |
| `catalogo.jsp` | Encabezado propio, container 1240px, estado vacío con icono |
| `detalle-propiedad.jsp` | Breadcrumb, galería 8/4, panel de precio sticky, chips por categoría |
| `WEB-INF/views/auth/login.jsp` | Split 50/50 + botón ver contraseña |
| `WEB-INF/views/auth/registro.jsp` | 2 columnas, obligatorios marcados con `*` |
| `WEB-INF/views/cliente/dashboard.jsp` | Saludo con correo, 4 tarjetas de acceso con icono |
| `WEB-INF/views/cliente/favoritos.jsp` | Navbar + footer, estado vacío, botón ver propiedad |
| `WEB-INF/views/cliente/perfil.jsp` | Navbar + footer, formulario en panel, ayuda por campo |
| `WEB-INF/views/inmobiliaria/solicitudes.jsp` | Navbar + footer, tabla con scroll, badges por estado |
| `WEB-INF/views/admin/perfil-usuario.jsp` | Navbar + footer, resumen de cuenta + roles como chips |

### Unificados por script (13, solo el `<head>`)

`favoritos.jsp` · `citas-propiedad.jsp` · `mis-citas.jsp` · `formulario-propiedad.jsp` · `auth/confirmar-logout.jsp` · `cliente/documentos.jsp` · `cliente/formulario-solicitud.jsp` · `cliente/mis-solicitudes.jsp` · `inmobiliaria/dashboard.jsp` · `admin/auditoria.jsp` · `admin/dashboard.jsp` · `admin/reportes.jsp` · `admin/usuarios.jsp`

Estas adoptan la nueva identidad automáticamente porque `estilos.css` conserva todos los nombres de clase originales (`.tarjeta-prop`, `.chip`, `.metrica`, `.banner-panel`, `.tabla-tema`...).

---

## 3. Bugs corregidos

**1. El filtro de ciudad no funcionaba desde la landing.**
`index.jsp` enviaba `value="bucaramanga"` (texto) pero `PropiedadServlet` espera el ID numérico. Ahora envía `1`/`2`/`3`/`4`, igual que `catalogo.jsp`. Este filtro simplemente no devolvía resultados.

**2. `documento` sin `required` en el registro.**
La columna es `NOT NULL UNIQUE`; sin el campo el INSERT podía fallar con un error feo. Ahora es obligatorio en el cliente y está marcado visualmente.

**3. Las tarjetas sin foto mostraban una "ilustración".**
`.foto-prop` tenía un degradado decorativo que parecía contenido real (el bloque verde de Oficina, Local y Bodega). Ahora es gris neutro.

**4. El zoom en hover desbordaba la tarjeta.**
Añadido `.marco-foto` con `overflow:hidden`.

**5. Cuatro pantallas sin navegación.**
`cliente/favoritos`, `cliente/perfil`, `inmobiliaria/solicitudes` y `admin/perfil-usuario` no cargaban ni el CSS ni la navbar: se veían como Bootstrap crudo y el usuario quedaba atrapado sin menú.

---

## 4. Lo que NO se tocó (a propósito)

- Los 20 Servlets
- DAOs, modelos, services, filtros
- `web.xml`
- Cualquier clase `.class`
- `/login.jsp` y `/registro.jsp` de la raíz — son legacy, ningún Servlet los sirve
- Estructura de base de datos
- Lógica de sesión, roles, BCrypt

---

## 5. Contrato de backend verificado

60 puntos comprobados uno por uno antes de empaquetar:

| Zona | Verificado |
|---|---|
| Login | `action=/login`, `method=post`, `name=correo`, `name=password`, scriptlet de error, `?registro` |
| Registro | `nombres`, `apellidos`, `correo`, `password`, `confirmPassword`, `documento`, `telefono`, `direccion` |
| Filtros | `operacion`, `ciudad`, `tipo`, `precioMax` |
| Favoritos | `propiedadId`, `volver` |
| Sesión | `sessionScope.roles`, `sessionScope.usuarioId`, `esCliente`, `esAgente` |
| Solicitudes agente | `id`, `estado`, valores `APROBADA` / `RECHAZADA` |
| Perfil | `idUsuario`, `foto`, y los getters del modelo `Perfil` |

En las 13 pantallas transformadas por script, el conteo de `${...}`, `<c:...>`, `name=` y `action=` es **idéntico** antes y después.

---

## 6. Checklist de sustentación

Recorre en este orden. Cada paso debe funcionar sin errores de consola.

### Visitante
- [ ] Landing carga con hero y buscador
- [ ] **Filtro ciudad = Bucaramanga → devuelve resultados** (era el bug)
- [ ] Filtro operación Arriendo / Venta
- [ ] Filtro precio máximo
- [ ] Clic en una tarjeta → ficha de detalle con galería
- [ ] Breadcrumb Inicio / Propiedades funciona
- [ ] "Limpiar filtros" vuelve al catálogo completo
- [ ] Menú hamburguesa en móvil (reduce la ventana a 390px)

### Cliente
- [ ] Login → redirige a `/cliente/dashboard`
- [ ] Botón "ver contraseña" funciona
- [ ] Dashboard muestra el correo y las 4 tarjetas
- [ ] Guardar un favorito desde el catálogo (corazón se pinta)
- [ ] Mis favoritos lista la propiedad
- [ ] Quitar favorito
- [ ] Mis favoritos vacío → estado vacío con CTA
- [ ] Agendar visita desde la ficha
- [ ] Mis citas
- [ ] Radicar solicitud
- [ ] Mi perfil → guardar cambios → mensaje verde
- [ ] Cerrar sesión

### Agente
- [ ] Login → `/inmobiliaria/dashboard`
- [ ] "Publicar propiedad" aparece en la navbar
- [ ] Formulario de propiedad
- [ ] Solicitudes: aprobar y rechazar, badges cambian de color
- [ ] Cerrar sesión

### Admin
- [ ] Login → `/admin/dashboard`
- [ ] Usuarios
- [ ] Perfil de un usuario → guardar
- [ ] Auditoría
- [ ] Reportes
- [ ] Cerrar sesión

### Seguridad
- [ ] Con sesión de CLIENTE, escribir a mano `/admin/dashboard` → debe bloquear
- [ ] Sin sesión, escribir `/cliente/dashboard` → debe mandar a login

### Responsive
Prueba en 1440 / 1024 / 768 / 390 px:
- [ ] 3 tarjetas por fila en desktop, 2 en tablet, 1 en móvil
- [ ] Sin scroll horizontal
- [ ] Navbar colapsa correctamente
- [ ] Login: la franja de imagen desaparece bajo 992px
- [ ] Tablas del panel no rompen la pantalla

---

## 7. Cosas que aún pueden aparecer

**Hero sin foto.** El CSS busca `img/hero.jpg`. Si no existe queda verde sólido — se ve bien igual. Si quieres foto, copia cualquier JPG horizontal ahí:
```bash
cp <tu-foto>.jpg ~/inmobiliaria/src/main/webapp/img/hero.jpg
```
Se usa también en el fondo del login y el registro.

**Iconos cuadrados vacíos.** Significa que el CDN de Bootstrap Icons no cargó. Requiere internet. Si vas a presentar sin conexión, descarga el CSS y sírvelo local.

**PIE-0007 (el lote) sin fotos.** No es un error: esa propiedad nunca tuvo imágenes cargadas. La tarjeta sale en gris neutro.

**El panel admin mantiene sus banners de color.** Los tonos se suavizaron a la paleta, pero la estructura es la original. Si prefieres unificarlos del todo, es un cambio de 4 líneas en `estilos.css` (`.banner-usuarios`, `.banner-auditoria`, `.banner-reportes`, `.banner-citas`).

---

## 8. Revertir si algo sale mal

Con Git:
```bash
cd ~/inmobiliaria
git reset --hard HEAD~1
mvn clean package
cp target/inmobiliaria.war ~/tools/apache-tomcat-8.5.100/webapps/
```

Sin Git, el script dejó la carpeta `backup-ui-<fecha>/`:
```bash
cd ~/inmobiliaria
rm -rf src && cp -r backup-ui-<fecha> src
mvn clean package
cp target/inmobiliaria.war ~/tools/apache-tomcat-8.5.100/webapps/
```

---

## 9. Antes de las 3:00 p.m. del jueves

1. Corre el checklist completo de la sección 6.
2. Congela el código: `git commit -m "version final sustentacion"`.
3. Crea una copia estable fuera del proyecto:
   ```bash
   cp ~/inmobiliaria/target/inmobiliaria.war ~/Desktop/inmobiliaria-FINAL.war
   ```
4. Haz un respaldo de la base de datos:
   ```bash
   mysqldump -u root -p87654321 inmobiliaria > ~/Desktop/inmobiliaria-FINAL.sql
   ```
5. Deja Tomcat corriendo y la landing abierta antes de empezar a presentar.
