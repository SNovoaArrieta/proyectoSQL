-- 1. Listar todos los productos disponibles
SELECT * FROM Productos;

-- 2. Mostrar empleados activos
SELECT nombre, apellido, fecha_contratacion, salario 
FROM Empleados 
WHERE estado = 'Activo';

-- 3. Clientes registrados ordenados por fecha
SELECT nombre_cliente, tipo, fecha_registro 
FROM Clientes 
ORDER BY fecha_registro DESC;

-- 4. Productos con precio mayor a $3.00
SELECT nombre_producto, precio_venta, unidad_medida 
FROM Productos 
WHERE precio_venta > 3.00;

-- 5. Maquinaria en mantenimiento
SELECT nombre_maquinaria, modelo, fecha_adquisicion 
FROM Maquinaria 
WHERE estado = 'Mantenimiento';

-- 6. Proveedores de insumos
SELECT nombre_proveedor, contacto, telefono 
FROM Proveedores 
WHERE tipo = 'Insumos';

-- 7. Parcelas ocupadas
SELECT nombre_parcela, area, tipo_suelo 
FROM Parcelas 
WHERE estado = 'Ocupada';

-- 8. Cultivos en crecimiento
SELECT id_cultivo, fecha_siembra, fecha_cosecha_estimada 
FROM Cultivos 
WHERE estado = 'En crecimiento';

-- 9. Ventas del mes actual
SELECT id_venta, fecha_venta, total 
FROM Ventas 
WHERE MONTH(fecha_venta) = MONTH(CURRENT_DATE()) 
AND YEAR(fecha_venta) = YEAR(CURRENT_DATE());

-- 10. Compras pendientes de pago
SELECT id_compra, fecha_compra, total 
FROM Compras 
WHERE estado = 'Pendiente';

-- 11. Inventario con menos de 10 unidades
SELECT id_producto, cantidad, unidad_medida 
FROM Inventario 
WHERE cantidad < 10;

-- 12. Tareas no completadas
SELECT descripcion, fecha_inicio, fecha_fin 
FROM Tareas 
WHERE estado != 'Completada';

-- 13. Producción lechera de hoy
SELECT id_animal, cantidad, calidad 
FROM Produccion_Lechera 
WHERE DATE(fecha) = CURRENT_DATE();

-- 14. Historial de cambios salariales
SELECT id_empleado, salario_anterior, salario_nuevo, fecha_cambio 
FROM Historial_Salarios 
ORDER BY fecha_cambio DESC;

-- 15. Riegos realizados esta semana
SELECT id_parcela, cantidad_agua, metodo 
FROM Registro_Riegos 
WHERE fecha BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) AND CURRENT_DATE();

-- 16. Aplicación de insumos recientes
SELECT id_parcela, id_producto, cantidad, metodo_aplicacion 
FROM Aplicacion_Insumos 
ORDER BY fecha DESC LIMIT 5;

-- 17. Mantenimientos de maquinaria costosos
SELECT id_maquinaria, tipo, costo 
FROM Mantenimiento_Maquinaria 
WHERE costo > 100 
ORDER BY costo DESC;

-- 18. Productos por categoría
SELECT p.nombre_producto, c.nombre_categoria 
FROM Productos p 
JOIN Categorias_Producto c ON p.id_categoria = c.id_categoria;

-- 19. Empleados por departamento
SELECT e.nombre, e.apellido, d.nombre_departamento 
FROM Empleados e 
JOIN Departamentos d ON e.id_departamento = d.id_departamento;

-- 20. Detalle de una venta específica
SELECT p.nombre_producto, dv.cantidad, dv.precio_unitario, dv.subtotal 
FROM Detalle_Ventas dv 
JOIN Productos p ON dv.id_producto = p.id_producto 
WHERE dv.id_venta = 1;

-- 21. Ventas con información de cliente y empleado
SELECT v.id_venta, v.fecha_venta, 
       c.nombre_cliente, 
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       v.total
FROM Ventas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
JOIN Empleados e ON v.id_empleado = e.id_empleado;

-- 22. Compras con proveedor y productos
SELECT c.id_compra, c.fecha_compra,
       p.nombre_proveedor,
       pr.nombre_producto,
       dc.cantidad,
       dc.costo_unitario,
       dc.subtotal
FROM Compras c
JOIN Proveedores p ON c.id_proveedor = p.id_proveedor
JOIN Detalle_Compras dc ON c.id_compra = dc.id_compra
JOIN Productos pr ON dc.id_producto = pr.id_producto;

-- 23. Cultivos con información de parcela y producto
SELECT cu.id_cultivo,
       pa.nombre_parcela,
       pr.nombre_producto,
       cu.fecha_siembra,
       cu.fecha_cosecha_estimada
FROM Cultivos cu
JOIN Parcelas pa ON cu.id_parcela = pa.id_parcela
JOIN Productos pr ON cu.id_producto = pr.id_producto;

-- 24. Tareas con empleado y maquinaria
SELECT t.descripcion,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       m.nombre_maquinaria,
       t.fecha_inicio,
       t.fecha_fin
FROM Tareas t
JOIN Empleados e ON t.id_empleado = e.id_empleado
LEFT JOIN Maquinaria m ON t.id_maquinaria = m.id_maquinaria;

-- 25. Producción lechera con empleado
SELECT pl.fecha,
       pl.id_animal,
       pl.cantidad,
       pl.calidad,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado
FROM Produccion_Lechera pl
JOIN Empleados e ON pl.id_empleado = e.id_empleado;

