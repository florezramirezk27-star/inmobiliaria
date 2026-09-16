package com.inmobiliaria.web;

import com.inmobiliaria.dao.CitaDAO;
import com.inmobiliaria.model.Cita;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/citas")
public class AdminCitasServlet extends HttpServlet {

    private final CitaDAO citaDAO = new CitaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            request.setAttribute(
                    "citas",
                    citaDAO.listarTodas()
            );

        } catch (SQLException e) {
            getServletContext().log(
                    "Error al cargar las citas para el administrador",
                    e
            );

            request.setAttribute("citas", List.<Cita>of());
            request.setAttribute(
                    "errorConsulta",
                    "No fue posible cargar las citas en este momento."
            );
        }

        request.getRequestDispatcher(
                "/WEB-INF/views/admin/citas.jsp"
        ).forward(request, response);
    }
}
