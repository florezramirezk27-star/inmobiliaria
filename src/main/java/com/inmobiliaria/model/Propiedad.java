package com.inmobiliaria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Representa una fila de la tabla `propiedad`.
 *
 * Los campos tipoNombre, tipoSlug, ciudadNombre, ciudadDepartamento y
 * rutaPortada no existen en la tabla: vienen de los JOIN que resuelve la
 * vista v_propiedad_catalogo. Se guardan aquí para que el catálogo pueda
 * pintar una tarjeta completa sin una segunda consulta por cada fila.
 *
 * precio y administracion usan BigDecimal, no double: los valores en pesos
 * no toleran el error de redondeo del punto flotante.
 *
 * Los envoltorios (Integer, BigDecimal) en lugar de tipos primitivos permiten
 * representar el NULL de la base de datos. Un lote, por ejemplo, no tiene
 * estrato ni área construida.
 */
public class Propiedad {

    // --- Identificación ---
    private int id;
    private String codigo;                  // código comercial visible al público
    private String matriculaInmobiliaria;    // folio de registro; UNIQUE exigido por el enunciado
    private String titulo;
    private String descripcion;

    // --- Clasificación ---
    private Operacion operacion;
    private EstadoPropiedad estado;

    private int tipoPropiedadId;
    private String tipoNombre;      // del JOIN
    private String tipoSlug;        // del JOIN

    private int ciudadId;
    private String ciudadNombre;        // del JOIN
    private String ciudadDepartamento;  // del JOIN

    private int inmobiliariaId;         // agencia que publica (relación 1:N exigida)
    private String inmobiliariaNombre;  // del JOIN

    private int usuarioId;              // usuario que registró la fila (auditoría)

    // --- Valores ---
    private BigDecimal precio;
    private BigDecimal administracion;

    // --- Medidas ---
    private BigDecimal areaConstruida;
    private BigDecimal areaLote;
    private int habitaciones;
    private int banos;
    private int parqueaderos;
    private Integer estrato;
    private Integer antiguedadAnios;

    // --- Ubicación ---
    private String direccion;
    private String barrio;
    private BigDecimal latitud;
    private BigDecimal longitud;

    // --- Auditoría ---
    private LocalDateTime creadoEn;
    private LocalDateTime actualizadoEn;

    // --- Derivado ---
    private String rutaPortada;     // imagen de portada, del subquery de la vista

    public Propiedad() {
    }

    // ------------------------------------------------------------
    // Métodos de apoyo para las vistas
    // ------------------------------------------------------------

    /**
     * true cuando el precio debe mostrarse con "/ mes".
     * Evita escribir la comparación con el enum dentro de la JSP.
     */
    public boolean isPrecioMensual() {
        return operacion != null && operacion.isPeriodica();
    }

    /**
     * Ubicación en una sola línea, tal como aparece bajo el título en la tarjeta.
     * Omite el barrio cuando la propiedad no lo tiene registrado.
     */
    public String getUbicacionCorta() {
        StringBuilder sb = new StringBuilder();
        if (barrio != null && !barrio.isBlank()) {
            sb.append(barrio).append(", ");
        }
        if (ciudadNombre != null) {
            sb.append(ciudadNombre);
        }
        if (ciudadDepartamento != null && !ciudadDepartamento.isBlank()) {
            sb.append(", ").append(ciudadDepartamento);
        }
        return sb.toString();
    }

    /** true si hay una imagen de portada cargada; si no, la JSP pinta el marcador CSS. */
    public boolean isTienePortada() {
        return rutaPortada != null && !rutaPortada.isBlank();
    }

