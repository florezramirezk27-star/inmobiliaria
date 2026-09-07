package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Auditoria;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AuditoriaDAO {

    public void registrar(
            Integer idUsuario,
            String accion,
            String tablaAfectada,
            Integer idRegistro,
            String detalle
    ) {

        String sql = """
                INSERT INTO auditoria (
                    id_usuario,
                    accion,
                    tabla_afectada,
                    id_registro,
                    detalle
                )
                VALUES (?, ?, ?, ?, ?)
                """;

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            if (idUsuario == null) {
                statement.setNull(1, java.sql.Types.INTEGER);
            } else {
                statement.setInt(1, idUsuario);
            }

            statement.setString(2, accion);
            statement.setString(3, tablaAfectada);

            if (idRegistro == null) {
                statement.setNull(4, java.sql.Types.INTEGER);
            } else {
                statement.setInt(4, idRegistro);
            }

            statement.setString(5, detalle);

            statement.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al registrar auditoría",
                    e
            );
        }
    }

    public List<Auditoria> listarTodas() {

        String sql = """
                SELECT
                    id_auditoria,
                    id_usuario,
                    accion,
                    tabla_afectada,
                    id_registro,
                    detalle,
                    creado_en
                FROM auditoria
                ORDER BY creado_en DESC
                """;

        List<Auditoria> auditorias = new ArrayList<>();

        try (
                Connection connection = ConnectionFactory.getConnection();
                PreparedStatement statement =
                        connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Auditoria auditoria = new Auditoria();

                auditoria.setIdAuditoria(
                        resultSet.getLong("id_auditoria")
                );

                int idUsuario =
                        resultSet.getInt("id_usuario");

                if (resultSet.wasNull()) {
                    auditoria.setIdUsuario(null);
                } else {
                    auditoria.setIdUsuario(idUsuario);
                }

                auditoria.setAccion(
                        resultSet.getString("accion")
                );

                auditoria.setTablaAfectada(
                        resultSet.getString("tabla_afectada")
                );

                int idRegistro =
                        resultSet.getInt("id_registro");

                if (resultSet.wasNull()) {
                    auditoria.setIdRegistro(null);
                } else {
                    auditoria.setIdRegistro(idRegistro);
                }

                auditoria.setDetalle(
                        resultSet.getString("detalle")
                );

                auditoria.setCreadoEn(
                        resultSet.getTimestamp("creado_en")
                );

                auditorias.add(auditoria);
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al listar auditorías",
                    e
            );
        }

        return auditorias;
    }
}