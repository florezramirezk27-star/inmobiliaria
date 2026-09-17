package com.inmobiliaria.web;

import com.inmobiliaria.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

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
                "/WEB-INF/views/auth/registro.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombres =
                request.getParameter("nombres");

        String apellidos =
                request.getParameter("apellidos");

        String correo =
                request.getParameter("correo");

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");

        String documento =
                request.getParameter("documento");

        String telefono =
                request.getParameter("telefono");

        String direccion =
                request.getParameter("direccion");

        // Validaciones del lado del servidor: el <input required> del
        // navegador no basta, alguien puede llegar a este POST con una
        // petición hecha a mano. Cada campo se valida con su propio
        // mensaje para que el cliente sepa exactamente qué corregir.

        if (nombres == null || nombres.isBlank()
                || apellidos == null || apellidos.isBlank()
                || correo == null || correo.isBlank()
                || password == null || password.isBlank()
                || confirmPassword == null || confirmPassword.isBlank()
                || documento == null || documento.isBlank()) {

            request.setAttribute(
                    "error",
                    "Todos los campos obligatorios deben completarse."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/registro.jsp"
            ).forward(request, response);

            return;
        }

        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "error",
                    "Las contraseñas no coinciden."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/registro.jsp"
            ).forward(request, response);

            return;
        }

        if (password.length() < 8) {

            request.setAttribute(
                    "error",
                    "La contraseña debe tener mínimo 8 caracteres."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/registro.jsp"
            ).forward(request, response);

            return;
        }

        if (!correo.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {

            request.setAttribute(
                    "error",
                    "El correo ingresado no tiene un formato válido."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/registro.jsp"
            ).forward(request, response);

            return;
        }

        if (!documento.trim().matches("^[0-9]{4,15}$")) {

            request.setAttribute(
                    "error",
                    "El número de documento solo puede contener dígitos (mínimo 4)."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/registro.jsp"
            ).forward(request, response);

            return;
        }

        // El teléfono es opcional, pero si llega escrito se valida su formato.
        if (telefono != null && !telefono.isBlank()
                && !telefono.trim().matches("^[0-9+()\\- ]{7,15}$")) {

            request.setAttribute(
                    "error",
                    "El teléfono tiene un formato inválido: usa solo dígitos, espacios, guiones, paréntesis o el prefijo +."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/registro.jsp"
            ).forward(request, response);

            return;
        }

        try {

            authService.registrar(
                    nombres,
                    apellidos,
                    correo,
                    password,
                    documento,
                    telefono,
                    direccion
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/login?registro=exitoso"
            );

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/registro.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            request.setAttribute(
                    "error",
                    "No fue posible completar el registro."
            );

            e.printStackTrace();

            request.getRequestDispatcher(
                    "/WEB-INF/views/auth/registro.jsp"
            ).forward(request, response);
        }
    }
}
