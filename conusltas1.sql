
-- 1. Listar todos los productos disponibles
SELECT id_producto, nombre_producto, tipo_producto, precio_venta, unidad_medida 
FROM Productos
ORDER BY nombre_producto;

-- 2. Mostrar empleados activos con su salario y departamento
SELECT e.nombre, e.apellido, e.fecha_contratacion, e.salario, d.nombre_departamento
FROM Empleados e
JOIN Departamentos d ON e.id_departamento = d.id_departamento
WHERE e.estado = 'Activo'
ORDER BY e.salario DESC;

-- 3. Clientes registrados ordenados por fecha con información de contacto
SELECT nombre_cliente, tipo, direccion, telefono, email, fecha_registro 
FROM Clientes 
ORDER BY fecha_registro DESC;

-- 4. Productos con precio mayor a $3.00 y su categoría
SELECT p.nombre_producto, p.precio_venta, p.unidad_medida, c.nombre_categoria
FROM Productos p
JOIN Categorias_Producto c ON p.id_categoria = c.id_categoria
WHERE p.precio_venta > 3.00
ORDER BY p.precio_venta DESC;

-- 5. Maquinaria en mantenimiento con días desde último mantenimiento
SELECT nombre_maquinaria, modelo, 
       DATEDIFF(CURRENT_DATE, fecha_mantenimiento) AS dias_desde_mantenimiento
FROM Maquinaria 
WHERE estado = 'Mantenimiento'
ORDER BY dias_desde_mantenimiento DESC;

-- 6. Proveedores de insumos con información de contacto completa
SELECT nombre_proveedor, contacto, telefono, email, direccion
FROM Proveedores 
WHERE tipo = 'Insumos'
ORDER BY nombre_proveedor;

-- 7. Parcelas ocupadas con su cultivo actual
SELECT p.nombre_parcela, p.area, p.tipo_suelo, pr.nombre_producto AS cultivo_actual
FROM Parcelas p
JOIN Cultivos c ON p.id_parcela = c.id_parcela
JOIN Productos pr ON c.id_producto = pr.id_producto
WHERE p.estado = 'Ocupada' AND c.estado = 'En crecimiento'
ORDER BY p.nombre_parcela;

-- 8. Cultivos en crecimiento con días hasta cosecha
SELECT c.id_cultivo, pr.nombre_producto, p.nombre_parcela,
       c.fecha_siembra, c.fecha_cosecha_estimada,
       DATEDIFF(c.fecha_cosecha_estimada, CURRENT_DATE) AS dias_hasta_cosecha
FROM Cultivos c
JOIN Productos pr ON c.id_producto = pr.id_producto
JOIN Parcelas p ON c.id_parcela = p.id_parcela
WHERE c.estado = 'En crecimiento'
ORDER BY dias_hasta_cosecha;

-- 9. Ventas del mes actual con estado y forma de pago
SELECT id_venta, DATE_FORMAT(fecha_venta, '%d/%m/%Y %H:%i') AS fecha_formateada, 
       total, estado, forma_pago
FROM Ventas 
WHERE MONTH(fecha_venta) = MONTH(CURRENT_DATE()) 
AND YEAR(fecha_venta) = YEAR(CURRENT_DATE())
ORDER BY fecha_venta DESC;

-- 10. Compras pendientes de pago con proveedor
SELECT c.id_compra, DATE_FORMAT(c.fecha_compra, '%d/%m/%Y') AS fecha, 
       c.total, p.nombre_proveedor, c.forma_pago
FROM Compras c
JOIN Proveedores p ON c.id_proveedor = p.id_proveedor
WHERE c.estado = 'Pendiente'
ORDER BY c.fecha_compra;

-- 11. Inventario bajo (menos de 10 unidades) con producto y ubicación
SELECT p.nombre_producto, i.cantidad, p.unidad_medida, i.ubicacion
FROM Inventario i
JOIN Productos p ON i.id_producto = p.id_producto
WHERE i.cantidad < 10
ORDER BY i.cantidad;

-- 12. Tareas no completadas con prioridad y responsable
SELECT t.descripcion, t.fecha_inicio, 
       DATEDIFF(CURRENT_DATE, t.fecha_inicio) AS dias_pendientes,
       t.prioridad, CONCAT(e.nombre, ' ', e.apellido) AS responsable
FROM Tareas t
JOIN Empleados e ON t.id_empleado = e.id_empleado
WHERE t.estado != 'Completada'
ORDER BY t.prioridad DESC, dias_pendientes DESC;

-- 13. Producción lechera de hoy con calidad y empleado
SELECT pl.id_animal, pl.cantidad AS litros, pl.calidad,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado
FROM Produccion_Lechera pl
JOIN Empleados e ON pl.id_empleado = e.id_empleado
WHERE DATE(pl.fecha) = CURRENT_DATE()
ORDER BY pl.cantidad DESC;

-- 14. Historial de cambios salariales con porcentaje de aumento
SELECT CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       hs.salario_anterior, hs.salario_nuevo, 
       ROUND(((hs.salario_nuevo - hs.salario_anterior)/hs.salario_anterior)*100, 2) AS porcentaje_aumento,
       hs.fecha_cambio, hs.motivo
FROM Historial_Salarios hs
JOIN Empleados e ON hs.id_empleado = e.id_empleado
ORDER BY hs.fecha_cambio DESC;

-- 15. Riegos realizados esta semana con método y parcela
SELECT p.nombre_parcela, r.cantidad_agua, r.metodo,
       DATE_FORMAT(r.fecha, '%d/%m %H:%i') AS fecha_hora,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado
FROM Registro_Riegos r
JOIN Parcelas p ON r.id_parcela = p.id_parcela
JOIN Empleados e ON r.id_empleado = e.id_empleado
WHERE r.fecha BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) AND CURRENT_DATE()
ORDER BY r.fecha DESC;

-- 16. Aplicación de insumos recientes con producto y método
SELECT p.nombre_parcela, pr.nombre_producto AS insumo, 
       a.cantidad, a.metodo_aplicacion,
       DATE_FORMAT(a.fecha, '%d/%m/%Y') AS fecha_aplicacion
FROM Aplicacion_Insumos a
JOIN Parcelas p ON a.id_parcela = p.id_parcela
JOIN Productos pr ON a.id_producto = pr.id_producto
ORDER BY a.fecha DESC 
LIMIT 5;

-- 17. Mantenimientos de maquinaria costosos con proveedor
SELECT m.nombre_maquinaria, mm.tipo, mm.costo,
       DATE_FORMAT(mm.fecha, '%d/%m/%Y') AS fecha,
       p.nombre_proveedor AS servicio_por
FROM Mantenimiento_Maquinaria mm
JOIN Maquinaria m ON mm.id_maquinaria = m.id_maquinaria
LEFT JOIN Proveedores p ON mm.id_proveedor_servicio = p.id_proveedor
WHERE mm.costo > 100
ORDER BY mm.costo DESC;

-- 18. Productos por categoría con cantidad en inventario
SELECT c.nombre_categoria, p.nombre_producto, 
       i.cantidad, p.unidad_medida
FROM Productos p
JOIN Categorias_Producto c ON p.id_categoria = c.id_categoria
JOIN Inventario i ON p.id_producto = i.id_producto
ORDER BY c.nombre_categoria, p.nombre_producto;

-- 19. Empleados por departamento con rol y estado
SELECT d.nombre_departamento, 
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       r.nombre_rol, e.estado
FROM Empleados e
JOIN Departamentos d ON e.id_departamento = d.id_departamento
JOIN Roles r ON e.id_rol = r.id_rol
ORDER BY d.nombre_departamento, e.apellido;

-- 20. Detalle completo de una venta específica con productos
SELECT p.nombre_producto, 
       dv.cantidad, dv.precio_unitario, 
       dv.descuento, dv.subtotal
FROM Detalle_Ventas dv
JOIN Productos p ON dv.id_producto = p.id_producto
WHERE dv.id_venta = 1
ORDER BY dv.id_detalle_venta;

-- 21. Ventas con información completa de cliente, empleado y estado
SELECT v.id_venta, 
       DATE_FORMAT(v.fecha_venta, '%d/%m/%Y %H:%i') AS fecha,
       c.nombre_cliente, 
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       v.total, v.estado, v.forma_pago
FROM Ventas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
JOIN Empleados e ON v.id_empleado = e.id_empleado
ORDER BY v.fecha_venta DESC;

-- 22. Compras detalladas con proveedor, productos y totales
SELECT c.id_compra, 
       DATE_FORMAT(c.fecha_compra, '%d/%m/%Y') AS fecha,
       p.nombre_proveedor,
       pr.nombre_producto,
       dc.cantidad,
       dc.costo_unitario,
       dc.subtotal,
       c.total AS total_compra
FROM Compras c
JOIN Proveedores p ON c.id_proveedor = p.id_proveedor
JOIN Detalle_Compras dc ON c.id_compra = dc.id_compra
JOIN Productos pr ON dc.id_producto = pr.id_producto
ORDER BY c.fecha_compra DESC;

-- 23. Cultivos con información completa de parcela, producto y fechas
SELECT cu.id_cultivo,
       pa.nombre_parcela,
       pr.nombre_producto,
       DATE_FORMAT(cu.fecha_siembra, '%d/%m/%Y') AS fecha_siembra,
       DATE_FORMAT(cu.fecha_cosecha_estimada, '%d/%m/%Y') AS fecha_cosecha_estimada,
       cu.cantidad_estimada,
       cu.estado
FROM Cultivos cu
JOIN Parcelas pa ON cu.id_parcela = pa.id_parcela
JOIN Productos pr ON cu.id_producto = pr.id_producto
ORDER BY cu.fecha_cosecha_estimada;

-- 24. Tareas completas con empleado, maquinaria y estado
SELECT t.id_tarea,
       t.descripcion,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       m.nombre_maquinaria,
       DATE_FORMAT(t.fecha_inicio, '%d/%m/%Y') AS inicio,
       DATE_FORMAT(t.fecha_fin, '%d/%m/%Y') AS fin,
       t.estado,
       t.prioridad
