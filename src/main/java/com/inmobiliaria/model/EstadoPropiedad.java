package com.inmobiliaria.model;

/**
 * Estado de publicación de una propiedad.
 *
 * Coincide con el ENUM `estado` de la tabla `propiedad`.
 * Solo las propiedades en PUBLICADA aparecen en el catálogo público
 * (la vista v_propiedad_catalogo ya aplica ese filtro).
 */
public enum EstadoPropiedad {

    BORRADOR("Borrador"),
    PUBLICADA("Publicada"),
    RESERVADA("Reservada"),
    CERRADA("Cerrada");

    private final String etiqueta;

    EstadoPropiedad(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public String getEtiqueta() {
        return etiqueta;
    }

    public static EstadoPropiedad desde(String valor) {
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
