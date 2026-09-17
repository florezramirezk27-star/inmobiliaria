-- ============================================================
--  INMOBILIARIA — Consultas obligatorias (v3)
--  Actualizadas a la convención id_<entidad> del proyecto.
-- ============================================================

USE inmobiliaria;


-- ============================================================
-- 1. INNER JOIN entre 4 tablas
--    Propiedades publicadas con su ciudad, su tipo y la
--    inmobiliaria que las publica.
-- ============================================================
SELECT
    p.codigo,
    p.titulo,
    c.nombre        AS ciudad,
    t.nombre        AS tipo,
    i.nombre_comercial AS inmobiliaria
FROM propiedad p
JOIN ciudad         c ON c.id_ciudad = p.id_ciudad
JOIN tipo_propiedad t ON t.id_tipo_propiedad = p.id_tipo_propiedad
JOIN inmobiliaria   i ON i.id_inmobiliaria = p.id_inmobiliaria
WHERE p.estado = 'PUBLICADA'
ORDER BY p.creado_en DESC;


-- ============================================================
-- 2. INNER JOIN entre 4 tablas (segunda consulta)
--    Citas activas con el nombre completo del cliente que las
--    agendó, cruzando cita, propiedad, usuario y perfil.
-- ============================================================
SELECT
    p.codigo,
    p.titulo,
    perf.nombres   AS cliente_nombre,
    perf.apellidos AS cliente_apellido,
    ci.fecha_hora,
    ci.estado
FROM cita ci
JOIN propiedad p  ON p.id_propiedad = ci.id_propiedad
JOIN usuario   u  ON u.id_usuario = ci.id_cliente
JOIN perfil perf  ON perf.id_usuario = u.id_usuario
WHERE ci.estado IN ('CONFIRMADA', 'SOLICITADA')
ORDER BY ci.fecha_hora;


-- ============================================================
-- 3. Relación muchos a muchos
--    Todas las características de una propiedad puntual.
-- ============================================================
SELECT
    p.codigo,
    p.titulo,
    car.nombre    AS caracteristica,
    car.categoria,
    pc.cantidad
FROM propiedad_caracteristica pc
JOIN propiedad      p   ON p.id_propiedad = pc.id_propiedad
JOIN caracteristica  car ON car.id_caracteristica = pc.id_caracteristica
WHERE p.id_propiedad = 1   -- BUC-0001, Apartamento en Cabecera del Llano
ORDER BY car.categoria, car.nombre;


-- ============================================================
-- 4. LEFT JOIN
--    Propiedades publicadas que todavía no tienen ninguna cita
--    agendada.
-- ============================================================
SELECT
    p.codigo,
    p.titulo,
    p.direccion,
    ciu.nombre AS ciudad
FROM propiedad p
JOIN ciudad ciu   ON ciu.id_ciudad = p.id_ciudad
LEFT JOIN cita c  ON c.id_propiedad = p.id_propiedad
WHERE p.estado = 'PUBLICADA'
  AND c.id_cita IS NULL;


-- ============================================================
-- 5. Agregación con GROUP BY + HAVING
--    Reporte: cantidad de propiedades publicadas y precio
--    promedio por ciudad, solo ciudades con 2 o más publicadas.
-- ============================================================
SELECT
    ciu.nombre               AS ciudad,
    COUNT(*)                 AS total_publicadas,
    ROUND(AVG(p.precio), 0)  AS precio_promedio
FROM propiedad p
JOIN ciudad ciu ON ciu.id_ciudad = p.id_ciudad
WHERE p.estado = 'PUBLICADA'
GROUP BY ciu.nombre
HAVING COUNT(*) >= 2
ORDER BY total_publicadas DESC;
