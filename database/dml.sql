-- ============================================================
--  INMOBILIARIA — DML
--  Datos de prueba del módulo de propiedades
--
--  Ejecutar después de ddl.sql.
--
--  Nota: las propiedades usan usuario_id = 1. Mientras el
--  módulo de autenticación no exista, ese valor no se valida
--  porque la llave foránea hacia `usuario` sigue comentada en
--  la sección 9 del ddl.sql.
-- ============================================================

USE inmobiliaria;


-- ------------------------------------------------------------
-- Ciudades
-- ------------------------------------------------------------
INSERT INTO ciudad (id, nombre, departamento) VALUES
    (1, 'Bucaramanga',  'Santander'),
    (2, 'Floridablanca','Santander'),
    (3, 'Girón',        'Santander'),
    (4, 'Piedecuesta',  'Santander');


-- ------------------------------------------------------------
-- Tipos de inmueble
-- ------------------------------------------------------------
INSERT INTO tipo_inmueble (id, nombre, slug) VALUES
    (1, 'Apartamento',     'apartamento'),
    (2, 'Casa',            'casa'),
    (3, 'Apartaestudio',   'apartaestudio'),
    (4, 'Local comercial', 'local'),
    (5, 'Oficina',         'oficina'),
    (6, 'Lote',            'lote'),
    (7, 'Bodega',          'bodega');


-- ------------------------------------------------------------
-- Catálogo de características
-- ------------------------------------------------------------
INSERT INTO caracteristica (id, nombre, categoria) VALUES
    (1,  'Cocina integral',       'INTERIOR'),
    (2,  'Closets empotrados',    'INTERIOR'),
    (3,  'Zona de ropas',         'INTERIOR'),
    (4,  'Baño auxiliar',         'INTERIOR'),
    (5,  'Aire acondicionado',    'INTERIOR'),
    (6,  'Balcón',                'EXTERIOR'),
    (7,  'Terraza',               'EXTERIOR'),
    (8,  'Patio',                 'EXTERIOR'),
    (9,  'Jardín',                'EXTERIOR'),
    (10, 'Piscina',               'CONJUNTO'),
    (11, 'Gimnasio',              'CONJUNTO'),
    (12, 'Salón social',          'CONJUNTO'),
    (13, 'Zona de BBQ',           'CONJUNTO'),
    (14, 'Ascensor',              'CONJUNTO'),
    (15, 'Portería 24 horas',     'SEGURIDAD'),
    (16, 'Circuito cerrado de TV','SEGURIDAD'),
    (17, 'Conjunto cerrado',      'SEGURIDAD');


-- ------------------------------------------------------------
-- Propiedades
-- ------------------------------------------------------------
INSERT INTO propiedad
    (id, codigo, titulo, descripcion, operacion, estado,
     tipo_inmueble_id, ciudad_id, usuario_id,
     precio, administracion, area_construida, area_lote,
     habitaciones, banos, parqueaderos, estrato, antiguedad_anios,
     direccion, barrio, latitud, longitud)
