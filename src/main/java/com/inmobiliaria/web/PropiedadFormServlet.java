package com.inmobiliaria.web;

import com.inmobiliaria.dao.CaracteristicaDAO;
import com.inmobiliaria.dao.CiudadDAO;
import com.inmobiliaria.dao.DuplicidadException;
import com.inmobiliaria.dao.ImagenPropiedadDAO;
import com.inmobiliaria.dao.InmobiliariaDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.dao.TipoPropiedadDAO;
import com.inmobiliaria.model.Caracteristica;
import com.inmobiliaria.model.EstadoPropiedad;
import com.inmobiliaria.model.ImagenPropiedad;
import com.inmobiliaria.model.Inmobiliaria;
import com.inmobiliaria.model.Operacion;
import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.model.TipoPropiedad;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

/**
 * Formulario de creación y edición de propiedades — incluye también
 * la asignación de características (checkboxes) y la subida de
 * fotos, todo en un mismo envío.
 *
 * GET /propiedades/formulario           -> formulario en blanco (crear)
 * GET /propiedades/formulario?id=5      -> formulario con los datos, las
 *                                          características marcadas y las
 *                                          fotos ya cargadas de la
 *                                          propiedad 5 (editar)
 * POST /propiedades/formulario          -> guarda todo: datos,
 *                                          características e imágenes
 *                                          nuevas, en una sola pasada
 *
 * ADVERTENCIA IMPORTANTE sobre las imágenes subidas — probado y
 * confirmado en este mismo proyecto: las fotos se guardan con
 * getRealPath() dentro de la carpeta donde Tomcat expande el WAR
 * (webapps/inmobiliaria/img/propiedades/). Esa carpeta se BORRA cada
 * vez que se despliega un WAR nuevo (ya lo vimos en el log de Tomcat:
 * "An expanded directory ... will be deleted"). Es decir: si subes
 * fotos, luego haces `mvn clean package` + redeploy, esas fotos
 * físicas desaparecen aunque la fila en `imagen_propiedad` siga
 * apuntando a ellas (quedaría como imagen rota). Para que una foto
 * sobreviva a un redeploy, hay que copiarla manualmente a
 * src/main/webapp/img/propiedades/ para que quede empaquetada en el
 * próximo WAR. Esto no lo pude evitar sin salirme de las tecnologías
 * que exige el enunciado (JDBC + JSP, sin un servicio externo de
 * almacenamiento) — es una limitación conocida, no un bug.
 *
 * Nota de auth, igual que antes: sin login integrado todavía, sin
 * control de acceso por rol. Ver el comentario original de esta
 * clase en el commit anterior para el detalle completo.
 */
@WebServlet("/propiedades/formulario")
@MultipartConfig(
        maxFileSize = 5L * 1024 * 1024,       // 5 MB por archivo
        maxRequestSize = 25L * 1024 * 1024,   // 25 MB por envío completo
        fileSizeThreshold = 0
)
public class PropiedadFormServlet extends HttpServlet {

    private static final Set<String> TIPOS_MIME_PERMITIDOS =
            Set.of("image/jpeg", "image/png", "image/webp");

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final CiudadDAO ciudadDAO = new CiudadDAO();
    private final TipoPropiedadDAO tipoPropiedadDAO = new TipoPropiedadDAO();
    private final InmobiliariaDAO inmobiliariaDAO = new InmobiliariaDAO();
    private final CaracteristicaDAO caracteristicaDAO = new CaracteristicaDAO();
    private final ImagenPropiedadDAO imagenDAO = new ImagenPropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Siempre presente, aunque quede vacío: evita invocar .contains()
        // sobre null en el EL del JSP cuando se está creando una propiedad
        // nueva (sin id todavía).
        request.setAttribute("caracteristicasAsignadas", new HashSet<Integer>());

