package com.inmobiliaria.dao;

/**
 * Se lanza cuando una escritura viola una restricción UNIQUE del modelo
 * (correo repetido, matrícula inmobiliaria repetida, etc.).
 *
 * El enunciado del parcial exige que la aplicación "capture el error que
 * se produce al intentar duplicarlos y muestre un mensaje claro al
 * usuario... en lugar de presentar una excepción de Java". Por eso esta
 * clase es unchecked (extiende RuntimeException): así el servlet no está
 * obligado a declarar throws SQLException solo para mostrar un mensaje de
 * validación, y puede capturar específicamente DuplicidadException para
 * decidir qué le muestra al usuario.
 */
public class DuplicidadException extends RuntimeException {

    public DuplicidadException(String mensaje, Throwable causa) {
        super(mensaje, causa);
    }
}
