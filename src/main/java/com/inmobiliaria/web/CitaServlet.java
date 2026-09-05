package com.inmobiliaria.web;

import com.inmobiliaria.dao.CitaDAO;
import com.inmobiliaria.dao.DuplicidadException;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.Cita;
import com.inmobiliaria.model.EstadoCita;
import com.inmobiliaria.model.Propiedad;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Agendamiento de visitas.
 *
 * GET  /propiedades/citas?id=5        -> ficha de la propiedad 5: sus
 *                                        citas agendadas + formulario
 *                                        para pedir una nueva
 * POST /propiedades/citas             -> agenda una visita nueva
 * POST /propiedades/citas/estado      -> confirma/rechaza/cancela/marca
 *                                        realizada una cita existente
 * GET  /citas                         -> "Mis citas": las del cliente
 *                                        de prueba, en todas las
 *                                        propiedades
 *
 * Mismo patrón temporal que FavoritoServlet y PropiedadFormServlet:
 * sin login integrado todavía, USUARIO_PRUEBA_ID hace de "cliente"
 * que agenda. La gestión de estado (confirmar/rechazar) debería
 * quedar restringida al rol INMOBILIARIA cuando el auth esté listo;
 * por ahora los botones están visibles para cualquiera.
 */
@WebServlet({"/propiedades/citas", "/propiedades/citas/estado", "/citas"})
public class CitaServlet extends HttpServlet {

    private static final int USUARIO_PRUEBA_ID = 4;

    private final CitaDAO citaDAO = new CitaDAO();
    private final PropiedadDAO propiedadDAO = new PropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ruta = request.getServletPath();

        if ("/citas".equals(ruta)) {
            mostrarMisCitas(request, response);
        } else {
            mostrarCitasDeLaPropiedad(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ruta = request.getServletPath();

        if ("/propiedades/citas/estado".equals(ruta)) {
            cambiarEstado(request, response);
        } else {
            agendarVisita(request, response);
        }
    }

    // ============================================================
    // GET /propiedades/citas?id=X
    // ============================================================

    private void mostrarCitasDeLaPropiedad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isBlank()) {
            request.setAttribute("error", "No se indicó de qué propiedad mostrar las citas.");
            request.getRequestDispatcher("/citas-propiedad.jsp").forward(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idParam.trim());
            Propiedad propiedad = propiedadDAO.buscarPorId(id);

            if (propiedad == null) {
                request.setAttribute("error", "La propiedad solicitada no existe.");
            } else {
                request.setAttribute("propiedad", propiedad);
                request.setAttribute("citas", citaDAO.listarPorPropiedad(id));
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "El identificador de la propiedad no es válido.");
        } catch (SQLException e) {
            getServletContext().log("Error al cargar las citas de la propiedad", e);
            request.setAttribute("error",
                    "No fue posible cargar las citas en este momento. Intenta de nuevo en unos minutos.");
        }

        request.getRequestDispatcher("/citas-propiedad.jsp").forward(request, response);
    }

    // ============================================================
    // GET /citas — "Mis citas"
    // ============================================================

    private void mostrarMisCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Cita> citas = citaDAO.listarPorCliente(USUARIO_PRUEBA_ID);
            request.setAttribute("citas", citas);

        } catch (SQLException e) {
            getServletContext().log("Error al cargar mis citas", e);
            request.setAttribute("citas", List.of());
            request.setAttribute("errorConsulta",
                    "No fue posible cargar tus citas en este momento. Intenta de nuevo en unos minutos.");
        }

        request.getRequestDispatcher("/mis-citas.jsp").forward(request, response);
    }

    // ============================================================
    // POST /propiedades/citas — agendar
    // ============================================================

    private void agendarVisita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idPropiedadParam = request.getParameter("propiedadId");
        String fechaHoraParam = request.getParameter("fechaHora");

        int propiedadId;
        try {
            propiedadId = Integer.parseInt(idPropiedadParam.trim());
        } catch (NumberFormatException | NullPointerException e) {
            response.sendRedirect(request.getContextPath() + "/propiedades");
            return;
        }

        List<String> errores = new java.util.ArrayList<>();
        LocalDateTime fechaHora = null;

        if (fechaHoraParam == null || fechaHoraParam.isBlank()) {
            errores.add("Selecciona la fecha y hora de la visita.");
        } else {
            try {
                // El <input type="datetime-local"> manda "yyyy-MM-ddTHH:mm",
                // que LocalDateTime.parse() acepta directamente (los segundos
                // son opcionales al parsear con el formato ISO por defecto).
                fechaHora = LocalDateTime.parse(fechaHoraParam.trim());
                if (fechaHora.isBefore(LocalDateTime.now())) {
                    errores.add("La fecha y hora de la visita debe ser en el futuro.");
                }
            } catch (DateTimeParseException e) {
                errores.add("La fecha y hora no tiene un formato válido.");
            }
        }

        if (!errores.isEmpty()) {
            volverAFormularioConError(request, response, propiedadId, errores);
            return;
        }

        try {
            Cita cita = new Cita();
            cita.setPropiedadId(propiedadId);
            cita.setClienteId(USUARIO_PRUEBA_ID);
            cita.setFechaHora(fechaHora);
            cita.setEstado(EstadoCita.SOLICITADA);
            cita.setObservacion(vacioComoNulo(request.getParameter("observacion")));

            citaDAO.agendar(cita);

            response.sendRedirect(request.getContextPath()
                    + "/propiedades/citas?id=" + propiedadId + "&agendada=1");

        } catch (DuplicidadException e) {
            volverAFormularioConError(request, response, propiedadId, List.of(e.getMessage()));

        } catch (SQLException e) {
            getServletContext().log("Error al agendar la visita", e);
            volverAFormularioConError(request, response, propiedadId,
                    List.of("No fue posible agendar la visita en este momento. Intenta de nuevo en unos minutos."));
        }
    }

    private void volverAFormularioConError(HttpServletRequest request, HttpServletResponse response,
                                            int propiedadId, List<String> errores)
            throws ServletException, IOException {

        try {
            Propiedad propiedad = propiedadDAO.buscarPorId(propiedadId);
            request.setAttribute("propiedad", propiedad);
            request.setAttribute("citas", citaDAO.listarPorPropiedad(propiedadId));
        } catch (SQLException ignorado) {
            // si ni siquiera esto carga, la JSP igual muestra los errores
        }

        request.setAttribute("errores", errores);
        request.getRequestDispatcher("/citas-propiedad.jsp").forward(request, response);
    }

    // ============================================================
    // POST /propiedades/citas/estado — confirmar/rechazar/etc.
    // ============================================================

    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idCitaParam = request.getParameter("citaId");
        String nuevoEstadoParam = request.getParameter("nuevoEstado");
        String volver = request.getParameter("volver");

        try {
            int idCita = Integer.parseInt(idCitaParam.trim());
            EstadoCita nuevoEstado = EstadoCita.desde(nuevoEstadoParam);

            if (nuevoEstado != null) {
                citaDAO.cambiarEstado(idCita, nuevoEstado);
            }

        } catch (NumberFormatException | SQLException e) {
            getServletContext().log("Error al cambiar el estado de la cita", e);
            // No se interrumpe la redirección por esto: el usuario
            // simplemente no ve el cambio reflejado, no un error 500.
        }

        String contexto = request.getContextPath();
        boolean esRutaInterna = volver != null && volver.startsWith(contexto + "/");
        response.sendRedirect(esRutaInterna ? volver : contexto + "/propiedades");
    }

    private String vacioComoNulo(String valor) {
        return (valor == null || valor.isBlank()) ? null : valor.trim();
    }
}
