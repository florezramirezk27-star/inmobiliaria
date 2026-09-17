package com.inmobiliaria.web;

import com.inmobiliaria.dao.InmobiliariaDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.dao.SolicitudDAO;
import com.inmobiliaria.model.Inmobiliaria;
import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.model.Solicitud;
import com.inmobiliaria.model.EstadoSolicitud;

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

@WebServlet("/inmobiliaria/solicitudes")
public class AgenteSolicitudServlet extends HttpServlet {

    private final SolicitudDAO solicitudDAO = new SolicitudDAO();
    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final InmobiliariaDAO inmobiliariaDAO = new InmobiliariaDAO();

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
                        "/WEB-INF/views/inmobiliaria/solicitudes.jsp"
                ).forward(request, response);

                return;
            }

            List<Propiedad> propiedades =
                    propiedadDAO.listarPorInmobiliaria(
                            inmobiliaria.getId()
                    );

            List<Solicitud> solicitudes = new ArrayList<>();

            for (Propiedad propiedad : propiedades) {

                solicitudes.addAll(
                        solicitudDAO.listarPorPropiedad(
                                propiedad.getId()
                        )
                );
            }

            request.setAttribute(
                    "solicitudes",
                    solicitudes
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/inmobiliaria/solicitudes.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            getServletContext().log(
                    "Error al cargar solicitudes del agente",
                    e
            );

            request.setAttribute(
                    "error",
                    "No fue posible cargar las solicitudes."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/inmobiliaria/solicitudes.jsp"
            ).forward(request, response);
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

        String idParam =
                request.getParameter("id");

        String estadoParam =
                request.getParameter("estado");

        if (idParam == null || estadoParam == null) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            return;
        }

        try {

            int idSolicitud =
                    Integer.parseInt(idParam);

            EstadoSolicitud estado =
                    EstadoSolicitud.desde(estadoParam);

            if (estado == null
                    || (estado != EstadoSolicitud.APROBADA
                    && estado != EstadoSolicitud.RECHAZADA)) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                return;
            }

            /*
             * Aquí se valida que la solicitud pertenece
             * a una propiedad de la inmobiliaria del agente.
             */

            int usuarioId =
                    (int) session.getAttribute("usuarioId");

            Inmobiliaria inmobiliaria =
                    inmobiliariaDAO.buscarPorUsuario(usuarioId);

            if (inmobiliaria == null) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN
                );

                return;
            }

            Solicitud solicitud =
                    solicitudDAO.buscarPorId(idSolicitud);

            if (solicitud == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND
                );

                return;
            }

            Propiedad propiedad =
                    propiedadDAO.buscarPorId(
                            solicitud.getPropiedadId()
                    );

            if (propiedad == null
                    || propiedad.getInmobiliariaId()
                    != inmobiliaria.getId()) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN
                );

                return;
            }

            solicitudDAO.cambiarEstado(
                    idSolicitud,
                    estado
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/inmobiliaria/solicitudes"
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Error al actualizar solicitud",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );
        }
    }
}
