package com.inmobiliaria.web;

import com.inmobiliaria.dao.CaracteristicaDAO;
import com.inmobiliaria.dao.ImagenPropiedadDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.Caracteristica;
import com.inmobiliaria.model.ImagenPropiedad;
import com.inmobiliaria.model.Propiedad;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Ficha de detalle de una propiedad: galería completa de imágenes,
 * todos sus datos y sus características agrupadas por categoría.
 *
 * GET /propiedades/detalle?id=5
 */
@WebServlet("/propiedades/detalle")
public class PropiedadDetalleServlet extends HttpServlet {

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final ImagenPropiedadDAO imagenDAO = new ImagenPropiedadDAO();
    private final CaracteristicaDAO caracteristicaDAO = new CaracteristicaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isBlank()) {
            request.setAttribute("error", "No se indicó qué propiedad mostrar.");
            request.getRequestDispatcher("/detalle-propiedad.jsp").forward(request, response);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "El identificador de la propiedad no es válido.");
            request.getRequestDispatcher("/detalle-propiedad.jsp").forward(request, response);
            return;
        }

        try {
            Propiedad propiedad = propiedadDAO.buscarPorId(id);

            if (propiedad == null) {
                request.setAttribute("error", "No se encontró la propiedad solicitada.");
            } else {
                List<ImagenPropiedad> imagenes = imagenDAO.listarPorPropiedad(id);
                List<Caracteristica> caracteristicas = caracteristicaDAO.listarPorPropiedad(id);

                request.setAttribute("propiedad", propiedad);
                request.setAttribute("imagenes", imagenes);
                request.setAttribute("caracteristicas", caracteristicas);
                request.setAttribute("categoriasCaracteristica",
                        List.of("INTERIOR", "EXTERIOR", "CONJUNTO", "SEGURIDAD"));
            }

        } catch (SQLException e) {
            getServletContext().log("Error al consultar el detalle de la propiedad " + id, e);
            request.setAttribute("error",
                    "No fue posible cargar esta propiedad en este momento. Intenta de nuevo en unos minutos.");
        }

        request.getRequestDispatcher("/detalle-propiedad.jsp").forward(request, response);
    }
}
