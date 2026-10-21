
CREATE TABLE PERSONA (
    dni INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_persona PRIMARY KEY (dni)
);

CREATE TABLE VENDEDOR (
    dni INT NOT NULL,
    nro_vendedor SERIAL NOT NULL,
    CONSTRAINT pk_vendedor PRIMARY KEY (dni),
    CONSTRAINT unq_vendedor_nro UNIQUE (nro_vendedor),
    CONSTRAINT fk_vendedor_persona FOREIGN KEY (dni) 
        REFERENCES PERSONA(dni) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE CLIENTE (
    dni INT NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (dni),
    CONSTRAINT fk_cliente_persona FOREIGN KEY (dni) 
        REFERENCES PERSONA(dni) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE MAYORISTA (
    dni INT NOT NULL,
    descuento NUMERIC(5,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_mayorista PRIMARY KEY (dni),
    CONSTRAINT chk_descuento_mayorista CHECK (descuento >= 0.00 AND descuento <= 100.00),
    CONSTRAINT fk_mayorista_cliente FOREIGN KEY (dni) 
        REFERENCES CLIENTE(dni) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE MINORISTA (
    dni INT NOT NULL,
    fecha_nac DATE NOT NULL,
    CONSTRAINT pk_minorista PRIMARY KEY (dni),
    CONSTRAINT fk_minorista_cliente FOREIGN KEY (dni) 
        REFERENCES CLIENTE(dni) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE PROVEEDOR (
    cuit BIGINT NOT NULL,
    razon_soc VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    tel_fijo VARCHAR(30),
    CONSTRAINT pk_proveedor PRIMARY KEY (cuit)
);

CREATE TABLE PROVEEDOR_CELULAR (
    cuit BIGINT NOT NULL,
    celular VARCHAR(30) NOT NULL,
    CONSTRAINT pk_proveedor_celular PRIMARY KEY (cuit, celular),
    CONSTRAINT fk_celular_proveedor FOREIGN KEY (cuit) 
        REFERENCES PROVEEDOR(cuit) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);


CREATE TABLE ZAPATO (
    id_zapato SERIAL NOT NULL,
    color VARCHAR(30) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    CONSTRAINT pk_zapato PRIMARY KEY (id_zapato),
    CONSTRAINT chk_precio_zapato CHECK (precio > 0.00 AND precio < 200000.00)
);

CREATE TABLE STOCK (
    nro_talle INT NOT NULL,
    CONSTRAINT pk_stock PRIMARY KEY (nro_talle),
    CONSTRAINT chk_nro_talle CHECK (nro_talle > 0)
);

CREATE TABLE TIENE (
    id_zapato INT NOT NULL,
    nro_talle INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_tiene PRIMARY KEY (id_zapato, nro_talle),
    CONSTRAINT chk_tiene_cantidad CHECK (cantidad >= 0),
    CONSTRAINT fk_tiene_zapato FOREIGN KEY (id_zapato) 
        REFERENCES ZAPATO(id_zapato) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_tiene_stock FOREIGN KEY (nro_talle) 
        REFERENCES STOCK(nro_talle) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

CREATE TABLE PROVEE (
    cuit BIGINT NOT NULL,
    id_zapato INT NOT NULL,
    CONSTRAINT pk_provee PRIMARY KEY (cuit, id_zapato),
    CONSTRAINT fk_provee_proveedor FOREIGN KEY (cuit) 
        REFERENCES PROVEEDOR(cuit) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT fk_provee_zapato FOREIGN KEY (id_zapato) 
        REFERENCES ZAPATO(id_zapato) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE FACTURA (
    nro_factura SERIAL NOT NULL,
    fecha DATE NOT NULL,
    monto NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    descuento NUMERIC(5,2) NOT NULL DEFAULT 0.00,
    dni_cliente INT NOT NULL,
    nro_vendedor INT NOT NULL,
    CONSTRAINT pk_factura PRIMARY KEY (nro_factura),
    CONSTRAINT chk_factura_monto CHECK (monto >= 0.00),
    CONSTRAINT chk_factura_descuento CHECK (descuento >= 0.00 AND descuento <= 100.00),
    CONSTRAINT fk_factura_cliente FOREIGN KEY (dni_cliente) 
        REFERENCES CLIENTE(dni) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT fk_factura_vendedor FOREIGN KEY (nro_vendedor) 
        REFERENCES VENDEDOR(nro_vendedor) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

CREATE TABLE DET_FACTURACION (
    nro_factura INT NOT NULL,
    id_zapato INT NOT NULL,
    nro_talle INT NOT NULL,
    cant_venta INT NOT NULL,
    precio_venta NUMERIC(10,2) NOT NULL,
    CONSTRAINT pk_det_facturacion PRIMARY KEY (nro_factura, id_zapato, nro_talle),
    CONSTRAINT chk_det_cant_venta CHECK (cant_venta > 0),
    CONSTRAINT chk_det_precio_venta CHECK (precio_venta > 0.00),
    CONSTRAINT fk_det_factura FOREIGN KEY (nro_factura) 
        REFERENCES FACTURA(nro_factura) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_det_tiene FOREIGN KEY (id_zapato, nro_talle) 
        REFERENCES TIENE(id_zapato, nro_talle) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

CREATE TABLE DIA (
    dia_semana VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dia PRIMARY KEY (dia_semana)
);

CREATE TABLE HORARIO (
    dni_vendedor INT NOT NULL,
    dia_semana VARCHAR(15) NOT NULL,
    hora_entrada TIME NOT NULL,
    hora_salida TIME NOT NULL,
    CONSTRAINT pk_horario PRIMARY KEY (dni_vendedor, dia_semana),
    CONSTRAINT fk_horario_vendedor FOREIGN KEY (dni_vendedor) 
        REFERENCES VENDEDOR(dni) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_horario_dia FOREIGN KEY (dia_semana) 
        REFERENCES DIA(dia_semana) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

CREATE TABLE FRANCO (
    nro_franco SERIAL NOT NULL,
    fecha DATE NOT NULL,
    observaciones TEXT,
    dni_vendedor INT NOT NULL,
    CONSTRAINT pk_franco PRIMARY KEY (nro_franco),
    CONSTRAINT fk_franco_vendedor FOREIGN KEY (dni_vendedor) 
        REFERENCES VENDEDOR(dni) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE AUDITORIA_PRECIO_ZAPATO (
    id_auditoria SERIAL NOT NULL,
    id_zapato INT NOT NULL,
    fecha TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    precio_anterior NUMERIC(10,2) NOT NULL,
    precio_nuevo NUMERIC(10,2) NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    CONSTRAINT pk_auditoria PRIMARY KEY (id_auditoria),
    CONSTRAINT fk_auditoria_zapato FOREIGN KEY (id_zapato) 
        REFERENCES ZAPATO(id_zapato) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE OR REPLACE FUNCTION funcion_auditar_precio_zapato()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO AUDITORIA_PRECIO_ZAPATO (id_zapato, fecha, precio_anterior, precio_nuevo, usuario)
        VALUES (OLD.id_zapato, CURRENT_TIMESTAMP, OLD.precio, NEW.precio, CURRENT_USER);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_auditoria_cambio_precio
AFTER UPDATE ON ZAPATO
FOR EACH ROW
EXECUTE FUNCTION funcion_auditar_precio_zapato();