FROM Tareas t
JOIN Empleados e ON t.id_empleado = e.id_empleado
LEFT JOIN Maquinaria m ON t.id_maquinaria = m.id_maquinaria
ORDER BY t.prioridad DESC, t.fecha_inicio;

-- 25. Producción lechera diaria con empleado y calidad
SELECT DATE_FORMAT(pl.fecha, '%d/%m/%Y') AS fecha,
       pl.id_animal,
       pl.cantidad AS litros,
       pl.calidad,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       pl.observaciones
FROM Produccion_Lechera pl
JOIN Empleados e ON pl.id_empleado = e.id_empleado
ORDER BY pl.fecha DESC;

-- 26. Riegos realizados con detalles completos
SELECT r.id_riego,
       p.nombre_parcela,
       r.cantidad_agua,
       r.metodo,
       DATE_FORMAT(r.fecha, '%d/%m/%Y %H:%i') AS fecha_hora,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       r.observaciones
FROM Registro_Riegos r
JOIN Parcelas p ON r.id_parcela = p.id_parcela
JOIN Empleados e ON r.id_empleado = e.id_empleado
ORDER BY r.fecha DESC;

-- 27. Aplicación de insumos con detalles completos
SELECT a.id_aplicacion,
       p.nombre_parcela,
       pr.nombre_producto AS insumo,
       a.cantidad,
       a.metodo_aplicacion,
       DATE_FORMAT(a.fecha, '%d/%m/%Y') AS fecha,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       a.observaciones
FROM Aplicacion_Insumos a
JOIN Parcelas p ON a.id_parcela = p.id_parcela
JOIN Productos pr ON a.id_producto = pr.id_producto
JOIN Empleados e ON a.id_empleado = e.id_empleado
ORDER BY a.fecha DESC;

-- 28. Mantenimientos de maquinaria con detalles completos
SELECT mm.id_mantenimiento,
       m.nombre_maquinaria,
       m.modelo,
       mm.tipo,
       DATE_FORMAT(mm.fecha, '%d/%m/%Y') AS fecha,
       mm.descripcion,
       mm.costo,
       p.nombre_proveedor AS servicio_por
FROM Mantenimiento_Maquinaria mm
JOIN Maquinaria m ON mm.id_maquinaria = m.id_maquinaria
LEFT JOIN Proveedores p ON mm.id_proveedor_servicio = p.id_proveedor
ORDER BY mm.fecha DESC;

-- 29. Historial salarial completo con nombres de empleados
SELECT hs.id_historial,
       CONCAT(e1.nombre, ' ', e1.apellido) AS empleado,
       hs.salario_anterior,
       hs.salario_nuevo,
       ROUND(((hs.salario_nuevo - hs.salario_anterior)/hs.salario_anterior)*100, 2) AS porcentaje_aumento,
       DATE_FORMAT(hs.fecha_cambio, '%d/%m/%Y') AS fecha_cambio,
       hs.motivo,
       CONCAT(e2.nombre, ' ', e2.apellido) AS autorizado_por
FROM Historial_Salarios hs
JOIN Empleados e1 ON hs.id_empleado = e1.id_empleado
LEFT JOIN Empleados e2 ON hs.id_responsable = e2.id_empleado
ORDER BY hs.fecha_cambio DESC;

-- 30. Productos con su inventario actual y categoría
SELECT p.id_producto,
       p.nombre_producto,
       c.nombre_categoria,
       p.precio_venta,
       p.unidad_medida,
       i.cantidad AS stock_actual,
       i.ubicacion,
       DATE_FORMAT(i.fecha_actualizacion, '%d/%m/%Y') AS ultima_actualizacion
FROM Productos p
JOIN Categorias_Producto c ON p.id_categoria = c.id_categoria
JOIN Inventario i ON p.id_producto = i.id_producto
ORDER BY c.nombre_categoria, p.nombre_producto;

-- 31. Ventas con productos específicos y totales (expandido)
SELECT v.id_venta,
       DATE_FORMAT(v.fecha_venta, '%d/%m/%Y %H:%i') AS fecha,
       c.nombre_cliente,
       p.nombre_producto,
       dv.cantidad,
       dv.precio_unitario,
       dv.descuento,
       dv.subtotal,
       v.total AS total_venta,
       v.estado,
       v.forma_pago
FROM Ventas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
JOIN Detalle_Ventas dv ON v.id_venta = dv.id_venta
JOIN Productos p ON dv.id_producto = p.id_producto
ORDER BY v.fecha_venta DESC, v.id_venta;

-- 32. Compras agrupadas por proveedor con cantidad de productos
SELECT p.nombre_proveedor,
       COUNT(DISTINCT c.id_compra) AS cantidad_compras,
       SUM(dc.cantidad) AS total_productos,
       SUM(c.total) AS total_gastado,
       MAX(c.fecha_compra) AS ultima_compra
FROM Proveedores p
JOIN Compras c ON p.id_proveedor = c.id_proveedor
JOIN Detalle_Compras dc ON c.id_compra = dc.id_compra
GROUP BY p.nombre_proveedor
ORDER BY total_gastado DESC;

-- 33. Cultivos con rendimiento histórico por parcela
SELECT pa.nombre_parcela,
       pr.nombre_producto AS cultivo,
       COUNT(cu.id_cultivo) AS veces_cultivado,
       AVG(cu.cantidad_real) AS promedio_produccion,
       MAX(cu.cantidad_real) AS mejor_produccion,
       MIN(cu.cantidad_real) AS peor_produccion
FROM Cultivos cu
JOIN Parcelas pa ON cu.id_parcela = pa.id_parcela
JOIN Productos pr ON cu.id_producto = pr.id_producto
WHERE cu.estado = 'Cosechado'
GROUP BY pa.nombre_parcela, pr.nombre_producto
ORDER BY pa.nombre_parcela, veces_cultivado DESC;

-- 34. Empleados con todas sus actividades (tareas, producción, riegos)
SELECT e.id_empleado,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       d.nombre_departamento,
       (SELECT COUNT(*) FROM Tareas t WHERE t.id_empleado = e.id_empleado) AS tareas_asignadas,
       (SELECT COUNT(*) FROM Tareas t WHERE t.id_empleado = e.id_empleado AND t.estado = 'Completada') AS tareas_completadas,
       (SELECT COUNT(*) FROM Produccion_Lechera pl WHERE pl.id_empleado = e.id_empleado) AS registros_produccion,
       (SELECT COUNT(*) FROM Registro_Riegos rr WHERE rr.id_empleado = e.id_empleado) AS riegos_realizados
FROM Empleados e
JOIN Departamentos d ON e.id_departamento = d.id_departamento
ORDER BY d.nombre_departamento, e.apellido;

-- 35. Productos con proveedores frecuentes y precios de compra
SELECT p.nombre_producto,
       COUNT(DISTINCT pr.id_proveedor) AS proveedores,
       MIN(dc.costo_unitario) AS precio_minimo_compra,
       MAX(dc.costo_unitario) AS precio_maximo_compra,
       AVG(dc.costo_unitario) AS precio_promedio_compra,
       p.precio_venta,
       ROUND((p.precio_venta - AVG(dc.costo_unitario)) / AVG(dc.costo_unitario) * 100, 2) AS margen_porcentaje
FROM Productos p
JOIN Detalle_Compras dc ON p.id_producto = dc.id_producto
JOIN Compras c ON dc.id_compra = c.id_compra
JOIN Proveedores pr ON c.id_proveedor = pr.id_proveedor
GROUP BY p.nombre_producto, p.precio_venta
ORDER BY margen_porcentaje DESC;

-- 36. Maquinaria con historial de mantenimientos y costos
SELECT m.id_maquinaria,
       m.nombre_maquinaria,
       m.modelo,
       m.estado,
       COUNT(mm.id_mantenimiento) AS mantenimientos,
       SUM(mm.costo) AS total_gastado_mantenimiento,
       DATEDIFF(CURRENT_DATE, MAX(mm.fecha)) AS dias_desde_ultimo_mantenimiento
FROM Maquinaria m
LEFT JOIN Mantenimiento_Maquinaria mm ON m.id_maquinaria = mm.id_maquinaria
GROUP BY m.id_maquinaria, m.nombre_maquinaria, m.modelo, m.estado
ORDER BY dias_desde_ultimo_mantenimiento DESC;

-- 37. Clientes con historial de compras y preferencias
SELECT c.id_cliente,
       c.nombre_cliente,
       COUNT(v.id_venta) AS cantidad_compras,
       SUM(v.total) AS total_gastado,
       MAX(v.fecha_venta) AS ultima_compra,
       (SELECT GROUP_CONCAT(DISTINCT p.nombre_producto SEPARATOR ', ')
        FROM Detalle_Ventas dv
        JOIN Ventas v2 ON dv.id_venta = v2.id_venta
        JOIN Productos p ON dv.id_producto = p.id_producto
        WHERE v2.id_cliente = c.id_cliente) AS productos_comprados
FROM Clientes c
LEFT JOIN Ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre_cliente
ORDER BY total_gastado DESC;

-- 38. Parcelas con historial de cultivos y rotación
SELECT p.id_parcela,
       p.nombre_parcela,
       p.area,
       p.tipo_suelo,
       COUNT(c.id_cultivo) AS cultivos_realizados,
       GROUP_CONCAT(DISTINCT pr.nombre_producto SEPARATOR ', ') AS productos_cultivados,
       DATEDIFF(CURRENT_DATE, MAX(c.fecha_cosecha_estimada))) AS dias_desde_ultimo_cultivo
FROM Parcelas p
LEFT JOIN Cultivos c ON p.id_parcela = c.id_parcela
LEFT JOIN Productos pr ON c.id_producto = pr.id_producto
GROUP BY p.id_parcela, p.nombre_parcela, p.area, p.tipo_suelo
ORDER BY dias_desde_ultimo_cultivo DESC;

