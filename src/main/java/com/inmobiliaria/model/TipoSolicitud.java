package com.inmobiliaria.model;

/**
 * Tipo de negocio de una solicitud.
 *
 * Los nombres de las constantes coinciden con los valores del ENUM
 * `tipo` en la tabla `solicitud`, para poder convertir entre la
 * base de datos y Java con valueOf() / name() sin traducciones manuales.
 */
public enum TipoSolicitud {

    COMPRA("Compra"),
    ARRIENDO("Arriendo");

    private final String etiqueta;

    TipoSolicitud(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    /** Texto que se muestra en las vistas. */
    public String getEtiqueta() {
        return etiqueta;
    }

    /**
     * Convierte un valor recibido de la base de datos o de un parámetro HTTP.
     *
     * @return la constante correspondiente, o null si el texto no coincide
     *         con ninguna. Devolver null permite que la validación trate un
     *         parámetro inválido como "sin valor" en lugar de fallar.
     */
    public static TipoSolicitud desde(String valor) {
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