VALUES
    (1, 'BUC-0001',
     'Apartamento en Cabecera del Llano',
     'Apartamento iluminado en piso 7, con vista abierta hacia el occidente. Cocina integral, tres alcobas y balcón. El conjunto cuenta con portería 24 horas y salón social.',
     'ARRIENDO', 'PUBLICADA',
     1, 1, 1,
     1850000.00, 380000.00, 92.00, NULL,
     3, 2, 1, 5, 8,
     'Calle 48 # 32-15', 'Cabecera del Llano', 7.1180000, -73.1120000),

    (2, 'FLO-0002',
     'Casa en Cañaveral',
     'Casa de dos plantas en conjunto cerrado. Patio posterior, zona de BBQ comunitaria y cuatro alcobas, una de ellas en el primer piso.',
     'VENTA', 'PUBLICADA',
     2, 2, 1,
     420000000.00, 260000.00, 168.00, 210.00,
     4, 3, 2, 5, 15,
     'Carrera 26 # 30-40', 'Cañaveral', 7.0640000, -73.0930000),

    (3, 'BUC-0003',
     'Apartaestudio en Provenza',
     'Apartaestudio remodelado, ideal para una persona o pareja. Incluye closets empotrados y zona de ropas independiente.',
     'ARRIENDO', 'PUBLICADA',
     3, 1, 1,
     1150000.00, 190000.00, 45.00, NULL,
     1, 1, 0, 3, 12,
     'Calle 105 # 19-22', 'Provenza', 7.0910000, -73.1050000),

    (4, 'BUC-0004',
     'Apartamento en Real de Minas',
     'Apartamento en tercer piso con tres alcobas y baño auxiliar. Cerca de centros comerciales y rutas de transporte.',
     'VENTA', 'PUBLICADA',
     1, 1, 1,
     295000000.00, 210000.00, 78.00, NULL,
     3, 2, 1, 4, 20,
     'Carrera 21 # 56-10', 'Real de Minas', 7.1050000, -73.1230000),

    (5, 'BUC-0005',
     'Local comercial en Sotomayor',
     'Local en primer piso sobre vía principal, con vitrina amplia y baño interno. Apto para oficina o comercio.',
     'ARRIENDO', 'PUBLICADA',
     4, 1, 1,
     3200000.00, 0.00, 120.00, NULL,
     0, 1, 1, 5, 25,
     'Carrera 29 # 45-60', 'Sotomayor', 7.1090000, -73.1180000),

    (6, 'GIR-0006',
     'Casa campestre en Ruitoque',
     'Casa campestre con jardín, terraza y piscina privada. Cinco alcobas y amplio parqueadero cubierto.',
     'VENTA', 'PUBLICADA',
     2, 3, 1,
     610000000.00, 450000.00, 240.00, 800.00,
     5, 4, 3, 6, 10,
     'Vereda Ruitoque Bajo, km 4', 'Ruitoque', 7.0210000, -73.1740000),

    (7, 'PIE-0007',
     'Lote urbanizable en Piedecuesta',
     'Lote plano con servicios disponibles, listo para construir. Documentación al día.',
     'VENTA', 'BORRADOR',
     6, 4, 1,
     180000000.00, 0.00, NULL, 450.00,
     0, 0, 0, NULL, NULL,
     'Calle 12 # 8-30', 'Centro', 6.9970000, -73.0510000);


-- ------------------------------------------------------------
-- Características por propiedad   (N : M)
-- ------------------------------------------------------------
INSERT INTO propiedad_caracteristica (propiedad_id, caracteristica_id) VALUES
    (1, 1), (1, 2), (1, 3), (1, 6), (1, 12), (1, 14), (1, 15),
    (2, 1), (2, 2), (2, 8), (2, 13), (2, 15), (2, 17),
    (3, 2), (3, 3),
    (4, 1), (4, 2), (4, 4), (4, 15),
    (5, 4),
    (6, 1), (6, 5), (6, 7), (6, 9), (6, 10), (6, 16), (6, 17);


-- ------------------------------------------------------------
-- Imágenes
--
-- Las rutas apuntan a src/main/webapp/img/propiedades/.
-- Mientras no existan los archivos, la JSP muestra el marcador
-- CSS de .foto-prop en lugar de una imagen rota.
-- ------------------------------------------------------------
INSERT INTO imagen_propiedad (propiedad_id, ruta, texto_alt, es_portada, orden) VALUES
    (1, 'img/propiedades/buc-0001-1.jpg', 'Sala del apartamento en Cabecera del Llano',  TRUE,  0),
    (1, 'img/propiedades/buc-0001-2.jpg', 'Cocina integral',                             FALSE, 1),
    (2, 'img/propiedades/flo-0002-1.jpg', 'Fachada de la casa en Cañaveral',             TRUE,  0),
    (3, 'img/propiedades/buc-0003-1.jpg', 'Interior del apartaestudio en Provenza',      TRUE,  0),
    (4, 'img/propiedades/buc-0004-1.jpg', 'Sala del apartamento en Real de Minas',       TRUE,  0),
    (5, 'img/propiedades/buc-0005-1.jpg', 'Vitrina del local en Sotomayor',              TRUE,  0),
    (6, 'img/propiedades/gir-0006-1.jpg', 'Piscina de la casa campestre en Ruitoque',    TRUE,  0);


-- ------------------------------------------------------------
-- Verificación rápida
-- ------------------------------------------------------------
-- SELECT COUNT(*) AS publicadas FROM v_propiedad_catalogo;   -- espera 6
-- SELECT * FROM v_propiedad_catalogo ORDER BY creado_en DESC;
