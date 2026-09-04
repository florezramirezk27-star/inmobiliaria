package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.EstadoPropiedad;
import com.inmobiliaria.model.Operacion;
import com.inmobiliaria.model.Propiedad;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a datos de la tabla `propiedad`.
 *
 * Las lecturas del catálogo consultan la vista v_propiedad_catalogo, que ya
 * resuelve los JOIN con ciudad y tipo_propiedad, trae la imagen de portada y
 * filtra por estado = 'PUBLICADA'.
 *
 * Las escrituras van directo contra la tabla.
 *
 * Todos los valores viajan como parámetros de PreparedStatement. En
 * construirWhere() se concatena SQL, pero únicamente nombres de columna y
 * marcadores '?' escritos en este archivo: ningún dato del usuario entra en
 * el texto de la consulta, que es lo que evita la inyección SQL.
 */
public class PropiedadDAO {

    /** Columnas de la vista, en el orden que espera mapearCatalogo(). */
    private static final String COLUMNAS_CATALOGO = """
            id_propiedad, codigo, matricula_inmobiliaria, titulo, operacion, precio, administracion,
            area_construida, habitaciones, banos, parqueaderos, estrato,
            direccion, barrio, creado_en,
            id_ciudad, id_tipo_propiedad, id_inmobiliaria, id_usuario,
            tipo_nombre, tipo_slug, ciudad_nombre, ciudad_departamento,
            inmobiliaria_nombre, ruta_portada
            """;

    // ============================================================
    // Lecturas
    // ============================================================

