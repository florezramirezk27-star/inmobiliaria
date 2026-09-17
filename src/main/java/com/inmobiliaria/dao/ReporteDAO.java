package com.inmobiliaria.dao;

import com.inmobiliaria.config.ConnectionFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReporteDAO {

    public List<Map<String, Object>> propiedadesPublicadas() {

        String sql = """
                SELECT
                    p.codigo,
                    p.titulo,
                    c.nombre AS ciudad,
                    t.nombre AS tipo,
                    i.nombre_comercial AS inmobiliaria
                FROM propiedad p
                JOIN ciudad c
                    ON c.id_ciudad = p.id_ciudad
                JOIN tipo_propiedad t
                    ON t.id_tipo_propiedad = p.id_tipo_propiedad
                JOIN inmobiliaria i
                    ON i.id_inmobiliaria = p.id_inmobiliaria
                WHERE p.estado = 'PUBLICADA'
                ORDER BY p.creado_en DESC
                """;

        return ejecutarConsulta(sql);
    }

    public List<Map<String, Object>> citasActivas() {

        String sql = """
                SELECT
                    p.codigo,
                    p.titulo,
                    perf.nombres AS cliente_nombre,
                    perf.apellidos AS cliente_apellido,
                    ci.fecha_hora,
                    ci.estado
                FROM cita ci
                JOIN propiedad p
                    ON p.id_propiedad = ci.id_propiedad
                JOIN usuario u
                    ON u.id_usuario = ci.id_cliente
                JOIN perfil perf
                    ON perf.id_usuario = u.id_usuario
                WHERE ci.estado IN ('CONFIRMADA', 'SOLICITADA')
                ORDER BY ci.fecha_hora
                """;

        return ejecutarConsulta(sql);
    }

    public List<Map<String, Object>> caracteristicasPropiedad(
            int idPropiedad
    ) {

        String sql = """
                SELECT
                    p.codigo,
                    p.titulo,
                    car.nombre AS caracteristica,
                    car.categoria,
                    pc.cantidad
                FROM propiedad_caracteristica pc
                JOIN propiedad p
                    ON p.id_propiedad = pc.id_propiedad
                JOIN caracteristica car
                    ON car.id_caracteristica = pc.id_caracteristica
                WHERE p.id_propiedad = ?
                ORDER BY car.categoria, car.nombre
                """;

        return ejecutarConsultaConParametro(sql, idPropiedad);
    }

    public List<Map<String, Object>> propiedadesSinCitas() {

        String sql = """
                SELECT
                    p.codigo,
                    p.titulo,
                    p.direccion,
                    ciu.nombre AS ciudad
                FROM propiedad p
                JOIN ciudad ciu
                    ON ciu.id_ciudad = p.id_ciudad
                LEFT JOIN cita c
                    ON c.id_propiedad = p.id_propiedad
                WHERE p.estado = 'PUBLICADA'
                  AND c.id_cita IS NULL
                """;

        return ejecutarConsulta(sql);
    }

    public List<Map<String, Object>> resumenPorCiudad() {

        String sql = """
                SELECT
                    ciu.nombre AS ciudad,
                    COUNT(*) AS total_publicadas,
                    ROUND(AVG(p.precio), 0) AS precio_promedio
                FROM propiedad p
                JOIN ciudad ciu
                    ON ciu.id_ciudad = p.id_ciudad
                WHERE p.estado = 'PUBLICADA'
                GROUP BY ciu.nombre
                HAVING COUNT(*) >= 2
                ORDER BY total_publicadas DESC
                """;

        return ejecutarConsulta(sql);
    }

    /** REPORTE 6 – Citas agrupadas por estado (SOLICITADA, CONFIRMADA, CANCELADA, CUMPLIDA). */
    public List<Map<String, Object>> citasPorEstado() {

        String sql = """
                SELECT
                    estado,
                    COUNT(*) AS total
                FROM cita
                GROUP BY estado
                ORDER BY total DESC
                """;

        return ejecutarConsulta(sql);
    }

    /** REPORTE 7 – Cantidad de solicitudes recibidas por cada inmobiliaria. */
    public List<Map<String, Object>> solicitudesPorInmobiliaria() {

        String sql = """
                SELECT
                    i.nombre_comercial AS inmobiliaria,
                    COUNT(s.id_solicitud) AS total_solicitudes
                FROM solicitud s
                JOIN propiedad p
                    ON p.id_propiedad = s.id_propiedad
                JOIN inmobiliaria i
                    ON i.id_inmobiliaria = p.id_inmobiliaria
                GROUP BY i.nombre_comercial
                ORDER BY total_solicitudes DESC
                """;

        return ejecutarConsulta(sql);
    }

    /**
     * Resumen de las propiedades de una inmobiliaria agrupadas por
     * operacion. Permite al agente analizar su oferta de venta y arriendo.
     */
    public List<Map<String, Object>> resumenOperacionesInmobiliaria(
            int idInmobiliaria
    ) {

        String sql = """
                SELECT
                    p.operacion,
                    COUNT(*) AS total_propiedades,
                    SUM(p.estado = 'PUBLICADA') AS publicadas,
                    SUM(p.estado = 'BORRADOR') AS borradores,
                    SUM(p.estado = 'RESERVADA') AS reservadas,
                    SUM(p.estado = 'CERRADA') AS cerradas,
                    ROUND(AVG(p.precio), 0) AS precio_promedio
                FROM propiedad p
                WHERE p.id_inmobiliaria = ?
                GROUP BY p.operacion
                ORDER BY p.operacion
                """;

        return ejecutarConsultaConParametro(
                sql,
                idInmobiliaria
        );
    }

    /**
     * Solicitudes de compra o arriendo recibidas por una inmobiliaria,
     * agrupadas por tipo y estado.
     */
    public List<Map<String, Object>> solicitudesPorTipoEstadoInmobiliaria(
            int idInmobiliaria
    ) {

        String sql = """
                SELECT
                    s.tipo,
                    s.estado,
                    COUNT(*) AS total_solicitudes
                FROM solicitud s
                JOIN propiedad p
                    ON p.id_propiedad = s.id_propiedad
                WHERE p.id_inmobiliaria = ?
                GROUP BY s.tipo, s.estado
                ORDER BY s.tipo, s.estado
                """;

        return ejecutarConsultaConParametro(
                sql,
                idInmobiliaria
        );
    }

    /**
     * Negociaciones aprobadas de la inmobiliaria.
     *
     * En el modelo actual no existe una tabla independiente de contratos
     * o cierres. Por eso una solicitud APROBADA representa la operacion
     * de compra o arriendo que fue aceptada por la inmobiliaria.
     */
    public List<Map<String, Object>> operacionesAprobadasInmobiliaria(
            int idInmobiliaria
    ) {

        String sql = """
                SELECT
                    s.id_solicitud,
                    p.codigo,
                    p.titulo,
                    s.tipo,
                    CONCAT(
                        COALESCE(perf.nombres, ''),
                        ' ',
                        COALESCE(perf.apellidos, '')
                    ) AS cliente,
                    p.precio,
                    s.actualizado_en
                FROM solicitud s
                JOIN propiedad p
                    ON p.id_propiedad = s.id_propiedad
                LEFT JOIN perfil perf
                    ON perf.id_usuario = s.id_cliente
                WHERE p.id_inmobiliaria = ?
                  AND s.estado = 'APROBADA'
                ORDER BY s.actualizado_en DESC
                """;

        return ejecutarConsultaConParametro(
                sql,
                idInmobiliaria
        );
    }

    private List<Map<String, Object>> ejecutarConsulta(
            String sql
    ) {

        List<Map<String, Object>> resultados = new ArrayList<>();

        try (
                Connection connection =
                        ConnectionFactory.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql);

                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            while (resultSet.next()) {

                resultados.add(convertirFila(resultSet));
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al ejecutar reporte",
                    e
            );
        }

        return resultados;
    }

    private List<Map<String, Object>> ejecutarConsultaConParametro(
            String sql,
            int parametro
    ) {

        List<Map<String, Object>> resultados = new ArrayList<>();

        try (
                Connection connection =
                        ConnectionFactory.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(1, parametro);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    resultados.add(convertirFila(resultSet));
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al ejecutar reporte",
                    e
            );
        }

        return resultados;
    }

    private Map<String, Object> convertirFila(
            ResultSet resultSet
    ) throws SQLException {

        Map<String, Object> fila = new HashMap<>();

        int columnas =
                resultSet.getMetaData().getColumnCount();

        for (int i = 1; i <= columnas; i++) {

            String nombre =
                    resultSet.getMetaData()
                            .getColumnLabel(i);

            fila.put(
                    nombre,
                    resultSet.getObject(i)
            );
        }

        return fila;
    }
}