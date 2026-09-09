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
import java.util.List;
import java.util.Set;

/**
 * Página de inicio (welcome-file "index"): carga las publicaciones
 * recientes para la sección de destacados y las marca según los
 * favoritos del usuario autenticado.
 *
 * GET / -> index.jsp con:
 *   propiedades     List<Propiedad>   (más recientes)
 *   favoritosIds    Set<Integer>      (del usuario de sesión, vacío si no hay)
 *   urlActual                       (para que el botón de favorito vuelva a "/")
 */
@WebServlet("/index")
public class IndexServlet extends HttpServlet {

    private static final int LIMITE_RECIENTES = 6;

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final FavoritoDAO favoritoDAO = new FavoritoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("urlActual", request.getRequestURI());

        try {
            List<Propiedad> recientes = propiedadDAO.listarRecientes(LIMITE_RECIENTES);
            request.setAttribute("propiedades", recientes);
            request.setAttribute("favoritosIds", favoritosDelUsuario(request));
        } catch (SQLException e) {
            getServletContext().log("Error al cargar las publicaciones recientes", e);
            request.setAttribute("propiedades", List.of());
            request.setAttribute("favoritosIds", Set.of());
            request.setAttribute("errorConsulta",
                    "No fue posible cargar las publicaciones en este momento. Intenta de nuevo en unos minutos.");
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private Set<Integer> favoritosDelUsuario(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return Set.of();
        }

        Integer usuarioId = (Integer) session.getAttribute("usuarioId");
        if (usuarioId == null) {
            return Set.of();
        }

        try {
            return favoritoDAO.listarIdsPropiedadPorUsuario(usuarioId);
        } catch (SQLException e) {
            getServletContext().log("Error al cargar favoritos del index", e);
            return Set.of();
        }
    }
}