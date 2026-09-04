package com.inmobiliaria.model;

/**
 * Fila de la tabla `ciudad`. Se usa para llenar el <select> de
 * ciudad en el buscador y en el formulario de propiedades.
 */
public class Ciudad {

    private int id;
    private String nombre;
    private String departamento;

    public Ciudad() {
    }

    public Ciudad(int id, String nombre, String departamento) {
        this.id = id;
        this.nombre = nombre;
        this.departamento = departamento;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDepartamento() { return departamento; }
    public void setDepartamento(String departamento) { this.departamento = departamento; }
}
