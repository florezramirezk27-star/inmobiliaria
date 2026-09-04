package com.inmobiliaria.service;

import com.inmobiliaria.model.Rol;
import com.inmobiliaria.model.Usuario;

import java.util.List;

public class LoginResult {

    private final boolean exitoso;
    private final Usuario usuario;
    private final List<Rol> roles;
    private final String mensaje;

    public LoginResult(
            boolean exitoso,
            Usuario usuario,
            List<Rol> roles,
            String mensaje
    ) {
        this.exitoso = exitoso;
        this.usuario = usuario;
        this.roles = roles;
        this.mensaje = mensaje;
    }

    public boolean isExitoso() {
        return exitoso;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public List<Rol> getRoles() {
        return roles;
    }

    public String getMensaje() {
        return mensaje;
    }
}
