package com.inmobiliaria.model;

/**
 * Fila de la tabla `inmobiliaria` (la agencia, no la app). Se usa
 * para llenar el <select> de "publicado por" en el formulario de
 * propiedades, mientras no exista un login que la asigne sola.
 */
public class Inmobiliaria {

    private int id;
    private String nombreComercial;
    private String nit;
    private String telefono;
    private int usuarioId;

    public Inmobiliaria() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombreComercial() { return nombreComercial; }
    public void setNombreComercial(String nombreComercial) { this.nombreComercial = nombreComercial; }

    public String getNit() { return nit; }
    public void setNit(String nit) { this.nit = nit; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
}