        try {
            cargarCatalogos(request);

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isBlank()) {
                int id = Integer.parseInt(idParam.trim());
                Propiedad existente = propiedadDAO.buscarPorId(id);

                if (existente == null) {
                    request.setAttribute("error", "La propiedad solicitada no existe.");
                } else {
                    request.setAttribute("propiedad", existente);
                    request.setAttribute("caracteristicasAsignadas",
                            idsDe(caracteristicaDAO.listarPorPropiedad(id)));
                    request.setAttribute("imagenesActuales",
                            imagenDAO.listarPorPropiedad(id));
                }
            }

        } catch (SQLException e) {
            getServletContext().log("Error al cargar el formulario de propiedad", e);
            request.setAttribute("error",
                    "No fue posible cargar el formulario en este momento. Intenta de nuevo en unos minutos.");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "El identificador de la propiedad no es válido.");
        }

        request.getRequestDispatcher("/formulario-propiedad.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // La codificación UTF-8 de este request ya la garantiza
        // CodificacionFilter (aplica a toda la app, no solo aquí) — ver
        // el javadoc de esa clase para el porqué era necesario.
        request.setAttribute("caracteristicasAsignadas", new HashSet<Integer>());

        try {
            cargarCatalogos(request);
        } catch (SQLException e) {
            getServletContext().log("Error al cargar catálogos del formulario", e);
        }

        List<String> errores = validar(request);

        if (!errores.isEmpty()) {
            request.setAttribute("errores", errores);
            request.getRequestDispatcher("/formulario-propiedad.jsp").forward(request, response);
            return;
        }

        Propiedad p = construirDesde(request);
        String idParam = request.getParameter("idPropiedad");
        boolean esEdicion = idParam != null && !idParam.isBlank();

        try {
            if (esEdicion) {
                p.setId(Integer.parseInt(idParam));
                propiedadDAO.actualizar(p);
            } else {
                propiedadDAO.insertar(p);
            }

            guardarCaracteristicas(request, p.getId());
            guardarImagenesNuevas(request, p.getId());
            procesarEliminacionesDeImagen(request, p.getId());
            procesarCambioDePortada(request, p.getId());

            response.sendRedirect(request.getContextPath()
                    + "/propiedades/detalle?id=" + p.getId() + "&guardado=1");

        } catch (DuplicidadException e) {
            // El enunciado exige capturar el UNIQUE duplicado y mostrar un
            // mensaje claro, no una excepción cruda de Java.
            request.setAttribute("errores", List.of(e.getMessage()));
            request.setAttribute("propiedad", p);
            request.getRequestDispatcher("/formulario-propiedad.jsp").forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Error al guardar la propiedad", e);
            request.setAttribute("errores",
                    List.of("No fue posible guardar la propiedad en este momento. Intenta de nuevo en unos minutos."));
            request.setAttribute("propiedad", p);
            request.getRequestDispatcher("/formulario-propiedad.jsp").forward(request, response);
        }
    }

    // ============================================================
    // Características
    // ============================================================

    /** Lee los checkboxes marcados (idsCaracteristica=3&idsCaracteristica=7...) y reemplaza la asignación completa. */
    private void guardarCaracteristicas(HttpServletRequest request, int propiedadId) throws SQLException {

        String[] seleccionadas = request.getParameterValues("idsCaracteristica");
        List<Integer> ids = new ArrayList<>();

        if (seleccionadas != null) {
            for (String valor : seleccionadas) {
                try {
                    ids.add(Integer.parseInt(valor.trim()));
                } catch (NumberFormatException ignorado) {
                    // un valor manipulado a mano en el checkbox se ignora en
                    // vez de tumbar el guardado completo
                }
            }
        }

        caracteristicaDAO.reemplazarAsignaciones(propiedadId, ids);
    }

    // ============================================================
    // Imágenes
    // ============================================================

    /**
     * Guarda en disco cada archivo nuevo recibido en el campo
     * "imagenesNuevas" (input file con `multiple`) y crea su fila en
     * imagen_propiedad. Los Part vacíos (el usuario no seleccionó
     * nada en ese slot) se ignoran sin error.
     */
    private void guardarImagenesNuevas(HttpServletRequest request, int propiedadId)
            throws IOException, ServletException, SQLException {

        for (Part parte : request.getParts()) {

            if (!"imagenesNuevas".equals(parte.getName())) {
                continue;
            }

            String nombreOriginal = parte.getSubmittedFileName();
            if (nombreOriginal == null || nombreOriginal.isBlank() || parte.getSize() == 0) {
                continue; // slot de archivo vacío, no es un error
            }

            String tipoMime = parte.getContentType();
            if (tipoMime == null || !TIPOS_MIME_PERMITIDOS.contains(tipoMime.toLowerCase())) {
                getServletContext().log("Imagen rechazada por tipo no permitido: "
                        + nombreOriginal + " (" + tipoMime + ")");
                continue; // se ignora en silencio; no bloquea el resto del guardado
            }

            String extension = extensionSegura(nombreOriginal, tipoMime);
            String nombreArchivo = "prop-" + propiedadId + "-" + UUID.randomUUID() + extension;

            Path carpetaDestino = carpetaDeImagenes();
            Files.createDirectories(carpetaDestino);
            Path archivoDestino = carpetaDestino.resolve(nombreArchivo);

            try (InputStream in = parte.getInputStream()) {
                Files.copy(in, archivoDestino, StandardCopyOption.REPLACE_EXISTING);
            }

            ImagenPropiedad imagen = new ImagenPropiedad();
            imagen.setPropiedadId(propiedadId);
            imagen.setRuta("img/propiedades/" + nombreArchivo);
            imagen.setTextoAlt(request.getParameter("titulo")); // texto alternativo razonable por defecto
            imagen.setOrden(0);

            imagenDAO.insertar(imagen);
        }
    }

    private void procesarEliminacionesDeImagen(HttpServletRequest request, int propiedadId) throws SQLException {

        String[] aEliminar = request.getParameterValues("eliminarImagen");
        if (aEliminar == null) {
            return;
        }

        for (String valor : aEliminar) {
            try {
                int idImagen = Integer.parseInt(valor.trim());
                ImagenPropiedad imagen = imagenDAO.buscarPorId(idImagen);

                // Verifica que la imagen sea de ESTA propiedad antes de
                // borrar nada — evita que alguien manipule el id en el
                // formulario y borre la foto de otra propiedad.
                if (imagen != null && imagen.getPropiedadId() == propiedadId) {
                    imagenDAO.eliminar(idImagen);
                    borrarArchivoFisico(imagen.getRuta());
                }
            } catch (NumberFormatException ignorado) {
                // valor manipulado a mano; se ignora sin tumbar el resto
            }
        }
    }

    private void procesarCambioDePortada(HttpServletRequest request, int propiedadId) throws SQLException {

        String idPortada = request.getParameter("imagenPortada");
        if (idPortada == null || idPortada.isBlank()) {
            return;
        }

        try {
            imagenDAO.marcarPortada(Integer.parseInt(idPortada.trim()), propiedadId);
        } catch (NumberFormatException ignorado) {
            // valor manipulado a mano; se ignora sin tumbar el resto
        }
    }

    private void borrarArchivoFisico(String rutaRelativa) {
        try {
            String realPath = getServletContext().getRealPath("/" + rutaRelativa);
            if (realPath != null) {
                Files.deleteIfExists(Paths.get(realPath));
            }
        } catch (IOException e) {
            // No borrar el archivo físico no debe tumbar el resto del
            // guardado — a lo sumo queda un archivo huérfano en disco,
            // que un redeploy limpia de todas formas (ver advertencia
            // al inicio de esta clase).
            getServletContext().log("No se pudo borrar el archivo físico: " + rutaRelativa, e);
        }
    }

    private Path carpetaDeImagenes() {
        String real = getServletContext().getRealPath("/img/propiedades");
        return Paths.get(real);
    }

    private String extensionSegura(String nombreOriginal, String tipoMime) {
        return switch (tipoMime.toLowerCase()) {
            case "image/png" -> ".png";
            case "image/webp" -> ".webp";
            default -> ".jpg"; // image/jpeg y cualquier otro caso ya filtrado antes de llegar aquí
        };
    }

    // ============================================================
    // Catálogos y validación (igual que antes, sin cambios de fondo)
    // ============================================================

    private void cargarCatalogos(HttpServletRequest request) throws SQLException {
        request.setAttribute("ciudades", ciudadDAO.listarTodas());
        request.setAttribute("tiposPropiedad", tipoPropiedadDAO.listarTodos());
        request.setAttribute("inmobiliarias", inmobiliariaDAO.listarTodas());
        request.setAttribute("todasLasCaracteristicas", caracteristicaDAO.listarTodas());
        request.setAttribute("categoriasCaracteristica",
                List.of("INTERIOR", "EXTERIOR", "CONJUNTO", "SEGURIDAD"));
    }

    private List<String> validar(HttpServletRequest request) {

        List<String> errores = new ArrayList<>();

        exigirTexto(request, "codigo", "El código es obligatorio.", errores);
        exigirTexto(request, "matriculaInmobiliaria", "La matrícula inmobiliaria es obligatoria.", errores);
        exigirTexto(request, "titulo", "El título es obligatorio.", errores);
        exigirTexto(request, "direccion", "La dirección es obligatoria.", errores);

        if (Operacion.desde(request.getParameter("operacion")) == null) {
            errores.add("Selecciona si la propiedad es en arriendo o en venta.");
        }

        exigirEntero(request, "idTipoPropiedad", "Selecciona el tipo de inmueble.", errores);
        exigirEntero(request, "idCiudad", "Selecciona la ciudad.", errores);
        exigirEntero(request, "idInmobiliaria", "Selecciona la inmobiliaria que publica.", errores);

        String precio = request.getParameter("precio");
        if (precio == null || precio.isBlank()) {
            errores.add("El precio es obligatorio.");
        } else {
            try {
                if (new BigDecimal(precio.trim()).compareTo(BigDecimal.ZERO) <= 0) {
                    errores.add("El precio debe ser mayor que cero.");
                }
            } catch (NumberFormatException e) {
                errores.add("El precio debe ser un número válido.");
            }
        }

        String estrato = request.getParameter("estrato");
        if (estrato != null && !estrato.isBlank()) {
            try {
                int valor = Integer.parseInt(estrato.trim());
                if (valor < 1 || valor > 6) {
                    errores.add("El estrato debe estar entre 1 y 6.");
                }
            } catch (NumberFormatException e) {
                errores.add("El estrato debe ser un número entre 1 y 6.");
            }
        }

        return errores;
    }

    private void exigirTexto(HttpServletRequest request, String campo, String mensaje, List<String> errores) {
        String valor = request.getParameter(campo);
        if (valor == null || valor.isBlank()) {
            errores.add(mensaje);
        }
    }

    private void exigirEntero(HttpServletRequest request, String campo, String mensaje, List<String> errores) {
        String valor = request.getParameter(campo);
        if (valor == null || valor.isBlank()) {
            errores.add(mensaje);
            return;
        }
        try {
            Integer.parseInt(valor.trim());
        } catch (NumberFormatException e) {
            errores.add(mensaje);
        }
    }

    @SuppressWarnings("unchecked")
    private Propiedad construirDesde(HttpServletRequest request) {

        Propiedad p = new Propiedad();

        p.setCodigo(request.getParameter("codigo").trim());
        p.setMatriculaInmobiliaria(request.getParameter("matriculaInmobiliaria").trim());
        p.setTitulo(request.getParameter("titulo").trim());
        p.setDescripcion(vacioComoNulo(request.getParameter("descripcion")));
        p.setOperacion(Operacion.desde(request.getParameter("operacion")));
        p.setEstado(EstadoPropiedad.desde(request.getParameter("estado")) != null
                ? EstadoPropiedad.desde(request.getParameter("estado"))
                : EstadoPropiedad.BORRADOR);

        p.setTipoPropiedadId(Integer.parseInt(request.getParameter("idTipoPropiedad").trim()));
        p.setCiudadId(Integer.parseInt(request.getParameter("idCiudad").trim()));

        int idInmobiliaria = Integer.parseInt(request.getParameter("idInmobiliaria").trim());
        p.setInmobiliariaId(idInmobiliaria);

        List<Inmobiliaria> inmobiliarias = (List<Inmobiliaria>) request.getAttribute("inmobiliarias");
        for (Inmobiliaria i : inmobiliarias) {
            if (i.getId() == idInmobiliaria) {
                p.setUsuarioId(i.getUsuarioId());
                break;
            }
        }

        p.setPrecio(new BigDecimal(request.getParameter("precio").trim()));
        p.setAdministracion(parseDecimalONulo(request.getParameter("administracion"), BigDecimal.ZERO));
        p.setAreaConstruida(parseDecimalONulo(request.getParameter("areaConstruida"), null));
        p.setAreaLote(parseDecimalONulo(request.getParameter("areaLote"), null));

        p.setHabitaciones(parseEnteroOCero(request.getParameter("habitaciones")));
        p.setBanos(parseEnteroOCero(request.getParameter("banos")));
        p.setParqueaderos(parseEnteroOCero(request.getParameter("parqueaderos")));
        p.setEstrato(parseEnteroONulo(request.getParameter("estrato")));
        p.setAntiguedadAnios(parseEnteroONulo(request.getParameter("antiguedadAnios")));

        p.setDireccion(request.getParameter("direccion").trim());
        p.setBarrio(vacioComoNulo(request.getParameter("barrio")));

        return p;
    }

    private Set<Integer> idsDe(List<Caracteristica> caracteristicas) {
        Set<Integer> ids = new HashSet<>();
        for (Caracteristica c : caracteristicas) {
            ids.add(c.getId());
        }
        return ids;
    }

    private String vacioComoNulo(String valor) {
        return (valor == null || valor.isBlank()) ? null : valor.trim();
    }

    private int parseEnteroOCero(String valor) {
        if (valor == null || valor.isBlank()) {
            return 0;
        }
        try {
            return Integer.parseInt(valor.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private Integer parseEnteroONulo(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }
        try {
            return Integer.parseInt(valor.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private BigDecimal parseDecimalONulo(String valor, BigDecimal porDefecto) {
        if (valor == null || valor.isBlank()) {
            return porDefecto;
        }
        try {
            return new BigDecimal(valor.trim());
        } catch (NumberFormatException e) {
            return porDefecto;
        }
    }
}
