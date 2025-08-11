-- Insertar datos en Categorias_Producto
INSERT INTO Categorias_Producto (nombre_categoria, descripcion) VALUES
('Frutas', 'Productos frutícolas como aguacates, mangos, etc.'),
('Granos', 'Cereales y granos básicos'),
('Lácteos', 'Productos derivados de la leche'),
('Insumos', 'Fertilizantes, pesticidas y otros insumos agrícolas'),
('Equipos', 'Herramientas y maquinaria menor');

-- Insertar datos en Productos
INSERT INTO Productos (nombre_producto, tipo_producto, precio_venta, unidad_medida, id_categoria) VALUES
('Aguacate Hass', 'Cultivo', 5.50, 'kg', 1),
('Maíz Blanco', 'Cultivo', 1.20, 'kg', 2),
('Leche Entera', 'Producto terminado', 0.80, 'litro', 3),
('Fertilizante NPK', 'Insumo', 25.00, 'saco 50kg', 4),
('Herramienta Poda', 'Equipo', 15.00, 'unidad', 5),
('Mango Tommy', 'Cultivo', 3.20, 'kg', 1),
('Queso Fresco', 'Producto terminado', 6.50, 'kg', 3),
('Pesticida Orgánico', 'Insumo', 18.00, 'litro', 4);

-- Insertar datos en Departamentos
INSERT INTO Departamentos (nombre_departamento, descripcion) VALUES
('Producción', 'Encargado de cultivos y cosechas'),
('Ganadería', 'Manejo de animales y producción lechera'),
('Ventas', 'Comercialización de productos'),
('Compras', 'Adquisición de insumos y equipos'),
('Administración', 'Gestión financiera y recursos humanos');

-- Insertar datos en Roles
INSERT INTO Roles (nombre_rol, descripcion, nivel_acceso) VALUES
('Administrador', 'Acceso total al sistema', 5),
('Gerente', 'Supervisión general', 4),
('Supervisor', 'Supervisión de área', 3),
('Técnico', 'Personal especializado', 2),
('Operario', 'Personal de campo', 1);

-- Insertar datos en Empleados
INSERT INTO Empleados (nombre, apellido, fecha_contratacion, salario, id_rol, id_departamento, telefono, direccion, estado) VALUES
('Juan', 'Pérez', '2020-05-15', 2500.00, 1, 5, '5551234567', 'Calle Principal 123', 'Activo'),
('María', 'Gómez', '2019-03-10', 1800.00, 2, 1, '5552345678', 'Avenida Central 456', 'Activo'),
('Carlos', 'López', '2021-02-20', 1500.00, 3, 2, '5553456789', 'Boulevard Norte 789', 'Activo'),
('Ana', 'Martínez', '2022-01-05', 1200.00, 4, 1, '5554567890', 'Calle Sur 321', 'Vacaciones'),
('Luis', 'Rodríguez', '2020-11-15', 1100.00, 5, 1, '5555678901', 'Avenida Este 654', 'Activo');

-- Insertar datos en Historial_Salarios
INSERT INTO Historial_Salarios (id_empleado, salario_anterior, salario_nuevo, fecha_cambio, motivo, id_responsable) VALUES
(2, 1600.00, 1800.00, '2023-01-15', 'Aumento por desempeño', 1),
(3, 1400.00, 1500.00, '2022-06-01', 'Ajuste salarial anual', 1),
(4, 1000.00, 1200.00, '2023-03-01', 'Ascenso a técnico', 2);

-- Insertar datos en Clientes
INSERT INTO Clientes (nombre_cliente, tipo, direccion, telefono, email, ruc_ci, fecha_registro) VALUES
('Supermercado Nacional', 'Empresa', 'Av. Comercial 100', '5551112233', 'contacto@supernac.com', '1234567890123', '2020-01-15'),
('Restaurante La Hacienda', 'Empresa', 'Calle Gourmet 45', '5552223344', 'pedidos@hacienda.com', '9876543210987', '2021-03-20'),
('Doña Luisa', 'Persona', 'Barrio Centro 78', '5553334455', NULL, '8765432109', '2022-05-10');

-- Insertar datos en Maquinaria
INSERT INTO Maquinaria (nombre_maquinaria, modelo, serie, fecha_adquisicion, costo, vida_util, estado, ubicacion) VALUES
('Tractor Agrícola', 'John Deere 5050', 'TRC2020JD', '2020-02-15', 45000.00, 120, 'Operativa', 'Granero Principal'),
('Cosechadora', 'New Holland 7.60', 'CSH2021NH', '2021-03-20', 38000.00, 96, 'Mantenimiento', 'Taller Mecánico'),
('Ordeñadora', 'DeLaval 20L', 'ORD2019DL', '2019-05-10', 12000.00, 60, 'Operativa', 'Sala de Ordeño');

