package com.inmobiliaria.model;

/**
 * Fila de la tabla `caracteristica`, opcionalmente con la `cantidad`
 * que trae la fila de `propiedad_caracteristica` cuando se consulta
 * junto a una propiedad puntual (ficha de detalle).
 */
public class Caracteristica {

    private int id;
    private String nombre;
    private String categoria;
    private int cantidad = 1;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
}
