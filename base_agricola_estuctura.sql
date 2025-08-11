use finca_agricola;

-- 
CREATE TABLE Categorias_Producto (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion TEXT
);

CREATE TABLE Departamentos (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre_departamento VARCHAR(50) NOT NULL,
    descripcion TEXT
);

CREATE TABLE Roles (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion TEXT,
    nivel_acceso INT NOT NULL
);

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR(100) NOT NULL,
    tipo ENUM('Persona', 'Empresa') NOT NULL,
    direccion TEXT,
    telefono VARCHAR(15),
    email VARCHAR(100),
    ruc_ci VARCHAR(20),
    fecha_registro DATE NOT NULL
);

CREATE TABLE Proveedores (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_proveedor VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(15),
    email VARCHAR(100),
    direccion TEXT,
    ruc VARCHAR(20),
    tipo ENUM('Insumos', 'Equipos', 'Servicios') NOT NULL
);

CREATE TABLE Parcelas (
    id_parcela INT PRIMARY KEY AUTO_INCREMENT,
    nombre_parcela VARCHAR(50) NOT NULL,
    area DECIMAL(10,2) NOT NULL,
    tipo_suelo VARCHAR(50),
    estado ENUM('Disponible', 'Ocupada', 'En descanso') DEFAULT 'Disponible'
);

CREATE TABLE Maquinaria (
    id_maquinaria INT PRIMARY KEY AUTO_INCREMENT,
    nombre_maquinaria VARCHAR(100) NOT NULL,
    modelo VARCHAR(50),
    serie VARCHAR(50),
    fecha_adquisicion DATE,
    costo DECIMAL(12,2),
    vida_util INT,
    estado ENUM('Operativa', 'Mantenimiento', 'Dañada', 'Retirada') DEFAULT 'Operativa',
    ubicacion VARCHAR(50)
);


CREATE TABLE Productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(100) NOT NULL,
    tipo_producto ENUM('Cultivo', 'Insumo', 'Equipo', 'Producto terminado') NOT NULL,
    precio_venta DECIMAL(10,2),
    unidad_medida VARCHAR(20),
    descripcion TEXT,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES Categorias_Producto(id_categoria)
);

CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    id_rol INT NOT NULL,
    id_departamento INT,
    telefono VARCHAR(15),
    direccion TEXT,
    estado ENUM('Activo', 'Inactivo', 'Vacaciones') DEFAULT 'Activo',
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol),
    FOREIGN KEY (id_departamento) REFERENCES Departamentos(id_departamento)
);


CREATE TABLE Historial_Salarios (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    salario_anterior DECIMAL(10,2) NOT NULL,
    salario_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio DATE NOT NULL,
    motivo VARCHAR(100),
    id_responsable INT,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_responsable) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Compras (
    id_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_proveedor INT NOT NULL,
    fecha_compra DATE NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    estado ENUM('Pendiente', 'Pagada', 'Cancelada') DEFAULT 'Pendiente',
    forma_pago VARCHAR(30),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor)
);

CREATE TABLE Detalle_Compras (
    id_detalle_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    costo_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES Compras(id_compra),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Inventario (
    id_inventario INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,
    fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ubicacion VARCHAR(50),
    lote VARCHAR(20),
    fecha_caducidad DATE,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    fecha_venta DATETIME NOT NULL,
    id_empleado INT NOT NULL,
    id_cliente INT NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    estado ENUM('Pendiente', 'Pagada', 'Cancelada') DEFAULT 'Pendiente',
    forma_pago VARCHAR(30),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Detalle_Ventas (
    id_detalle_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0,
    subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Cultivos (
    id_cultivo INT PRIMARY KEY AUTO_INCREMENT,
    id_parcela INT NOT NULL,
    id_producto INT NOT NULL, 
    fecha_siembra DATE NOT NULL,
    fecha_cosecha_estimada DATE,
    fecha_cosecha_real DATE,
    cantidad_estimada DECIMAL(10,2),
    cantidad_real DECIMAL(10,2),
    estado ENUM('Planificado', 'En crecimiento', 'Cosechado', 'Cancelado') DEFAULT 'Planificado',
    FOREIGN KEY (id_parcela) REFERENCES Parcelas(id_parcela),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Produccion_Lechera (
    id_produccion INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    id_animal VARCHAR(20),
    cantidad DECIMAL(10,2) NOT NULL, 
    calidad ENUM('Excelente', 'Buena', 'Regular', 'Mala'),
    observaciones TEXT,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Registro_Riegos (
    id_riego INT PRIMARY KEY AUTO_INCREMENT,
    id_parcela INT NOT NULL,
    fecha DATETIME NOT NULL,
    cantidad_agua DECIMAL(10,2), 
    metodo VARCHAR(50),
    id_empleado INT NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (id_parcela) REFERENCES Parcelas(id_parcela),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Aplicacion_Insumos (
    id_aplicacion INT PRIMARY KEY AUTO_INCREMENT,
    id_parcela INT NOT NULL,
    id_producto INT NOT NULL, 
    fecha DATE NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    metodo_aplicacion VARCHAR(50),
    id_empleado INT NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (id_parcela) REFERENCES Parcelas(id_parcela),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Tareas (
    id_tarea INT PRIMARY KEY AUTO_INCREMENT,
    descripcion TEXT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    id_maquinaria INT,
    id_empleado INT NOT NULL,
    id_parcela INT,
    estado ENUM('Pendiente', 'En progreso', 'Completada', 'Cancelada') DEFAULT 'Pendiente',
    prioridad ENUM('Baja', 'Media', 'Alta') DEFAULT 'Media',
    FOREIGN KEY (id_maquinaria) REFERENCES Maquinaria(id_maquinaria),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_parcela) REFERENCES Parcelas(id_parcela)
);

CREATE TABLE Mantenimiento_Maquinaria (
    id_mantenimiento INT PRIMARY KEY AUTO_INCREMENT,
    id_maquinaria INT NOT NULL,
    fecha DATE NOT NULL,
    tipo ENUM('Preventivo', 'Correctivo', 'Rutina') NOT NULL,
    descripcion TEXT,
    costo DECIMAL(10,2),
    id_proveedor_servicio INT,
    FOREIGN KEY (id_maquinaria) REFERENCES Maquinaria(id_maquinaria),
    FOREIGN KEY (id_proveedor_servicio) REFERENCES Proveedores(id_proveedor)
);

CREATE TABLE Auditoria (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    tabla_afectada VARCHAR(50) NOT NULL,
    id_registro INT,
    accion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50),
    valores_anteriores TEXT,
    valores_nuevos TEXT
);

CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    fecha_venta DATETIME NOT NULL,
    id_empleado INT NOT NULL,
    id_cliente INT NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    estado ENUM('Pendiente', 'Pagada', 'Cancelada') DEFAULT 'Pendiente',
    forma_pago VARCHAR(30),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);


CREATE TABLE Detalle_Ventas (
    id_detalle_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0,
    subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);



