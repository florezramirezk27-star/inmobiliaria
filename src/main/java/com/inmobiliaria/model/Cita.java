package com.inmobiliaria.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Fila de la tabla `cita`, con los campos de la propiedad ya
 * resueltos por el JOIN (título, código) para no necesitar una
 * segunda consulta al pintar "Mis citas".
 */
public class Cita {

    // La etiqueta <fmt:formatDate> de JSTL 1.2 espera java.util.Date,
    // no java.time.LocalDateTime (JSTL es de 2006, años antes de que
    // existiera java.time) — por eso el formateo se hace aquí, no en
    // el JSP con esa etiqueta.
    private static final DateTimeFormatter FORMATO_VISITA =
            DateTimeFormatter.ofPattern("EEEE d 'de' MMMM, h:mm a", new Locale("es", "ES"));

    private int id;
    private int propiedadId;
    private int clienteId;
    private LocalDateTime fechaHora;
    private EstadoCita estado;
    private String observacion;
    private LocalDateTime creadoEn;

    // Del JOIN con propiedad — solo se llenan cuando la consulta los trae.
    private String propiedadTitulo;
    private String propiedadCodigo;

    // Del JOIN con perfil — solo para la vista del agente (lista por propiedad).
    private String clienteNombreCompleto;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPropiedadId() { return propiedadId; }
    public void setPropiedadId(int propiedadId) { this.propiedadId = propiedadId; }

    public int getClienteId() { return clienteId; }
    public void setClienteId(int clienteId) { this.clienteId = clienteId; }

    public LocalDateTime getFechaHora() { return fechaHora; }
    public void setFechaHora(LocalDateTime fechaHora) { this.fechaHora = fechaHora; }

    public EstadoCita getEstado() { return estado; }
    public void setEstado(EstadoCita estado) { this.estado = estado; }

    public String getObservacion() { return observacion; }
    public void setObservacion(String observacion) { this.observacion = observacion; }

    public LocalDateTime getCreadoEn() { return creadoEn; }
    public void setCreadoEn(LocalDateTime creadoEn) { this.creadoEn = creadoEn; }

    public String getPropiedadTitulo() { return propiedadTitulo; }
    public void setPropiedadTitulo(String propiedadTitulo) { this.propiedadTitulo = propiedadTitulo; }

    public String getPropiedadCodigo() { return propiedadCodigo; }
    public void setPropiedadCodigo(String propiedadCodigo) { this.propiedadCodigo = propiedadCodigo; }

    public String getClienteNombreCompleto() { return clienteNombreCompleto; }
    public void setClienteNombreCompleto(String clienteNombreCompleto) { this.clienteNombreCompleto = clienteNombreCompleto; }

    /** true si todavía tiene sentido confirmarla/rechazarla (no quedó ya cerrada de algún modo). */
    public boolean isPendienteDeGestion() {
        return estado == EstadoCita.SOLICITADA;
    }

    /** "jueves 10 de septiembre, 2:30 p. m." — listo para pintar directo en el JSP. */
    public String getFechaHoraFormateada() {
        return fechaHora != null ? FORMATO_VISITA.format(fechaHora) : "";
    }
}
