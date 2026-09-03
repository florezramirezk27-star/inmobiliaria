package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Rol;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RolDAO {

    public List<Rol> obtenerRolesPorUsuario(int idUsuario) {

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

                    rol.setIdRol(
                            resultSet.getInt("id_rol")
                    );

                    rol.setNombre(
                            resultSet.getString("nombre")
                    );

                    rol.setDescripcion(
                            resultSet.getString("descripcion")
                    );

                    roles.add(rol);
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al obtener los roles del usuario",
                    e
            );
        }

        return roles;
    }
}
