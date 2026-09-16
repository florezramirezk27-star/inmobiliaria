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
         * Algunas rutas exigen sesión iniciada, pero pueden usarlas varios
         * roles (por ejemplo /propiedades/citas la ve el cliente para pedir
         * una visita y el agente para gestionarla).
         */
        boolean soloLogin =
                requiereSoloLogin(path);

        /*
         * Si la ruta no necesita autenticación,
         * dejamos pasar.
         */
        if (rolRequerido == null && !soloLogin) {
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
         * Ruta que solo exige estar autenticado
         * (cualquier rol), sin comprobar uno en concreto.
         */
        if (soloLogin) {
            chain.doFilter(request, response);
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

            resp.sendRedirect(
                    contextPath + "/acceso-denegado"
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
                || path.equals("/index")
                || path.equals("/index.jsp")
                || path.equals("/catalogo.jsp")
                || path.equals("/propiedades")
                || path.equals("/propiedades/detalle")
                || path.equals("/acceso-denegado")
                || path.equals("/favicon.ico")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/img/")
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

        // Citas: el cambio de estado es solo del agente de la inmobiliaria.
        if ("/propiedades/citas/estado".equals(path)) {
            return "AGENTE";
        }

        // Las demás operaciones privadas restantes son de cliente:
        // listar favoritos, alternar favorito, listar mis citas.
        if ("/favoritos".equals(path)
                || "/propiedades/favorito".equals(path)
                || "/citas".equals(path)) {
            return "CLIENTE";
        }

        return null;
    }

    /**
     * Rutas que requieren sesión iniciada pero no un rol concreto:
     * la ficha de citas de una propiedad la usa el cliente (pedir visita)
     * y el agente (gestionar el estado).
     */
    private boolean requiereSoloLogin(String path) {
        return "/propiedades/citas".equals(path)
                || "/logout".equals(path);
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
