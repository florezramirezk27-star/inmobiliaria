package com.inmobiliaria.web;

import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.dao.SolicitudDAO;
import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.model.Solicitud;
import com.inmobiliaria.model.TipoSolicitud;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Gestión de solicitudes de compra o arriendo de un cliente.
 *
 * GET /cliente/solicitudes                  -> listado de mis solicitudes
 * GET /cliente/solicitudes/nueva?id=5       -> prepara el formulario para la propiedad 5
 * POST /cliente/solicitudes/nueva           -> registra la solicitud sobre una propiedad
 *
 * La url-mapping queda bajo /cliente/* para que AuthFilter exiga sesión iniciada
 * y el rol CLIENTE, igual que hace con los favoritos.
 */
@WebServlet("/cliente/solicitudes")
public class SolicitudServlet extends HttpServlet {

    private final SolicitudDAO solicitudDAO = new SolicitudDAO();
    private final PropiedadDAO propiedadDAO = new PropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int idCliente = (int) session.getAttribute("usuarioId");

        String accion = request.getParameter("accion");

        try {
            if ("nueva".equals(accion)) {
                cargarFormulario(request, idCliente);
                request.getRequestDispatcher("/WEB-INF/views/cliente/formulario-solicitud.jsp")
                        .forward(request, response);
                return;
            }

            request.setAttribute("solicitudes", solicitudDAO.listarPorCliente(idCliente));
            request.getRequestDispatcher("/WEB-INF/views/cliente/mis-solicitudes.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Error al listar las solicitudes del cliente", e);
            request.setAttribute("error",
                    "No fue posible cargar tus solicitudes en este momento. Intenta de nuevo en unos minutos.");
            request.getRequestDispatcher("/WEB-INF/views/cliente/mis-solicitudes.jsp")
                    .forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "El identificador de la propiedad no es válido.");
            request.getRequestDispatcher("/WEB-INF/views/cliente/mis-solicitudes.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int idCliente = (int) session.getAttribute("usuarioId");

        List<String> errores = validar(request);

        if (!errores.isEmpty()) {
            request.setAttribute("errores", errores);
            cargarPropiedad(request);
            request.getRequestDispatcher("/WEB-INF/views/cliente/formulario-solicitud.jsp")
                    .forward(request, response);
            return;
        }

        Solicitud solicitud = construirDesde(request, idCliente);

        try {
            solicitudDAO.insertar(solicitud);
            response.sendRedirect(request.getContextPath()
                    + "/cliente/solicitudes?creada=1");

        } catch (SQLException e) {
            getServletContext().log("Error al registrar la solicitud", e);
            request.setAttribute("errores",
                    List.of("No fue posible registrar la solicitud en este momento. Intenta de nuevo en unos minutos."));
            request.setAttribute("solicitud", solicitud);
            cargarPropiedad(request);
            request.getRequestDispatcher("/WEB-INF/views/cliente/formulario-solicitud.jsp")
                    .forward(request, response);
        }
    }

    // ============================================================
    // Apoyo interno
    // ============================================================

    /** Carga la propiedad elegida para que el formulario la muestre al cliente. */
    private void cargarFormulario(HttpServletRequest request, int idCliente) throws SQLException {
        cargarPropiedad(request);
    }

    private void cargarPropiedad(HttpServletRequest request) {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            return;
        }
        try {
            int idPropiedad = Integer.parseInt(idParam.trim());
            Propiedad propiedad = propiedadDAO.buscarPorId(idPropiedad);
            if (propiedad != null) {
                request.setAttribute("propiedad", propiedad);
                request.setAttribute("idPropiedad", idPropiedad);
            }
        } catch (SQLException | NumberFormatException e) {
            getServletContext().log("No se pudo cargar la propiedad del formulario de solicitud", e);
        }
    }

    private List<String> validar(HttpServletRequest request) {

        List<String> errores = new ArrayList<>();

        String idPropiedad = request.getParameter("idPropiedad");
        if (idPropiedad == null || idPropiedad.isBlank()) {
            errores.add("Selecciona la propiedad sobre la que quieres solicitar.");
        } else {
            try {
                if (Integer.parseInt(idPropiedad.trim()) <= 0) {
                    errores.add("La propiedad seleccionada no es válida.");
                }
            } catch (NumberFormatException e) {
                errores.add("La propiedad seleccionada no es válida.");
            }
        }

        if (TipoSolicitud.desde(request.getParameter("tipo")) == null) {
            errores.add("Selecciona si la solicitud es de compra o de arriendo.");
        }

        return errores;
    }

    private Solicitud construirDesde(HttpServletRequest request, int idCliente) {

        Solicitud solicitud = new Solicitud();

        solicitud.setPropiedadId(Integer.parseInt(request.getParameter("idPropiedad").trim()));
        solicitud.setClienteId(idCliente);
        solicitud.setTipo(TipoSolicitud.desde(request.getParameter("tipo")));
        solicitud.setComentario(vacioComoNulo(request.getParameter("comentario")));

        return solicitud;
    }

    private String vacioComoNulo(String valor) {
        return (valor == null || valor.isBlank()) ? null : valor.trim();
    }
}
