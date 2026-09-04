package com.inmobiliaria.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

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
}
