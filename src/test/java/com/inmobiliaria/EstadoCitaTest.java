package com.inmobiliaria;

import com.inmobiliaria.model.EstadoCita;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class EstadoCitaTest {

    @Test
    void debeExistirEstadoSolicitada() {
        assertNotNull(EstadoCita.SOLICITADA);
    }

    @Test
    void debenExistirEstadosDeGestion() {
        assertNotNull(EstadoCita.CONFIRMADA);
        assertNotNull(EstadoCita.RECHAZADA);
    }
}