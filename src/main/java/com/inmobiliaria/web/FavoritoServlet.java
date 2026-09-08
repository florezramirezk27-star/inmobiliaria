package com.inmobiliaria.web;

import com.inmobiliaria.dao.FavoritoDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.Propiedad;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Marcar/quitar favoritos y ver la lista de "Mis favoritos".
 *
 * GET  /favoritos                    -> catálogo de las propiedades
 *                                       que el usuario marcó
 * POST /propiedades/favorito         -> alterna (agrega o quita) el
 *                                       favorito de una propiedad y
 *                                       vuelve a la página desde la
 *                                       que se llamó
 *
 * El usuario se obtiene siempre de la sesión (usuarioId); nunca se
 * acepta un id de usuario enviado por el cliente. Sin sesión válida
 * se redirige al login.
 */
@WebServlet({
        "/favoritos",
        "/cliente/favoritos",
        "/propiedades/favorito"
})
public class FavoritoServlet extends HttpServlet {

    private final FavoritoDAO favoritoDAO = new FavoritoDAO();
    private final PropiedadDAO propiedadDAO = new PropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer usuarioId = usuarioDeSesion(request, response);
        if (usuarioId == null) {
            return;
        }

        try {
            List<Integer> ids = favoritoDAO.listarIdsPropiedadPorUsuarioOrdenados(usuarioId);
            List<Propiedad> propiedades = new ArrayList<>();

            for (Integer id : ids) {
                Propiedad p = propiedadDAO.buscarPorId(id);
                // Una propiedad pudo borrarse físicamente después de
                // marcarse como favorita; se omite en vez de romper la
                // página completa por una fila huérfana.
                if (p != null) {
                    propiedades.add(p);
                }
            }

            request.setAttribute("propiedades", propiedades);
            // Todas las que se listan aquí ya son favoritas por definición;
            // se pasa igual para que la tarjeta reutilice el mismo botón
            // (siempre pintado "activo") que usa el catálogo.
            request.setAttribute("favoritosIds", new java.util.HashSet<>(ids));

        } catch (SQLException e) {
            getServletContext().log("Error al cargar los favoritos", e);
            request.setAttribute("propiedades", List.of());
            request.setAttribute("favoritosIds", java.util.Set.of());
            request.setAttribute("errorConsulta",
                    "No fue posible cargar tus favoritos en este momento. Intenta de nuevo en unos minutos.");
        }

        request.getRequestDispatcher("/favoritos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer usuarioId = usuarioDeSesion(request, response);
        if (usuarioId == null) {
            return;
        }

        String idParam = request.getParameter("propiedadId");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int propiedadId = Integer.parseInt(idParam.trim());

                if (favoritoDAO.esFavorito(usuarioId, propiedadId)) {
                    favoritoDAO.quitar(usuarioId, propiedadId);
                } else {
                    favoritoDAO.agregar(usuarioId, propiedadId);
                }

            } catch (NumberFormatException | SQLException e) {
                getServletContext().log("Error al alternar favorito", e);
                // No se interrumpe la redirección por esto: el usuario
                // simplemente no ve el cambio reflejado, no un error 500.
            }
        }

        response.sendRedirect(destinoSeguro(request));
    }

    /**
     * Obtiene el usuario autenticado de la sesión. Si no hay sesión o
     * falta el usuario se redirige al login y devuelve null.
     */
    private Integer usuarioDeSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return null;
        }

        Integer usuarioId =
                (Integer) session.getAttribute("usuarioId");

        if (usuarioId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return null;
        }

        return usuarioId;
    }

    /**
     * El formulario del botón de favorito manda a dónde volver en el
     * campo "volver". No se confía en ese valor a ciegas (podría
     * manipularse para redirigir a un sitio externo) — solo se acepta
     * si es una ruta interna de esta misma aplicación.
     */
    private String destinoSeguro(HttpServletRequest request) {

        String volver = request.getParameter("volver");
        String contexto = request.getContextPath();

        boolean esRutaInterna = (volver != null && volver.startsWith(contexto + "/"))
                || (contexto.isEmpty() && volver != null && volver.startsWith("/"));

        if (esRutaInterna) {
            return volver;
        }

        return contexto + "/propiedades";
    }
}
