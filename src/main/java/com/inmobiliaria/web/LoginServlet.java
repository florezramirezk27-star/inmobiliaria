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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String correo = req.getParameter("correo");
        String password = req.getParameter("password");

        try {
            Usuario usuario = authService.autenticar(correo, password);

            if (usuario == null) {
                req.setAttribute("error", "Correo o contraseña incorrectos");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            req.getSession().setAttribute("usuario", usuario);
            resp.sendRedirect(req.getContextPath() + "/index.jsp");

        } catch (SQLException e) {
            throw new ServletException("Error al iniciar sesión", e);
        }
    }
}
