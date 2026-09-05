package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Favorito;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class FavoritoDAO {

    public boolean agregar(Favorito favorito) {

        String sql = """
                INSERT INTO favorito (
                    id_usuario,
                    id_propiedad
                )
                VALUES (?, ?)
                """;

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setInt(1, favorito.getIdUsuario());
            statement.setInt(2, favorito.getIdPropiedad());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al agregar la propiedad a favoritos",
                    e
            );
        }
    }

    public boolean eliminar(int idUsuario, int idPropiedad) {

        String sql = """
                DELETE FROM favorito
                WHERE id_usuario = ?
                  AND id_propiedad = ?
                """;

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setInt(1, idUsuario);
            statement.setInt(2, idPropiedad);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al eliminar el favorito",
                    e
            );
        }
    }

    public boolean existe(int idUsuario, int idPropiedad) {

        String sql = """
                SELECT 1
                FROM favorito
                WHERE id_usuario = ?
                  AND id_propiedad = ?
                LIMIT 1
                """;

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setInt(1, idUsuario);
            statement.setInt(2, idPropiedad);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al comprobar favorito",
                    e
            );
        }
    }

    public List<Favorito> listarPorUsuario(int idUsuario) {

        String sql = """
                SELECT
                    id_usuario,
                    id_propiedad,
                    creado_en
                FROM favorito
                WHERE id_usuario = ?
                ORDER BY creado_en DESC
                """;

        List<Favorito> favoritos = new ArrayList<>();

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setInt(1, idUsuario);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {

                    Favorito favorito = new Favorito();

                    favorito.setIdUsuario(
                            resultSet.getInt("id_usuario")
                    );

                    favorito.setIdPropiedad(
                            resultSet.getInt("id_propiedad")
                    );

                    favorito.setFecha(
                            resultSet.getTimestamp("creado_en")
                    );

                    favoritos.add(favorito);
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al listar favoritos",
                    e
            );
        }

        return favoritos;
    }
}