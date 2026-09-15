package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Ciudad;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CiudadDAO {

    public List<Ciudad> listarTodas() throws SQLException {

        String sql = """
                SELECT id_ciudad, nombre, departamento
                FROM ciudad
                ORDER BY nombre
                """;

        List<Ciudad> ciudades = new ArrayList<>();

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                ciudades.add(new Ciudad(
                        rs.getInt("id_ciudad"),
                        rs.getString("nombre"),
                        rs.getString("departamento")
                ));
            }
        }

        return ciudades;
    }

    public Ciudad buscarPorId(int id) throws SQLException {

        String sql = """
                SELECT id_ciudad, nombre, departamento
                FROM ciudad
                WHERE id_ciudad = ?
                """;

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return new Ciudad(
                            rs.getInt("id_ciudad"),
                            rs.getString("nombre"),
                            rs.getString("departamento")
                    );
                }
            }
        }

        return null;
    }

    public void insertar(Ciudad ciudad) throws SQLException {

        String sql = """
                INSERT INTO ciudad (nombre, departamento)
                VALUES (?, ?)
                """;

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setString(1, ciudad.getNombre().trim());
            ps.setString(2, ciudad.getDepartamento().trim());

            ps.executeUpdate();
        }
    }

    public void actualizar(Ciudad ciudad) throws SQLException {

        String sql = """
                UPDATE ciudad
                SET nombre = ?,
                    departamento = ?
                WHERE id_ciudad = ?
                """;

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setString(1, ciudad.getNombre().trim());
            ps.setString(2, ciudad.getDepartamento().trim());
            ps.setInt(3, ciudad.getId());

            ps.executeUpdate();
        }
    }

    public void eliminar(int id) throws SQLException {

        String sql = """
                DELETE FROM ciudad
                WHERE id_ciudad = ?
                """;

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            ps.executeUpdate();
        }
    }
}
