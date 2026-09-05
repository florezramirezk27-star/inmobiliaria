package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Documento;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a los documentos de una solicitud (tabla `documento_solicitud`).
 *
 * Esta clase solo conoce la fila de base de datos (nombre del archivo,
 * ruta, fecha de subida). Guardar y borrar el archivo físico en disco es
 * responsabilidad del servlet que la usa (DocumentoServlet), no de este
 * DAO — mismo principio de separación que el resto del proyecto: el DAO
 * habla con la base de datos, el servlet habla con el mundo exterior
 * (disco, HTTP).
 */
public class DocumentoDAO {

    private static final String COLUMNAS = """
            id_documento, id_solicitud, nombre_archivo, ruta, subido_en
            """;

    public List<Documento> listarPorSolicitud(int solicitudId) throws SQLException {

        String sql = "SELECT " + COLUMNAS
                + " FROM documento_solicitud WHERE id_solicitud = ? ORDER BY subido_en ASC";

        List<Documento> documentos = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, solicitudId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    documentos.add(mapear(rs));
                }
            }
        }
        return documentos;
    }

    /** Necesario antes de borrar: para saber qué archivo físico eliminar del disco. */
    public Documento buscarPorId(int idDocumento) throws SQLException {

        String sql = "SELECT " + COLUMNAS
                + " FROM documento_solicitud WHERE id_documento = ?";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idDocumento);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    /**
     * Inserta la fila del documento ya guardado en disco.
     * Devuelve el id generado por MySQL, que además queda asignado en el objeto.
     */
    public int insertar(Documento documento) throws SQLException {

        String sql = """
                INSERT INTO documento_solicitud (id_solicitud, nombre_archivo, ruta)
                VALUES (?, ?, ?)
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, documento.getSolicitudId());
            ps.setString(2, documento.getNombreArchivo());
            ps.setString(3, documento.getRuta());

            ps.executeUpdate();

            try (ResultSet claves = ps.getGeneratedKeys()) {
                if (claves.next()) {
                    documento.setId(claves.getInt(1));
                }
            }
            return documento.getId();
        }
    }

    /**
     * Borra la fila. El archivo físico en disco lo borra el servlet
     * después de llamar a este método (necesita la ruta, que ya tenía
     * de un buscarPorId() previo).
     */
    public boolean eliminar(int idDocumento) throws SQLException {

        String sql = "DELETE FROM documento_solicitud WHERE id_documento = ?";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idDocumento);
            return ps.executeUpdate() > 0;
        }
    }

    private Documento mapear(ResultSet rs) throws SQLException {

        Documento documento = new Documento();

        documento.setId(rs.getInt("id_documento"));
        documento.setSolicitudId(rs.getInt("id_solicitud"));
        documento.setNombreArchivo(rs.getString("nombre_archivo"));
        documento.setRuta(rs.getString("ruta"));
        documento.setSubidoEn(leerFecha(rs, "subido_en"));

        return documento;
    }

    private java.time.LocalDateTime leerFecha(ResultSet rs, String columna)
            throws SQLException {
        Timestamp ts = rs.getTimestamp(columna);
        return ts == null ? null : ts.toLocalDateTime();
    }
}
