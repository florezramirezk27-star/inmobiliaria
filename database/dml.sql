-- ============================================================
--  INMOBILIARIA — DML v3
--  Datos de prueba, mínimo 10 registros por tabla principal.
--
--  Ejecutar después de ddl.sql.
--
--  Sección 1 amplía el usuario admin que ya estaba en el DML
--  original (id_usuario = 1) con 9 usuarios más: 2 agentes y
--  7 clientes, necesarios para inmobiliaria, citas y solicitudes.
--  Las contraseñas de los usuarios 2-10 son hashes BCrypt de
--  ejemplo para "Clave123*"; cámbialas por hashes reales cuando
--  el registro esté conectado de punta a punta.
-- ============================================================

SET NAMES utf8mb4;

USE inmobiliaria;


-- ------------------------------------------------------------
-- 1. Autenticación
-- ------------------------------------------------------------

-- Usuario admin (igual que en el DML original: id=1, admin123)
INSERT INTO usuario (id_usuario, correo, password_hash, estado) VALUES
    (1,  'admin@inmobiliaria.com',        '$2a$10$1abQAEwWSztTv0iATf4KJOOiev2BrcYu2evqfykcMQi8OJL4fTtvi', 'ACTIVO'),
    (2,  'agente.centro@inmobiliaria.com','$2a$10$N9qo8uLOickgx2ZMRZoMy.MqcQfN2/9AY0f1sVdRTM8gc8n.6E7Qa', 'ACTIVO'),
    (3,  'agente.norte@inmobiliaria.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqcQfN2/9AY0f1sVdRTM8gc8n.6E7Qa', 'ACTIVO'),
    (4,  'maria.rojas@correo.com',        '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqcQfN2/9AY0f1sVdRTM8gc8n.6E7Qa', 'ACTIVO'),
    (5,  'juan.paez@correo.com',          '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqcQfN2/9AY0f1sVdRTM8gc8n.6E7Qa', 'ACTIVO'),
    (6,  'laura.gomez@correo.com',        '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqcQfN2/9AY0f1sVdRTM8gc8n.6E7Qa', 'ACTIVO'),
    (7,  'carlos.diaz@correo.com',        '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqcQfN2/9AY0f1sVdRTM8gc8n.6E7Qa', 'ACTIVO'),
    (8,  'ana.suarez@correo.com',         '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqcQfN2/9AY0f1sVdRTM8gc8n.6E7Qa', 'ACTIVO'),
    (9,  'felipe.torres@correo.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqcQfN2/9AY0f1sVdRTM8gc8n.6E7Qa', 'ACTIVO'),
    (10, 'sofia.moreno@correo.com',       '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqcQfN2/9AY0f1sVdRTM8gc8n.6E7Qa', 'INACTIVO');

INSERT INTO rol (id_rol, nombre, descripcion) VALUES
    (1, 'ADMIN',    'Administrador del sistema'),
    (2, 'AGENTE',   'Usuario que publica y gestiona inmuebles'),
    (3, 'CLIENTE',  'Usuario final que consulta y contacta');

INSERT INTO usuario_rol (id_usuario, id_rol) VALUES
    (1, 1),
    (2, 2), (3, 2),
    (4, 3), (5, 3), (6, 3), (7, 3), (8, 3), (9, 3), (10, 3);

INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES
    (1,  'Administrador', 'del Sistema',  '1000000001', '3000000000', 'Calle 45 # 20-10, Bucaramanga'),
    (2,  'Andrea',        'Ramírez',      '1098765432', '3011234567', 'Calle 45 # 20-10, Bucaramanga'),
    (3,  'Ricardo',       'Molina',       '1087654321', '3012345678', 'Carrera 27 # 50-20, Floridablanca'),
    (4,  'María',         'Rojas',        '1005551111', '3151112222', 'Calle 30 # 15-40, Bucaramanga'),
    (5,  'Juan',          'Páez',         '1005552222', '3152223333', 'Carrera 10 # 25-60, Girón'),
    (6,  'Laura',         'Gómez',        '1005553333', '3153334444', 'Calle 60 # 18-25, Bucaramanga'),
    (7,  'Carlos',        'Díaz',         '1005554444', '3154445555', 'Carrera 33 # 40-10, Floridablanca'),
    (8,  'Ana',           'Suárez',       '1005555555', '3155556666', 'Calle 12 # 8-30, Piedecuesta'),
    (9,  'Felipe',        'Torres',       '1005556666', '3156667777', 'Carrera 15 # 60-05, Bucaramanga'),
    (10, 'Sofía',         'Moreno',       '1005557777', '3157778888', 'Calle 100 # 40-15, Floridablanca');


