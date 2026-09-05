package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Cita;
import com.inmobiliaria.model.EstadoCita;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a la tabla `cita` (agendamiento de visitas).
 *
 * Igual que PropiedadDAO: todos los valores viajan como parámetros
 * de PreparedStatement, y el UNIQUE duplicado (misma propiedad +
 * mismo horario) se traduce a DuplicidadException con un mensaje
 * claro, no se deja pasar la excepción cruda de MySQL.
 */
public class CitaDAO {

    /** Para la ficha de la propiedad: todas sus citas, más recientes primero. */
    public List<Cita> listarPorPropiedad(int propiedadId) throws SQLException {

        String sql = """
                SELECT c.id_cita, c.id_propiedad, c.id_cliente, c.fecha_hora,
                       c.estado, c.observacion, c.creado_en,
                       CONCAT(perf.nombres, ' ', perf.apellidos) AS cliente_nombre_completo
                  FROM cita c
                  JOIN usuario u ON u.id_usuario = c.id_cliente
                  LEFT JOIN perfil perf ON perf.id_usuario = u.id_usuario
                 WHERE c.id_propiedad = ?
                 ORDER BY c.fecha_hora DESC
                """;

        List<Cita> citas = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, propiedadId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita c = mapearBase(rs);
                    c.setClienteNombreCompleto(rs.getString("cliente_nombre_completo"));
                    citas.add(c);
                }
            }
        }
        return citas;
    }

    /** Para "Mis citas": las del cliente, con el título de cada propiedad ya resuelto. */
    public List<Cita> listarPorCliente(int clienteId) throws SQLException {

        String sql = """
                SELECT c.id_cita, c.id_propiedad, c.id_cliente, c.fecha_hora,
                       c.estado, c.observacion, c.creado_en,
                       p.titulo AS propiedad_titulo, p.codigo AS propiedad_codigo
                  FROM cita c
                  JOIN propiedad p ON p.id_propiedad = c.id_propiedad
                 WHERE c.id_cliente = ?
                 ORDER BY c.fecha_hora DESC
                """;

        List<Cita> citas = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, clienteId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita c = mapearBase(rs);
                    c.setPropiedadTitulo(rs.getString("propiedad_titulo"));
                    c.setPropiedadCodigo(rs.getString("propiedad_codigo"));
                    citas.add(c);
                }
            }
        }
        return citas;
    }

    public Cita buscarPorId(int idCita) throws SQLException {

        String sql = """
                SELECT id_cita, id_propiedad, id_cliente, fecha_hora, estado, observacion, creado_en
                  FROM cita
                 WHERE id_cita = ?
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCita);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapearBase(rs) : null;
            }
        }
    }

    /**
     * Agenda una visita nueva. Si ya existe una cita para la misma
     * propiedad en el mismo horario exacto (restricción UNIQUE de la
     * tabla), se traduce a DuplicidadException con un mensaje claro
     * en vez de dejar pasar la excepción cruda de MySQL — el
     * enunciado exige exactamente este manejo.
     */
    public int agendar(Cita cita) throws SQLException {

        String sql = """
                INSERT INTO cita (id_propiedad, id_cliente, fecha_hora, estado, observacion)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, cita.getPropiedadId());
            ps.setInt(2, cita.getClienteId());
            ps.setTimestamp(3, Timestamp.valueOf(cita.getFechaHora()));
            ps.setString(4, cita.getEstado() != null ? cita.getEstado().name() : EstadoCita.SOLICITADA.name());
            ps.setString(5, cita.getObservacion());

            ps.executeUpdate();

            try (ResultSet claves = ps.getGeneratedKeys()) {
                if (claves.next()) {
                    cita.setId(claves.getInt(1));
                }
            }
            return cita.getId();

        } catch (SQLIntegrityConstraintViolationException e) {
            if (e.getMessage() != null && e.getMessage().contains("uq_cita_propiedad_horario")) {
                throw new DuplicidadException(
                        "Ya hay una visita agendada a esa propiedad exactamente a esa fecha y hora. Elige otro horario.",
                        e);
            }
            throw e;
        }
    }

    public boolean cambiarEstado(int idCita, EstadoCita nuevoEstado) throws SQLException {

        String sql = "UPDATE cita SET estado = ? WHERE id_cita = ?";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado.name());
            ps.setInt(2, idCita);

            return ps.executeUpdate() > 0;
        }
    }

    private Cita mapearBase(ResultSet rs) throws SQLException {

        Cita c = new Cita();
        c.setId(rs.getInt("id_cita"));
        c.setPropiedadId(rs.getInt("id_propiedad"));
        c.setClienteId(rs.getInt("id_cliente"));
        c.setFechaHora(leerFecha(rs, "fecha_hora"));
        c.setEstado(EstadoCita.desde(rs.getString("estado")));
        c.setObservacion(rs.getString("observacion"));
        c.setCreadoEn(leerFecha(rs, "creado_en"));
        return c;
    }

    private LocalDateTime leerFecha(ResultSet rs, String columna) throws SQLException {
        Timestamp ts = rs.getTimestamp(columna);
        return ts == null ? null : ts.toLocalDateTime();
    }
}
