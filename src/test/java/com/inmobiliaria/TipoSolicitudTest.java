package com.inmobiliaria;

import com.inmobiliaria.model.TipoSolicitud;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class TipoSolicitudTest {

    @Test
    void debenExistirCompraYArriendo() {
        assertNotNull(TipoSolicitud.COMPRA);
        assertNotNull(TipoSolicitud.ARRIENDO);
    }
}