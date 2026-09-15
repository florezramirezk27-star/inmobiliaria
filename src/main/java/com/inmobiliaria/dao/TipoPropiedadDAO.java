package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.TipoPropiedad;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;

public class TipoPropiedadDAO {

    public List<TipoPropiedad> listarTodos() throws SQLException {

        String sql = """
                SELECT id_tipo_propiedad, nombre, descripcion
                FROM tipo_propiedad
                ORDER BY nombre
                """;

        List<TipoPropiedad> tipos = new ArrayList<>();

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                TipoPropiedad tipo = new TipoPropiedad();

                tipo.setIdTipo(
                        rs.getInt("id_tipo_propiedad")
                );

                tipo.setNombre(
                        rs.getString("nombre")
                );

                tipo.setDescripcion(
                        rs.getString("descripcion")
                );

                tipos.add(tipo);
            }
        }

        return tipos;
    }

    public TipoPropiedad buscarPorId(int id) throws SQLException {

        String sql = """
                SELECT id_tipo_propiedad, nombre, descripcion
                FROM tipo_propiedad
                WHERE id_tipo_propiedad = ?
                """;

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    TipoPropiedad tipo =
                            new TipoPropiedad();

                    tipo.setIdTipo(
                            rs.getInt("id_tipo_propiedad")
                    );

                    tipo.setNombre(
                            rs.getString("nombre")
                    );

                    tipo.setDescripcion(
                            rs.getString("descripcion")
                    );

                    return tipo;
                }
            }
        }

        return null;
    }

    /**
     * La columna `slug` es NOT NULL y UNIQUE en el esquema
     * (el buscador público filtra por ese valor), así que se
     * genera automáticamente a partir del nombre.
     */
    public void insertar(TipoPropiedad tipo)
            throws SQLException {

        String sql = """
                INSERT INTO tipo_propiedad
                    (nombre, descripcion, slug)
                VALUES (?, ?, ?)
                """;

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps =
                        cn.prepareStatement(sql)
        ) {

            ps.setString(
                    1,
                    tipo.getNombre().trim()
            );

            ps.setString(
                    2,
                    tipo.getDescripcion() != null
                            ? tipo.getDescripcion().trim()
                            : null
            );

            ps.setString(
                    3,
                    generarSlug(tipo.getNombre())
            );

            ps.executeUpdate();
        }
    }

    public void actualizar(TipoPropiedad tipo)
            throws SQLException {

        String sql = """
                UPDATE tipo_propiedad
                SET nombre = ?,
                    descripcion = ?,
                    slug = ?
                WHERE id_tipo_propiedad = ?
                """;

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps =
                        cn.prepareStatement(sql)
        ) {

            ps.setString(
                    1,
                    tipo.getNombre().trim()
            );

            ps.setString(
                    2,
                    tipo.getDescripcion() != null
                            ? tipo.getDescripcion().trim()
                            : null
            );

            ps.setString(
                    3,
                    generarSlug(tipo.getNombre())
            );

            ps.setInt(
                    4,
                    tipo.getIdTipo()
            );

            ps.executeUpdate();
        }
    }

    public void eliminar(int id)
            throws SQLException {

        String sql = """
                DELETE FROM tipo_propiedad
                WHERE id_tipo_propiedad = ?
                """;

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps =
                        cn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            ps.executeUpdate();
        }
    }

    /**
     * Slug simple: minúsculas, sin acentos, espacios a guiones.
     */
    private String generarSlug(String nombre) {

        String base = Normalizer.normalize(
                nombre.toLowerCase(),
                Normalizer.Form.NFD
        ).replaceAll("\\p{M}", "");

        return base.replaceAll("[^a-z0-9]+", "-")
                   .replaceAll("(^-|-$)", "");
    }
}