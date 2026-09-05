package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.EstadoSolicitud;
import com.inmobiliaria.model.Solicitud;
import com.inmobiliaria.model.TipoSolicitud;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a datos de la tabla `solicitud`.
 *
 * Todos los valores viajan como parámetros de PreparedStatement; ningún
 * dato del usuario entra en el texto de la consulta, que es lo que evita
 * la inyección SQL.
 */
public class SolicitudDAO {

    private static final String COLUMNAS = """
            id_solicitud, id_propiedad, id_cliente, tipo, estado, comentario, creado_en, actualizado_en
            """;

    // ============================================================
    // Lecturas
    // ============================================================

    /** Todas las solicitudes que ha registrado un cliente, de la más reciente a la más antigua. */
    public List<Solicitud> listarPorCliente(int clienteId) throws SQLException {

        String sql = "SELECT " + COLUMNAS
                + " FROM solicitud WHERE id_cliente = ? ORDER BY creado_en DESC";

        List<Solicitud> solicitudes = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, clienteId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    solicitudes.add(mapear(rs));
                }
            }
        }
        return solicitudes;
    }

    /** Todas las solicitudes de una propiedad, para que la inmobiliaria las gestione. */
    public List<Solicitud> listarPorPropiedad(int propiedadId) throws SQLException {

        String sql = "SELECT " + COLUMNAS
                + " FROM solicitud WHERE id_propiedad = ? ORDER BY creado_en DESC";

        List<Solicitud> solicitudes = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, propiedadId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    solicitudes.add(mapear(rs));
                }
            }
        }
        return solicitudes;
    }

    /** Todas las solicitudes del sistema. */
    public List<Solicitud> listarTodas() throws SQLException {

        String sql = "SELECT " + COLUMNAS
                + " FROM solicitud ORDER BY creado_en DESC";

        List<Solicitud> solicitudes = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    solicitudes.add(mapear(rs));
                }
            }
        }
        return solicitudes;
    }

    /**
     * Ficha completa de una solicitud.
     *
     * @return la solicitud, o null si el id no existe.
     */
    public Solicitud buscarPorId(int id) throws SQLException {

        String sql = "SELECT " + COLUMNAS
                + " FROM solicitud WHERE id_solicitud = ?";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    // ============================================================
    // Escrituras
    // ============================================================

    /**
     * Inserta una solicitud y devuelve el id generado por MySQL,
     * que además queda asignado en el objeto recibido.
     * El estado por defecto lo pone la base de datos (PENDIENTE).
     */
    public int insertar(Solicitud solicitud) throws SQLException {

        String sql = """
                INSERT INTO solicitud (id_propiedad, id_cliente, tipo, comentario)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, solicitud.getPropiedadId());
            ps.setInt(2, solicitud.getClienteId());
            ps.setString(3, solicitud.getTipo().name());
            ps.setString(4, solicitud.getComentario());

            ps.executeUpdate();

            try (ResultSet claves = ps.getGeneratedKeys()) {
                if (claves.next()) {
                    solicitud.setId(claves.getInt(1));
                }
            }
            return solicitud.getId();
        }
    }

    /** Cambia el estado de la solicitud mientras la inmobiliaria la gestiona. */
    public boolean cambiarEstado(int id, EstadoSolicitud estado) throws SQLException {

        String sql = "UPDATE solicitud SET estado = ? WHERE id_solicitud = ?";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, estado.name());
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        }
    }

    /** @return true si la solicitud existía y se actualizó. */
    public boolean actualizar(Solicitud solicitud) throws SQLException {

        String sql = """
                UPDATE solicitud SET
                    id_propiedad = ?, id_cliente = ?, tipo = ?, estado = ?, comentario = ?
                WHERE id_solicitud = ?
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, solicitud.getPropiedadId());
            ps.setInt(2, solicitud.getClienteId());
            ps.setString(3, solicitud.getTipo().name());
            ps.setString(4, solicitud.getEstado() != null
                    ? solicitud.getEstado().name()
                    : EstadoSolicitud.PENDIENTE.name());
            ps.setString(5, solicitud.getComentario());
            ps.setInt(6, solicitud.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ============================================================
    // Apoyo interno
    // ============================================================

    private Solicitud mapear(ResultSet rs) throws SQLException {

        Solicitud solicitud = new Solicitud();

        solicitud.setId(rs.getInt("id_solicitud"));
        solicitud.setPropiedadId(rs.getInt("id_propiedad"));
        solicitud.setClienteId(rs.getInt("id_cliente"));
        solicitud.setTipo(TipoSolicitud.desde(rs.getString("tipo")));
        solicitud.setEstado(EstadoSolicitud.desde(rs.getString("estado")));
        solicitud.setComentario(rs.getString("comentario"));
        solicitud.setCreadoEn(leerFecha(rs, "creado_en"));
        solicitud.setActualizadoEn(leerFecha(rs, "actualizado_en"));

        return solicitud;
    }

    private java.time.LocalDateTime leerFecha(ResultSet rs, String columna)
            throws SQLException {
        Timestamp ts = rs.getTimestamp(columna);
        return ts == null ? null : ts.toLocalDateTime();
    }
}
