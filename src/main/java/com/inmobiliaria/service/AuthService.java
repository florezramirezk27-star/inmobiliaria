package com.inmobiliaria.service;

import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;

public class AuthService {

    private final UsuarioDAO usuarioDAO;

    public AuthService() {
        this.usuarioDAO = new UsuarioDAO();
    }

    public Usuario registrar(String correo, String password,
                             String estado) throws SQLException {

        if (correo == null || correo.isBlank()
                || password == null || password.isBlank()) {
            throw new IllegalArgumentException(
                    "Correo y contraseña son obligatorios");
        }

        if (usuarioDAO.buscarPorCorreo(correo) != null) {
            throw new IllegalArgumentException(
                    "Ya existe un usuario con ese correo");
        }

        String hash = BCrypt.hashpw(password, BCrypt.gensalt());

        Usuario usuario = new Usuario();
        usuario.setCorreo(correo);
        usuario.setPasswordHash(hash);
        usuario.setEstado(estado != null ? estado : "ACTIVO");

        int id = usuarioDAO.crearUsuario(usuario);
        usuario.setIdUsuario(id);
        return usuario;
    }

    public Usuario autenticar(String correo, String password)
            throws SQLException {

        Usuario usuario = usuarioDAO.buscarPorCorreo(correo);

        if (usuario == null) {
            return null;
        }

        if (!BCrypt.checkpw(password, usuario.getPasswordHash())) {
            return null;
        }

        usuarioDAO.actualizarUltimoAcceso(usuario.getIdUsuario());
        return usuario;
    }
}
