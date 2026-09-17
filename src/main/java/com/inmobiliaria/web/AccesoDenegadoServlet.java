package com.inmobiliaria.web;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Muestra una respuesta amigable cuando un usuario autenticado
 * intenta acceder a una sección para la que no posee el rol requerido.
 */
@WebServlet("/acceso-denegado")
public class AccesoDenegadoServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        response.setStatus(HttpServletResponse.SC_FORBIDDEN);

        request.getRequestDispatcher(
                "/WEB-INF/views/error/acceso-denegado.jsp"
        ).forward(request, response);
    }
}
