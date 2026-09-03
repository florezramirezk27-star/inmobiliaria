package com.inmobiliaria.web;

import com.inmobiliaria.model.Usuario;
import com.inmobiliaria.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/registro.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String correo = req.getParameter("correo");
        String password = req.getParameter("password");

        try {
            Usuario usuario = authService.registrar(correo, password, "ACTIVO");
            req.getSession().setAttribute("usuario", usuario);
            resp.sendRedirect(req.getContextPath() + "/index.jsp");

        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Error al registrar el usuario", e);
        }
    }
}
