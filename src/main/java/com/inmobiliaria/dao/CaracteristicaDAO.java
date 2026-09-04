package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.Caracteristica;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CaracteristicaDAO {

    /** Catálogo completo, para los checkboxes del formulario de asignación. */
    public List<Caracteristica> listarTodas() throws SQLException {

        String sql = "SELECT id_caracteristica, nombre, categoria FROM caracteristica ORDER BY categoria, nombre";

        List<Caracteristica> caracteristicas = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                caracteristicas.add(mapear(rs));
            }
        }
        return caracteristicas;
    }

    /**
     * Características de una propiedad puntual — resuelve la relación
     * N:M vía propiedad_caracteristica, trayendo también la `cantidad`
     * (el atributo propio de la tabla puente).
     */
    public List<Caracteristica> listarPorPropiedad(int propiedadId) throws SQLException {

        String sql = """
                SELECT c.id_caracteristica, c.nombre, c.categoria, pc.cantidad
                  FROM propiedad_caracteristica pc
                  JOIN caracteristica c ON c.id_caracteristica = pc.id_caracteristica
                 WHERE pc.id_propiedad = ?
                 ORDER BY c.categoria, c.nombre
                """;

        List<Caracteristica> caracteristicas = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, propiedadId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Caracteristica c = mapear(rs);
                    c.setCantidad(rs.getInt("cantidad"));
                    caracteristicas.add(c);
                }
            }
        }
        return caracteristicas;
    }

    /**
     * Reemplaza por completo el conjunto de características de una
     * propiedad por la lista de ids recibida.
     *
     * Se implementa como "borrar todo y volver a insertar" en vez de
     * comparar cuáles agregar/quitar una por una: el formulario envía
     * el conjunto completo marcado (checkboxes), así que es más simple
     * y menos propenso a errores reemplazar todo de una vez que hacer
     * un diff manual contra lo que ya había.
     *
     * Los dos pasos corren dentro de la misma conexión pero sin una
     * transacción explícita — igual que marcarPortada() en
     * ImagenPropiedadDAO, el peor caso posible ante una falla a mitad
     * de camino es quedar sin características un instante, nunca con
     * datos duplicados o inconsistentes.
     */
    public void reemplazarAsignaciones(int propiedadId, List<Integer> idsCaracteristicas) throws SQLException {

        try (Connection cn = ConnectionFactory.getConnection()) {

            try (PreparedStatement borrar = cn.prepareStatement(
                    "DELETE FROM propiedad_caracteristica WHERE id_propiedad = ?")) {
                borrar.setInt(1, propiedadId);
                borrar.executeUpdate();
            }

            if (idsCaracteristicas == null || idsCaracteristicas.isEmpty()) {
                return;
            }

            String sql = "INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES (?, ?)";

            try (PreparedStatement insertar = cn.prepareStatement(sql)) {
                for (Integer idCaracteristica : idsCaracteristicas) {
                    insertar.setInt(1, propiedadId);
                    insertar.setInt(2, idCaracteristica);
                    insertar.addBatch();
                }
                insertar.executeBatch();
            }
        }
    }

    private Caracteristica mapear(ResultSet rs) throws SQLException {
        Caracteristica c = new Caracteristica();
        c.setId(rs.getInt("id_caracteristica"));
        c.setNombre(rs.getString("nombre"));
        c.setCategoria(rs.getString("categoria"));
        return c;
    }
}
