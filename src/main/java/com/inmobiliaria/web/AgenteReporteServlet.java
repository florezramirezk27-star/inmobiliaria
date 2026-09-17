package com.inmobiliaria.web;

import com.inmobiliaria.dao.InmobiliariaDAO;
import com.inmobiliaria.dao.ReporteDAO;
import com.inmobiliaria.model.Inmobiliaria;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/inmobiliaria/reportes")
public class AgenteReporteServlet extends HttpServlet {

    private final InmobiliariaDAO inmobiliariaDAO =
            new InmobiliariaDAO();

    private final ReporteDAO reporteDAO =
            new ReporteDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        Object usuarioIdSesion =
                session == null
                        ? null
                        : session.getAttribute("usuarioId");

        if (!(usuarioIdSesion instanceof Integer usuarioId)) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        try {

            Inmobiliaria inmobiliaria =
                    inmobiliariaDAO.buscarPorUsuario(usuarioId);

            if (inmobiliaria == null) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "El agente no tiene una inmobiliaria asignada."
                );

                return;
            }

            int idInmobiliaria =
                    inmobiliaria.getId();

            request.setAttribute(
                    "inmobiliaria",
                    inmobiliaria
            );

            request.setAttribute(
                    "resumenOperaciones",
                    reporteDAO.resumenOperacionesInmobiliaria(
                            idInmobiliaria
                    )
            );

            request.setAttribute(
                    "solicitudesPorTipoEstado",
                    reporteDAO
                            .solicitudesPorTipoEstadoInmobiliaria(
                                    idInmobiliaria
                            )
            );

            request.setAttribute(
                    "operacionesAprobadas",
                    reporteDAO.operacionesAprobadasInmobiliaria(
                            idInmobiliaria
                    )
            );

        } catch (SQLException | RuntimeException e) {

            getServletContext().log(
                    "Error al cargar los reportes del agente",
                    e
            );

            request.setAttribute(
                    "error",
                    "No fue posible cargar los reportes en este momento."
            );

            request.setAttribute(
                    "resumenOperaciones",
                    List.of()
            );

            request.setAttribute(
                    "solicitudesPorTipoEstado",
                    List.of()
            );

            request.setAttribute(
                    "operacionesAprobadas",
                    List.of()
            );
        }

        request.getRequestDispatcher(
                "/WEB-INF/views/inmobiliaria/reportes.jsp"
        ).forward(request, response);
    }
}