-- 26. Riegos con parcela y empleado
SELECT r.fecha,
       p.nombre_parcela,
       r.cantidad_agua,
       r.metodo,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado
FROM Registro_Riegos r
JOIN Parcelas p ON r.id_parcela = p.id_parcela
JOIN Empleados e ON r.id_empleado = e.id_empleado;

-- 27. Aplicación de insumos con detalles
SELECT a.fecha,
       p.nombre_parcela,
       pr.nombre_producto,
       a.cantidad,
       a.metodo_aplicacion,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado
FROM Aplicacion_Insumos a
JOIN Parcelas p ON a.id_parcela = p.id_parcela
JOIN Productos pr ON a.id_producto = pr.id_producto
JOIN Empleados e ON a.id_empleado = e.id_empleado;

-- 28. Mantenimientos con maquinaria y proveedor
SELECT mm.fecha,
       m.nombre_maquinaria,
       mm.tipo,
       mm.descripcion,
       mm.costo,
       p.nombre_proveedor
FROM Mantenimiento_Maquinaria mm
JOIN Maquinaria m ON mm.id_maquinaria = m.id_maquinaria
LEFT JOIN Proveedores p ON mm.id_proveedor_servicio = p.id_proveedor;

-- 29. Historial salarial con nombres de empleados
SELECT CONCAT(e1.nombre, ' ', e1.apellido) AS empleado,
       hs.salario_anterior,
       hs.salario_nuevo,
       hs.fecha_cambio,
       hs.motivo,
       CONCAT(e2.nombre, ' ', e2.apellido) AS responsable
FROM Historial_Salarios hs
JOIN Empleados e1 ON hs.id_empleado = e1.id_empleado
LEFT JOIN Empleados e2 ON hs.id_responsable = e2.id_empleado;

-- 30. Productos con su inventario actual
SELECT p.nombre_producto,
       p.precio_venta,
       p.unidad_medida,
       i.cantidad AS stock,
       i.fecha_actualizacion
FROM Productos p
JOIN Inventario i ON p.id_producto = i.id_producto;



--. Total de ventas por mes
SELECT 
    DATE_FORMAT(fecha_venta, '%Y-%m') AS mes,
    COUNT(*) AS cantidad_ventas,
    SUM(total) AS total_ventas
FROM Ventas
GROUP BY mes
ORDER BY mes;

-- . Productos más vendidos
SELECT 
    p.nombre_producto,
    SUM(dv.cantidad) AS cantidad_vendida,
    SUM(dv.subtotal) AS ingresos_totales
FROM Detalle_Ventas dv
JOIN Productos p ON dv.id_producto = p.id_producto
GROUP BY p.nombre_producto
ORDER BY cantidad_vendida DESC;

-- . Ventas por empleado
SELECT 
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    COUNT(v.id_venta) AS cantidad_ventas,
    SUM(v.total) AS total_ventas
FROM Ventas v
JOIN Empleados e ON v.id_empleado = e.id_empleado
GROUP BY empleado
ORDER BY total_ventas DESC;

-- . Compras por proveedor
SELECT 
    p.nombre_proveedor,
    COUNT(c.id_compra) AS cantidad_compras,
    SUM(c.total) AS total_compras
FROM Compras c
JOIN Proveedores p ON c.id_proveedor = p.id_proveedor
GROUP BY p.nombre_proveedor
ORDER BY total_compras DESC;

-- . Producción lechera por animal
SELECT 
    id_animal,
    COUNT(*) AS cantidad_registros,
    SUM(cantidad) AS total_leche,
    AVG(cantidad) AS promedio_diario
FROM Produccion_Lechera
GROUP BY id_animal
ORDER BY total_leche DESC;

-- . Riegos por parcela
SELECT 
    p.nombre_parcela,
    COUNT(r.id_riego) AS cantidad_riegos,
    SUM(r.cantidad_agua) AS total_agua
FROM Registro_Riegos r
JOIN Parcelas p ON r.id_parcela = p.id_parcela
GROUP BY p.nombre_parcela;

-- . Tareas completadas por empleado
SELECT 
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    COUNT(t.id_tarea) AS tareas_completadas
FROM Tareas t
JOIN Empleados e ON t.id_empleado = e.id_empleado
WHERE t.estado = 'Completada'
GROUP BY empleado
ORDER BY tareas_completadas DESC;

-- . Mantenimientos por tipo de maquinaria
SELECT 
    m.nombre_maquinaria,
    COUNT(mm.id_mantenimiento) AS cantidad_mantenimientos,
    SUM(mm.costo) AS total_costo
FROM Mantenimiento_Maquinaria mm
JOIN Maquinaria m ON mm.id_maquinaria = m.id_maquinaria
GROUP BY m.nombre_maquinaria
ORDER BY total_costo DESC;

-- . Cultivos por tipo de producto
SELECT 
    p.nombre_producto,
    COUNT(c.id_cultivo) AS cantidad_cultivos,
    SUM(c.cantidad_estimada) AS total_estimado
FROM Cultivos c
JOIN Productos p ON c.id_producto = p.id_producto
GROUP BY p.nombre_producto
ORDER BY cantidad_cultivos DESC;

-- . Salarios por departamento
SELECT 
    d.nombre_departamento,
    COUNT(e.id_empleado) AS cantidad_empleados,
    AVG(e.salario) AS salario_promedio,
    SUM(e.salario) AS total_nomina
FROM Empleados e
JOIN Departamentos d ON e.id_departamento = d.id_departamento
GROUP BY d.nombre_departamento
ORDER BY total_nomina DESC;



