package com.inmobiliaria.model;

import java.sql.Timestamp;

public class Favorito {

    private int idUsuario;
    private int idPropiedad;
    private Timestamp fecha;

    public Favorito() {
    }

    public Favorito(int idUsuario, int idPropiedad, Timestamp fecha) {
        this.idUsuario = idUsuario;
        this.idPropiedad = idPropiedad;
        this.fecha = fecha;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdPropiedad() {
        return idPropiedad;
    }

    public void setIdPropiedad(int idPropiedad) {
        this.idPropiedad = idPropiedad;
    }

    public Timestamp getFecha() {
        return fecha;
    }

    public void setFecha(Timestamp fecha) {
        this.fecha = fecha;
    }
}