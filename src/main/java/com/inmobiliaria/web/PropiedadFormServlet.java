package com.inmobiliaria.web;

import com.inmobiliaria.dao.CiudadDAO;
import com.inmobiliaria.dao.DuplicidadException;
import com.inmobiliaria.dao.InmobiliariaDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.dao.TipoPropiedadDAO;
import com.inmobiliaria.model.Ciudad;
import com.inmobiliaria.model.EstadoPropiedad;
import com.inmobiliaria.model.Inmobiliaria;
import com.inmobiliaria.model.Operacion;
import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.model.TipoPropiedad;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Formulario de creación y edición de propiedades.
 *
 * GET /propiedades/formulario           -> formulario en blanco (crear)
 * GET /propiedades/formulario?id=5      -> formulario con los datos de la
 *                                          propiedad 5 (editar)
 * POST /propiedades/formulario          -> guarda; si el request trae
 *                                          idPropiedad, actualiza; si no,
 *                                          inserta
 *
 * Nota temporal: todavía no existe login integrado en develop, así que
 * no hay un usuario autenticado del que tomar el rol ni el id_usuario.
 * Por eso este servlet no está protegido por ningún filtro de rol y
 * el id_usuario que queda en la propiedad se deriva del agente dueño
 * de la inmobiliaria seleccionada (inmobiliaria.id_usuario), no de una
 * sesión. Cuando el módulo de autenticación de auth-security se integre,
 * hay que:
 *   1) Mapear este servlet detrás de un filtro que solo deje pasar al
 *      rol INMOBILIARIA (o ADMIN).
 *   2) Tomar id_usuario de la sesión en lugar de derivarlo aquí.
 */
@WebServlet("/propiedades/formulario")
public class PropiedadFormServlet extends HttpServlet {

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final CiudadDAO ciudadDAO = new CiudadDAO();
    private final TipoPropiedadDAO tipoPropiedadDAO = new TipoPropiedadDAO();
    private final InmobiliariaDAO inmobiliariaDAO = new InmobiliariaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            cargarCatalogos(request);

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isBlank()) {
                Propiedad existente = propiedadDAO.buscarPorId(Integer.parseInt(idParam));
                if (existente == null) {
                    request.setAttribute("error", "La propiedad solicitada no existe.");
                } else {
                    request.setAttribute("propiedad", existente);
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

        try {
            String idParam = request.getParameter("idPropiedad");

            if (idParam != null && !idParam.isBlank()) {
                p.setId(Integer.parseInt(idParam));
                propiedadDAO.actualizar(p);
            } else {
                propiedadDAO.insertar(p);
            }

            response.sendRedirect(request.getContextPath() + "/propiedades?guardado=1");

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

    /** Carga las listas para los <select> del formulario en atributos del request. */
    private void cargarCatalogos(HttpServletRequest request) throws SQLException {
        request.setAttribute("ciudades", ciudadDAO.listarTodas());
        request.setAttribute("tiposPropiedad", tipoPropiedadDAO.listarTodos());
        request.setAttribute("inmobiliarias", inmobiliariaDAO.listarTodas());
    }

    /**
     * Valida los campos obligatorios y sus formatos antes de tocar la base
     * de datos. El enunciado exige "campos obligatorios, formatos válidos
     * ... y mensajes de error comprensibles para el usuario final" — por
     * eso esta validación ocurre en el servlet, no solo confiando en los
     * atributos required del HTML (que el usuario puede saltarse).
     */
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

    /** Arma el objeto Propiedad a partir de los parámetros ya validados. */
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

        // El usuario que "registra" la propiedad se deriva del agente dueño
        // de la inmobiliaria seleccionada — ver la nota al inicio de la clase
        // sobre por qué no viene de una sesión todavía.
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