-- Insertar datos en Proveedores
INSERT INTO Proveedores (nombre_proveedor, contacto, telefono, email, direccion, ruc, tipo) VALUES
('Agroinsumos S.A.', 'Ing. Roberto Mendoza', '5554445566', 'ventas@agroinsumos.com', 'Zona Industrial 200', '1112223334445', 'Insumos'),
('Maquinaria Agrícola Ltda.', 'Lic. Sandra Ruiz', '5555556677', 'cotizaciones@maquinaria-ag.com', 'Autopista Norte Km 12', '5556667778889', 'Equipos'),
('Semillas Premium', 'Téc. Javier Solís', '5556667788', 'semillas@premium.com', 'Carrera Este 34', '9998887776665', 'Insumos');

-- Insertar datos en Parcelas
INSERT INTO Parcelas (nombre_parcela, area, tipo_suelo, estado) VALUES
('Parcela Norte', 5.2, 'Arcilloso', 'Ocupada'),
('Parcela Sur', 3.8, 'Franco', 'Disponible'),
('Parcela Este', 4.5, 'Arenoso', 'En descanso'),
('Parcela Oeste', 2.7, 'Franco-arcilloso', 'Ocupada');

-- Insertar datos en Cultivos
INSERT INTO Cultivos (id_parcela, id_producto, fecha_siembra, fecha_cosecha_estimada, cantidad_estimada, estado) VALUES
(1, 1, '2023-01-15', '2023-10-20', 2500.00, 'En crecimiento'),
(4, 2, '2023-03-01', '2023-08-15', 1800.00, 'En crecimiento'),
(1, 6, '2022-11-20', '2023-07-10', 1200.00, 'En crecimiento');


-- 1. Categorias_Producto
INSERT INTO Categorias_Producto (nombre_categoria, descripcion) VALUES
('Frutas', 'Productos frutícolas como aguacates, mangos, etc.'),
('Granos', 'Cereales y granos básicos'),
('Lácteos', 'Productos derivados de la leche'),
('Insumos', 'Fertilizantes, pesticidas y otros insumos agrícolas'),
('Equipos', 'Herramientas y maquinaria menor');

-- 2. Departamentos
INSERT INTO Departamentos (nombre_departamento, descripcion) VALUES
('Producción', 'Encargado de cultivos y cosechas'),
('Ganadería', 'Manejo de animales y producción lechera'),
('Ventas', 'Comercialización de productos'),
('Compras', 'Adquisición de insumos y equipos'),
('Administración', 'Gestión financiera y recursos humanos');

-- 3. Roles
INSERT INTO Roles (nombre_rol, descripcion, nivel_acceso) VALUES
('Administrador', 'Acceso total al sistema', 5),
('Gerente', 'Supervisión general', 4),
('Supervisor', 'Supervisión de área', 3),
('Técnico', 'Personal especializado', 2),
('Operario', 'Personal de campo', 1);

-- 4. Clientes
INSERT INTO Clientes (nombre_cliente, tipo, direccion, telefono, email, ruc_ci, fecha_registro) VALUES
('Supermercado Nacional', 'Empresa', 'Av. Comercial 100', '5551112233', 'contacto@supernac.com', '1234567890123', '2020-01-15'),
('Restaurante La Hacienda', 'Empresa', 'Calle Gourmet 45', '5552223344', 'pedidos@hacienda.com', '9876543210987', '2021-03-20'),
('Doña Luisa', 'Persona', 'Barrio Centro 78', '5553334455', NULL, '8765432109', '2022-05-10');

-- 5. Proveedores
INSERT INTO Proveedores (nombre_proveedor, contacto, telefono, email, direccion, ruc, tipo) VALUES
('Agroinsumos S.A.', 'Ing. Roberto Mendoza', '5554445566', 'ventas@agroinsumos.com', 'Zona Industrial 200', '1112223334445', 'Insumos'),
('Maquinaria Agrícola Ltda.', 'Lic. Sandra Ruiz', '5555556677', 'cotizaciones@maquinaria-ag.com', 'Autopista Norte Km 12', '5556667778889', 'Equipos'),
('Semillas Premium', 'Téc. Javier Solís', '5556667788', 'semillas@premium.com', 'Carrera Este 34', '9998887776665', 'Insumos');

