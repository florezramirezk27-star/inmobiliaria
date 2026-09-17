package com.inmobiliaria.web;

import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.RolDAO;
import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.dao.UsuarioRolDAO;
import com.inmobiliaria.model.Rol;
import com.inmobiliaria.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/usuarios")
public class AdminUsuariosServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final RolDAO rolDAO = new RolDAO();
    private final UsuarioRolDAO usuarioRolDAO = new UsuarioRolDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        List<Usuario> usuarios = usuarioDAO.listarTodos();

        request.setAttribute("usuarios", usuarios);
        request.setAttribute("roles", obtenerTodosLosRoles());

        for (Usuario usuario : usuarios) {

            List<Rol> rolesUsuario =
                    rolDAO.obtenerRolesPorUsuario(
                            usuario.getIdUsuario()
                    );

            request.setAttribute(
                    "roles_" + usuario.getIdUsuario(),
                    rolesUsuario
            );
        }

        request.getRequestDispatcher(
                "/WEB-INF/views/admin/usuarios.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String accion = request.getParameter("accion");
        String idParam = request.getParameter("id");

        HttpSession session = request.getSession(false);

        Integer adminId = (Integer) session.getAttribute("usuarioId");

        if (adminId == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Sesión no válida"
            );
            return;
        }

        try {

            int idUsuario = Integer.parseInt(idParam);

            if ("activar".equals(accion)) {

                usuarioDAO.cambiarEstado(
                        idUsuario,
                        "ACTIVO"
                );

                auditoriaDAO.registrar(
                        adminId,
                        "ACTIVAR_USUARIO",
                        "usuario",
                        idUsuario,
                        "Usuario activado por administrador"
                );

            } else if ("desactivar".equals(accion)) {

                usuarioDAO.cambiarEstado(
                        idUsuario,
                        "INACTIVO"
                );

                auditoriaDAO.registrar(
                        adminId,
                        "DESACTIVAR_USUARIO",
                        "usuario",
                        idUsuario,
                        "Usuario desactivado por administrador"
                );

            } else if ("cambiarRol".equals(accion)) {

                int idRol = Integer.parseInt(
                        request.getParameter("idRol")
                );

                usuarioRolDAO.reemplazarRol(
                        idUsuario,
                        idRol
                );

                auditoriaDAO.registrar(
                        adminId,
                        "CAMBIAR_ROL",
                        "usuario_rol",
                        idUsuario,
                        "Rol cambiado. Nuevo rol ID: " + idRol
                );
            }

            response.sendRedirect(
                    request.getContextPath() + "/admin/usuarios"
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Datos inválidos"
            );
        }
    }

    private List<Rol> obtenerTodosLosRoles() {

        return List.of(
                crearRol(1, "ADMIN", "Administrador"),
                crearRol(2, "AGENTE", "Agente inmobiliario"),
                crearRol(3, "CLIENTE", "Cliente")
        );
    }

    private Rol crearRol(
            int id,
            String nombre,
            String descripcion
    ) {

        Rol rol = new Rol();

        rol.setIdRol(id);
        rol.setNombre(nombre);
        rol.setDescripcion(descripcion);

        return rol;
    }
}