    // ------------------------------------------------------------
    // Getters y setters
    // ------------------------------------------------------------

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getMatriculaInmobiliaria() { return matriculaInmobiliaria; }
    public void setMatriculaInmobiliaria(String matriculaInmobiliaria) { this.matriculaInmobiliaria = matriculaInmobiliaria; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public Operacion getOperacion() { return operacion; }
    public void setOperacion(Operacion operacion) { this.operacion = operacion; }

    public EstadoPropiedad getEstado() { return estado; }
    public void setEstado(EstadoPropiedad estado) { this.estado = estado; }

    public int getTipoPropiedadId() { return tipoPropiedadId; }
    public void setTipoPropiedadId(int tipoPropiedadId) { this.tipoPropiedadId = tipoPropiedadId; }

    public String getTipoNombre() { return tipoNombre; }
    public void setTipoNombre(String tipoNombre) { this.tipoNombre = tipoNombre; }

    public String getTipoSlug() { return tipoSlug; }
    public void setTipoSlug(String tipoSlug) { this.tipoSlug = tipoSlug; }

    public int getCiudadId() { return ciudadId; }
    public void setCiudadId(int ciudadId) { this.ciudadId = ciudadId; }

    public String getCiudadNombre() { return ciudadNombre; }
    public void setCiudadNombre(String ciudadNombre) { this.ciudadNombre = ciudadNombre; }

    public String getCiudadDepartamento() { return ciudadDepartamento; }
    public void setCiudadDepartamento(String ciudadDepartamento) { this.ciudadDepartamento = ciudadDepartamento; }

    public int getInmobiliariaId() { return inmobiliariaId; }
    public void setInmobiliariaId(int inmobiliariaId) { this.inmobiliariaId = inmobiliariaId; }

    public String getInmobiliariaNombre() { return inmobiliariaNombre; }
    public void setInmobiliariaNombre(String inmobiliariaNombre) { this.inmobiliariaNombre = inmobiliariaNombre; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }

    public BigDecimal getAdministracion() { return administracion; }
    public void setAdministracion(BigDecimal administracion) { this.administracion = administracion; }

    public BigDecimal getAreaConstruida() { return areaConstruida; }
    public void setAreaConstruida(BigDecimal areaConstruida) { this.areaConstruida = areaConstruida; }

    public BigDecimal getAreaLote() { return areaLote; }
    public void setAreaLote(BigDecimal areaLote) { this.areaLote = areaLote; }

    public int getHabitaciones() { return habitaciones; }
    public void setHabitaciones(int habitaciones) { this.habitaciones = habitaciones; }

    public int getBanos() { return banos; }
    public void setBanos(int banos) { this.banos = banos; }

    public int getParqueaderos() { return parqueaderos; }
    public void setParqueaderos(int parqueaderos) { this.parqueaderos = parqueaderos; }

    public Integer getEstrato() { return estrato; }
    public void setEstrato(Integer estrato) { this.estrato = estrato; }

    public Integer getAntiguedadAnios() { return antiguedadAnios; }
    public void setAntiguedadAnios(Integer antiguedadAnios) { this.antiguedadAnios = antiguedadAnios; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public String getBarrio() { return barrio; }
    public void setBarrio(String barrio) { this.barrio = barrio; }

    public BigDecimal getLatitud() { return latitud; }
    public void setLatitud(BigDecimal latitud) { this.latitud = latitud; }

    public BigDecimal getLongitud() { return longitud; }
    public void setLongitud(BigDecimal longitud) { this.longitud = longitud; }

    public LocalDateTime getCreadoEn() { return creadoEn; }
    public void setCreadoEn(LocalDateTime creadoEn) { this.creadoEn = creadoEn; }

    public LocalDateTime getActualizadoEn() { return actualizadoEn; }
    public void setActualizadoEn(LocalDateTime actualizadoEn) { this.actualizadoEn = actualizadoEn; }

    public String getRutaPortada() { return rutaPortada; }
    public void setRutaPortada(String rutaPortada) { this.rutaPortada = rutaPortada; }

    @Override
    public String toString() {
        return "Propiedad{" + codigo + " - " + titulo + " - " + precio + "}";
    }
}
