package com.inmobiliaria.model;

import java.time.LocalDateTime;

/** Fila de la tabla `documento_solicitud`. */
public class Documento {

    private int id;
    private int solicitudId;
    private String nombreArchivo;
    private String ruta;
    private LocalDateTime subidoEn;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSolicitudId() { return solicitudId; }
    public void setSolicitudId(int solicitudId) { this.solicitudId = solicitudId; }

    public String getNombreArchivo() { return nombreArchivo; }
    public void setNombreArchivo(String nombreArchivo) { this.nombreArchivo = nombreArchivo; }

    public String getRuta() { return ruta; }
    public void setRuta(String ruta) { this.ruta = ruta; }

    public LocalDateTime getSubidoEn() { return subidoEn; }
    public void setSubidoEn(LocalDateTime subidoEn) { this.subidoEn = subidoEn; }
}
