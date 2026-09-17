package com.inmobiliaria.model;

public enum EstadoDocumento {
    PENDIENTE,
    APROBADO,
    RECHAZADO;

    public static EstadoDocumento desde(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }

        for (EstadoDocumento estado : values()) {
            if (estado.name().equalsIgnoreCase(valor.trim())) {
                return estado;
            }
        }

        return null;
    }
}
