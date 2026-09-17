package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Acceso a la tabla `favorito` (relación N:M usuario ↔ propiedad).
 *
 * Devuelve solo ids de propiedad, no objetos Propiedad completos:
 * quien necesite los datos completos de cada favorito los pide a
 * PropiedadDAO.buscarPorId() uno por uno. Para una lista de favoritos
 * (típicamente pocas decenas, nunca miles) es más simple reutilizar
 * el DAO ya probado que duplicar aquí el mismo JOIN con ciudad, tipo
 * e inmobiliaria que ya existe en PropiedadDAO.
 */
public class FavoritoDAO {

    public boolean esFavorito(int usuarioId, int propiedadId) throws SQLException {

        String sql = "SELECT 1 FROM favorito WHERE id_usuario = ? AND id_propiedad = ?";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            ps.setInt(2, propiedadId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Para pintar el corazón lleno/vacío en el catálogo sin una consulta por tarjeta. */
    public Set<Integer> listarIdsPropiedadPorUsuario(int usuarioId) throws SQLException {

        String sql = "SELECT id_propiedad FROM favorito WHERE id_usuario = ?";

        Set<Integer> ids = new HashSet<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("id_propiedad"));
                }
            }
        }
        return ids;
    }

    /** Mismo listado, pero como List — útil cuando el orden de inserción importa (página "Mis favoritos"). */
    public List<Integer> listarIdsPropiedadPorUsuarioOrdenados(int usuarioId) throws SQLException {

        String sql = "SELECT id_propiedad FROM favorito WHERE id_usuario = ? ORDER BY creado_en DESC";

        List<Integer> ids = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("id_propiedad"));
                }
            }
        }
        return ids;
    }

    /** No lanza error si ya existía (INSERT IGNORE): marcar dos veces el mismo favorito no debe romper nada. */
    public void agregar(int usuarioId, int propiedadId) throws SQLException {

        String sql = "INSERT IGNORE INTO favorito (id_usuario, id_propiedad) VALUES (?, ?)";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            ps.setInt(2, propiedadId);
            ps.executeUpdate();
        }
    }

    public void quitar(int usuarioId, int propiedadId) throws SQLException {

        String sql = "DELETE FROM favorito WHERE id_usuario = ? AND id_propiedad = ?";

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            ps.setInt(2, propiedadId);
            ps.executeUpdate();
        }
    }
}
