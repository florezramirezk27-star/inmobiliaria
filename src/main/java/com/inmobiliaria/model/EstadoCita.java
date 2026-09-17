package com.inmobiliaria.model;

/** Coincide con el ENUM `estado` de la tabla `cita`. */
public enum EstadoCita {

    SOLICITADA("Solicitada"),
    CONFIRMADA("Confirmada"),
    RECHAZADA("Rechazada"),
    REALIZADA("Realizada"),
    CANCELADA("Cancelada");

    private final String etiqueta;

    EstadoCita(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public String getEtiqueta() {
        return etiqueta;
    }

    public static EstadoCita desde(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }
        try {
            return valueOf(valor.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
