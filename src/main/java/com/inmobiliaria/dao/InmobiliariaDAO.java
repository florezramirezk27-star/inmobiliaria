package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Inmobiliaria;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso de solo lectura a las inmobiliarias (agencias). Se usa
 * para llenar el <select> "publicado por" en el formulario de
 * propiedades mientras no exista un login que la asigne sola a
 * partir del usuario autenticado.
 */
public class InmobiliariaDAO {

    public List<Inmobiliaria> listarTodas() throws SQLException {

        String sql = """
                SELECT id_inmobiliaria, nombre_comercial, nit, telefono, id_usuario
                  FROM inmobiliaria
                 ORDER BY nombre_comercial
                """;

        List<Inmobiliaria> inmobiliarias = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Inmobiliaria i = new Inmobiliaria();
                i.setId(rs.getInt("id_inmobiliaria"));
                i.setNombreComercial(rs.getString("nombre_comercial"));
                i.setNit(rs.getString("nit"));
                i.setTelefono(rs.getString("telefono"));
                i.setUsuarioId(rs.getInt("id_usuario"));
                inmobiliarias.add(i);
            }
        }
        return inmobiliarias;
    }

    public Inmobiliaria buscarPorUsuario(int usuarioId) throws SQLException {

        String sql = """
                SELECT
                    id_inmobiliaria,
                    nombre_comercial,
                    nit,
                    telefono,
                    id_usuario
                FROM inmobiliaria
                WHERE id_usuario = ?
                """;

        try (
                Connection cn = ConnectionFactory.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setInt(1, usuarioId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Inmobiliaria inmobiliaria = new Inmobiliaria();

                    inmobiliaria.setId(
                            rs.getInt("id_inmobiliaria")
                    );

                    inmobiliaria.setNombreComercial(
                            rs.getString("nombre_comercial")
                    );

                    inmobiliaria.setNit(
                            rs.getString("nit")
                    );

                    inmobiliaria.setTelefono(
                            rs.getString("telefono")
                    );

                    inmobiliaria.setUsuarioId(
                            rs.getInt("id_usuario")
                    );

                    return inmobiliaria;
                }
            }
        }

        return null;
    }
}
