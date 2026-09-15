package com.inmobiliaria.web;

import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.CiudadDAO;
import com.inmobiliaria.model.Ciudad;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/ciudades")
public class AdminCiudadesServlet extends HttpServlet {

    private final CiudadDAO ciudadDAO = new CiudadDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            List<Ciudad> ciudades =
                    ciudadDAO.listarTodas();

            request.setAttribute(
                    "ciudades",
                    ciudades
            );

            String idParam =
                    request.getParameter("id");

            if (idParam != null && !idParam.isBlank()) {

                try {

                    int id =
                            Integer.parseInt(idParam);

                    Ciudad ciudad =
                            ciudadDAO.buscarPorId(id);

                    request.setAttribute(
                            "ciudadEditar",
                            ciudad
                    );

                } catch (NumberFormatException e) {

                    request.setAttribute(
                            "error",
                            "El ID de la ciudad no es válido."
                    );
                }
            }

            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/ciudades.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Error al consultar las ciudades.",
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

            if ("crear".equals(accion)) {

                crearCiudad(
                        request,
                        response,
                        adminId
                );

            } else if ("editar".equals(accion)) {

                editarCiudad(
                        request,
                        response,
                        adminId
                );

            } else if ("eliminar".equals(accion)) {

                eliminarCiudad(
                        request,
                        response,
                        adminId
                );

            } else {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Acción no válida."
                );
            }

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Los datos numéricos no son válidos."
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
                        "La ciudad ya existe.";
            }

            if (detalle.contains("foreign key")
                    || detalle.contains("constraint")) {

                mensaje =
                        "No se puede eliminar la ciudad porque está siendo utilizada por propiedades.";
            }

            request.getSession().setAttribute(
                    "error",
                    mensaje
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/ciudades"
            );
        }
    }

    private void crearCiudad(
            HttpServletRequest request,
            HttpServletResponse response,
            int adminId
    ) throws IOException, SQLException {

        String nombre =
                request.getParameter("nombre");

        String departamento =
                request.getParameter("departamento");

        if (nombre == null
                || nombre.isBlank()
                || departamento == null
                || departamento.isBlank()) {

            request.getSession().setAttribute(
                    "error",
                    "Nombre y departamento son obligatorios."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/ciudades"
            );

            return;
        }

        Ciudad ciudad =
                new Ciudad(
                        0,
                        nombre.trim(),
                        departamento.trim()
                );

        ciudadDAO.insertar(ciudad);

        auditoriaDAO.registrar(
                adminId,
                "CREAR_CIUDAD",
                "ciudad",
                null,
                "Ciudad creada: "
                        + nombre.trim()
                        + " - "
                        + departamento.trim()
        );

        request.getSession().setAttribute(
                "exito",
                "Ciudad creada correctamente."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/ciudades"
        );
    }

    private void editarCiudad(
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

        String departamento =
                request.getParameter("departamento");

        if (nombre == null
                || nombre.isBlank()
                || departamento == null
                || departamento.isBlank()) {

            request.getSession().setAttribute(
                    "error",
                    "Nombre y departamento son obligatorios."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/ciudades?id="
                            + id
            );

            return;
        }

        Ciudad ciudad =
                new Ciudad(
                        id,
                        nombre.trim(),
                        departamento.trim()
                );

        ciudadDAO.actualizar(ciudad);

        auditoriaDAO.registrar(
                adminId,
                "EDITAR_CIUDAD",
                "ciudad",
                id,
                "Ciudad actualizada: "
                        + nombre.trim()
                        + " - "
                        + departamento.trim()
        );

        request.getSession().setAttribute(
                "exito",
                "Ciudad actualizada correctamente."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/ciudades"
        );
    }

    private void eliminarCiudad(
            HttpServletRequest request,
            HttpServletResponse response,
            int adminId
    ) throws IOException, SQLException {

        int id =
                Integer.parseInt(
                        request.getParameter("id")
                );

        Ciudad ciudad =
                ciudadDAO.buscarPorId(id);

        ciudadDAO.eliminar(id);

        auditoriaDAO.registrar(
                adminId,
                "ELIMINAR_CIUDAD",
                "ciudad",
                id,
                "Ciudad eliminada: "
                        + (ciudad != null
                        ? ciudad.getNombre()
                        : "ID " + id)
        );

        request.getSession().setAttribute(
                "exito",
                "Ciudad eliminada correctamente."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/ciudades"
        );
    }
}
