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
 * Acceso de solo lectura a las inmobiliarias (agencias).
 *
 * En la gestión de propiedades, la inmobiliaria del agente se
 * obtiene por el usuario autenticado y nunca desde un parámetro
 * editable enviado por el navegador.
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
