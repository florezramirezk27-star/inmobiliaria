package com.inmobiliaria.web;

import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.CaracteristicaDAO;
import com.inmobiliaria.model.Caracteristica;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/caracteristicas")
public class AdminCaracteristicasServlet extends HttpServlet {

    private final CaracteristicaDAO caracteristicaDAO =
            new CaracteristicaDAO();

    private final AuditoriaDAO auditoriaDAO =
            new AuditoriaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            List<Caracteristica> caracteristicas =
                    caracteristicaDAO.listarTodas();

            request.setAttribute(
                    "caracteristicas",
                    caracteristicas
            );

            String idParam =
                    request.getParameter("id");

            if (idParam != null && !idParam.isBlank()) {

                try {

                    int id = Integer.parseInt(idParam);

                    Caracteristica caracteristica =
                            caracteristicaDAO.buscarPorId(id);

                    request.setAttribute(
                            "caracteristicaEditar",
                            caracteristica
                    );

                } catch (NumberFormatException e) {

                    request.setAttribute(
                            "error",
                            "El ID de la característica no es válido."
                    );
                }
            }

            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/caracteristicas.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Error al consultar las características.",
                    e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Sesión no válida."
            );

            return;
        }

        Integer adminId =
                (Integer) session.getAttribute("usuarioId");

        if (adminId == null) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Sesión no válida."
            );

            return;
        }

        String accion =
                request.getParameter("accion");

        try {

            switch (accion == null ? "" : accion) {

                case "crear":

                    crear(
                            request,
                            response,
                            adminId
                    );

                    break;

                case "editar":

                    editar(
                            request,
                            response,
                            adminId
                    );

                    break;

                case "eliminar":

                    eliminar(
                            request,
                            response,
                            adminId
                    );

                    break;

                default:

                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Acción no válida."
                    );
            }

        } catch (NumberFormatException e) {

            request.getSession().setAttribute(
                    "error",
                    "El identificador no es válido."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/caracteristicas"
            );

        } catch (SQLException e) {

            String mensaje =
                    "No se pudo realizar la operación.";

            String detalle =
                    e.getMessage() != null
                            ? e.getMessage().toLowerCase()
                            : "";

            if (detalle.contains("duplicate")
                    || detalle.contains("unique")) {

                mensaje =
                        "La característica ya existe.";
            }

            if (detalle.contains("foreign key")
                    || detalle.contains("constraint")) {

                mensaje =
                        "No se puede eliminar la característica porque está asociada a una o más propiedades.";
            }

            request.getSession().setAttribute(
                    "error",
                    mensaje
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/caracteristicas"
            );
        }
    }

    private void crear(
            HttpServletRequest request,
            HttpServletResponse response,
            int adminId
    ) throws IOException, SQLException {

        String nombre =
                request.getParameter("nombre");

        String categoria =
                request.getParameter("categoria");

        if (nombre == null || nombre.isBlank()
                || categoria == null || categoria.isBlank()) {

            request.getSession().setAttribute(
                    "error",
                    "El nombre y la categoría de la característica son obligatorios."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/caracteristicas"
            );

            return;
        }

        Caracteristica caracteristica =
                new Caracteristica();

        caracteristica.setNombre(
                nombre.trim()
        );

        caracteristica.setCategoria(
                categoria
        );

        caracteristicaDAO.insertar(
                caracteristica
        );

        auditoriaDAO.registrar(
                adminId,
                "CREAR_CARACTERISTICA",
                "caracteristica",
                null,
                "Característica creada: "
                        + nombre.trim()
                        + " ("
                        + categoria
                        + ")"
        );

        request.getSession().setAttribute(
                "exito",
                "Característica creada correctamente."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/caracteristicas"
        );
    }

    private void editar(
            HttpServletRequest request,
            HttpServletResponse response,
            int adminId
    ) throws IOException, SQLException {

        int id =
                Integer.parseInt(
                        request.getParameter("id")
                );

        String nombre =
                request.getParameter("nombre");

        String categoria =
                request.getParameter("categoria");

        if (nombre == null || nombre.isBlank()
                || categoria == null || categoria.isBlank()) {

            request.getSession().setAttribute(
                    "error",
                    "El nombre y la categoría de la característica son obligatorios."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/caracteristicas?id="
                            + id
            );

            return;
        }

        Caracteristica caracteristica =
                new Caracteristica();

        caracteristica.setId(id);

        caracteristica.setNombre(
                nombre.trim()
        );

        caracteristica.setCategoria(
                categoria
        );

        caracteristicaDAO.actualizar(
                caracteristica
        );

        auditoriaDAO.registrar(
                adminId,
                "EDITAR_CARACTERISTICA",
                "caracteristica",
                id,
                "Característica actualizada: "
                        + nombre.trim()
                        + " ("
                        + categoria
                        + ")"
        );

        request.getSession().setAttribute(
                "exito",
                "Característica actualizada correctamente."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/caracteristicas"
        );
    }

    private void eliminar(
            HttpServletRequest request,
            HttpServletResponse response,
            int adminId
    ) throws IOException, SQLException {

        int id =
                Integer.parseInt(
                        request.getParameter("id")
                );

        Caracteristica caracteristica =
                caracteristicaDAO.buscarPorId(id);

        caracteristicaDAO.eliminar(id);

        auditoriaDAO.registrar(
                adminId,
                "ELIMINAR_CARACTERISTICA",
                "caracteristica",
                id,
                "Característica eliminada: "
                        + (caracteristica != null
                        ? caracteristica.getNombre()
                        : "ID " + id)
        );

        request.getSession().setAttribute(
                "exito",
                "Característica eliminada correctamente."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/caracteristicas"
        );
    }
}