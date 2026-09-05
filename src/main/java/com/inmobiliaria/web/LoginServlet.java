package com.inmobiliaria.web;

import com.inmobiliaria.model.Rol;
import com.inmobiliaria.service.AuthService;
import com.inmobiliaria.service.LoginResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/auth/login.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        if (correo == null || correo.isBlank()
                || password == null || password.isBlank()) {

            request.setAttribute(
                    "error",
                    "Correo y contraseña son obligatorios."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/login.jsp"
            ).forward(request, response);

            return;
        }

        LoginResult resultado =
                authService.autenticar(correo, password);

        if (!resultado.isExitoso()) {

            request.setAttribute(
                    "error",
                    resultado.getMensaje()
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/login.jsp"
            ).forward(request, response);

            return;
        }

        HttpSession session = request.getSession(true);

        session.setAttribute(
                "usuario",
                resultado.getUsuario()
        );

        session.setAttribute(
                "usuarioId",
                resultado.getUsuario().getIdUsuario()
        );

        session.setAttribute(
                "correo",
                resultado.getUsuario().getCorreo()
        );

        session.setAttribute(
                "roles",
                resultado.getRoles()
        );

        List<Rol> roles = resultado.getRoles();

        String rolPrincipal =
                roles.get(0).getNombre().toUpperCase();

        switch (rolPrincipal) {

            case "ADMIN":
                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/dashboard"
                );
                break;

            case "AGENTE":
                response.sendRedirect(
                        request.getContextPath()
                                + "/inmobiliaria/dashboard"
                );
                break;

            case "CLIENTE":
                response.sendRedirect(
                        request.getContextPath()
                                + "/cliente/dashboard"
                );
                break;

            default:
                session.invalidate();

                request.setAttribute(
                        "error",
                        "Rol de usuario no reconocido."
                );

                request.getRequestDispatcher(
                        "/WEB-INF/views/auth/login.jsp"
                ).forward(request, response);
        }
    }
}
