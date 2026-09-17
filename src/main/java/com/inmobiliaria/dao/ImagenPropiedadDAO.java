package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;
import com.inmobiliaria.model.ImagenPropiedad;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a la galería de imágenes de una propiedad.
 *
 * Esta clase solo conoce la fila de base de datos (ruta, portada,
 * orden). Guardar y borrar el archivo físico en disco es
 * responsabilidad del servlet que la usa (ImagenPropiedadServlet),
 * no de este DAO — mismo principio de separación que el resto del
 * proyecto: el DAO habla con la base de datos, el servlet habla con
 * el mundo exterior (disco, HTTP).
 */
public class ImagenPropiedadDAO {

    public List<ImagenPropiedad> listarPorPropiedad(int propiedadId) throws SQLException {

        String sql = """
                SELECT id_imagen, id_propiedad, ruta, texto_alt, es_portada, orden
                  FROM imagen_propiedad
                 WHERE id_propiedad = ?
                 ORDER BY es_portada DESC, orden ASC
                """;

        List<ImagenPropiedad> imagenes = new ArrayList<>();

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, propiedadId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    imagenes.add(mapear(rs));
                }
            }
        }
        return imagenes;
    }

    /** Necesario antes de borrar: para saber qué archivo físico eliminar del disco. */
    public ImagenPropiedad buscarPorId(int idImagen) throws SQLException {

        String sql = """
                SELECT id_imagen, id_propiedad, ruta, texto_alt, es_portada, orden
                  FROM imagen_propiedad
                 WHERE id_imagen = ?
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idImagen);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    /**
     * Inserta la fila de la imagen ya guardada en disco.
     *
     * Si es la primera imagen de la propiedad (no tenía ninguna), se
     * marca como portada automáticamente — así el catálogo nunca
     * queda con el marcador CSS vacío pudiendo tener ya una foto real.
     */
    public int insertar(ImagenPropiedad imagen) throws SQLException {

        boolean esLaPrimera = listarPorPropiedad(imagen.getPropiedadId()).isEmpty();

        String sql = """
                INSERT INTO imagen_propiedad (id_propiedad, ruta, texto_alt, es_portada, orden)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, imagen.getPropiedadId());
            ps.setString(2, imagen.getRuta());
            ps.setString(3, imagen.getTextoAlt());
            ps.setBoolean(4, esLaPrimera);
            ps.setInt(5, imagen.getOrden());

            ps.executeUpdate();

            try (ResultSet claves = ps.getGeneratedKeys()) {
                if (claves.next()) {
                    imagen.setId(claves.getInt(1));
                }
            }
            return imagen.getId();
        }
    }

    /**
     * Marca una imagen como portada y desmarca cualquier otra que
     * tuviera la propiedad — nunca deben quedar dos a la vez.
     * No es estrictamente atómico entre los dos UPDATE (no hay una
     * transacción explícita), pero el orden — primero desmarcar,
     * luego marcar — hace que el peor caso posible sea quedar sin
     * portada un instante, nunca con dos.
     */
    public boolean marcarPortada(int idImagen, int propiedadId) throws SQLException {

        try (Connection cn = ConnectionFactory.getConnection()) {

            try (PreparedStatement desmarcar = cn.prepareStatement(
                    "UPDATE imagen_propiedad SET es_portada = FALSE WHERE id_propiedad = ?")) {
                desmarcar.setInt(1, propiedadId);
                desmarcar.executeUpdate();
            }

            try (PreparedStatement marcar = cn.prepareStatement(
                    "UPDATE imagen_propiedad SET es_portada = TRUE WHERE id_imagen = ? AND id_propiedad = ?")) {
                marcar.setInt(1, idImagen);
                marcar.setInt(2, propiedadId);
                return marcar.executeUpdate() > 0;
            }
        }
    }

    /**
     * Borra la fila. El archivo físico en disco lo borra el servlet
     * después de llamar a este método (necesita la ruta, que ya
     * tenía de un buscarPorId() previo).
     *
     * Si la imagen borrada era la portada y quedan otras, promueve
     * automáticamente la de menor `orden` — sin este paso, borrar la
     * portada dejaba la propiedad sin ninguna imagen marcada como tal
     * (se detectó probando este método contra datos reales).
     */
    public boolean eliminar(int idImagen) throws SQLException {

        ImagenPropiedad borrada = buscarPorId(idImagen);
        if (borrada == null) {
            return false;
        }

        String sql = "DELETE FROM imagen_propiedad WHERE id_imagen = ?";
        boolean eliminada;

        try (Connection cn = ConnectionFactory.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idImagen);
            eliminada = ps.executeUpdate() > 0;
        }

        if (eliminada && borrada.isEsPortada()) {
            promoverPortadaSiFalta(borrada.getPropiedadId());
        }

        return eliminada;
    }

    /** Si la propiedad tiene imágenes pero ninguna marcada como portada, promueve la de menor orden. */
    private void promoverPortadaSiFalta(int propiedadId) throws SQLException {

        List<ImagenPropiedad> restantes = listarPorPropiedad(propiedadId);
        if (restantes.isEmpty()) {
            return;
        }

        boolean hayPortada = false;
        for (ImagenPropiedad img : restantes) {
            if (img.isEsPortada()) {
                hayPortada = true;
                break;
            }
        }

        if (!hayPortada) {
            marcarPortada(restantes.get(0).getId(), propiedadId);
        }
    }

    private ImagenPropiedad mapear(ResultSet rs) throws SQLException {
        ImagenPropiedad img = new ImagenPropiedad();
        img.setId(rs.getInt("id_imagen"));
        img.setPropiedadId(rs.getInt("id_propiedad"));
        img.setRuta(rs.getString("ruta"));
        img.setTextoAlt(rs.getString("texto_alt"));
        img.setEsPortada(rs.getBoolean("es_portada"));
        img.setOrden(rs.getInt("orden"));
        return img;
    }
}
