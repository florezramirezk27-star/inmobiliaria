package com.inmobiliaria.web;

import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.TipoPropiedadDAO;
import com.inmobiliaria.model.TipoPropiedad;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/tipos-propiedad")
public class AdminTiposPropiedadServlet extends HttpServlet {

    private final TipoPropiedadDAO tipoDAO =
            new TipoPropiedadDAO();

    private final AuditoriaDAO auditoriaDAO =
            new AuditoriaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            List<TipoPropiedad> tipos =
                    tipoDAO.listarTodos();

            request.setAttribute(
                    "tipos",
                    tipos
            );

            String idParam =
                    request.getParameter("id");

            if (idParam != null
                    && !idParam.isBlank()) {

                try {

                    int id =
                            Integer.parseInt(idParam);

                    TipoPropiedad tipo =
                            tipoDAO.buscarPorId(id);

                    request.setAttribute(
                            "tipoEditar",
                            tipo
                    );

                } catch (NumberFormatException e) {

                    request.setAttribute(
                            "error",
                            "El ID del tipo no es válido."
                    );
                }
            }

            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/tipos-propiedad.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Error al consultar los tipos de propiedad.",
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
                (Integer) session.getAttribute(
                        "usuarioId"
                );

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
                            + "/admin/tipos-propiedad"
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
                        "El tipo de propiedad ya existe.";
            }

            if (detalle.contains("foreign key")
                    || detalle.contains("constraint")) {

                mensaje =
                        "No se puede eliminar el tipo porque está siendo utilizado por propiedades.";
            }

            request.getSession().setAttribute(
                    "error",
                    mensaje
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tipos-propiedad"
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

        String descripcion =
                request.getParameter("descripcion");

        if (nombre == null
                || nombre.isBlank()) {

            request.getSession().setAttribute(
                    "error",
                    "El nombre del tipo es obligatorio."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tipos-propiedad"
            );

            return;
        }

        TipoPropiedad tipo =
                new TipoPropiedad(
                        0,
                        nombre.trim(),
                        descripcion != null
                                ? descripcion.trim()
                                : null
                );

        tipoDAO.insertar(tipo);

        auditoriaDAO.registrar(
                adminId,
                "CREAR_TIPO_PROPIEDAD",
                "tipo_propiedad",
                null,
                "Tipo creado: "
                        + nombre.trim()
        );

        request.getSession().setAttribute(
                "exito",
                "Tipo de propiedad creado correctamente."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/tipos-propiedad"
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

        String descripcion =
                request.getParameter("descripcion");

        if (nombre == null
                || nombre.isBlank()) {

            request.getSession().setAttribute(
                    "error",
                    "El nombre del tipo es obligatorio."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tipos-propiedad?id="
                            + id
            );

            return;
        }

        TipoPropiedad tipo =
                new TipoPropiedad(
                        id,
                        nombre.trim(),
                        descripcion != null
                                ? descripcion.trim()
                                : null
                );

        tipoDAO.actualizar(tipo);

        auditoriaDAO.registrar(
                adminId,
                "EDITAR_TIPO_PROPIEDAD",
                "tipo_propiedad",
                id,
                "Tipo actualizado: "
                        + nombre.trim()
        );

        request.getSession().setAttribute(
                "exito",
                "Tipo de propiedad actualizado correctamente."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/tipos-propiedad"
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

        TipoPropiedad tipo =
                tipoDAO.buscarPorId(id);

        tipoDAO.eliminar(id);

        auditoriaDAO.registrar(
                adminId,
                "ELIMINAR_TIPO_PROPIEDAD",
                "tipo_propiedad",
                id,
                "Tipo eliminado: "
                        + (tipo != null
                        ? tipo.getNombre()
                        : "ID " + id)
        );

        request.getSession().setAttribute(
                "exito",
                "Tipo de propiedad eliminado correctamente."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/tipos-propiedad"
        );
    }
}