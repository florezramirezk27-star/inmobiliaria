package com.inmobiliaria.web;

import com.inmobiliaria.dao.ReporteDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/reportes")
public class ReporteServlet extends HttpServlet {

    private final ReporteDAO reporteDAO = new ReporteDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "propiedadesPublicadas",
                reporteDAO.propiedadesPublicadas()
        );

        request.setAttribute(
                "citasActivas",
                reporteDAO.citasActivas()
        );

        request.setAttribute(
                "propiedadesSinCitas",
                reporteDAO.propiedadesSinCitas()
        );

        request.setAttribute(
                "resumenPorCiudad",
                reporteDAO.resumenPorCiudad()
        );

        String idPropiedadParam =
                request.getParameter("idPropiedad");

        int idPropiedad = 1;

        if (idPropiedadParam != null && !idPropiedadParam.isBlank()) {

            try {
                idPropiedad = Integer.parseInt(idPropiedadParam);
            } catch (NumberFormatException e) {
                idPropiedad = 1;
            }
        }

        request.setAttribute(
                "idPropiedadSeleccionada",
                idPropiedad
        );

        request.setAttribute(
                "caracteristicasPropiedad",
                reporteDAO.caracteristicasPropiedad(idPropiedad)
        );

        request.getRequestDispatcher(
                "/WEB-INF/views/admin/reportes.jsp"
        ).forward(request, response);
    }
}