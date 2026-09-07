package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Rol;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioRolDAO {

    public void asignarRol(Connection connection, int idUsuario, int idRol)
            throws SQLException {

        String sql = """
                INSERT INTO usuario_rol (
                    id_usuario,
                    id_rol
                )
                VALUES (?, ?)
                """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, idUsuario);
            statement.setInt(2, idRol);

            statement.executeUpdate();
        }
    }

    public List<Rol> listarRoles(int idUsuario) {

        String sql = """
                SELECT
                    r.id_rol,
                    r.nombre,
                    r.descripcion
                FROM rol r
                INNER JOIN usuario_rol ur
                    ON r.id_rol = ur.id_rol
                WHERE ur.id_usuario = ?
                ORDER BY r.id_rol
                """;

        List<Rol> roles = new ArrayList<>();

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setInt(1, idUsuario);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {

                    Rol rol = new Rol();

                    rol.setIdRol(resultSet.getInt("id_rol"));
                    rol.setNombre(resultSet.getString("nombre"));
                    rol.setDescripcion(
                            resultSet.getString("descripcion")
                    );

                    roles.add(rol);
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al listar los roles del usuario",
                    e
            );
        }

        return roles;
    }

    public void reemplazarRol(
            int idUsuario,
            int idRol
    ) {

        String deleteSql = """
                DELETE FROM usuario_rol
                WHERE id_usuario = ?
                """;

        String insertSql = """
                INSERT INTO usuario_rol (
                    id_usuario,
                    id_rol
                )
                VALUES (?, ?)
                """;

        try (
                Connection connection = ConnectionFactory.getConnection()
        ) {

            connection.setAutoCommit(false);

            try {

                try (PreparedStatement deleteStatement =
                             connection.prepareStatement(deleteSql)) {

                    deleteStatement.setInt(1, idUsuario);
                    deleteStatement.executeUpdate();
                }

                try (PreparedStatement insertStatement =
                             connection.prepareStatement(insertSql)) {

                    insertStatement.setInt(1, idUsuario);
                    insertStatement.setInt(2, idRol);
                    insertStatement.executeUpdate();
                }

                connection.commit();

            } catch (SQLException e) {

                connection.rollback();
                throw e;
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al cambiar el rol del usuario",
                    e
            );
        }
    }
}