-- 6. Parcelas
INSERT INTO Parcelas (nombre_parcela, area, tipo_suelo, estado) VALUES
('Parcela Norte', 5.2, 'Arcilloso', 'Ocupada'),
('Parcela Sur', 3.8, 'Franco', 'Disponible'),
('Parcela Este', 4.5, 'Arenoso', 'En descanso'),
('Parcela Oeste', 2.7, 'Franco-arcilloso', 'Ocupada');

-- 7. Maquinaria
INSERT INTO Maquinaria (nombre_maquinaria, modelo, serie, fecha_adquisicion, costo, vida_util, estado, ubicacion) VALUES
('Tractor Agrícola', 'John Deere 5050', 'TRC2020JD', '2020-02-15', 45000.00, 120, 'Operativa', 'Granero Principal'),
('Cosechadora', 'New Holland 7.60', 'CSH2021NH', '2021-03-20', 38000.00, 96, 'Mantenimiento', 'Taller Mecánico'),
('Ordeñadora', 'DeLaval 20L', 'ORD2019DL', '2019-05-10', 12000.00, 60, 'Operativa', 'Sala de Ordeño');

-- 8. Productos (depende de Categorias_Producto)
INSERT INTO Productos (nombre_producto, tipo_producto, precio_venta, unidad_medida, id_categoria, descripcion) VALUES
('Aguacate Hass', 'Cultivo', 5.50, 'kg', 1, 'Aguacate variedad Hass de exportación'),
('Maíz Blanco', 'Cultivo', 1.20, 'kg', 2, 'Maíz blanco para consumo humano'),
('Leche Entera', 'Producto terminado', 0.80, 'litro', 3, 'Leche pasteurizada entera'),
('Fertilizante NPK', 'Insumo', 25.00, 'saco 50kg', 4, 'Fertilizante completo 15-15-15'),
('Herramienta Poda', 'Equipo', 15.00, 'unidad', 5, 'Tijeras profesionales para poda'),
('Mango Tommy', 'Cultivo', 3.20, 'kg', 1, 'Mango variedad Tommy Atkins'),
('Queso Fresco', 'Producto terminado', 6.50, 'kg', 3, 'Queso fresco campesino'),
('Pesticida Orgánico', 'Insumo', 18.00, 'litro', 4, 'Pesticida orgánico certificado');

-- 9. Empleados (depende de Roles y Departamentos)
INSERT INTO Empleados (nombre, apellido, fecha_contratacion, salario, id_rol, id_departamento, telefono, direccion, estado) VALUES
('Juan', 'Pérez', '2020-05-15', 2500.00, 1, 5, '5551234567', 'Calle Principal 123', 'Activo'),
('María', 'Gómez', '2019-03-10', 1800.00, 2, 1, '5552345678', 'Avenida Central 456', 'Activo'),
('Carlos', 'López', '2021-02-20', 1500.00, 3, 2, '5553456789', 'Boulevard Norte 789', 'Activo'),
('Ana', 'Martínez', '2022-01-05', 1200.00, 4, 1, '5554567890', 'Calle Sur 321', 'Vacaciones'),
('Luis', 'Rodríguez', '2020-11-15', 1100.00, 5, 1, '5555678901', 'Avenida Este 654', 'Activo');

-- 10. Historial_Salarios (depende de Empleados)
INSERT INTO Historial_Salarios (id_empleado, salario_anterior, salario_nuevo, fecha_cambio, motivo, id_responsable) VALUES
(2, 1600.00, 1800.00, '2023-01-15', 'Aumento por desempeño', 1),
(3, 1400.00, 1500.00, '2022-06-01', 'Ajuste salarial anual', 1),
(4, 1000.00, 1200.00, '2023-03-01', 'Ascenso a técnico', 2);

-- 11. Compras (depende de Proveedores)
INSERT INTO Compras (id_proveedor, fecha_compra, total, estado, forma_pago) VALUES
(1, '2023-01-10', 1250.00, 'Pagada', 'Transferencia'),
(3, '2023-02-15', 840.00, 'Pagada', 'Efectivo'),
(2, '2023-03-05', 3800.00, 'Pendiente', 'Crédito 30 días');

-- 12. Detalle_Compras (depende de Compras y Productos)
INSERT INTO Detalle_Compras (id_compra, id_producto, cantidad, costo_unitario, subtotal) VALUES
(1, 4, 50, 25.00, 1250.00),
(2, 8, 20, 18.00, 360.00),
(2, 4, 20, 25.00, 500.00),
(3, 5, 10, 15.00, 150.00);

