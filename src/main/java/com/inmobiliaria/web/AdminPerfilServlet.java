package com.inmobiliaria.web;

import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.dao.PerfilDAO;
import com.inmobiliaria.dao.RolDAO;
import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.model.Perfil;
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

@WebServlet("/admin/usuarios/perfil")
public class AdminPerfilServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final PerfilDAO perfilDAO = new PerfilDAO();
    private final RolDAO rolDAO = new RolDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String idParam = request.getParameter("id");

        try {

            int idUsuario = Integer.parseInt(idParam);

            Usuario usuario = buscarUsuarioPorId(idUsuario);
            Perfil perfil = perfilDAO.buscarPorUsuario(idUsuario);
            List<Rol> roles = rolDAO.obtenerRolesPorUsuario(idUsuario);

            if (usuario == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Usuario no encontrado"
                );
                return;
            }

            request.setAttribute("usuario", usuario);
            request.setAttribute("perfil", perfil);
            request.setAttribute("roles", roles);

            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/perfil-usuario.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "ID de usuario inválido"
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        try {

            int idUsuario = Integer.parseInt(
                    request.getParameter("idUsuario")
            );

            Perfil perfil = new Perfil();

            perfil.setIdUsuario(idUsuario);
            perfil.setNombres(
                    request.getParameter("nombres")
            );
            perfil.setApellidos(
                    request.getParameter("apellidos")
            );
            perfil.setDocumento(
                    request.getParameter("documento")
            );
            perfil.setTelefono(
                    request.getParameter("telefono")
            );
            perfil.setDireccion(
                    request.getParameter("direccion")
            );

            perfilDAO.actualizarPerfil(perfil);

            HttpSession session = request.getSession(false);

            Integer adminId = (Integer) session.getAttribute("usuarioId");

            auditoriaDAO.registrar(
                    adminId,
                    "ACTUALIZAR_PERFIL",
                    "perfil",
                    idUsuario,
                    "Perfil actualizado por administrador"
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/usuarios/perfil?id="
                            + idUsuario
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Datos inválidos"
            );
        }
    }

    private Usuario buscarUsuarioPorId(int idUsuario) {

        List<Usuario> usuarios = usuarioDAO.listarTodos();

        for (Usuario usuario : usuarios) {

            if (usuario.getIdUsuario() == idUsuario) {
                return usuario;
            }
        }

        return null;
    }
}