-- 39. Ventas con detalles expandidos (productos, cantidades, empleado, cliente)
SELECT v.id_venta,
       DATE_FORMAT(v.fecha_venta, '%d/%m/%Y %H:%i') AS fecha,
       c.nombre_cliente,
       c.direccion AS direccion_cliente,
       c.telefono AS telefono_cliente,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       p.nombre_producto,
       dv.cantidad,
       dv.precio_unitario,
       dv.descuento,
       dv.subtotal,
       v.total,
       v.estado,
       v.forma_pago
FROM Ventas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
JOIN Empleados e ON v.id_empleado = e.id_empleado
JOIN Detalle_Ventas dv ON v.id_venta = dv.id_venta
JOIN Productos p ON dv.id_producto = p.id_producto
ORDER BY v.fecha_venta DESC, v.id_venta;

-- 40. Compras con análisis de precios por producto
SELECT pr.nombre_producto,
       COUNT(dc.id_detalle_compra) AS veces_comprado,
       MIN(dc.costo_unitario) AS precio_minimo,
       MAX(dc.costo_unitario) AS precio_maximo,
       AVG(dc.costo_unitario) AS precio_promedio,
       (SELECT AVG(dc2.costo_unitario)
        FROM Detalle_Compras dc2
        JOIN Compras c2 ON dc2.id_compra = c2.id_compra
        WHERE dc2.id_producto = dc.id_producto
        AND c2.fecha_compra BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH) AND CURRENT_DATE) AS precio_promedio_3meses,
       p.precio_venta,
       ROUND((p.precio_venta - AVG(dc.costo_unitario)) / AVG(dc.costo_unitario) * 100, 2) AS margen_porcentaje
FROM Detalle_Compras dc
JOIN Compras c ON dc.id_compra = c.id_compra
JOIN Productos p ON dc.id_producto = p.id_producto
JOIN Proveedores pr ON c.id_proveedor = pr.id_proveedor
GROUP BY pr.nombre_producto, p.precio_venta, dc.id_producto
ORDER BY margen_porcentaje DESC;

-- 41. Producción lechera con análisis por animal
SELECT id_animal,
       COUNT(*) AS dias_produccion,
       SUM(cantidad) AS total_leche,
       AVG(cantidad) AS promedio_diario,
       MIN(cantidad) AS minimo_diario,
       MAX(cantidad) AS maximo_diario,
       (SELECT calidad
        FROM Produccion_Lechera
        WHERE id_animal = pl.id_animal
        ORDER BY cantidad DESC
        LIMIT 1) AS calidad_mejor_dia,
       DATEDIFF(CURRENT_DATE, MAX(fecha))) AS dias_desde_ultima_produccion
FROM Produccion_Lechera pl
GROUP BY id_animal
ORDER BY total_leche DESC;

-- 42. Riegos con análisis de consumo por parcela
SELECT p.nombre_parcela,
       COUNT(r.id_riego) AS cantidad_riegos,
       SUM(r.cantidad_agua) AS total_agua,
       AVG(r.cantidad_agua) AS promedio_por_riego,
       MAX(r.cantidad_agua) AS maximo_riego,
       MIN(r.cantidad_agua) AS minimo_riego,
       DATEDIFF(CURRENT_DATE, MAX(r.fecha))) AS dias_desde_ultimo_riego
FROM Registro_Riegos r
JOIN Parcelas p ON r.id_parcela = p.id_parcela
GROUP BY p.nombre_parcela
ORDER BY total_agua DESC;

-- 43. Aplicación de insumos con análisis por producto
SELECT pr.nombre_producto AS insumo,
       COUNT(a.id_aplicacion) AS veces_aplicado,
       SUM(a.cantidad) AS cantidad_total,
       AVG(a.cantidad) AS promedio_por_aplicacion,
       MIN(a.fecha) AS primera_aplicacion,
       MAX(a.fecha) AS ultima_aplicacion,
       DATEDIFF(CURRENT_DATE, MAX(a.fecha))) AS dias_desde_ultima_aplicacion
FROM Aplicacion_Insumos a
JOIN Productos pr ON a.id_producto = pr.id_producto
GROUP BY pr.nombre_producto
ORDER BY cantidad_total DESC;

-- 44. Tareas con análisis de tiempo de completación
SELECT t.descripcion,
       t.prioridad,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       COUNT(*) OVER (PARTITION BY t.descripcion) AS veces_realizada,
       AVG(DATEDIFF(t.fecha_fin, t.fecha_inicio)) OVER (PARTITION BY t.descripcion) AS dias_promedio,
       MIN(DATEDIFF(t.fecha_fin, t.fecha_inicio)) OVER (PARTITION BY t.descripcion) AS dias_minimos,
       MAX(DATEDIFF(t.fecha_fin, t.fecha_inicio)) OVER (PARTITION BY t.descripcion) AS dias_maximos
FROM Tareas t
JOIN Empleados e ON t.id_empleado = e.id_empleado
WHERE t.estado = 'Completada'
ORDER BY t.prioridad DESC, t.descripcion;

-- 45. Mantenimientos agrupados por tipo de maquinaria
SELECT m.nombre_maquinaria,
       mm.tipo AS tipo_mantenimiento,
       COUNT(mm.id_mantenimiento) AS cantidad,
       SUM(mm.costo) AS total_gastado,
       AVG(mm.costo) AS costo_promedio,
       MAX(mm.fecha) AS ultimo_mantenimiento,
       DATEDIFF(CURRENT_DATE, MAX(mm.fecha))) AS dias_desde_ultimo
FROM Mantenimiento_Maquinaria mm
JOIN Maquinaria m ON mm.id_maquinaria = m.id_maquinaria
GROUP BY m.nombre_maquinaria, mm.tipo
ORDER BY m.nombre_maquinaria, total_gastado DESC;

-- 46. Historial salarial con análisis de aumentos
SELECT CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       d.nombre_departamento,
       COUNT(hs.id_historial) AS cantidad_aumentos,
       MIN(hs.salario_anterior) AS salario_inicial,
       MAX(hs.salario_nuevo) AS salario_actual,
       SUM(hs.salario_nuevo - hs.salario_anterior) AS total_aumentado,
       ROUND((MAX(hs.salario_nuevo) - MIN(hs.salario_anterior)) / MIN(hs.salario_anterior) * 100, 2) AS porcentaje_total_aumento,
       MAX(hs.fecha_cambio) AS ultimo_aumento
FROM Historial_Salarios hs
JOIN Empleados e ON hs.id_empleado = e.id_empleado
JOIN Departamentos d ON e.id_departamento = d.id_departamento
GROUP BY hs.id_empleado, e.nombre, e.apellido, d.nombre_departamento
ORDER BY porcentaje_total_aumento DESC;

-- 47. Ventas por categoría de producto con tendencia mensual
SELECT 
    cp.nombre_categoria,
    DATE_FORMAT(v.fecha_venta, '%Y-%m') AS mes,
    COUNT(DISTINCT v.id_venta) AS cantidad_ventas,
    SUM(dv.subtotal) AS total_ventas,
    LAG(SUM(dv.subtotal), 1) OVER (PARTITION BY cp.nombre_categoria ORDER BY DATE_FORMAT(v.fecha_venta, '%Y-%m')) AS mes_anterior,
    ROUND((SUM(dv.subtotal) - LAG(SUM(dv.subtotal), 1) OVER (PARTITION BY cp.nombre_categoria ORDER BY DATE_FORMAT(v.fecha_venta, '%Y-%m'))) / 
          LAG(SUM(dv.subtotal), 1) OVER (PARTITION BY cp.nombre_categoria ORDER BY DATE_FORMAT(v.fecha_venta, '%Y-%m')) * 100, 2) AS variacion_porcentual
FROM Ventas v
JOIN Detalle_Ventas dv ON v.id_venta = dv.id_venta
JOIN Productos p ON dv.id_producto = p.id_producto
JOIN Categorias_Producto cp ON p.id_categoria = cp.id_categoria
WHERE v.estado = 'Pagada'
GROUP BY cp.nombre_categoria, DATE_FORMAT(v.fecha_venta, '%Y-%m')
ORDER BY cp.nombre_categoria, mes;

-- 48. Compras por proveedor con análisis de frecuencia
SELECT 
    p.nombre_proveedor,
    p.tipo,
    COUNT(c.id_compra) AS cantidad_compras,
    SUM(c.total) AS total_comprado,
    AVG(c.total) AS promedio_compra,
    MIN(c.fecha_compra) AS primera_compra,
    MAX(c.fecha_compra) AS ultima_compra,
    DATEDIFF(MAX(c.fecha_compra), MIN(c.fecha_compra)) / COUNT(c.id_compra) AS dias_promedio_entre_compras,
    (SELECT pr.nombre_producto
     FROM Detalle_Compras dc
     JOIN Compras c2 ON dc.id_compra = c2.id_compra
     JOIN Productos pr ON dc.id_producto = pr.id_producto
     WHERE c2.id_proveedor = p.id_proveedor
     GROUP BY pr.nombre_producto
     ORDER BY SUM(dc.cantidad) DESC
     LIMIT 1) AS producto_mas_comprado
FROM Proveedores p
JOIN Compras c ON p.id_proveedor = c.id_proveedor
GROUP BY p.nombre_proveedor, p.tipo, p.id_proveedor
ORDER BY total_comprado DESC;

-- 49. Cultivos con análisis de rendimiento por parcela y producto
SELECT 
    pa.nombre_parcela,
    pr.nombre_producto,
    COUNT(cu.id_cultivo) AS veces_cultivado,
    AVG(cu.cantidad_real / cu.cantidad_estimada) * 100 AS rendimiento_promedio,
    MIN(cu.cantidad_real / cu.cantidad_estimada) * 100 AS peor_rendimiento,
    MAX(cu.cantidad_real / cu.cantidad_estimada) * 100 AS mejor_rendimiento,
    AVG(DATEDIFF(cu.fecha_cosecha_real, cu.fecha_siembra)) AS dias_promedio_cultivo,
    (SELECT a.metodo_aplicacion
     FROM Aplicacion_Insumos a
     WHERE a.id_parcela = pa.id_parcela
     GROUP BY a.metodo_aplicacion
     ORDER BY COUNT(*) DESC
     LIMIT 1) AS metodo_riego_mas_usado
