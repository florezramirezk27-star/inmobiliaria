package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class UsuarioDAO {

    public Usuario buscarPorCorreo(String correo) {

        String sql = """
                SELECT
                    id_usuario,
                    correo,
                    password_hash,
                    estado,
                    fecha_creacion,
                    fecha_ultimo_acceso
                FROM usuario
                WHERE correo = ?
                """;

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setString(1, correo);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    Usuario usuario = new Usuario();

                    usuario.setIdUsuario(
                            resultSet.getInt("id_usuario")
                    );

                    usuario.setCorreo(
                            resultSet.getString("correo")
                    );

                    usuario.setPasswordHash(
                            resultSet.getString("password_hash")
                    );

                    usuario.setEstado(
                            resultSet.getString("estado")
                    );

                    usuario.setFechaCreacion(
                            resultSet.getTimestamp("fecha_creacion")
                    );

                    usuario.setFechaUltimoAcceso(
                            resultSet.getTimestamp("fecha_ultimo_acceso")
                    );

                    return usuario;
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al buscar el usuario por correo",
                    e
            );
        }

        return null;
    }

    public int crearUsuario(Usuario usuario) {

        String sql = """
                INSERT INTO usuario (
                    correo,
                    password_hash,
                    estado
                )
                VALUES (?, ?, ?)
                """;

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        sql,
                        java.sql.Statement.RETURN_GENERATED_KEYS
                )
        ) {

            statement.setString(1, usuario.getCorreo());
            statement.setString(2, usuario.getPasswordHash());
            statement.setString(3, usuario.getEstado());

            int filasAfectadas = statement.executeUpdate();

            if (filasAfectadas == 0) {
                throw new SQLException(
                        "No se pudo crear el usuario."
                );
            }

            try (ResultSet keys = statement.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al crear el usuario",
                    e
            );
        }

        throw new RuntimeException(
                "No se pudo obtener el ID del usuario creado."
        );
    }

    public int crearUsuario(Connection connection, Usuario usuario) throws SQLException {

        String sql = """
                INSERT INTO usuario (
                    correo,
                    password_hash,
                    estado
                )
                VALUES (?, ?, ?)
                """;

        try (PreparedStatement statement = connection.prepareStatement(
                sql,
                java.sql.Statement.RETURN_GENERATED_KEYS
        )) {

            statement.setString(1, usuario.getCorreo());
            statement.setString(2, usuario.getPasswordHash());
            statement.setString(3, usuario.getEstado());

            int filas = statement.executeUpdate();

            if (filas == 0) {
                throw new SQLException("No se pudo crear el usuario.");
            }

            try (ResultSet keys = statement.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        throw new SQLException("No se pudo obtener el ID del usuario.");
    }

    public boolean actualizarUltimoAcceso(int idUsuario) {

        String sql = """
                UPDATE usuario
                SET fecha_ultimo_acceso = CURRENT_TIMESTAMP
                WHERE id_usuario = ?
                """;

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setInt(1, idUsuario);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al actualizar el último acceso",
                    e
            );
        }
    }
}
