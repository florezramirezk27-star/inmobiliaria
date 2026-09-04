package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.TipoPropiedad;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Acceso de solo lectura al catálogo de tipos de propiedad. */
public class TipoPropiedadDAO {

    public List<TipoPropiedad> listarTodos() throws SQLException {

        String sql = "SELECT id_tipo_propiedad, nombre, slug FROM tipo_propiedad ORDER BY nombre";

        List<TipoPropiedad> tipos = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                tipos.add(new TipoPropiedad(
                        rs.getInt("id_tipo_propiedad"),
                        rs.getString("nombre"),
                        rs.getString("slug")
                ));
            }
        }
        return tipos;
    }
}
