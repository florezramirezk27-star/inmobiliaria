package com.inmobiliaria.model;

/**
 * Tipo de negocio de una propiedad.
 *
 * Los nombres de las constantes coinciden con los valores del ENUM
 * `operacion` en la tabla `propiedad`, para poder convertir entre la
 * base de datos y Java con valueOf() / name() sin traducciones manuales.
 */
public enum Operacion {

    ARRIENDO("Arriendo", true),
    VENTA("Venta", false);

    private final String etiqueta;
    private final boolean periodica;

    Operacion(String etiqueta, boolean periodica) {
        this.etiqueta = etiqueta;
        this.periodica = periodica;
    }

    /** Texto que se muestra en las vistas. */
    public String getEtiqueta() {
        return etiqueta;
    }

    /** true cuando el precio se paga cada mes, para escribir "/ mes" en la tarjeta. */
    public boolean isPeriodica() {
        return periodica;
    }

    /**
     * Convierte un valor recibido de la base de datos o de un parámetro HTTP.
     *
     * @return la constante correspondiente, o null si el texto no coincide
     *         con ninguna. Devolver null permite que el buscador trate un
     *         parámetro inválido como "sin filtro" en lugar de fallar.
     */
    public static Operacion desde(String valor) {
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
