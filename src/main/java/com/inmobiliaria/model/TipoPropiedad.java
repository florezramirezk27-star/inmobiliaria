package com.inmobiliaria.model;

/**
 * Fila de la tabla `tipo_propiedad`. Se usa para llenar el
 * <select> de tipo de inmueble en el buscador y en el formulario.
 */
public class TipoPropiedad {

    private int id;
    private String nombre;
    private String slug;

    public TipoPropiedad() {
    }

    public TipoPropiedad(int id, String nombre, String slug) {
        this.id = id;
        this.nombre = nombre;
        this.slug = slug;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
}