FROM Cultivos cu
JOIN Parcelas pa ON cu.id_parcela = pa.id_parcela
JOIN Productos pr ON cu.id_producto = pr.id_producto
WHERE cu.estado = 'Cosechado'
GROUP BY pa.nombre_parcela, pr.nombre_producto, pa.id_parcela, pr.id_producto
ORDER BY pa.nombre_parcela, rendimiento_promedio DESC;

-- 50. Empleados con análisis completo de productividad
SELECT 
    e.id_empleado,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    d.nombre_departamento,
    r.nombre_rol,
    e.salario,
    (SELECT COUNT(*) 
     FROM Tareas t 
     WHERE t.id_empleado = e.id_empleado 
     AND t.estado = 'Completada') AS tareas_completadas,
    (SELECT COUNT(*) 
     FROM Tareas t 
     WHERE t.id_empleado = e.id_empleado) AS tareas_asignadas,
    (SELECT SUM(pl.cantidad) 
     FROM Produccion_Lechera pl 
     WHERE pl.id_empleado = e.id_empleado) AS litros_leche_producidos,
    (SELECT COUNT(*) 
     FROM Registro_Riegos rr 
     WHERE rr.id_empleado = e.id_empleado) AS riegos_realizados,
    (SELECT COUNT(*) 
     FROM Aplicacion_Insumos ai 
     WHERE ai.id_empleado = e.id_empleado) AS aplicaciones_realizadas,
    (SELECT COUNT(*) 
     FROM Ventas v 
     WHERE v.id_empleado = e.id_empleado 
     AND v.estado = 'Pagada') AS ventas_realizadas,
    (SELECT SUM(v.total) 
     FROM Ventas v 
     WHERE v.id_empleado = e.id_empleado 
     AND v.estado = 'Pagada') AS total_ventas_generadas
FROM Empleados e
JOIN Departamentos d ON e.id_departamento = d.id_departamento
JOIN Roles r ON e.id_rol = r.id_rol
ORDER BY d.nombre_departamento, e.apellido;



-- 51. Total de ventas por mes con comparación anual
SELECT 
    YEAR(fecha_venta) AS año,
    MONTH(fecha_venta) AS mes,
    COUNT(*) AS cantidad_ventas,
    SUM(total) AS total_ventas,
    LAG(SUM(total), 12) OVER (ORDER BY YEAR(fecha_venta), MONTH(fecha_venta)) AS total_mismo_mes_año_anterior,
    ROUND((SUM(total) - LAG(SUM(total), 12) OVER (ORDER BY YEAR(fecha_venta), MONTH(fecha_venta))) / 
          LAG(SUM(total), 12) OVER (ORDER BY YEAR(fecha_venta), MONTH(fecha_venta)) * 100, 2) AS crecimiento_porcentual
FROM Ventas
WHERE estado = 'Pagada'
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY año DESC, mes DESC;

-- 52. Productos más vendidos con margen de ganancia
SELECT 
    p.nombre_producto,
    p.precio_venta,
    AVG(dc.costo_unitario) AS costo_promedio,
    SUM(dv.cantidad) AS cantidad_vendida,
    SUM(dv.subtotal) AS ingresos_totales,
    SUM(dv.subtotal) - SUM(dv.cantidad * dc.costo_unitario) AS ganancia_total,
    ROUND(((SUM(dv.subtotal) - SUM(dv.cantidad * dc.costo_unitario)) / SUM(dv.subtotal)) * 100, 2) AS margen_porcentual
FROM Detalle_Ventas dv
JOIN Productos p ON dv.id_producto = p.id_producto
JOIN Ventas v ON dv.id_venta = v.id_venta
LEFT JOIN (
    SELECT id_producto, AVG(costo_unitario) AS costo_unitario
    FROM Detalle_Compras
    GROUP BY id_producto
) dc ON p.id_producto = dc.id_producto
WHERE v.estado = 'Pagada'
GROUP BY p.nombre_producto, p.precio_venta
ORDER BY ganancia_total DESC;

-- 53. Ventas por empleado con comisión estimada
SELECT 
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    d.nombre_departamento,
    COUNT(v.id_venta) AS cantidad_ventas,
    SUM(v.total) AS total_ventas,
    ROUND(SUM(v.total) * 0.05, 2) AS comision_5porciento,
    AVG(v.total) AS promedio_por_venta
FROM Ventas v
JOIN Empleados e ON v.id_empleado = e.id_empleado
JOIN Departamentos d ON e.id_departamento = d.id_departamento
WHERE v.estado = 'Pagada'
GROUP BY empleado, d.nombre_departamento
ORDER BY total_ventas DESC;

-- 54. Compras por proveedor con análisis de frecuencia y monto
SELECT 
    p.nombre_proveedor,
    p.tipo,
    COUNT(c.id_compra) AS cantidad_compras,
    SUM(c.total) AS total_comprado,
    AVG(c.total) AS promedio_por_compra,
    MIN(c.fecha_compra) AS primera_compra,
    MAX(c.fecha_compra) AS ultima_compra,
    DATEDIFF(MAX(c.fecha_compra), MIN(c.fecha_compra)) / COUNT(c.id_compra) AS dias_promedio_entre_compras
FROM Proveedores p
JOIN Compras c ON p.id_proveedor = c.id_proveedor
GROUP BY p.nombre_proveedor, p.tipo
ORDER BY total_comprado DESC;

-- 55. Producción lechera por animal con análisis de calidad
SELECT 
    id_animal,
    COUNT(*) AS dias_produccion,
    SUM(cantidad) AS total_leche,
    AVG(cantidad) AS promedio_diario,
    MIN(cantidad) AS minimo_diario,
    MAX(cantidad) AS maximo_diario,
    SUM(CASE WHEN calidad = 'Excelente' THEN 1 ELSE 0 END) AS dias_excelente,
    SUM(CASE WHEN calidad = 'Buena' THEN 1 ELSE 0 END) AS dias_buena,
    SUM(CASE WHEN calidad = 'Regular' THEN 1 ELSE 0 END) AS dias_regular,
    SUM(CASE WHEN calidad = 'Mala' THEN 1 ELSE 0 END) AS dias_mala,
    ROUND((SUM(CASE WHEN calidad IN ('Excelente', 'Buena') THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS porcentaje_buena_calidad
FROM Produccion_Lechera
GROUP BY id_animal
ORDER BY total_leche DESC;

-- 56. Riegos por parcela con consumo de agua
SELECT 
    p.nombre_parcela,
    p.area,
    COUNT(r.id_riego) AS cantidad_riegos,
    SUM(r.cantidad_agua) AS total_agua,
    AVG(r.cantidad_agua) AS promedio_por_riego,
    SUM(r.cantidad_agua) / p.area AS agua_por_hectarea,
    r.metodo AS metodo_mas_usado
FROM Registro_Riegos r
JOIN Parcelas p ON r.id_parcela = p.id_parcela
GROUP BY p.nombre_parcela, p.area, r.metodo
ORDER BY total_agua DESC;

-- 57. Tareas completadas por empleado con tiempo promedio
SELECT 
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    d.nombre_departamento,
    COUNT(t.id_tarea) AS tareas_completadas,
    AVG(DATEDIFF(t.fecha_fin, t.fecha_inicio)) AS dias_promedio,
    MIN(DATEDIFF(t.fecha_fin, t.fecha_inicio)) AS dias_minimos,
    MAX(DATEDIFF(t.fecha_fin, t.fecha_inicio)) AS dias_maximos,
    SUM(CASE WHEN t.prioridad = 'Alta' THEN 1 ELSE 0 END) AS tareas_alta_prioridad,
    SUM(CASE WHEN t.prioridad = 'Media' THEN 1 ELSE 0 END) AS tareas_media_prioridad,
    SUM(CASE WHEN t.prioridad = 'Baja' THEN 1 ELSE 0 END) AS tareas_baja_prioridad
FROM Tareas t
JOIN Empleados e ON t.id_empleado = e.id_empleado
JOIN Departamentos d ON e.id_departamento = d.id_departamento
WHERE t.estado = 'Completada'
GROUP BY empleado, d.nombre_departamento
ORDER BY tareas_completadas DESC;

-- 58. Mantenimientos por tipo de maquinaria con costos
SELECT 
    m.nombre_maquinaria,
    mm.tipo AS tipo_mantenimiento,
    COUNT(mm.id_mantenimiento) AS cantidad,
    SUM(mm.costo) AS total_gastado,
    AVG(mm.costo) AS costo_promedio,
    MAX(mm.fecha) AS ultimo_mantenimiento,
    DATEDIFF(CURRENT_DATE, MAX(mm.fecha))) AS dias_desde_ultimo
FROM Mantenimiento_Maquinaria mm
JOIN Maquinaria m ON mm.id_maquinaria = m.id_maquinaria
GROUP BY m.nombre_maquinaria, mm.tipo
ORDER BY m.nombre_maquinaria, total_gastado DESC;

-- 59. Cultivos por tipo de producto con rendimiento
SELECT 
    p.nombre_producto,
    COUNT(c.id_cultivo) AS cantidad_cultivos,
    SUM(c.cantidad_estimada) AS total_estimado,
    SUM(c.cantidad_real) AS total_real,
    AVG(c.cantidad_real / c.cantidad_estimada) * 100 AS rendimiento_promedio,
    AVG(DATEDIFF(c.fecha_cosecha_real, c.fecha_siembra))) AS dias_promedio_cultivo
FROM Cultivos c
JOIN Productos p ON c.id_producto = p.id_producto
WHERE c.estado = 'Cosechado'
GROUP BY p.nombre_producto
ORDER BY rendimiento_promedio DESC;

-- 60. Salarios por departamento con análisis de distribución
SELECT 
    d.nombre_departamento,
    COUNT(e.id_empleado) AS cantidad_empleados,
    MIN(e.salario) AS salario_minimo,
    MAX(e.salario) AS salario_maximo,
    AVG(e.salario) AS salario_promedio,
    MEDIAN(e.salario) AS salario_mediano,
    STDDEV(e.salario) AS desviacion_estandar,
    SUM(e.salario) AS total_nomina
FROM Empleados e
JOIN Departamentos d ON e.id_departamento = d.id_departamento
GROUP BY d.nombre_departamento
ORDER BY total_nomina DESC;

-- 61. Ventas por cliente con frecuencia y monto
SELECT 
    c.nombre_cliente,
    c.tipo,
    COUNT(v.id_venta) AS cantidad_compras,
    SUM(v.total) AS total_gastado,
    AVG(v.total) AS promedio_por_compra,
    MIN(v.fecha_venta) AS primera_compra,
    MAX(v.fecha_venta) AS ultima_compra,
    DATEDIFF(MAX(v.fecha_venta), MIN(v.fecha_venta)) / COUNT(v.id_venta) AS dias_promedio_entre_compras
FROM Clientes c
JOIN Ventas v ON c.id_cliente = v.id_cliente
WHERE v.estado = 'Pagada'
GROUP BY c.nombre_cliente, c.tipo
ORDER BY total_gastado DESC;

-- 62. Productos por categoría con rotación de inventario
SELECT 
    cp.nombre_categoria,
    COUNT(p.id_producto) AS cantidad_productos,
    SUM(i.cantidad) AS stock_total,
    AVG(i.cantidad) AS stock_promedio,
    (SELECT COUNT(*) 
     FROM Detalle_Ventas dv 
     JOIN Ventas v ON dv.id_venta = v.id_venta
     JOIN Productos p2 ON dv.id_producto = p2.id_producto
     WHERE p2.id_categoria = cp.id_categoria
     AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) AND CURRENT_DATE) AS ventas_ultimos_30dias,
    SUM(i.cantidad) / (SELECT COUNT(*) 
                       FROM Detalle_Ventas dv 
                       JOIN Ventas v ON dv.id_venta = v.id_venta
                       JOIN Productos p2 ON dv.id_producto = p2.id_producto
                       WHERE p2.id_categoria = cp.id_categoria
                       AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) AND CURRENT_DATE) AS dias_inventario
