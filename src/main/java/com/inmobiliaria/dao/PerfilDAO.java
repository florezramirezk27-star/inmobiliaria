package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Perfil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PerfilDAO {

    public int crearPerfil(Perfil perfil) {

        String sql = """
                INSERT INTO perfil (
                    id_usuario,
                    nombres,
                    apellidos,
                    documento,
                    telefono,
                    direccion,
                    foto
                )
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        sql,
                        java.sql.Statement.RETURN_GENERATED_KEYS
                )
        ) {

            statement.setInt(1, perfil.getIdUsuario());
            statement.setString(2, perfil.getNombres());
            statement.setString(3, perfil.getApellidos());
            statement.setString(4, perfil.getDocumento());
            statement.setString(5, perfil.getTelefono());
            statement.setString(6, perfil.getDireccion());
            statement.setString(7, perfil.getFoto());

            int filasAfectadas = statement.executeUpdate();

            if (filasAfectadas == 0) {
                throw new SQLException(
                        "No se pudo crear el perfil."
                );
            }

            try (ResultSet keys = statement.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al crear el perfil",
                    e
            );
        }

        throw new RuntimeException(
                "No se pudo obtener el ID del perfil creado."
        );
    }

    public int crearPerfil(Connection connection, Perfil perfil) throws SQLException {

        String sql = """
                INSERT INTO perfil (
                    id_usuario,
                    nombres,
                    apellidos,
                    documento,
                    telefono,
                    direccion,
                    foto
                )
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement statement = connection.prepareStatement(
                sql,
                java.sql.Statement.RETURN_GENERATED_KEYS
        )) {

            statement.setInt(1, perfil.getIdUsuario());
            statement.setString(2, perfil.getNombres());
            statement.setString(3, perfil.getApellidos());
            statement.setString(4, perfil.getDocumento());
            statement.setString(5, perfil.getTelefono());
            statement.setString(6, perfil.getDireccion());
            statement.setString(7, perfil.getFoto());

            int filas = statement.executeUpdate();

            if (filas == 0) {
                throw new SQLException("No se pudo crear el perfil.");
            }

            try (ResultSet keys = statement.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        throw new SQLException("No se pudo obtener el ID del perfil.");
    }
}
