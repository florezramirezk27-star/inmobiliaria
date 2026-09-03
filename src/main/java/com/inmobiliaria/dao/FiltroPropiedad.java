package com.inmobiliaria.dao;

import com.inmobiliaria.model.Operacion;

import java.math.BigDecimal;

/**
 * Criterios de búsqueda del catálogo.
 *
 * Existe para que PropiedadDAO.buscar() reciba un solo parámetro en lugar de
 * ocho, y para que agregar un criterio nuevo no obligue a cambiar la firma
 * del método ni todos los sitios que lo llaman.
 *
 * Cualquier campo en null significa "sin filtro por este criterio".
 */
public class FiltroPropiedad {

    private Operacion operacion;
    private Integer ciudadId;
    private String tipoSlug;
    private BigDecimal precioMinimo;
    private BigDecimal precioMaximo;
    private Integer habitacionesMinimo;
    private Integer banosMinimo;

    /** Texto libre; se busca dentro del título, el barrio y la dirección. */
    private String texto;

    private int limite = 24;
    private int desplazamiento = 0;

    public FiltroPropiedad() {
    }

    /** true cuando no se aplicó ningún criterio: sirve para mostrar el catálogo completo. */
    public boolean isVacio() {
        return operacion == null
                && ciudadId == null
                && (tipoSlug == null || tipoSlug.isBlank())
                && precioMinimo == null
                && precioMaximo == null
                && habitacionesMinimo == null
                && banosMinimo == null
                && (texto == null || texto.isBlank());
    }

    public Operacion getOperacion() { return operacion; }
    public void setOperacion(Operacion operacion) { this.operacion = operacion; }

    public Integer getCiudadId() { return ciudadId; }
    public void setCiudadId(Integer ciudadId) { this.ciudadId = ciudadId; }

    public String getTipoSlug() { return tipoSlug; }
    public void setTipoSlug(String tipoSlug) { this.tipoSlug = tipoSlug; }

    public BigDecimal getPrecioMinimo() { return precioMinimo; }
    public void setPrecioMinimo(BigDecimal precioMinimo) { this.precioMinimo = precioMinimo; }

    public BigDecimal getPrecioMaximo() { return precioMaximo; }
    public void setPrecioMaximo(BigDecimal precioMaximo) { this.precioMaximo = precioMaximo; }

    public Integer getHabitacionesMinimo() { return habitacionesMinimo; }
    public void setHabitacionesMinimo(Integer habitacionesMinimo) { this.habitacionesMinimo = habitacionesMinimo; }

    public Integer getBanosMinimo() { return banosMinimo; }
    public void setBanosMinimo(Integer banosMinimo) { this.banosMinimo = banosMinimo; }

    public String getTexto() { return texto; }
    public void setTexto(String texto) { this.texto = texto; }

    public int getLimite() { return limite; }

    /** Se acota entre 1 y 100 para que un parámetro manipulado no traiga la tabla entera. */
    public void setLimite(int limite) {
        if (limite < 1) {
            this.limite = 1;
        } else if (limite > 100) {
            this.limite = 100;
        } else {
            this.limite = limite;
        }
    }

    public int getDesplazamiento() { return desplazamiento; }

    public void setDesplazamiento(int desplazamiento) {
        this.desplazamiento = Math.max(desplazamiento, 0);
    }
}