FROM Categorias_Producto cp
JOIN Productos p ON cp.id_categoria = p.id_categoria
JOIN Inventario i ON p.id_producto = i.id_producto
GROUP BY cp.nombre_categoria, cp.id_categoria
ORDER BY ventas_ultimos_30dias DESC;

-- 63. Compras por mes con comparación interanual
SELECT 
    MONTH(fecha_compra) AS mes,
    YEAR(fecha_compra) AS año,
    COUNT(id_compra) AS cantidad_compras,
    SUM(total) AS total_comprado,
    LAG(SUM(total), 1) OVER (PARTITION BY MONTH(fecha_compra) ORDER BY YEAR(fecha_compra)) AS total_mes_anterior,
    ROUND((SUM(total) - LAG(SUM(total), 1) OVER (PARTITION BY MONTH(fecha_compra) ORDER BY YEAR(fecha_compra))) / 
          LAG(SUM(total), 1) OVER (PARTITION BY MONTH(fecha_compra) ORDER BY YEAR(fecha_compra)) * 100, 2) AS crecimiento_porcentual
FROM Compras
WHERE estado = 'Pagada'
GROUP BY YEAR(fecha_compra), MONTH(fecha_compra)
ORDER BY año DESC, mes DESC;

-- 64. Producción lechera mensual con tendencia
SELECT 
    YEAR(fecha) AS año,
    MONTH(fecha) AS mes,
    COUNT(DISTINCT id_animal) AS vacas_en_produccion,
    SUM(cantidad) AS total_leche,
    AVG(cantidad) AS promedio_diario,
    LAG(SUM(cantidad), 1) OVER (ORDER BY YEAR(fecha), MONTH(fecha)) AS total_mes_anterior,
    ROUND((SUM(cantidad) - LAG(SUM(cantidad), 1) OVER (ORDER BY YEAR(fecha), MONTH(fecha))) / 
          LAG(SUM(cantidad), 1) OVER (ORDER BY YEAR(fecha), MONTH(fecha)) * 100, 2) AS crecimiento_porcentual,
    SUM(CASE WHEN calidad = 'Excelente' THEN cantidad ELSE 0 END) / SUM(cantidad) * 100 AS porcentaje_excelente,
    SUM(CASE WHEN calidad = 'Buena' THEN cantidad ELSE 0 END) / SUM(cantidad) * 100 AS porcentaje_buena
FROM Produccion_Lechera
GROUP BY YEAR(fecha), MONTH(fecha)
ORDER BY año DESC, mes DESC;

-- 65. Tareas por tipo con tiempo de completación
SELECT 
    CASE 
        WHEN descripcion LIKE '%siembra%' THEN 'Siembra'
        WHEN descripcion LIKE '%riego%' THEN 'Riego'
        WHEN descripcion LIKE '%cosecha%' THEN 'Cosecha'
        WHEN descripcion LIKE '%mantenimiento%' THEN 'Mantenimiento'
        ELSE 'Otros'
    END AS tipo_tarea,
    COUNT(*) AS cantidad,
    AVG(DATEDIFF(fecha_fin, fecha_inicio)) AS dias_promedio,
    MIN(DATEDIFF(fecha_fin, fecha_inicio)) AS dias_minimos,
    MAX(DATEDIFF(fecha_fin, fecha_inicio)) AS dias_maximos,
    SUM(CASE WHEN estado = 'Completada' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN estado = 'Pendiente' THEN 1 ELSE 0 END) AS pendientes,
    SUM(CASE WHEN estado = 'En progreso' THEN 1 ELSE 0 END) AS en_progreso
FROM Tareas
GROUP BY tipo_tarea
ORDER BY cantidad DESC;

-- 66. Aplicación de insumos por tipo con frecuencia
SELECT 
    CASE 
        WHEN p.nombre_producto LIKE '%fertilizante%' THEN 'Fertilizante'
        WHEN p.nombre_producto LIKE '%pesticida%' THEN 'Pesticida'
        WHEN p.nombre_producto LIKE '%herbicida%' THEN 'Herbicida'
        ELSE 'Otros insumos'
    END AS tipo_insumo,
    COUNT(*) AS aplicaciones,
    SUM(a.cantidad) AS cantidad_total,
    AVG(a.cantidad) AS promedio_por_aplicacion,
    MIN(a.fecha) AS primera_aplicacion,
    MAX(a.fecha) AS ultima_aplicacion,
    DATEDIFF(CURRENT_DATE, MAX(a.fecha))) AS dias_desde_ultima_aplicacion
FROM Aplicacion_Insumos a
JOIN Productos p ON a.id_producto = p.id_producto
GROUP BY tipo_insumo
ORDER BY cantidad_total DESC;

-- 67. Mantenimientos por año con costos acumulados
SELECT 
    YEAR(fecha) AS año,
    COUNT(*) AS cantidad_mantenimientos,
    SUM(costo) AS total_gastado,
    SUM(SUM(costo)) OVER (ORDER BY YEAR(fecha)) AS gasto_acumulado,
    AVG(costo) AS costo_promedio,
    SUM(CASE WHEN tipo = 'Preventivo' THEN costo ELSE 0 END) AS gasto_preventivo,
    SUM(CASE WHEN tipo = 'Correctivo' THEN costo ELSE 0 END) AS gasto_correctivo,
    SUM(CASE WHEN tipo = 'Rutina' THEN costo ELSE 0 END) AS gasto_rutina
FROM Mantenimiento_Maquinaria
GROUP BY YEAR(fecha)
ORDER BY año;

-- 68. Cultivos por temporada con rendimiento
SELECT 
    CASE 
        WHEN MONTH(fecha_siembra) BETWEEN 1 AND 3 THEN 'Invierno'
        WHEN MONTH(fecha_siembra) BETWEEN 4 AND 6 THEN 'Primavera'
        WHEN MONTH(fecha_siembra) BETWEEN 7 AND 9 THEN 'Verano'
        WHEN MONTH(fecha_siembra) BETWEEN 10 AND 12 THEN 'Otoño'
    END AS temporada,
    COUNT(*) AS cantidad_cultivos,
    AVG(cantidad_real / cantidad_estimada) * 100 AS rendimiento_promedio,
    AVG(DATEDIFF(fecha_cosecha_real, fecha_siembra)) AS dias_promedio_cultivo,
    SUM(cantidad_real) AS produccion_total
FROM Cultivos
WHERE estado = 'Cosechado'
GROUP BY temporada
ORDER BY rendimiento_promedio DESC;

-- 69. Ventas por día de la semana con análisis
SELECT 
    DAYNAME(fecha_venta) AS dia_semana,
    COUNT(*) AS cantidad_ventas,
    SUM(total) AS total_ventas,
    AVG(total) AS promedio_por_venta,
    COUNT(*) / (SELECT COUNT(DISTINCT DATE(fecha_venta)) 
                FROM Ventas 
                WHERE DAYNAME(fecha_venta) = DAYNAME(v.fecha_venta)) AS ventas_promedio_por_dia,
    SUM(CASE WHEN HOUR(fecha_venta) BETWEEN 8 AND 12 THEN total ELSE 0 END) AS ventas_manana,
    SUM(CASE WHEN HOUR(fecha_venta) BETWEEN 13 AND 17 THEN total ELSE 0 END) AS ventas_tarde
FROM Ventas v
WHERE estado = 'Pagada'
GROUP BY dia_semana, DAYOFWEEK(fecha_venta)
ORDER BY DAYOFWEEK(fecha_venta);