-- ------------------------------------------------------------
-- 2. Inmobiliarias
-- ------------------------------------------------------------
INSERT INTO inmobiliaria (id_inmobiliaria, nombre_comercial, nit, telefono, id_usuario) VALUES
    (1, 'Vivienda Santander S.A.S.', '900123456-1', '6076401010', 2),
    (2, 'Hábitat del Oriente Ltda.', '900654321-2', '6076402020', 3);


-- ------------------------------------------------------------
-- 3. Ciudades
-- ------------------------------------------------------------
INSERT INTO ciudad (id_ciudad, nombre, departamento) VALUES
    (1, 'Bucaramanga',  'Santander'),
    (2, 'Floridablanca','Santander'),
    (3, 'Girón',        'Santander'),
    (4, 'Piedecuesta',  'Santander');


-- ------------------------------------------------------------
-- 4. Tipos de propiedad (10)
-- ------------------------------------------------------------
INSERT INTO tipo_propiedad (id_tipo_propiedad, nombre, slug) VALUES
    (1,  'Apartamento',      'apartamento'),
    (2,  'Casa',             'casa'),
    (3,  'Apartaestudio',    'apartaestudio'),
    (4,  'Local comercial',  'local'),
    (5,  'Oficina',          'oficina'),
    (6,  'Lote',             'lote'),
    (7,  'Bodega',           'bodega'),
    (8,  'Finca',            'finca'),
    (9,  'Casa campestre',   'casa-campestre'),
    (10, 'Consultorio',      'consultorio');


-- ------------------------------------------------------------
-- 5. Catálogo de características
-- ------------------------------------------------------------
INSERT INTO caracteristica (id_caracteristica, nombre, categoria) VALUES
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
-- 6. Propiedades (10)
-- ------------------------------------------------------------
INSERT INTO propiedad
    (id_propiedad, codigo, matricula_inmobiliaria, titulo, descripcion, operacion, estado,
     id_tipo_propiedad, id_ciudad, id_inmobiliaria, id_usuario,
     precio, administracion, area_construida, area_lote,
     habitaciones, banos, parqueaderos, estrato, antiguedad_anios,
     direccion, barrio, latitud, longitud)
