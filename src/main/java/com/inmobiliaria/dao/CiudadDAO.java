package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Ciudad;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso de solo lectura al catálogo de ciudades. Alimenta los
 * <select> del buscador y del formulario de propiedades — no hay
 * pantalla para editar ciudades en el corte 1, por eso no tiene
 * insertar()/actualizar()/eliminar().
 */
public class CiudadDAO {

    public List<Ciudad> listarTodas() throws SQLException {

        String sql = "SELECT id_ciudad, nombre, departamento FROM ciudad ORDER BY nombre";

        List<Ciudad> ciudades = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ciudades.add(new Ciudad(
                        rs.getInt("id_ciudad"),
                        rs.getString("nombre"),
                        rs.getString("departamento")
                ));
            }
        }
        return ciudades;
    }
}
