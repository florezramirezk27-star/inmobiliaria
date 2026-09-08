package com.inmobiliaria;

import com.inmobiliaria.model.EstadoSolicitud;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class EstadoSolicitudTest {

    @Test
    void debeExistirEstadoPendiente() {
        assertNotNull(EstadoSolicitud.PENDIENTE);
    }

    @Test
    void debenExistirLosEstadosPrincipales() {
        assertNotNull(EstadoSolicitud.EN_REVISION);
        assertNotNull(EstadoSolicitud.APROBADA);
        assertNotNull(EstadoSolicitud.RECHAZADA);
    }
}