VALUES
    (1, 'BUC-0001', '300-1234567',
     'Apartamento en Cabecera del Llano',
     'Apartamento iluminado en piso 7, con vista abierta hacia el occidente. Cocina integral, tres alcobas y balcón.',
     'ARRIENDO', 'PUBLICADA',
     1, 1, 1, 2,
     1850000.00, 380000.00, 92.00, NULL,
     3, 2, 1, 5, 8,
     'Calle 48 # 32-15', 'Cabecera del Llano', 7.1180000, -73.1120000),

    (2, 'FLO-0002', '300-1234568',
     'Casa en Cañaveral',
     'Casa de dos plantas en conjunto cerrado. Patio posterior, zona de BBQ comunitaria y cuatro alcobas.',
     'VENTA', 'PUBLICADA',
     2, 2, 1, 2,
     420000000.00, 260000.00, 168.00, 210.00,
     4, 3, 2, 5, 15,
     'Carrera 26 # 30-40', 'Cañaveral', 7.0640000, -73.0930000),

    (3, 'BUC-0003', '300-1234569',
     'Apartaestudio en Provenza',
     'Apartaestudio remodelado, ideal para una persona o pareja. Closets empotrados y zona de ropas.',
     'ARRIENDO', 'PUBLICADA',
     3, 1, 2, 3,
     1150000.00, 190000.00, 45.00, NULL,
     1, 1, 0, 3, 12,
     'Calle 105 # 19-22', 'Provenza', 7.0910000, -73.1050000),

    (4, 'BUC-0004', '300-1234570',
     'Apartamento en Real de Minas',
     'Apartamento en tercer piso con tres alcobas y baño auxiliar. Cerca de centros comerciales.',
     'VENTA', 'PUBLICADA',
     1, 1, 1, 2,
     295000000.00, 210000.00, 78.00, NULL,
     3, 2, 1, 4, 20,
     'Carrera 21 # 56-10', 'Real de Minas', 7.1050000, -73.1230000),

    (5, 'BUC-0005', '300-1234571',
     'Local comercial en Sotomayor',
     'Local en primer piso sobre vía principal, con vitrina amplia y baño interno.',
     'ARRIENDO', 'PUBLICADA',
     4, 1, 2, 3,
     3200000.00, 0.00, 120.00, NULL,
     0, 1, 1, 5, 25,
     'Carrera 29 # 45-60', 'Sotomayor', 7.1090000, -73.1180000),

    (6, 'GIR-0006', '300-1234572',
     'Casa campestre en Ruitoque',
     'Casa campestre con jardín, terraza y piscina privada. Cinco alcobas y parqueadero cubierto.',
     'VENTA', 'PUBLICADA',
     9, 3, 1, 2,
     610000000.00, 450000.00, 240.00, 800.00,
     5, 4, 3, 6, 10,
     'Vereda Ruitoque Bajo, km 4', 'Ruitoque', 7.0210000, -73.1740000),

    (7, 'PIE-0007', '300-1234573',
     'Lote urbanizable en Piedecuesta',
     'Lote plano con servicios disponibles, listo para construir. Documentación al día.',
     'VENTA', 'BORRADOR',
     6, 4, 2, 3,
     180000000.00, 0.00, NULL, 450.00,
     0, 0, 0, NULL, NULL,
     'Calle 12 # 8-30', 'Centro', 6.9970000, -73.0510000),

    (8, 'BUC-0008', '300-1234574',
     'Oficina en el centro de Bucaramanga',
     'Oficina de 55 m² en edificio corporativo con recepción compartida y ascensor.',
     'ARRIENDO', 'PUBLICADA',
     5, 1, 1, 2,
     1900000.00, 320000.00, 55.00, NULL,
     0, 1, 1, 4, 18,
     'Calle 35 # 19-45', 'Centro', 7.1200000, -73.1250000),

    (9, 'FLO-0009', '300-1234575',
     'Bodega industrial en Floridablanca',
     'Bodega de 300 m² con altura libre de 6 metros, portón vehicular y oficina administrativa.',
     'VENTA', 'PUBLICADA',
     7, 2, 2, 3,
     850000000.00, 0.00, 300.00, 400.00,
     0, 1, 4, NULL, 5,
     'Zona Industrial, Vía Café Madrid', 'Zona Industrial', 7.0580000, -73.0870000),

    (10, 'BUC-0010', '300-1234576',
     'Casa en Mutis',
     'Casa de un piso con patio amplio, ideal para familia. Tres alcobas y garaje techado.',
     'ARRIENDO', 'PUBLICADA',
     2, 1, 1, 2,
     2100000.00, 0.00, 130.00, 160.00,
     3, 2, 1, 3, 22,
     'Carrera 9 # 60-30', 'Mutis', 7.1310000, -73.1290000);


-- ------------------------------------------------------------
-- 7. Características por propiedad   (N : M)
-- ------------------------------------------------------------
INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES
    (1, 1), (1, 2), (1, 3), (1, 6), (1, 12), (1, 14), (1, 15),
    (2, 1), (2, 2), (2, 8), (2, 13), (2, 15), (2, 17),
    (3, 2), (3, 3),
    (4, 1), (4, 2), (4, 4), (4, 15),
    (5, 4),
    (6, 1), (6, 5), (6, 7), (6, 9), (6, 10), (6, 16), (6, 17),
    (8, 5), (8, 14), (8, 15),
    (9, 15),
    (10, 1), (10, 3), (10, 8);


-- ------------------------------------------------------------
-- 8. Imágenes
-- ------------------------------------------------------------
INSERT INTO imagen_propiedad (id_propiedad, ruta, texto_alt, es_portada, orden) VALUES
    (1,  'img/propiedades/buc-0001-1.jpg', 'Sala del apartamento en Cabecera del Llano', TRUE,  0),
    (1,  'img/propiedades/buc-0001-2.jpg', 'Cocina integral',                            FALSE, 1),
    (2,  'img/propiedades/flo-0002-1.jpg', 'Fachada de la casa en Cañaveral',            TRUE,  0),
    (3,  'img/propiedades/buc-0003-1.jpg', 'Interior del apartaestudio en Provenza',     TRUE,  0),
    (4,  'img/propiedades/buc-0004-1.jpg', 'Sala del apartamento en Real de Minas',      TRUE,  0),
    (5,  'img/propiedades/buc-0005-1.jpg', 'Vitrina del local en Sotomayor',             TRUE,  0),
    (6,  'img/propiedades/gir-0006-1.jpg', 'Piscina de la casa campestre en Ruitoque',   TRUE,  0),
    (8,  'img/propiedades/buc-0008-1.jpg', 'Recepción de la oficina en el centro',       TRUE,  0),
    (9,  'img/propiedades/flo-0009-1.jpg', 'Fachada de la bodega industrial',            TRUE,  0),
    (10, 'img/propiedades/buc-0010-1.jpg', 'Fachada de la casa en Mutis',                TRUE,  0);


