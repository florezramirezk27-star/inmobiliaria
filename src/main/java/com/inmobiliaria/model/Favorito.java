package com.inmobiliaria.model;

import java.time.LocalDateTime;

/** Fila de la tabla `favorito` (usuario ↔ propiedad, N:M). */
public class Favorito {

    private int usuarioId;
    private int propiedadId;
    private LocalDateTime creadoEn;

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public int getPropiedadId() { return propiedadId; }
    public void setPropiedadId(int propiedadId) { this.propiedadId = propiedadId; }

    public LocalDateTime getCreadoEn() { return creadoEn; }
    public void setCreadoEn(LocalDateTime creadoEn) { this.creadoEn = creadoEn; }
}
