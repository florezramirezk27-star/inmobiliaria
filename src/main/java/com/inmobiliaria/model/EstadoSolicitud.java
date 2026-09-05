package com.inmobiliaria.model;

/**
 * Estado de una solicitud.
 *
 * Coincide con el ENUM `estado` de la tabla `solicitud`.
 * Una solicitud nueva nace en PENDIENTE y la inmobiliaria la va
 * moviendo a EN_REVISION, APROBADA o RECHAZADA a medida que la gestiona.
 */
public enum EstadoSolicitud {

    PENDIENTE("Pendiente"),
    EN_REVISION("En revisión"),
    APROBADA("Aprobada"),
    RECHAZADA("Rechazada");

    private final String etiqueta;

    EstadoSolicitud(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public String getEtiqueta() {
        return etiqueta;
    }

    public static EstadoSolicitud desde(String valor) {
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