-- 70. Empleados con productividad comparada
SELECT 
    e.id_empleado,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    d.nombre_departamento,
    e.salario,
    (SELECT COUNT(*) 
     FROM Tareas t 
     WHERE t.id_empleado = e.id_empleado 
     AND t.estado = 'Completada') AS tareas_completadas,
    (SELECT COUNT(*) 
     FROM Tareas t 
     WHERE t.id_empleado = e.id_empleado) AS tareas_asignadas,
    (SELECT COUNT(*) 
     FROM Tareas t 
     WHERE t.id_empleado = e.id_empleado 
     AND t.estado = 'Completada') / 
     (SELECT COUNT(*) 
      FROM Tareas t 
      WHERE t.id_empleado = e.id_empleado) * 100 AS porcentaje_completadas,
    (SELECT AVG(DATEDIFF(t.fecha_fin, t.fecha_inicio))
     FROM Tareas t 
     WHERE t.id_empleado = e.id_empleado 
     AND t.estado = 'Completada') AS dias_promedio_por_tarea,
    e.salario / (SELECT COUNT(*) 
                 FROM Tareas t 
                 WHERE t.id_empleado = e.id_empleado 
                 AND t.estado = 'Completada') AS costo_por_tarea
FROM Empleados e
JOIN Departamentos d ON e.id_departamento = d.id_departamento
ORDER BY porcentaje_completadas DESC, dias_promedio_por_tarea;



-- 71. Productos que nunca se han vendido pero están en inventario
SELECT p.nombre_producto, i.cantidad AS stock_actual
FROM Productos p
JOIN Inventario i ON p.id_producto = i.id_producto
WHERE p.id_producto NOT IN (
    SELECT DISTINCT id_producto 
    FROM Detalle_Ventas
)
AND p.tipo_producto NOT IN ('Insumo', 'Equipo')
ORDER BY i.cantidad DESC;

-- 72. Empleados con salario mayor al promedio de su departamento
SELECT e.nombre, e.apellido, e.salario, d.nombre_departamento,
       (SELECT AVG(e2.salario) 
        FROM Empleados e2 
        WHERE e2.id_departamento = e.id_departamento) AS salario_promedio_departamento,
       e.salario - (SELECT AVG(e2.salario) 
                    FROM Empleados e2 
                    WHERE e2.id_departamento = e.id_departamento) AS diferencia
FROM Empleados e
JOIN Departamentos d ON e.id_departamento = d.id_departamento
WHERE e.salario > (
    SELECT AVG(e2.salario) 
    FROM Empleados e2 
    WHERE e2.id_departamento = e.id_departamento
)
ORDER BY diferencia DESC;

-- 73. Ventas que superan el promedio del cliente
SELECT v.id_venta, c.nombre_cliente, v.total,
       (SELECT AVG(v2.total) 
        FROM Ventas v2 
        WHERE v2.id_cliente = v.id_cliente) AS promedio_cliente,
       v.total - (SELECT AVG(v2.total) 
                  FROM Ventas v2 
                  WHERE v2.id_cliente = v.id_cliente) AS diferencia
FROM Ventas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
WHERE v.total > (
    SELECT AVG(v2.total) 
    FROM Ventas v2 
    WHERE v2.id_cliente = v.id_cliente
)
AND v.estado = 'Pagada'
ORDER BY diferencia DESC;

-- 74. Productos con inventario bajo (menos del 20% del promedio de ventas mensual)
SELECT p.nombre_producto, i.cantidad AS stock_actual,
       (SELECT AVG(dv.cantidad) 
        FROM Detalle_Ventas dv 
        JOIN Ventas v ON dv.id_venta = v.id_venta
        WHERE dv.id_producto = p.id_producto
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH) AND CURRENT_DATE) AS ventas_promedio_mensual,
       i.cantidad / (SELECT AVG(dv.cantidad) 
                     FROM Detalle_Ventas dv 
                     JOIN Ventas v ON dv.id_venta = v.id_venta
                     WHERE dv.id_producto = p.id_producto
                     AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH) AND CURRENT_DATE) AS meses_inventario
FROM Productos p
JOIN Inventario i ON p.id_producto = i.id_producto
WHERE i.cantidad < (
    SELECT AVG(dv.cantidad) * 0.2 
    FROM Detalle_Ventas dv 
    JOIN Ventas v ON dv.id_venta = v.id_venta
    WHERE dv.id_producto = p.id_producto
    AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH) AND CURRENT_DATE
)
ORDER BY meses_inventario;

-- 75. Clientes con compras superiores a $1000 en los últimos 6 meses
SELECT c.nombre_cliente, 
       (SELECT SUM(v.total) 
        FROM Ventas v 
        WHERE v.id_cliente = c.id_cliente
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE
        AND v.estado = 'Pagada') AS total_ultimos_6meses,
       (SELECT COUNT(*) 
        FROM Ventas v 
        WHERE v.id_cliente = c.id_cliente
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE
        AND v.estado = 'Pagada') AS cantidad_compras,
       (SELECT MAX(v.fecha_venta) 
        FROM Ventas v 
        WHERE v.id_cliente = c.id_cliente) AS ultima_compra
FROM Clientes c
WHERE (
    SELECT SUM(v.total) 
    FROM Ventas v 
    WHERE v.id_cliente = c.id_cliente
    AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE
    AND v.estado = 'Pagada'
) > 1000
ORDER BY total_ultimos_6meses DESC;

-- 76. Empleados que no han realizado ventas este mes pero sí el anterior
SELECT e.nombre, e.apellido,
       (SELECT COUNT(*) 
        FROM Ventas v 
        WHERE v.id_empleado = e.id_empleado
        AND MONTH(v.fecha_venta) = MONTH(DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH))
        AS ventas_mes_anterior,
       (SELECT SUM(v.total) 
        FROM Ventas v 
        WHERE v.id_empleado = e.id_empleado
        AND MONTH(v.fecha_venta) = MONTH(DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)))
        AS total_mes_anterior
FROM Empleados e
WHERE e.id_departamento = (
    SELECT id_departamento 
    FROM Departamentos 
    WHERE nombre_departamento = 'Ventas'
)
AND e.id_empleado NOT IN (
    SELECT DISTINCT v.id_empleado
    FROM Ventas v
    WHERE MONTH(v.fecha_venta) = MONTH(CURRENT_DATE)
    AND YEAR(v.fecha_venta) = YEAR(CURRENT_DATE))
AND e.id_empleado IN (
    SELECT DISTINCT v.id_empleado
    FROM Ventas v
    WHERE MONTH(v.fecha_venta) = MONTH(DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH))
    AND YEAR(v.fecha_venta) = YEAR(DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)))
ORDER BY total_mes_anterior DESC;

-- 77. Parcelas con rendimiento superior al promedio de la finca
SELECT p.nombre_parcela, 
       AVG(c.cantidad_real / c.cantidad_estimada) * 100 AS rendimiento_parcela,
       (SELECT AVG(c2.cantidad_real / c2.cantidad_estimada) * 100
        FROM Cultivos c2
        WHERE c2.estado = 'Cosechado') AS rendimiento_promedio_finca,
       AVG(c.cantidad_real / c.cantidad_estimada) * 100 - 
       (SELECT AVG(c2.cantidad_real / c2.cantidad_estimada) * 100
        FROM Cultivos c2
        WHERE c2.estado = 'Cosechado') AS diferencia
FROM Cultivos c
JOIN Parcelas p ON c.id_parcela = p.id_parcela
WHERE c.estado = 'Cosechado'
GROUP BY p.nombre_parcela
HAVING rendimiento_parcela > (
    SELECT AVG(c2.cantidad_real / c2.cantidad_estimada) * 100
    FROM Cultivos c2
    WHERE c2.estado = 'Cosechado'
)
ORDER BY diferencia DESC;

-- 78. Productos con ventas decrecientes (último mes vs promedio histórico)
SELECT p.nombre_producto,
       (SELECT SUM(dv.cantidad)
        FROM Detalle_Ventas dv
        JOIN Ventas v ON dv.id_venta = v.id_venta
        WHERE dv.id_producto = p.id_producto
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AND CURRENT_DATE) AS ventas_ultimo_mes,
       (SELECT AVG(ventas_mensuales)
        FROM (
            SELECT MONTH(v.fecha_venta) AS mes, SUM(dv.cantidad) AS ventas_mensuales
            FROM Detalle_Ventas dv
            JOIN Ventas v ON dv.id_venta = v.id_venta
            WHERE dv.id_producto = p.id_producto
            GROUP BY mes
        ) AS ventas_historicas) AS promedio_historico,
       (SELECT SUM(dv.cantidad)
        FROM Detalle_Ventas dv
        JOIN Ventas v ON dv.id_venta = v.id_venta
        WHERE dv.id_producto = p.id_producto
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AND CURRENT_DATE) - 
       (SELECT AVG(ventas_mensuales)
        FROM (
            SELECT MONTH(v.fecha_venta) AS mes, SUM(dv.cantidad) AS ventas_mensuales
            FROM Detalle_Ventas dv
            JOIN Ventas v ON dv.id_venta = v.id_venta
            WHERE dv.id_producto = p.id_producto
            GROUP BY mes
        ) AS ventas_historicas) AS diferencia
FROM Productos p
HAVING ventas_ultimo_mes < promedio_historico
ORDER BY diferencia;

-- 79. Empleados con mejor rendimiento en producción lechera (top 3 por cantidad)
SELECT 
    e.nombre, 
    e.apellido,
    (SELECT SUM(pl.cantidad) 
     FROM Produccion_Lechera pl 
     WHERE pl.id_empleado = e.id_empleado) AS total_leche,
    (SELECT COUNT(DISTINCT pl.id_animal) 
     FROM Produccion_Lechera pl 
     WHERE pl.id_empleado = e.id_empleado) AS animales_atendidos,
    (SELECT AVG(pl.cantidad) 
     FROM Produccion_Lechera pl 
     WHERE pl.id_empleado = e.id_empleado) AS promedio_por_animal,
    (SELECT SUM(CASE WHEN pl.calidad IN ('Excelente', 'Buena') THEN 1 ELSE 0 END) / COUNT(*) * 100
     FROM Produccion_Lechera pl 
     WHERE pl.id_empleado = e.id_empleado) AS porcentaje_calidad
