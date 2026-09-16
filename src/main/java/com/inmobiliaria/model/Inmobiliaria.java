package com.inmobiliaria.model;

/**
 * Representa una fila de la tabla `inmobiliaria`.
 *
 * Cada agencia está asociada a un usuario responsable mediante
 * id_usuario.
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
