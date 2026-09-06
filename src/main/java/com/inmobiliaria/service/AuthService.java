package com.inmobiliaria.service;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.dao.PerfilDAO;
import com.inmobiliaria.dao.RolDAO;
import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.dao.UsuarioRolDAO;
import com.inmobiliaria.model.Perfil;
import com.inmobiliaria.model.Usuario;

import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class AuthService {

    private final UsuarioDAO usuarioDAO;
    private final PerfilDAO perfilDAO;
    private final UsuarioRolDAO usuarioRolDAO;
    private final RolDAO rolDAO;

    public AuthService() {
        this.usuarioDAO = new UsuarioDAO();
        this.perfilDAO = new PerfilDAO();
        this.usuarioRolDAO = new UsuarioRolDAO();
        this.rolDAO = new RolDAO();
    }

    public boolean correoExiste(String correo) {

        return usuarioDAO.buscarPorCorreo(correo) != null;
    }

    public LoginResult autenticar(String correo, String password) {

        Usuario usuario = usuarioDAO.buscarPorCorreo(correo);

        if (usuario == null) {
            return new LoginResult(false, null, null,
                    "Correo o contraseña incorrectos.");
        }

        if (!"ACTIVO".equalsIgnoreCase(usuario.getEstado())) {
            return new LoginResult(false, null, null,
                    "La cuenta se encuentra inactiva.");
        }

        if (!BCrypt.checkpw(password, usuario.getPasswordHash())) {
            return new LoginResult(false, null, null,
                    "Correo o contraseña incorrectos.");
        }

        List<com.inmobiliaria.model.Rol> roles =
                rolDAO.obtenerRolesPorUsuario(
                        usuario.getIdUsuario()
                );

        if (roles == null || roles.isEmpty()) {
            return new LoginResult(false, null, null,
                    "El usuario no tiene roles asignados.");
        }

        usuarioDAO.actualizarUltimoAcceso(
                usuario.getIdUsuario()
        );

        return new LoginResult(
                true,
                usuario,
                roles,
                null
        );
    }

    public void registrar(
            String nombres,
            String apellidos,
            String correo,
            String password,
            String documento,
            String telefono,
            String direccion
    ) {

        if (correoExiste(correo)) {
            throw new IllegalArgumentException(
                    "El correo ya se encuentra registrado."
            );
        }

        String passwordHash = BCrypt.hashpw(
                password,
                BCrypt.gensalt()
        );

        Usuario usuario = new Usuario();
        usuario.setCorreo(correo);
        usuario.setPasswordHash(passwordHash);
        usuario.setEstado("ACTIVO");

        Perfil perfil = new Perfil();
        perfil.setNombres(nombres);
        perfil.setApellidos(apellidos);
        perfil.setDocumento(documento);
        perfil.setTelefono(telefono);
        perfil.setDireccion(direccion);
        perfil.setFoto(null);

        try (Connection connection = ConnectionFactory.getConnection()) {

            try {

                connection.setAutoCommit(false);

                int idUsuario =
                        usuarioDAO.crearUsuario(connection, usuario);

                perfil.setIdUsuario(idUsuario);

                perfilDAO.crearPerfil(connection, perfil);

                // 3 = CLIENTE
                usuarioRolDAO.asignarRol(
                        connection,
                        idUsuario,
                        3
                );

                connection.commit();

            } catch (Exception e) {

                connection.rollback();

                throw e;
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "No se pudo completar el registro del usuario.",
                    e
            );
        }
    }
}