-- ------------------------------------------------------------
-- 9. Favoritos
-- ------------------------------------------------------------
INSERT INTO favorito (id_usuario, id_propiedad) VALUES
    (4, 1), (4, 3), (5, 2), (6, 1), (6, 6), (7, 4), (8, 8), (9, 10);


-- ------------------------------------------------------------
-- 10. Citas (10)
-- ------------------------------------------------------------
INSERT INTO cita (id_propiedad, id_cliente, fecha_hora, estado, observacion) VALUES
    (1, 4,  '2026-09-10 10:00:00', 'CONFIRMADA', 'Cliente pidió confirmar disponibilidad de parqueadero'),
    (1, 6,  '2026-09-12 15:00:00', 'SOLICITADA', NULL),
    (2, 5,  '2026-09-11 09:00:00', 'CONFIRMADA', NULL),
    (3, 7,  '2026-09-09 17:00:00', 'REALIZADA',  'Visita completada, cliente interesado'),
    (4, 8,  '2026-09-13 11:00:00', 'SOLICITADA', NULL),
    (5, 9,  '2026-09-14 14:00:00', 'RECHAZADA',  'Horario no disponible por el agente'),
    (6, 4,  '2026-09-15 16:00:00', 'CONFIRMADA', NULL),
    (6, 10, '2026-09-16 10:00:00', 'SOLICITADA', NULL),
    (8, 5,  '2026-09-17 08:00:00', 'CONFIRMADA', NULL),
    (10, 6, '2026-09-18 13:00:00', 'CANCELADA',  'Cliente canceló por cambio de planes');


-- ------------------------------------------------------------
-- 11. Solicitudes (10)
-- ------------------------------------------------------------
INSERT INTO solicitud (id_propiedad, id_cliente, tipo, estado, comentario) VALUES
    (1, 4,  'ARRIENDO', 'APROBADA',    'Contrato firmado, entrega 1 de octubre'),
    (2, 5,  'COMPRA',   'EN_REVISION', 'Verificando documentos financieros'),
    (3, 6,  'ARRIENDO', 'PENDIENTE',   NULL),
    (4, 7,  'COMPRA',   'PENDIENTE',   NULL),
    (5, 8,  'ARRIENDO', 'RECHAZADA',   'No cumple con codeudor solicitado'),
    (6, 9,  'COMPRA',   'EN_REVISION', NULL),
    (8, 10, 'ARRIENDO', 'APROBADA',    'Contrato firmado'),
    (9, 4,  'COMPRA',   'PENDIENTE',   NULL),
    (10,5,  'ARRIENDO', 'PENDIENTE',   NULL),
    (1, 8,  'ARRIENDO', 'RECHAZADA',   'Propiedad ya arrendada a otro cliente');


-- ------------------------------------------------------------
-- 12. Documentos de solicitud
-- ------------------------------------------------------------
INSERT INTO documento_solicitud (id_solicitud, nombre_archivo, ruta) VALUES
    (1, 'cedula_maria_rojas.pdf',      'docs/solicitudes/1/cedula.pdf'),
    (1, 'certificado_laboral.pdf',     'docs/solicitudes/1/laboral.pdf'),
    (2, 'cedula_juan_paez.pdf',        'docs/solicitudes/2/cedula.pdf'),
    (2, 'extracto_bancario.pdf',       'docs/solicitudes/2/extracto.pdf'),
    (7, 'cedula_sofia_moreno.pdf',     'docs/solicitudes/7/cedula.pdf');


-- ------------------------------------------------------------
-- 13. Auditoría (muestra)
-- ------------------------------------------------------------
INSERT INTO auditoria (id_usuario, accion, tabla_afectada, id_registro, detalle) VALUES
    (2, 'LOGIN',   NULL,        NULL, 'Inicio de sesión exitoso'),
    (2, 'INSERT',  'propiedad', 1,    'Publicación de nueva propiedad BUC-0001'),
    (3, 'INSERT',  'propiedad', 5,    'Publicación de nueva propiedad BUC-0005'),
    (1, 'UPDATE',  'usuario',   10,   'Desactivación de cuenta por inactividad'),
    (4, 'LOGIN',   NULL,        NULL, 'Inicio de sesión exitoso');


-- ------------------------------------------------------------
-- Verificación rápida
-- ------------------------------------------------------------
-- SELECT COUNT(*) FROM v_propiedad_catalogo;   -- espera 9 (BORRADOR queda fuera)