FROM Empleados e
WHERE e.id_departamento = (
    SELECT id_departamento 
    FROM Departamentos 
    WHERE nombre_departamento = 'Ganadería'
)
ORDER BY total_leche DESC
LIMIT 3;

-- 80. Proveedores con compras consistentes (más de 3 compras por año)
SELECT p.nombre_proveedor,
       (SELECT COUNT(*) 
        FROM Compras c 
        WHERE c.id_proveedor = p.id_proveedor
        AND c.fecha_compra BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR) AND CURRENT_DATE) AS compras_ultimo_anio,
       (SELECT AVG(c.total) 
        FROM Compras c 
        WHERE c.id_proveedor = p.id_proveedor
        AND c.fecha_compra BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR) AND CURRENT_DATE) AS promedio_compra,
       (SELECT MIN(c.fecha_compra) 
        FROM Compras c 
        WHERE c.id_proveedor = p.id_proveedor) AS primera_compra,
       (SELECT MAX(c.fecha_compra) 
        FROM Compras c 
        WHERE c.id_proveedor = p.id_proveedor) AS ultima_compra,
       (SELECT GROUP_CONCAT(DISTINCT pr.nombre_producto SEPARATOR ', ')
        FROM Detalle_Compras dc
        JOIN Compras c ON dc.id_compra = c.id_compra
        JOIN Productos pr ON dc.id_producto = pr.id_producto
        WHERE c.id_proveedor = p.id_proveedor) AS productos_suministrados
FROM Proveedores p
WHERE (
    SELECT COUNT(*) 
    FROM Compras c 
    WHERE c.id_proveedor = p.id_proveedor
    AND c.fecha_compra BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR) AND CURRENT_DATE
) >= 3
ORDER BY compras_ultimo_anio DESC;

-- 81. Productos con mayor margen de ganancia pero baja rotación
SELECT p.nombre_producto,
       p.precio_venta,
       (SELECT AVG(dc.costo_unitario) 
        FROM Detalle_Compras dc 
        WHERE dc.id_producto = p.id_producto) AS costo_promedio,
       p.precio_venta - (SELECT AVG(dc.costo_unitario) 
                         FROM Detalle_Compras dc 
                         WHERE dc.id_producto = p.id_producto) AS margen_unitario,
       ((p.precio_venta - (SELECT AVG(dc.costo_unitario) 
                           FROM Detalle_Compras dc 
                           WHERE dc.id_producto = p.id_producto)) / 
        (SELECT AVG(dc.costo_unitario) 
         FROM Detalle_Compras dc 
         WHERE dc.id_producto = p.id_producto)) * 100 AS margen_porcentual,
       (SELECT SUM(dv.cantidad) 
        FROM Detalle_Ventas dv 
        JOIN Ventas v ON dv.id_venta = v.id_venta
        WHERE dv.id_producto = p.id_producto
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH) AND CURRENT_DATE) AS ventas_ultimos_3meses,
       i.cantidad AS stock_actual,
       i.cantidad / (SELECT COALESCE(SUM(dv.cantidad), 1) 
                     FROM Detalle_Ventas dv 
                     JOIN Ventas v ON dv.id_venta = v.id_venta
                     WHERE dv.id_producto = p.id_producto
                     AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH) AND CURRENT_DATE) AS meses_inventario
FROM Productos p
JOIN Inventario i ON p.id_producto = i.id_producto
WHERE (
    SELECT SUM(dv.cantidad) 
    FROM Detalle_Ventas dv 
    JOIN Ventas v ON dv.id_venta = v.id_venta
    WHERE dv.id_producto = p.id_producto
    AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH) AND CURRENT_DATE
) < 10
AND ((p.precio_venta - (SELECT AVG(dc.costo_unitario) 
                         FROM Detalle_Compras dc 
                         WHERE dc.id_producto = p.id_producto)) / 
     (SELECT AVG(dc.costo_unitario) 
      FROM Detalle_Compras dc 
      WHERE dc.id_producto = p.id_producto)) * 100 > 50
ORDER BY margen_porcentual DESC;

-- 82. Empleados con mayor productividad en tareas de campo
SELECT e.nombre, e.apellido,
       (SELECT COUNT(*) 
        FROM Tareas t 
        WHERE t.id_empleado = e.id_empleado
        AND t.estado = 'Completada') AS tareas_completadas,
       (SELECT AVG(DATEDIFF(t.fecha_fin, t.fecha_inicio)) 
        FROM Tareas t 
        WHERE t.id_empleado = e.id_empleado
        AND t.estado = 'Completada') AS dias_promedio_por_tarea,
       (SELECT SUM(CASE WHEN t.prioridad = 'Alta' THEN 1 ELSE 0 END) 
        FROM Tareas t 
        WHERE t.id_empleado = e.id_empleado
        AND t.estado = 'Completada') AS tareas_alta_prioridad,
       (SELECT COUNT(*) 
        FROM Produccion_Lechera pl 
        WHERE pl.id_empleado = e.id_empleado) AS registros_produccion,
       (SELECT COUNT(*) 
        FROM Registro_Riegos rr 
        WHERE rr.id_empleado = e.id_empleado) AS riegos_realizados
FROM Empleados e
WHERE e.id_departamento IN (
    SELECT id_departamento 
    FROM Departamentos 
    WHERE nombre_departamento IN ('Producción', 'Ganadería')
)
ORDER BY tareas_completadas DESC, dias_promedio_por_tarea
LIMIT 5;

-- 83. Clientes frecuentes pero con ticket promedio bajo
SELECT c.nombre_cliente,
       (SELECT COUNT(*) 
        FROM Ventas v 
        WHERE v.id_cliente = c.id_cliente
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE) AS compras_ultimos_6meses,
       (SELECT AVG(v.total) 
        FROM Ventas v 
        WHERE v.id_cliente = c.id_cliente
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE) AS ticket_promedio,
       (SELECT MAX(v.total) 
        FROM Ventas v 
        WHERE v.id_cliente = c.id_cliente
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE) AS ticket_maximo,
       (SELECT MIN(v.total) 
        FROM Ventas v 
        WHERE v.id_cliente = c.id_cliente
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE) AS ticket_minimo,
       (SELECT GROUP_CONCAT(DISTINCT p.nombre_producto SEPARATOR ', ')
        FROM Detalle_Ventas dv
        JOIN Ventas v ON dv.id_venta = v.id_venta
        JOIN Productos p ON dv.id_producto = p.id_producto
        WHERE v.id_cliente = c.id_cliente
        AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE) AS productos_comprados
FROM Clientes c
WHERE (
    SELECT COUNT(*) 
    FROM Ventas v 
    WHERE v.id_cliente = c.id_cliente
    AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE
) >= 3
AND (
    SELECT AVG(v.total) 
    FROM Ventas v 
    WHERE v.id_cliente = c.id_cliente
    AND v.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE
) < (
    SELECT AVG(v2.total) 
    FROM Ventas v2 
    WHERE v2.fecha_venta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) AND CURRENT_DATE
)
ORDER BY compras_ultimos_6meses DESC, ticket_promedio;

-- 84. Parcelas con mayor potencial de mejora en rendimiento
SELECT p.nombre_parcela,
       (SELECT AVG(c2.cantidad_real / c2.cantidad_estimada) * 100
        FROM Cultivos c2
        JOIN Parcelas p2 ON c2.id_parcela = p2.id_parcela
        WHERE p2.nombre_parcela = p.nombre_parcela
        AND c2.estado = 'Cosechado') AS rendimiento_actual,
       (SELECT MAX(c2.cantidad_real / c2.cantidad_estimada) * 100
        FROM Cultivos c2
        JOIN Parcelas p2 ON c2.id_parcela = p2.id_parcela
        WHERE p2.nombre_parcela = p.nombre_parcela
        AND c2.estado = 'Cosechado') AS mejor_rendimiento,
       (SELECT MAX(c2.cantidad_real / c2.cantidad_estimada) * 100 - 
               AVG(c2.cantidad_real / c2.cantidad_estimada) * 100
        FROM Cultivos c2
        JOIN Parcelas p2 ON c2.id_parcela = p2.id_parcela
        WHERE p2.nombre_parcela = p.nombre_parcela
        AND c2.estado = 'Cosechado') AS potencial_mejora,
       (SELECT pr.nombre_producto
        FROM Cultivos c2
        JOIN Productos pr ON c2.id_producto = pr.id_producto
        WHERE c2.id_parcela = p.id_parcela
        AND c2.cantidad_real / c2.cantidad_estimada = (
            SELECT MAX(c3.cantidad_real / c3.cantidad_estimada)
            FROM Cultivos c3
            WHERE c3.id_parcela = p.id_parcela
        )
        LIMIT 1) AS mejor_producto
FROM Parcelas p
WHERE (
    SELECT COUNT(*) 
    FROM Cultivos c2 
    WHERE c2.id_parcela = p.id_parcela
    AND c2.estado = 'Cosechado'
) > 0
ORDER BY potencial_mejora DESC;

-- 85. Maquinaria con mayor costo de mantenimiento por año
SELECT m.nombre_maquinaria,
       m.modelo,
       (SELECT SUM(mm.costo)
        FROM Mantenimiento_Maquinaria mm
        WHERE mm.id_maquinaria = m.id_maquinaria
        AND YEAR(mm.fecha) = YEAR(CURRENT_DATE)) AS costo_mantenimiento_anual,
       (SELECT COUNT(*) 
        FROM Mantenimiento_Maquinaria mm
        WHERE mm.id_maquinaria = m.id_maquinaria
        AND YEAR(mm.fecha) = YEAR(CURRENT_DATE)) AS cantidad_mantenimientos,
       (SELECT AVG(mm.costo) 
        FROM Mantenimiento_Maquinaria mm
        WHERE mm.id_maquinaria = m.id_maquinaria
        AND YEAR(mm.fecha) = YEAR(CURRENT_DATE)) AS costo_promedio,
       m.costo AS costo_adquisicion,
       (SELECT SUM(mm.costo) 
        FROM Mantenimiento_Maquinaria mm
        WHERE mm.id_maquinaria = m.id_maquinaria) / m.costo * 100 AS porcentaje_costo_sobre_adquisicion
