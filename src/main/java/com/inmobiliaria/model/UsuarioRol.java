package com.inmobiliaria.model;

import java.sql.Timestamp;

public class UsuarioRol {

    private int idUsuario;
    private int idRol;
    private Timestamp fechaAsignacion;

    public UsuarioRol() {
    }

    public UsuarioRol(int idUsuario, int idRol, Timestamp fechaAsignacion) {
        this.idUsuario = idUsuario;
        this.idRol = idRol;
        this.fechaAsignacion = fechaAsignacion;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

    public Timestamp getFechaAsignacion() {
        return fechaAsignacion;
    }

    public void setFechaAsignacion(Timestamp fechaAsignacion) {
        this.fechaAsignacion = fechaAsignacion;
    }
}
