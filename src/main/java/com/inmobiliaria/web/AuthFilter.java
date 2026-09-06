package com.inmobiliaria.web;

import com.inmobiliaria.model.Rol;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No necesita configuración adicional.
    }

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpServletResponse resp =
                (HttpServletResponse) response;

        String uri = req.getRequestURI();

        String contextPath =
                req.getContextPath();

        String path =
                uri.substring(contextPath.length());

        /*
         * ==========================
         * RUTAS PÚBLICAS
         * ==========================
         */

        if (esRutaPublica(path)) {
            chain.doFilter(request, response);
            return;
        }

        /*
         * ==========================
         * RUTAS PROTEGIDAS
         * ==========================
         */

        String rolRequerido =
                obtenerRolRequerido(path);

        /*
         * Si la ruta no necesita autenticación,
         * dejamos pasar.
         */
        if (rolRequerido == null) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session =
                req.getSession(false);

        /*
         * ==========================
         * COMPROBAR SESIÓN
         * ==========================
         */

        boolean autenticado =
                session != null
                && session.getAttribute("usuario") != null;

        if (!autenticado) {

            resp.sendRedirect(
                    contextPath + "/login"
            );

            return;
        }

        /*
         * ==========================
         * COMPROBAR ROL
         * ==========================
         */

        @SuppressWarnings("unchecked")
        List<Rol> roles =
                (List<Rol>) session.getAttribute("roles");

        if (!tieneRol(roles, rolRequerido)) {

            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "No tienes permisos para acceder a esta sección."
            );

            return;
        }

        /*
         * ==========================
         * TODO CORRECTO
         * ==========================
         */

        chain.doFilter(request, response);
    }

    /**
     * Determina si una ruta es pública.
     */
    private boolean esRutaPublica(String path) {

        return path.equals("/")
                || path.equals("/index.jsp")
                || path.equals("/catalogo.jsp")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.equals("/login")
                || path.equals("/registro");
    }

    /**
     * Determina qué rol necesita una ruta.
     */
    private String obtenerRolRequerido(String path) {

        if (path.startsWith("/admin/")) {
            return "ADMIN";
        }

        if (path.startsWith("/agente/")
                || path.startsWith("/inmobiliaria/")) {
            return "AGENTE";
        }

        if (path.startsWith("/cliente/")) {
            return "CLIENTE";
        }

        return null;
    }

    /**
     * Comprueba si el usuario posee el rol requerido.
     */
    private boolean tieneRol(
            List<Rol> roles,
            String rolRequerido
    ) {

        if (roles == null) {
            return false;
        }

        for (Rol rol : roles) {

            if (rol != null
                    && rol.getNombre() != null
                    && rol.getNombre()
                    .equalsIgnoreCase(rolRequerido)) {

                return true;
            }
        }

        return false;
    }

    @Override
    public void destroy() {
        // No hay recursos que liberar.
    }
}