    /**
     * Propiedades publicadas más recientes, para la sección de destacados
     * de la página de inicio.
     */
    public List<Propiedad> listarRecientes(int limite) throws SQLException {

        String sql = "SELECT " + COLUMNAS_CATALOGO
                + " FROM v_propiedad_catalogo ORDER BY creado_en DESC LIMIT ?";

        List<Propiedad> propiedades = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, limite);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    propiedades.add(mapearCatalogo(rs));
                }
            }
        }
        return propiedades;
    }

    /**
     * Búsqueda del catálogo con los criterios del formulario.
     * Un filtro vacío devuelve las propiedades publicadas más recientes.
     */
    public List<Propiedad> buscar(FiltroPropiedad filtro) throws SQLException {

        List<Object> parametros = new ArrayList<>();
        String where = construirWhere(filtro, parametros);

        String sql = "SELECT " + COLUMNAS_CATALOGO
                + " FROM v_propiedad_catalogo"
                + where
                + " ORDER BY creado_en DESC LIMIT ? OFFSET ?";

        parametros.add(filtro.getLimite());
        parametros.add(filtro.getDesplazamiento());

        List<Propiedad> propiedades = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            asignarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    propiedades.add(mapearCatalogo(rs));
                }
            }
        }
        return propiedades;
    }

    /** Total de resultados del filtro, sin paginar. Sirve para el paginador. */
    public int contar(FiltroPropiedad filtro) throws SQLException {

        List<Object> parametros = new ArrayList<>();
        String where = construirWhere(filtro, parametros);

        String sql = "SELECT COUNT(*) FROM v_propiedad_catalogo" + where;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            asignarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /**
     * Ficha completa de una propiedad, incluidos los campos que el catálogo
     * no necesita (descripción, coordenadas, estado, dueño).
     *
     * Consulta la tabla y no la vista, para poder abrir también las
     * propiedades en BORRADOR desde el panel de administración.
     *
     * @return la propiedad, o null si el id no existe.
     */
    public Propiedad buscarPorId(int id) throws SQLException {

        String sql = """
                SELECT p.*, t.nombre AS tipo_nombre, t.slug AS tipo_slug,
                       c.nombre AS ciudad_nombre, c.departamento AS ciudad_departamento,
                       im.nombre_comercial AS inmobiliaria_nombre,
                       (SELECT img.ruta FROM imagen_propiedad img
                         WHERE img.id_propiedad = p.id_propiedad
                         ORDER BY img.es_portada DESC, img.orden ASC LIMIT 1) AS ruta_portada
                  FROM propiedad p
                  JOIN tipo_propiedad t ON t.id_tipo_propiedad = p.id_tipo_propiedad
                  JOIN ciudad         c ON c.id_ciudad = p.id_ciudad
                  JOIN inmobiliaria  im ON im.id_inmobiliaria = p.id_inmobiliaria
                 WHERE p.id_propiedad = ?
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapearCompleta(rs) : null;
            }
        }
    }

    // ============================================================
    // Escrituras
    // ============================================================

    /**
     * Inserta una propiedad y devuelve el id generado por MySQL,
     * que además queda asignado en el objeto recibido.
     */
    public int insertar(Propiedad p) throws SQLException {

        String sql = """
                INSERT INTO propiedad
                    (codigo, matricula_inmobiliaria, titulo, descripcion, operacion, estado,
                     id_tipo_propiedad, id_ciudad, id_inmobiliaria, id_usuario,
                     precio, administracion, area_construida, area_lote,
                     habitaciones, banos, parqueaderos, estrato, antiguedad_anios,
                     direccion, barrio, latitud, longitud)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            asignarCampos(ps, p);

            ps.executeUpdate();

            try (ResultSet claves = ps.getGeneratedKeys()) {
                if (claves.next()) {
                    p.setId(claves.getInt(1));
                }
            }
            return p.getId();

        } catch (SQLIntegrityConstraintViolationException e) {
            // El enunciado exige capturar el UNIQUE duplicado y mostrar un
            // mensaje claro, no dejar pasar la excepción cruda de Java.
            if (mencionaColumna(e, "uq_propiedad_matricula")) {
                throw new DuplicidadException(
                        "Ya existe una propiedad registrada con esa matrícula inmobiliaria.", e);
            }
            if (mencionaColumna(e, "uq_propiedad_codigo")) {
                throw new DuplicidadException(
                        "Ya existe una propiedad registrada con ese código.", e);
            }
            throw e;
        }
    }

    /** El mensaje de MySQL para un UNIQUE incluye el nombre de la restricción entre comillas. */
    private boolean mencionaColumna(SQLIntegrityConstraintViolationException e, String restriccion) {
        return e.getMessage() != null && e.getMessage().contains(restriccion);
    }

    /** @return true si la propiedad existía y se actualizó. */
    public boolean actualizar(Propiedad p) throws SQLException {

        String sql = """
                UPDATE propiedad SET
                    codigo = ?, matricula_inmobiliaria = ?, titulo = ?, descripcion = ?, operacion = ?, estado = ?,
                    id_tipo_propiedad = ?, id_ciudad = ?, id_inmobiliaria = ?, id_usuario = ?,
                    precio = ?, administracion = ?, area_construida = ?, area_lote = ?,
                    habitaciones = ?, banos = ?, parqueaderos = ?, estrato = ?, antiguedad_anios = ?,
                    direccion = ?, barrio = ?, latitud = ?, longitud = ?
                WHERE id_propiedad = ?
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            int i = asignarCampos(ps, p);
            ps.setInt(i, p.getId());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cambia el estado sin borrar la fila.
     *
     * Se prefiere sobre eliminar() para retirar una publicación: conserva el
     * historial de citas y solicitudes que la referencian.
     */
    public boolean cambiarEstado(int id, EstadoPropiedad estado) throws SQLException {

        String sql = "UPDATE propiedad SET estado = ? WHERE id_propiedad = ?";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, estado.name());
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Borrado físico.
     *
     * Las imágenes, características y favoritos asociados se eliminan solos
     * por el ON DELETE CASCADE definido en el DDL.
     */
    public boolean eliminar(int id) throws SQLException {

        String sql = "DELETE FROM propiedad WHERE id_propiedad = ?";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ============================================================
    // Apoyo interno
    // ============================================================

    /**
     * Arma la cláusula WHERE según los criterios presentes y va llenando la
     * lista de parámetros en el mismo orden en que aparecen los '?'.
     *
     * Solo se concatenan literales escritos en este método; los valores
     * siempre viajan como parámetros.
     */
    private String construirWhere(FiltroPropiedad filtro, List<Object> parametros) {

        List<String> condiciones = new ArrayList<>();

        if (filtro.getOperacion() != null) {
            condiciones.add("operacion = ?");
            parametros.add(filtro.getOperacion().name());
        }
        if (filtro.getCiudadId() != null) {
            condiciones.add("id_ciudad = ?");
            parametros.add(filtro.getCiudadId());
        }
        if (filtro.getTipoSlug() != null && !filtro.getTipoSlug().isBlank()) {
            condiciones.add("tipo_slug = ?");
            parametros.add(filtro.getTipoSlug().trim());
        }
        if (filtro.getPrecioMinimo() != null) {
            condiciones.add("precio >= ?");
            parametros.add(filtro.getPrecioMinimo());
        }
        if (filtro.getPrecioMaximo() != null) {
            condiciones.add("precio <= ?");
            parametros.add(filtro.getPrecioMaximo());
        }
        if (filtro.getHabitacionesMinimo() != null) {
            condiciones.add("habitaciones >= ?");
            parametros.add(filtro.getHabitacionesMinimo());
        }
        if (filtro.getBanosMinimo() != null) {
            condiciones.add("banos >= ?");
            parametros.add(filtro.getBanosMinimo());
        }
        if (filtro.getTexto() != null && !filtro.getTexto().isBlank()) {
            condiciones.add("(titulo LIKE ? OR barrio LIKE ? OR direccion LIKE ?)");
            String patron = "%" + filtro.getTexto().trim() + "%";
            parametros.add(patron);
            parametros.add(patron);
            parametros.add(patron);
        }

        if (condiciones.isEmpty()) {
            return "";
        }
        return " WHERE " + String.join(" AND ", condiciones);
    }

    private void asignarParametros(PreparedStatement ps, List<Object> parametros)
            throws SQLException {

        for (int i = 0; i < parametros.size(); i++) {
            ps.setObject(i + 1, parametros.get(i));
        }
    }

    /**
     * Coloca los 21 campos de la propiedad en el statement.
     *
     * @return el siguiente índice libre, para que actualizar() ponga ahí el WHERE id = ?.
     */
    private int asignarCampos(PreparedStatement ps, Propiedad p) throws SQLException {

        int i = 1;

        ps.setString(i++, p.getCodigo());
        ps.setString(i++, p.getMatriculaInmobiliaria());
        ps.setString(i++, p.getTitulo());
        ps.setString(i++, p.getDescripcion());
        ps.setString(i++, p.getOperacion().name());
        ps.setString(i++, p.getEstado() != null
                ? p.getEstado().name()
                : EstadoPropiedad.BORRADOR.name());

        ps.setInt(i++, p.getTipoPropiedadId());
        ps.setInt(i++, p.getCiudadId());
        ps.setInt(i++, p.getInmobiliariaId());
        ps.setInt(i++, p.getUsuarioId());

        ps.setBigDecimal(i++, p.getPrecio());
        ps.setBigDecimal(i++, p.getAdministracion() != null
                ? p.getAdministracion()
                : BigDecimal.ZERO);

        ps.setBigDecimal(i++, p.getAreaConstruida());
        ps.setBigDecimal(i++, p.getAreaLote());

        ps.setInt(i++, p.getHabitaciones());
        ps.setInt(i++, p.getBanos());
        ps.setInt(i++, p.getParqueaderos());

        asignarEntero(ps, i++, p.getEstrato());
        asignarEntero(ps, i++, p.getAntiguedadAnios());

        ps.setString(i++, p.getDireccion());
        ps.setString(i++, p.getBarrio());
        ps.setBigDecimal(i++, p.getLatitud());
        ps.setBigDecimal(i++, p.getLongitud());

        return i;
    }

    /** setInt() no acepta null, así que un Integer vacío se escribe como NULL explícito. */
    private void asignarEntero(PreparedStatement ps, int indice, Integer valor)
            throws SQLException {

        if (valor == null) {
            ps.setNull(indice, java.sql.Types.INTEGER);
        } else {
            ps.setInt(indice, valor);
        }
    }

    /** Mapea una fila de v_propiedad_catalogo. */
    private Propiedad mapearCatalogo(ResultSet rs) throws SQLException {

        Propiedad p = new Propiedad();

        p.setId(rs.getInt("id_propiedad"));
        p.setCodigo(rs.getString("codigo"));
        p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
        p.setTitulo(rs.getString("titulo"));
        p.setOperacion(Operacion.desde(rs.getString("operacion")));
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setAdministracion(rs.getBigDecimal("administracion"));
        p.setAreaConstruida(rs.getBigDecimal("area_construida"));
        p.setHabitaciones(rs.getInt("habitaciones"));
        p.setBanos(rs.getInt("banos"));
        p.setParqueaderos(rs.getInt("parqueaderos"));
        p.setEstrato(leerEntero(rs, "estrato"));
        p.setDireccion(rs.getString("direccion"));
        p.setBarrio(rs.getString("barrio"));
        p.setCreadoEn(leerFecha(rs, "creado_en"));
        p.setCiudadId(rs.getInt("id_ciudad"));
        p.setTipoPropiedadId(rs.getInt("id_tipo_propiedad"));
        p.setInmobiliariaId(rs.getInt("id_inmobiliaria"));
        p.setUsuarioId(rs.getInt("id_usuario"));
        p.setTipoNombre(rs.getString("tipo_nombre"));
        p.setTipoSlug(rs.getString("tipo_slug"));
        p.setCiudadNombre(rs.getString("ciudad_nombre"));
        p.setCiudadDepartamento(rs.getString("ciudad_departamento"));
        p.setInmobiliariaNombre(rs.getString("inmobiliaria_nombre"));
        p.setRutaPortada(rs.getString("ruta_portada"));

        // La vista solo publica propiedades activas.
        p.setEstado(EstadoPropiedad.PUBLICADA);

        return p;
    }

    /** Mapea una fila con todas las columnas de la tabla más los JOIN. */
    private Propiedad mapearCompleta(ResultSet rs) throws SQLException {

        Propiedad p = new Propiedad();

        p.setId(rs.getInt("id_propiedad"));
        p.setCodigo(rs.getString("codigo"));
        p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
        p.setTitulo(rs.getString("titulo"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setOperacion(Operacion.desde(rs.getString("operacion")));
        p.setEstado(EstadoPropiedad.desde(rs.getString("estado")));

        p.setTipoPropiedadId(rs.getInt("id_tipo_propiedad"));
        p.setCiudadId(rs.getInt("id_ciudad"));
        p.setInmobiliariaId(rs.getInt("id_inmobiliaria"));
        p.setUsuarioId(rs.getInt("id_usuario"));

        p.setPrecio(rs.getBigDecimal("precio"));
        p.setAdministracion(rs.getBigDecimal("administracion"));
        p.setAreaConstruida(rs.getBigDecimal("area_construida"));
        p.setAreaLote(rs.getBigDecimal("area_lote"));

        p.setHabitaciones(rs.getInt("habitaciones"));
        p.setBanos(rs.getInt("banos"));
        p.setParqueaderos(rs.getInt("parqueaderos"));
        p.setEstrato(leerEntero(rs, "estrato"));
        p.setAntiguedadAnios(leerEntero(rs, "antiguedad_anios"));

        p.setDireccion(rs.getString("direccion"));
        p.setBarrio(rs.getString("barrio"));
        p.setLatitud(rs.getBigDecimal("latitud"));
        p.setLongitud(rs.getBigDecimal("longitud"));

        p.setCreadoEn(leerFecha(rs, "creado_en"));
        p.setActualizadoEn(leerFecha(rs, "actualizado_en"));

        p.setTipoNombre(rs.getString("tipo_nombre"));
        p.setTipoSlug(rs.getString("tipo_slug"));
        p.setCiudadNombre(rs.getString("ciudad_nombre"));
        p.setCiudadDepartamento(rs.getString("ciudad_departamento"));
        p.setInmobiliariaNombre(rs.getString("inmobiliaria_nombre"));
        p.setRutaPortada(rs.getString("ruta_portada"));

        return p;
    }

    /** getInt() devuelve 0 ante un NULL; wasNull() distingue el cero real del vacío. */
    private Integer leerEntero(ResultSet rs, String columna) throws SQLException {
        int valor = rs.getInt(columna);
        return rs.wasNull() ? null : valor;
    }

    private java.time.LocalDateTime leerFecha(ResultSet rs, String columna)
            throws SQLException {
        Timestamp ts = rs.getTimestamp(columna);
        return ts == null ? null : ts.toLocalDateTime();
    }
}