FROM Maquinaria m
WHERE (
    SELECT SUM(mm.costo)
    FROM Mantenimiento_Maquinaria mm
    WHERE mm.id_maquinaria = m.id_maquinaria
    AND YEAR(mm.fecha) = YEAR(CURRENT_DATE)
) > 0
ORDER BY costo_mantenimiento_anual DESC;

-- 86. Productos con estacionalidad marcada en ventas
SELECT p.nombre_producto,
       (SELECT SUM(dv.cantidad)
        FROM Detalle_Ventas dv
        JOIN Ventas v ON dv.id_venta = v.id_venta
        WHERE dv.id_producto = p.id_producto
        AND MONTH(v.fecha_venta) = MONTH(CURRENT_DATE)) AS ventas_mes_actual,
       (SELECT AVG(ventas_mensuales)
        FROM (
            SELECT MONTH(v.fecha_venta) AS mes, SUM(dv.cantidad) AS ventas_mensuales
            FROM Detalle_Ventas dv
            JOIN Ventas v ON dv.id_venta = v.id_venta
            WHERE dv.id_producto = p.id_producto
            GROUP BY mes
        ) AS vm) AS promedio_mensual,
       (SELECT MAX(ventas_mensuales) - MIN(ventas_mensuales)
        FROM (
            SELECT MONTH(v.fecha_venta) AS mes, SUM(dv.cantidad) AS ventas_mensuales
            FROM Detalle_Ventas dv
            JOIN Ventas v ON dv.id_venta = v.id_venta
            WHERE dv.id_producto = p.id_producto
            GROUP BY mes
        ) AS vm) AS diferencia_max_min,
       (SELECT mes
        FROM (
            SELECT MONTH(v.fecha_venta) AS mes, SUM(dv.cantidad) AS ventas_mensuales
            FROM Detalle_Ventas dv
            JOIN Ventas v ON dv.id_venta = v.id_venta
            WHERE dv.id_producto = p.id_producto
            GROUP BY mes
            ORDER BY ventas_mensuales DESC
            LIMIT 1
        ) AS vm) AS mes_pico,
       (SELECT mes
        FROM (
            SELECT MONTH(v.fecha_venta) AS mes, SUM(dv.cantidad) AS ventas_mensuales
            FROM Detalle_Ventas dv
            JOIN Ventas v ON dv.id_venta = v.id_venta
            WHERE dv.id_producto = p.id_producto
            GROUP BY mes
            ORDER BY ventas_mensuales ASC
            LIMIT 1
        ) AS vm) AS mes_valle
FROM Productos p
HAVING diferencia_max_min > promedio_mensual * 0.5
ORDER BY diferencia_max_min DESC;

-- 87. Empleados con mayor versatilidad (más tipos de tareas realizadas)
SELECT e.nombre, e.apellido,
       (SELECT COUNT(DISTINCT 
          CASE 
            WHEN t.descripcion LIKE '%siembra%' THEN 'Siembra'
            WHEN t.descripcion LIKE '%riego%' THEN 'Riego'
            WHEN t.descripcion LIKE '%cosecha%' THEN 'Cosecha'
            WHEN t.descripcion LIKE '%mantenimiento%' THEN 'Mantenimiento'
            ELSE 'Otros'
          END)
        FROM Tareas t
        WHERE t.id_empleado = e.id_empleado
        AND t.estado = 'Completada') AS tipos_tareas_diferentes,
       (SELECT COUNT(*)
        FROM Tareas t
        WHERE t.id_empleado = e.id_empleado
        AND t.estado = 'Completada') AS tareas_completadas,
       (SELECT GROUP_CONCAT(DISTINCT 
          CASE 
            WHEN t.descripcion LIKE '%siembra%' THEN 'Siembra'
            WHEN t.descripcion LIKE '%riego%' THEN 'Riego'
            WHEN t.descripcion LIKE '%cosecha%' THEN 'Cosecha'
            WHEN t.descripcion LIKE '%mantenimiento%' THEN 'Mantenimiento'
            ELSE 'Otros'
          END SEPARATOR ', ')
        FROM Tareas t
        WHERE t.id_empleado = e.id_empleado
        AND t.estado = 'Completada') AS lista_tipos_tareas
FROM Empleados e
ORDER BY tipos_tareas_diferentes DESC, tareas_completadas DESC
LIMIT 5;

-- 88. Proveedores con mejor relación calidad-precio (según rendimiento de insumos)
SELECT p.nombre_proveedor,
       (SELECT COUNT(*)
        FROM Compras c
        WHERE c.id_proveedor = p.id_proveedor) AS compras_totales,
       (SELECT AVG(dc.costo_unitario)
        FROM Detalle_Compras dc
        JOIN Compras c ON dc.id_compra = c.id_compra
        WHERE c.id_proveedor = p.id_proveedor) AS costo_promedio_insumos,
       (SELECT AVG(cu.cantidad_real / cu.cantidad_estimada) * 100
        FROM Cultivos cu
        JOIN Aplicacion_Insumos ai ON cu.id_parcela = ai.id_parcela
        JOIN Detalle_Compras dc ON ai.id_producto = dc.id_producto
        JOIN Compras c ON dc.id_compra = c.id_compra
        WHERE c.id_proveedor = p.id_proveedor
        AND cu.estado = 'Cosechado') AS rendimiento_promedio,
       (SELECT AVG(cu.cantidad_real / cu.cantidad_estimada) * 100 /
               (SELECT AVG(dc2.costo_unitario)
                FROM Detalle_Compras dc2
                JOIN Compras c2 ON dc2.id_compra = c2.id_compra
                WHERE c2.id_proveedor = p.id_proveedor)
        FROM Cultivos cu
        JOIN Aplicacion_Insumos ai ON cu.id_parcela = ai.id_parcela
        JOIN Detalle_Compras dc ON ai.id_producto = dc.id_producto
        JOIN Compras c ON dc.id_compra = c.id_compra
        WHERE c.id_proveedor = p.id_proveedor
        AND cu.estado = 'Cosechado') AS rendimiento_por_costo
FROM Proveedores p
WHERE p.tipo = 'Insumos'
AND (
    SELECT COUNT(*)
    FROM Compras c
    WHERE c.id_proveedor = p.id_proveedor
) > 0
ORDER BY rendimiento_por_costo DESC;

-- 89. Tareas que toman más tiempo que el promedio para su tipo
SELECT t.id_tarea,
       t.descripcion,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       DATEDIFF(t.fecha_fin, t.fecha_inicio) AS dias_tomados,
       (SELECT AVG(DATEDIFF(t2.fecha_fin, t2.fecha_inicio))
        FROM Tareas t2
        WHERE 
          CASE 
            WHEN t.descripcion LIKE '%siembra%' THEN t2.descripcion LIKE '%siembra%'
            WHEN t.descripcion LIKE '%riego%' THEN t2.descripcion LIKE '%riego%'
            WHEN t.descripcion LIKE '%cosecha%' THEN t2.descripcion LIKE '%cosecha%'
            WHEN t.descripcion LIKE '%mantenimiento%' THEN t2.descripcion LIKE '%mantenimiento%'
            ELSE t2.descripcion = t.descripcion
          END
        AND t2.estado = 'Completada') AS dias_promedio_tipo,
       DATEDIFF(t.fecha_fin, t.fecha_inicio) - 
       (SELECT AVG(DATEDIFF(t2.fecha_fin, t2.fecha_inicio))
        FROM Tareas t2
        WHERE 
          CASE 
            WHEN t.descripcion LIKE '%siembra%' THEN t2.descripcion LIKE '%siembra%'
            WHEN t.descripcion LIKE '%riego%' THEN t2.descripcion LIKE '%riego%'
            WHEN t.descripcion LIKE '%cosecha%' THEN t2.descripcion LIKE '%cosecha%'
            WHEN t.descripcion LIKE '%mantenimiento%' THEN t2.descripcion LIKE '%mantenimiento%'
            ELSE t2.descripcion = t.descripcion
          END
        AND t2.estado = 'Completada') AS diferencia_dias
FROM Tareas t
JOIN Empleados e ON t.id_empleado = e.id_empleado
WHERE t.estado = 'Completada'
HAVING diferencia_dias > 0
ORDER BY diferencia_dias DESC;

-- 90. Cultivos con mejor rendimiento en condiciones similares
SELECT c.id_cultivo,
       p.nombre_producto AS cultivo,
       pa.nombre_parcela,
       c.cantidad_real / c.cantidad_estimada * 100 AS rendimiento,
       (SELECT AVG(c2.cantidad_real / c2.cantidad_estimada) * 100
        FROM Cultivos c2
        JOIN Parcelas p2 ON c2.id_parcela = p2.id_parcela
        WHERE c2.id_producto = c.id_producto
        AND p2.tipo_suelo = pa.tipo_suelo
        AND c2.estado = 'Cosechado') AS rendimiento_promedio_condiciones_similares,
       c.cantidad_real / c.cantidad_estimada * 100 - 
       (SELECT AVG(c2.cantidad_real / c2.cantidad_estimada) * 100
        FROM Cultivos c2
        JOIN Parcelas p2 ON c2.id_parcela = p2.id_parcela
        WHERE c2.id_producto = c.id_producto
        AND p2.tipo_suelo = pa.tipo_suelo
        AND c2.estado = 'Cosechado') AS diferencia_rendimiento,
       (SELECT GROUP_CONCAT(DISTINCT a.metodo_aplicacion SEPARATOR ', ')
        FROM Aplicacion_Insumos a
        WHERE a.id_parcela = c.id_parcela
        AND a.fecha BETWEEN c.fecha_siembra AND c.fecha_cosecha_real) AS metodos_aplicacion_utilizados
FROM Cultivos c
JOIN Productos p ON c.id_producto = p.id_producto
JOIN Parcelas pa ON c.id_parcela = pa.id_parcela
WHERE c.estado = 'Cosechado'
HAVING diferencia_rendimiento > 0
ORDER BY diferencia_rendimiento DESC;
