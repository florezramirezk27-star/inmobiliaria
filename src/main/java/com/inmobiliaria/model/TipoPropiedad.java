package com.inmobiliaria.model;

public class TipoPropiedad {

    private int idTipo;
    private String nombre;
    private String descripcion;
    private String slug;

    public TipoPropiedad() {
    }

    public TipoPropiedad(
            int idTipo,
            String nombre,
            String descripcion
    ) {
        this.idTipo = idTipo;
        this.nombre = nombre;
        this.descripcion = descripcion;
    }

    public TipoPropiedad(
            int idTipo,
            String nombre,
            String descripcion,
            String slug
    ) {
        this(idTipo, nombre, descripcion);
        this.slug = slug;
    }

    public int getIdTipo() {
        return idTipo;
    }

    public void setIdTipo(int idTipo) {
        this.idTipo = idTipo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }
}