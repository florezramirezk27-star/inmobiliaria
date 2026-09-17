package com.inmobiliaria.model;

/** Fila de la tabla `imagen_propiedad`. */
public class ImagenPropiedad {

    private int id;
    private int propiedadId;
    private String ruta;
    private String textoAlt;
    private boolean esPortada;
    private int orden;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPropiedadId() { return propiedadId; }
    public void setPropiedadId(int propiedadId) { this.propiedadId = propiedadId; }

    public String getRuta() { return ruta; }
    public void setRuta(String ruta) { this.ruta = ruta; }

    public String getTextoAlt() { return textoAlt; }
    public void setTextoAlt(String textoAlt) { this.textoAlt = textoAlt; }

    public boolean isEsPortada() { return esPortada; }
    public void setEsPortada(boolean esPortada) { this.esPortada = esPortada; }

    public int getOrden() { return orden; }
    public void setOrden(int orden) { this.orden = orden; }
}
