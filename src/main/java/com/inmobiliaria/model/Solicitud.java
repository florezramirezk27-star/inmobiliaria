package com.inmobiliaria.model;

import java.time.LocalDateTime;

/**
 * Representa una fila de la tabla `solicitud`.
 *
 * Una solicitud es la intención de un cliente de comprar o arrendar una
 * propiedad. idCliente apunta al usuario que la registra y idPropiedad a
 * la propiedad sobre la que se solicita.
 *
 * tipo y estado se almacenan como ENUM de la base de datos y se
 * representan aquí con TipoSolicitud y EstadoSolicitud, cuyos nombres de
 * constantes coinciden con los valores del ENUM para poder convertir con
 * name() / valueOf() sin traducciones manuales.
 */
public class Solicitud {

    // --- Identificación ---
    private int id;
    private int propiedadId;
    private int clienteId;          // usuario que registra la solicitud

    // --- Clasificación ---
    private TipoSolicitud tipo;
    private EstadoSolicitud estado;

    private String comentario;

    // --- Auditoría ---
    private LocalDateTime creadoEn;
    private LocalDateTime actualizadoEn;

    public Solicitud() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPropiedadId() { return propiedadId; }
    public void setPropiedadId(int propiedadId) { this.propiedadId = propiedadId; }

    public int getClienteId() { return clienteId; }
    public void setClienteId(int clienteId) { this.clienteId = clienteId; }

    public TipoSolicitud getTipo() { return tipo; }
    public void setTipo(TipoSolicitud tipo) { this.tipo = tipo; }

    public EstadoSolicitud getEstado() { return estado; }
    public void setEstado(EstadoSolicitud estado) { this.estado = estado; }

    public String getComentario() { return comentario; }
    public void setComentario(String comentario) { this.comentario = comentario; }

    public LocalDateTime getCreadoEn() { return creadoEn; }
    public void setCreadoEn(LocalDateTime creadoEn) { this.creadoEn = creadoEn; }

    public LocalDateTime getActualizadoEn() { return actualizadoEn; }
    public void setActualizadoEn(LocalDateTime actualizadoEn) { this.actualizadoEn = actualizadoEn; }

    @Override
    public String toString() {
        return "Solicitud{" + id + " - propiedad " + propiedadId
                + " - " + tipo + " - " + estado + "}";
    }
}