-- 13. Inventario (depende de Productos)
INSERT INTO Inventario (id_producto, cantidad, unidad_medida, ubicacion, lote, fecha_caducidad) VALUES
(1, 0, 'kg', 'Almacén Principal', NULL, NULL),
(2, 0, 'kg', 'Almacén Principal', NULL, NULL),
(3, 120, 'litro', 'Cuarto Frío', 'LT20230301', '2023-03-15'),
(4, 30, 'saco 50kg', 'Bodega Insumos', 'FERT202301', '2024-01-10'),
(5, 8, 'unidad', 'Taller Herramientas', NULL, NULL),
(6, 0, 'kg', 'Almacén Principal', NULL, NULL),
(7, 25, 'kg', 'Cuarto Frío', 'QUES202303', '2023-03-20'),
(8, 15, 'litro', 'Bodega Insumos', 'PEST202302', '2024-02-15');

-- 14. Ventas (depende de Empleados y Clientes)
INSERT INTO Ventas (fecha_venta, id_empleado, id_cliente, total, estado, forma_pago) VALUES
('2023-03-01 09:30:00', 2, 1, 2650.00, 'Pagada', 'Transferencia'),
('2023-03-05 11:15:00', 3, 2, 480.00, 'Pagada', 'Efectivo'),
('2023-03-10 16:45:00', 2, 3, 120.00, 'Pendiente', 'Efectivo');

-- 15. Detalle_Ventas (depende de Ventas y Productos)
INSERT INTO Detalle_Ventas (id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 200, 5.50, 1100.00),
(1, 6, 150, 3.20, 480.00),
(1, 7, 20, 6.50, 130.00),
(2, 3, 100, 0.80, 80.00),
(2, 7, 10, 6.50, 65.00),
(3, 3, 50, 0.80, 40.00);

-- 16. Cultivos (depende de Parcelas y Productos)
INSERT INTO Cultivos (id_parcela, id_producto, fecha_siembra, fecha_cosecha_estimada, cantidad_estimada, estado) VALUES
(1, 1, '2023-01-15', '2023-10-20', 2500.00, 'En crecimiento'),
(4, 2, '2023-03-01', '2023-08-15', 1800.00, 'En crecimiento'),
(1, 6, '2022-11-20', '2023-07-10', 1200.00, 'En crecimiento');

-- 17. Produccion_Lechera (depende de Empleados)
INSERT INTO Produccion_Lechera (fecha, id_animal, cantidad, calidad, id_empleado) VALUES
('2023-03-01', 'VACA001', 12.5, 'Buena', 4),
('2023-03-01', 'VACA002', 14.2, 'Excelente', 4),
('2023-03-02', 'VACA001', 11.8, 'Buena', 5),
('2023-03-02', 'VACA003', 10.5, 'Regular', 5);

-- 18. Registro_Riegos (depende de Parcelas y Empleados)
INSERT INTO Registro_Riegos (id_parcela, fecha, cantidad_agua, metodo, id_empleado) VALUES
(1, '2023-03-01 06:00:00', 1200.00, 'Aspersión', 3),
(4, '2023-03-02 07:30:00', 800.00, 'Goteo', 3),
(1, '2023-03-05 06:15:00', 1100.00, 'Aspersión', 5);

-- 19. Aplicacion_Insumos (depende de Parcelas, Productos y Empleados)
INSERT INTO Aplicacion_Insumos (id_parcela, id_producto, fecha, cantidad, metodo_aplicacion, id_empleado) VALUES
(1, 4, '2023-02-20', 5.00, 'Fertirriego', 3),
(4, 8, '2023-02-25', 2.50, 'Pulverización', 3);

-- 20. Tareas (depende de Empleados, Maquinaria y Parcelas)
INSERT INTO Tareas (descripcion, fecha_inicio, fecha_fin, id_maquinaria, id_empleado, id_parcela, estado, prioridad) VALUES
('Preparación terreno parcela norte', '2023-02-10', '2023-02-15', 1, 3, 1, 'Completada', 'Alta'),
('Siembra maíz parcela oeste', '2023-03-01', '2023-03-02', NULL, 5, 4, 'Completada', 'Media'),
('Mantenimiento preventivo cosechadora', '2023-03-05', NULL, 2, 4, NULL, 'En progreso', 'Alta');

-- 21. Mantenimiento_Maquinaria (depende de Maquinaria y Proveedores)
INSERT INTO Mantenimiento_Maquinaria (id_maquinaria, fecha, tipo, descripcion, costo, id_proveedor_servicio) VALUES
(2, '2023-03-05', 'Preventivo', 'Cambio de aceite y filtros', 120.00, 2),
(1, '2022-12-15', 'Correctivo', 'Reparación sistema hidráulico', 350.00, 2);