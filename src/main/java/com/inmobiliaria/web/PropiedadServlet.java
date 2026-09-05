package com.inmobiliaria.web;

import com.inmobiliaria.dao.FavoritoDAO;
import com.inmobiliaria.dao.FiltroPropiedad;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.Operacion;
import com.inmobiliaria.model.Propiedad;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;

/**
 * Sirve el catálogo público de propiedades: la landing lo usa para
 * los destacados y esta misma ruta atiende el buscador con filtros.
 *
 * GET /propiedades              -> catálogo completo (más recientes primero)
 * GET /propiedades?operacion=arriendo&ciudad=1&tipo=apartamento&precioMax=2000000
 *                                -> catálogo filtrado
 */
@WebServlet("/propiedades")
public class PropiedadServlet extends HttpServlet {

    // Ver el javadoc de FavoritoServlet: usuario de prueba fijo hasta
    // que exista sesión real. Cuando eso pase, este catálogo debe
    // tomar el id_usuario de la sesión (o simplemente no calcular
    // favoritosIds en absoluto si nadie ha iniciado sesión).
    private static final int USUARIO_PRUEBA_ID = 4;

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final FavoritoDAO favoritoDAO = new FavoritoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Se calcula AQUÍ, antes del forward hacia catalogo.jsp: dentro de
        // la JSP, request.getRequestURI() ya no devuelve esta URL sino la
        // ruta del propio archivo JSP destino (comportamiento normal de
        // forward() según la especificación Servlet) — usarlo allá había
        // estado mandando el botón de favorito de vuelta a
        // "/catalogo.jsp" en crudo, sin pasar por este controlador.
        String urlActual = request.getRequestURI()
                + (request.getQueryString() != null ? "?" + request.getQueryString() : "");
        request.setAttribute("urlActual", urlActual);

        FiltroPropiedad filtro = construirFiltroDesde(request);

        try {
            List<Propiedad> propiedades = propiedadDAO.buscar(filtro);
            request.setAttribute("propiedades", propiedades);
            request.setAttribute("filtro", filtro);

            Set<Integer> favoritosIds = favoritoDAO.listarIdsPropiedadPorUsuario(USUARIO_PRUEBA_ID);
            request.setAttribute("favoritosIds", favoritosIds);

        } catch (SQLException e) {
            // No se deja pasar la excepción cruda al usuario final:
            // se registra en el log del servidor y se muestra una
            // lista vacía con un mensaje entendible en la JSP.
            getServletContext().log("Error al consultar el catálogo de propiedades", e);
            request.setAttribute("propiedades", List.of());
            request.setAttribute("favoritosIds", Set.of());
            request.setAttribute("errorConsulta",
                    "No fue posible cargar el catálogo en este momento. Intenta de nuevo en unos minutos.");
        }

        request.getRequestDispatcher("/catalogo.jsp").forward(request, response);
    }

    /**
     * Traduce los parámetros de la URL a un FiltroPropiedad.
     * Cualquier parámetro ausente, vacío o no parseable se ignora en
     * vez de lanzar una excepción: un precioMax mal escrito no debe
     * tumbar la búsqueda completa, solo queda sin aplicar ese filtro.
     */
    private FiltroPropiedad construirFiltroDesde(HttpServletRequest request) {

        FiltroPropiedad filtro = new FiltroPropiedad();

        filtro.setOperacion(Operacion.desde(request.getParameter("operacion")));

        String ciudad = request.getParameter("ciudad");
        if (ciudad != null && !ciudad.isBlank()) {
            try {
                filtro.setCiudadId(Integer.valueOf(ciudad.trim()));
            } catch (NumberFormatException ignorado) {
                // El <select> de la landing envía el id numérico de la ciudad;
                // si llega otra cosa, se trata como "sin filtro de ciudad".
            }
        }

        String tipo = request.getParameter("tipo");
        if (tipo != null && !tipo.isBlank()) {
            filtro.setTipoSlug(tipo.trim());
        }

        String precioMax = request.getParameter("precioMax");
        if (precioMax != null && !precioMax.isBlank()) {
            try {
                filtro.setPrecioMaximo(new BigDecimal(precioMax.trim()));
            } catch (NumberFormatException ignorado) {
                // idem: un precioMax no numérico no rompe la búsqueda.
            }
        }

        String texto = request.getParameter("q");
        if (texto != null && !texto.isBlank()) {
            filtro.setTexto(texto.trim());
        }

        return filtro;
    }
}
