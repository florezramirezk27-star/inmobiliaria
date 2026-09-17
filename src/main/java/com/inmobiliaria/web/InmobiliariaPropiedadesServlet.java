package com.inmobiliaria.web;

import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.InmobiliariaDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.EstadoPropiedad;
import com.inmobiliaria.model.Inmobiliaria;
import com.inmobiliaria.model.Propiedad;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Listado de las propiedades del agente y baja lógica de las mismas.
 *
 * GET  /inmobiliaria/propiedades  -> tabla con estado y acciones
 * POST /inmobiliaria/propiedades  -> accion=darDeBaja (UPDATE estado=CERRADA)
 *
 * La baja lógica se hace con PropiedadDAO.cambiarEstado(), nunca con
 * DELETE; al quedar CERRADA, la vista v_propiedad_catalogo la excluye
 * automáticamente del catálogo público.
 */
@WebServlet("/inmobiliaria/propiedades")
public class InmobiliariaPropiedadesServlet extends HttpServlet {

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final InmobiliariaDAO inmobiliariaDAO = new InmobiliariaDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        int usuarioId =
                (int) session.getAttribute("usuarioId");

        try {

            Inmobiliaria inmobiliaria =
                    inmobiliariaDAO.buscarPorUsuario(usuarioId);

            if (inmobiliaria == null) {

                request.setAttribute(
                        "error",
                        "El usuario no tiene una inmobiliaria asociada."
                );

                request.getRequestDispatcher(
                        "/WEB-INF/views/inmobiliaria/propiedades.jsp"
                ).forward(request, response);

                return;
            }

            List<Propiedad> propiedades =
                    propiedadDAO.listarPorInmobiliaria(
                            inmobiliaria.getId()
                    );

            request.setAttribute("propiedades", propiedades);

            request.getRequestDispatcher(
                    "/WEB-INF/views/inmobiliaria/propiedades.jsp"
            ).forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Error al consultar las propiedades de la inmobiliaria.",
                    e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        int usuarioId =
                (int) session.getAttribute("usuarioId");

        String accion = request.getParameter("accion");

        try {

            switch (accion == null ? "" : accion) {

                case "darDeBaja":
                    darDeBaja(request, response, session, usuarioId);
                    break;

                default:
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Acción no válida."
                    );
            }

        } catch (SQLException e) {

            getServletContext().log(
                    "Error en la baja lógica de la propiedad.",
                    e
            );

            session.setAttribute(
                    "error",
                    "No fue posible dar de baja la propiedad. "
                            + "Intenta de nuevo en unos minutos."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/inmobiliaria/propiedades"
            );
        }
    }

    /**
     * Baja lógica: establece estado = CERRADA sobre la propiedad.
     * Solo si la propiedad pertenece a la inmobiliaria del agente.
     */
    private void darDeBaja(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            int usuarioId)
            throws IOException, SQLException {

        int idPropiedad = Integer.parseInt(
                request.getParameter("id").trim()
        );

        Inmobiliaria inmobiliaria =
                inmobiliariaDAO.buscarPorUsuario(usuarioId);

        Propiedad propiedad =
                propiedadDAO.buscarPorId(idPropiedad);

        if (inmobiliaria == null
                || propiedad == null
                || propiedad.getInmobiliariaId()
                        != inmobiliaria.getId()) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "La propiedad no pertenece a tu inmobiliaria."
            );
            return;
        }

        if (propiedad.getEstado() == EstadoPropiedad.CERRADA) {

            session.setAttribute(
                    "exito",
                    "La propiedad ya estaba dada de baja."
            );

        } else {

            propiedadDAO.cambiarEstado(
                    idPropiedad,
                    EstadoPropiedad.CERRADA
            );

            auditoriaDAO.registrar(
                    usuarioId,
                    "DAR_DE_BAJA_PROPIEDAD",
                    "propiedad",
                    idPropiedad,
                    "Propiedad marcada como CERRADA (baja lógica): "
                            + propiedad.getTitulo()
            );

            session.setAttribute(
                    "exito",
                    "La propiedad «"
                            + propiedad.getTitulo()
                            + "» se dio de baja y ya no aparece "
                            + "en el catálogo público."
            );
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/inmobiliaria/propiedades"
        );
    }
}