-- ============================================================================
-- Datos iniciales ficticios (Asunción y Gran Asunción, Paraguay)
-- Incluye ubicaciones reales para OpenStreetMap y exportación a Google Maps
-- ============================================================================

INSERT INTO empresas (nombre, rubro, ciudad, direccion, latitud, longitud) VALUES
  ('Guaraní Sistemas S.A.', 'Tecnología y Software', 'Asunción', 'Av. España 1240, Villa Morra', -25.291820, -57.580640),
  ('Itapúa Logística Integral', 'Logística y Transporte', 'Asunción', 'Av. Artigas 1920, Trinidad', -25.263450, -57.593120),
  ('Clínica Central Escalada', 'Salud y Laboratorio', 'Asunción', 'Av. Colón 685, Centro', -25.284910, -57.641380),
  ('Paraná Ingeniería Eléctrica', 'Hardware e Infraestructura', 'San Lorenzo', 'Ruta Mariscal Estigarribia Km 10', -25.339710, -57.523410),
  ('Banco del Este S.A.', 'Finanzas y Administración', 'Asunción', 'Av. Aviadores del Chaco 2050, Carmelitas', -25.282790, -57.564110),
  ('Agroindustria Ypacaraí', 'Producción e Industria', 'Luque', 'Av. Gral. Aquino 840, Centro Luque', -25.268320, -57.487930)
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO vacantes (empresa_id, cargo, descripcion, cierre, cupos, estado)
SELECT e.id, v.cargo, v.descripcion, v.cierre::date, v.cupos, v.estado
FROM (
  VALUES
    ('Guaraní Sistemas S.A.', 'Desarrollador Web Junior', 'Mantenimiento de módulos React, APIs REST y consultas SQL en PostgreSQL.', '2026-12-30', 2, 'abierta'),
    ('Guaraní Sistemas S.A.', 'Soporte Técnico de Laboratorio', 'Diagnóstico de hardware, redes LAN y configuración de estaciones de trabajo.', '2026-12-20', 1, 'abierta'),
    ('Itapúa Logística Integral', 'Auxiliar de Control de Flota', 'Seguimiento de rutas, registro de entregas y control documental.', '2026-12-18', 2, 'abierta'),
    ('Clínica Central Escalada', 'Recepcionista de Turno Mañana', 'Atención al paciente, carga de órdenes de laboratorio y archivo.', '2026-12-28', 2, 'abierta'),
    ('Paraná Ingeniería Eléctrica', 'Técnico en Redes y Cableado', 'Instalación de racks, puntos de red UTP/fibra y certificación de enlaces.', '2026-12-22', 1, 'abierta'),
    ('Banco del Este S.A.', 'Analista de Datos Jr.', 'Generación de tableros de control y validación de registros financieros.', '2026-11-10', 2, 'abierta'),
    ('Agroindustria Ypacaraí', 'Operador de Control de Calidad', 'Inspección de lotes en planta y registro de conformidad.', '2026-12-15', 1, 'cerrada')
) AS v(empresa_nombre, cargo, descripcion, cierre, cupos, estado)
JOIN empresas e ON e.nombre = v.empresa_nombre
WHERE NOT EXISTS (
  SELECT 1 FROM vacantes ex WHERE ex.empresa_id = e.id AND ex.cargo = v.cargo
);

INSERT INTO candidatos (documento, nombre, email, telefono) VALUES
  ('5124890', 'Lucas Benítez', 'lucas.benitez@ejemplo.py', '+595 981 210 340'),
  ('5439120', 'Sofía Villalba', 'sofia.villalba@ejemplo.py', '+595 971 452 118'),
  ('4982311', 'Mateo Coronel', 'mateo.coronel@ejemplo.py', '+595 982 664 092'),
  ('5610442', 'Camila Duarte', 'camila.duarte@ejemplo.py', '+595 985 330 715'),
  ('5290874', 'Thiago Giménez', 'thiago.gimenez@ejemplo.py', '+595 972 889 401'),
  ('5341908', 'Valentina Acosta', 'valentina.acosta@ejemplo.py', '+595 984 512 630')
ON CONFLICT (documento) DO NOTHING;

INSERT INTO postulaciones (vacante_id, candidato_id, fecha, estado, motivo_decision)
SELECT v.id, c.id, p.fecha::timestamptz, p.estado, p.motivo_decision
FROM (
  VALUES
    ('Desarrollador Web Junior', '5124890', '2026-11-20T09:15:00Z', 'seleccionado', 'Seleccionado dentro del cupo (1/2) tras validación de perfil.'),
    ('Desarrollador Web Junior', '5439120', '2026-11-21T10:30:00Z', 'pendiente', 'Postulación aceptada dentro de fecha de cierre.'),
    ('Soporte Técnico de Laboratorio', '4982311', '2026-11-21T14:00:00Z', 'pendiente', 'Postulación aceptada dentro de fecha de cierre.'),
    ('Soporte Técnico de Laboratorio', '5290874', '2026-11-22T08:45:00Z', 'pendiente', 'Postulación aceptada dentro de fecha de cierre.'),
    ('Auxiliar de Control de Flota', '5610442', '2026-11-22T11:20:00Z', 'seleccionado', 'Seleccionado dentro del cupo (1/2).'),
    ('Recepcionista de Turno Mañana', '5341908', '2026-11-23T09:00:00Z', 'pendiente', 'Postulación aceptada dentro de fecha de cierre.')
) AS p(cargo, documento, fecha, estado, motivo_decision)
JOIN vacantes v ON v.cargo = p.cargo
JOIN candidatos c ON c.documento = p.documento
ON CONFLICT (vacante_id, candidato_id) DO NOTHING;
