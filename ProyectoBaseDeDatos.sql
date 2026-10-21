--
-- PostgreSQL database dump
--

\restrict 6G4DOztCsT82q7AKFNvvJVIXbg3mjOShFz5CT3UvCgHRtq2TwwO8sLceTILkRZG

-- Dumped from database version 15.19 (Homebrew)
-- Dumped by pg_dump version 18.6 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: funcion_auditar_precio_zapato(); Type: FUNCTION; Schema: public; Owner: ignacio
--

CREATE FUNCTION public.funcion_auditar_precio_zapato() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO AUDITORIA_PRECIO_ZAPATO (id_zapato, fecha, precio_anterior, precio_nuevo, usuario)
        VALUES (OLD.id_zapato, CURRENT_TIMESTAMP, OLD.precio, NEW.precio, CURRENT_USER);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.funcion_auditar_precio_zapato() OWNER TO ignacio;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auditoria_precio_zapato; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.auditoria_precio_zapato (
    id_auditoria integer NOT NULL,
    id_zapato integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    precio_anterior numeric(10,2) NOT NULL,
    precio_nuevo numeric(10,2) NOT NULL,
    usuario character varying(100) NOT NULL
);


ALTER TABLE public.auditoria_precio_zapato OWNER TO ignacio;

--
-- Name: auditoria_precio_zapato_id_auditoria_seq; Type: SEQUENCE; Schema: public; Owner: ignacio
--

CREATE SEQUENCE public.auditoria_precio_zapato_id_auditoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auditoria_precio_zapato_id_auditoria_seq OWNER TO ignacio;

--
-- Name: auditoria_precio_zapato_id_auditoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ignacio
--

ALTER SEQUENCE public.auditoria_precio_zapato_id_auditoria_seq OWNED BY public.auditoria_precio_zapato.id_auditoria;


--
-- Name: cliente; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.cliente (
    dni integer NOT NULL
);


ALTER TABLE public.cliente OWNER TO ignacio;

--
-- Name: det_facturacion; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.det_facturacion (
    nro_factura integer NOT NULL,
    id_zapato integer NOT NULL,
    nro_talle integer NOT NULL,
    cant_venta integer NOT NULL,
    precio_venta numeric(10,2) NOT NULL,
    CONSTRAINT chk_det_cant_venta CHECK ((cant_venta > 0)),
    CONSTRAINT chk_det_precio_venta CHECK ((precio_venta > 0.00))
);


ALTER TABLE public.det_facturacion OWNER TO ignacio;

--
-- Name: dia; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.dia (
    dia_semana character varying(15) NOT NULL
);


ALTER TABLE public.dia OWNER TO ignacio;

--
-- Name: factura; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.factura (
    nro_factura integer NOT NULL,
    fecha date NOT NULL,
    monto numeric(12,2) DEFAULT 0.00 NOT NULL,
    descuento numeric(5,2) DEFAULT 0.00 NOT NULL,
    dni_cliente integer NOT NULL,
    dni_vendedor integer NOT NULL,
    CONSTRAINT chk_factura_descuento CHECK (((descuento >= 0.00) AND (descuento <= 100.00))),
    CONSTRAINT chk_factura_monto CHECK ((monto >= 0.00))
);


ALTER TABLE public.factura OWNER TO ignacio;

--
-- Name: factura_nro_factura_seq; Type: SEQUENCE; Schema: public; Owner: ignacio
--

CREATE SEQUENCE public.factura_nro_factura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.factura_nro_factura_seq OWNER TO ignacio;

--
-- Name: factura_nro_factura_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ignacio
--

ALTER SEQUENCE public.factura_nro_factura_seq OWNED BY public.factura.nro_factura;


--
-- Name: franco; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.franco (
    nro_franco integer NOT NULL,
    fecha date NOT NULL,
    observaciones text,
    dni_vendedor integer NOT NULL
);


ALTER TABLE public.franco OWNER TO ignacio;

--
-- Name: franco_nro_franco_seq; Type: SEQUENCE; Schema: public; Owner: ignacio
--

CREATE SEQUENCE public.franco_nro_franco_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.franco_nro_franco_seq OWNER TO ignacio;

--
-- Name: franco_nro_franco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ignacio
--

ALTER SEQUENCE public.franco_nro_franco_seq OWNED BY public.franco.nro_franco;


--
-- Name: horario; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.horario (
    dni_vendedor integer NOT NULL,
    dia_semana character varying(15) NOT NULL,
    hora_entrada time without time zone NOT NULL,
    hora_salida time without time zone NOT NULL
);


ALTER TABLE public.horario OWNER TO ignacio;

--
-- Name: mayorista; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.mayorista (
    dni integer NOT NULL,
    descuento numeric(5,2) DEFAULT 0.00 NOT NULL,
    CONSTRAINT chk_descuento_mayorista CHECK (((descuento >= 0.00) AND (descuento <= 100.00)))
);


ALTER TABLE public.mayorista OWNER TO ignacio;

--
-- Name: minorista; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.minorista (
    dni integer NOT NULL,
    fecha_nac date NOT NULL
);


ALTER TABLE public.minorista OWNER TO ignacio;

--
-- Name: persona; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.persona (
    dni integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    direccion character varying(100) NOT NULL
);


ALTER TABLE public.persona OWNER TO ignacio;

--
-- Name: provee; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.provee (
    cuit bigint NOT NULL,
    id_zapato integer NOT NULL
);


ALTER TABLE public.provee OWNER TO ignacio;

--
-- Name: proveedor; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.proveedor (
    cuit bigint NOT NULL,
    razon_soc character varying(100) NOT NULL,
    direccion character varying(100) NOT NULL,
    tel_fijo character varying(30)
);


ALTER TABLE public.proveedor OWNER TO ignacio;

--
-- Name: proveedor_celular; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.proveedor_celular (
    cuit bigint NOT NULL,
    celular character varying(30) NOT NULL
);


ALTER TABLE public.proveedor_celular OWNER TO ignacio;

--
-- Name: stock; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.stock (
    nro_talle integer NOT NULL,
    CONSTRAINT chk_nro_talle CHECK ((nro_talle > 0))
);


ALTER TABLE public.stock OWNER TO ignacio;

--
-- Name: tiene; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.tiene (
    id_zapato integer NOT NULL,
    nro_talle integer NOT NULL,
    cantidad integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_tiene_cantidad CHECK ((cantidad >= 0))
);


ALTER TABLE public.tiene OWNER TO ignacio;

--
-- Name: vendedor; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.vendedor (
    dni integer NOT NULL,
    nro_vendedor integer NOT NULL
);


ALTER TABLE public.vendedor OWNER TO ignacio;

--
-- Name: vendedor_nro_vendedor_seq; Type: SEQUENCE; Schema: public; Owner: ignacio
--

CREATE SEQUENCE public.vendedor_nro_vendedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vendedor_nro_vendedor_seq OWNER TO ignacio;

--
-- Name: vendedor_nro_vendedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ignacio
--

ALTER SEQUENCE public.vendedor_nro_vendedor_seq OWNED BY public.vendedor.nro_vendedor;


--
-- Name: zapato; Type: TABLE; Schema: public; Owner: ignacio
--

CREATE TABLE public.zapato (
    id_zapato integer NOT NULL,
    color character varying(30) NOT NULL,
    modelo character varying(50) NOT NULL,
    precio numeric(10,2) NOT NULL,
    CONSTRAINT chk_precio_zapato CHECK (((precio > 0.00) AND (precio < 200000.00)))
);


ALTER TABLE public.zapato OWNER TO ignacio;

--
-- Name: zapato_id_zapato_seq; Type: SEQUENCE; Schema: public; Owner: ignacio
--

CREATE SEQUENCE public.zapato_id_zapato_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.zapato_id_zapato_seq OWNER TO ignacio;

--
-- Name: zapato_id_zapato_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ignacio
--

ALTER SEQUENCE public.zapato_id_zapato_seq OWNED BY public.zapato.id_zapato;


--
-- Name: auditoria_precio_zapato id_auditoria; Type: DEFAULT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.auditoria_precio_zapato ALTER COLUMN id_auditoria SET DEFAULT nextval('public.auditoria_precio_zapato_id_auditoria_seq'::regclass);


--
-- Name: factura nro_factura; Type: DEFAULT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.factura ALTER COLUMN nro_factura SET DEFAULT nextval('public.factura_nro_factura_seq'::regclass);


--
-- Name: franco nro_franco; Type: DEFAULT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.franco ALTER COLUMN nro_franco SET DEFAULT nextval('public.franco_nro_franco_seq'::regclass);


--
-- Name: vendedor nro_vendedor; Type: DEFAULT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.vendedor ALTER COLUMN nro_vendedor SET DEFAULT nextval('public.vendedor_nro_vendedor_seq'::regclass);


--
-- Name: zapato id_zapato; Type: DEFAULT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.zapato ALTER COLUMN id_zapato SET DEFAULT nextval('public.zapato_id_zapato_seq'::regclass);


--
-- Data for Name: auditoria_precio_zapato; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.auditoria_precio_zapato (id_auditoria, id_zapato, fecha, precio_anterior, precio_nuevo, usuario) FROM stdin;
1	1	2026-10-20 15:59:27.798786	65000.00	69900.00	ignacio
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.cliente (dni) FROM stdin;
35111222
28777888
32444555
45123987
\.


--
-- Data for Name: det_facturacion; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.det_facturacion (nro_factura, id_zapato, nro_talle, cant_venta, precio_venta) FROM stdin;
1	1	40	2	65000.00
2	2	41	2	54000.00
3	3	39	2	42000.00
\.


--
-- Data for Name: dia; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.dia (dia_semana) FROM stdin;
Lunes
Martes
Miércoles
Jueves
Viernes
Sábado
\.


--
-- Data for Name: factura; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.factura (nro_factura, fecha, monto, descuento, dni_cliente, dni_vendedor) FROM stdin;
1	2025-06-15	130000.00	0.00	35111222	38123456
2	2025-11-20	108000.00	5.00	32444555	40987654
3	2026-03-10	84000.00	10.00	28777888	38123456
\.


--
-- Data for Name: franco; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.franco (nro_franco, fecha, observaciones, dni_vendedor) FROM stdin;
1	2026-01-15	Compensatorio fin de semana	38123456
2	2026-02-10	Franco rotativo	40987654
\.


--
-- Data for Name: horario; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.horario (dni_vendedor, dia_semana, hora_entrada, hora_salida) FROM stdin;
38123456	Lunes	08:30:00	16:30:00
38123456	Martes	08:30:00	16:30:00
40987654	Lunes	09:00:00	17:00:00
42333444	Viernes	10:00:00	18:00:00
\.


--
-- Data for Name: mayorista; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.mayorista (dni, descuento) FROM stdin;
35111222	15.00
28777888	20.00
\.


--
-- Data for Name: minorista; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.minorista (dni, fecha_nac) FROM stdin;
32444555	1990-05-14
45123987	2001-11-28
\.


--
-- Data for Name: persona; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.persona (dni, nombre, apellido, direccion) FROM stdin;
38123456	Martín	Gómez	Sobremonte 234, Río Cuarto
40987654	Lucía	Fernández	General Paz 890, Río Cuarto
42333444	Rodrigo	Pérez	Belgrano 1120, Río Cuarto
35111222	Gonzalo	Romero	San Martín 500, Río Cuarto
28777888	Marcela	Suárez	Bv. Roca 340, Río Cuarto
32444555	Esteban	Quinteros	España 760, Río Cuarto
45123987	Camila	Domínguez	Alberdi 1500, Río Cuarto
\.


--
-- Data for Name: provee; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.provee (cuit, id_zapato) FROM stdin;
30711223344	1
30655443322	1
30655443322	2
33544332219	3
30655443322	4
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.proveedor (cuit, razon_soc, direccion, tel_fijo) FROM stdin;
30711223344	Calzados Argentinos S.A.	Rivadavia 450, Córdoba	0351-4221100
30655443322	Cueros del Centro SRL	Constitución 1240, Río Cuarto	0358-4632211
33544332219	Suela y Confort Mayorista	Alvear 890, Rosario	0341-4890011
\.


--
-- Data for Name: proveedor_celular; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.proveedor_celular (cuit, celular) FROM stdin;
30711223344	351-155123456
30711223344	351-156987654
30655443322	358-154332211
33544332219	341-152445566
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.stock (nro_talle) FROM stdin;
37
38
39
40
41
42
43
\.


--
-- Data for Name: tiene; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.tiene (id_zapato, nro_talle, cantidad) FROM stdin;
1	39	10
1	40	15
1	41	8
2	40	5
2	41	12
3	38	20
3	39	25
4	42	6
\.


--
-- Data for Name: vendedor; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.vendedor (dni, nro_vendedor) FROM stdin;
38123456	1
40987654	2
42333444	3
\.


--
-- Data for Name: zapato; Type: TABLE DATA; Schema: public; Owner: ignacio
--

COPY public.zapato (id_zapato, color, modelo, precio) FROM stdin;
2	Marrón	Zapato Náutico Cuero	54000.00
3	Blanco	Zapatilla Deportiva Classic	42000.00
4	Suela	Borcego Trekking	89000.00
1	Negro	Bota Chelsea Urbano	69900.00
\.


--
-- Name: auditoria_precio_zapato_id_auditoria_seq; Type: SEQUENCE SET; Schema: public; Owner: ignacio
--

SELECT pg_catalog.setval('public.auditoria_precio_zapato_id_auditoria_seq', 1, true);


--
-- Name: factura_nro_factura_seq; Type: SEQUENCE SET; Schema: public; Owner: ignacio
--

SELECT pg_catalog.setval('public.factura_nro_factura_seq', 3, true);


--
-- Name: franco_nro_franco_seq; Type: SEQUENCE SET; Schema: public; Owner: ignacio
--

SELECT pg_catalog.setval('public.franco_nro_franco_seq', 2, true);


--
-- Name: vendedor_nro_vendedor_seq; Type: SEQUENCE SET; Schema: public; Owner: ignacio
--

SELECT pg_catalog.setval('public.vendedor_nro_vendedor_seq', 3, true);


--
-- Name: zapato_id_zapato_seq; Type: SEQUENCE SET; Schema: public; Owner: ignacio
--

SELECT pg_catalog.setval('public.zapato_id_zapato_seq', 4, true);


--
-- Name: auditoria_precio_zapato pk_auditoria; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.auditoria_precio_zapato
    ADD CONSTRAINT pk_auditoria PRIMARY KEY (id_auditoria);


--
-- Name: cliente pk_cliente; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT pk_cliente PRIMARY KEY (dni);


--
-- Name: det_facturacion pk_det_facturacion; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.det_facturacion
    ADD CONSTRAINT pk_det_facturacion PRIMARY KEY (nro_factura, id_zapato, nro_talle);


--
-- Name: dia pk_dia; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.dia
    ADD CONSTRAINT pk_dia PRIMARY KEY (dia_semana);


--
-- Name: factura pk_factura; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.factura
    ADD CONSTRAINT pk_factura PRIMARY KEY (nro_factura);


--
-- Name: franco pk_franco; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.franco
    ADD CONSTRAINT pk_franco PRIMARY KEY (nro_franco);


--
-- Name: horario pk_horario; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.horario
    ADD CONSTRAINT pk_horario PRIMARY KEY (dni_vendedor, dia_semana);


--
-- Name: mayorista pk_mayorista; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.mayorista
    ADD CONSTRAINT pk_mayorista PRIMARY KEY (dni);


--
-- Name: minorista pk_minorista; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.minorista
    ADD CONSTRAINT pk_minorista PRIMARY KEY (dni);


--
-- Name: persona pk_persona; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.persona
    ADD CONSTRAINT pk_persona PRIMARY KEY (dni);


--
-- Name: provee pk_provee; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.provee
    ADD CONSTRAINT pk_provee PRIMARY KEY (cuit, id_zapato);


--
-- Name: proveedor pk_proveedor; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT pk_proveedor PRIMARY KEY (cuit);


--
-- Name: proveedor_celular pk_proveedor_celular; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.proveedor_celular
    ADD CONSTRAINT pk_proveedor_celular PRIMARY KEY (cuit, celular);


--
-- Name: stock pk_stock; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT pk_stock PRIMARY KEY (nro_talle);


--
-- Name: tiene pk_tiene; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.tiene
    ADD CONSTRAINT pk_tiene PRIMARY KEY (id_zapato, nro_talle);


--
-- Name: vendedor pk_vendedor; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT pk_vendedor PRIMARY KEY (dni);


--
-- Name: zapato pk_zapato; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.zapato
    ADD CONSTRAINT pk_zapato PRIMARY KEY (id_zapato);


--
-- Name: vendedor unq_vendedor_nro; Type: CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT unq_vendedor_nro UNIQUE (nro_vendedor);


--
-- Name: zapato trg_auditoria_cambio_precio; Type: TRIGGER; Schema: public; Owner: ignacio
--

CREATE TRIGGER trg_auditoria_cambio_precio AFTER UPDATE ON public.zapato FOR EACH ROW EXECUTE FUNCTION public.funcion_auditar_precio_zapato();


--
-- Name: auditoria_precio_zapato fk_auditoria_zapato; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.auditoria_precio_zapato
    ADD CONSTRAINT fk_auditoria_zapato FOREIGN KEY (id_zapato) REFERENCES public.zapato(id_zapato) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: proveedor_celular fk_celular_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.proveedor_celular
    ADD CONSTRAINT fk_celular_proveedor FOREIGN KEY (cuit) REFERENCES public.proveedor(cuit) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cliente fk_cliente_persona; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT fk_cliente_persona FOREIGN KEY (dni) REFERENCES public.persona(dni) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: det_facturacion fk_det_factura; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.det_facturacion
    ADD CONSTRAINT fk_det_factura FOREIGN KEY (nro_factura) REFERENCES public.factura(nro_factura) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: det_facturacion fk_det_tiene; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.det_facturacion
    ADD CONSTRAINT fk_det_tiene FOREIGN KEY (id_zapato, nro_talle) REFERENCES public.tiene(id_zapato, nro_talle) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: factura fk_factura_cliente; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.factura
    ADD CONSTRAINT fk_factura_cliente FOREIGN KEY (dni_cliente) REFERENCES public.cliente(dni) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: factura fk_factura_vendedor; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.factura
    ADD CONSTRAINT fk_factura_vendedor FOREIGN KEY (dni_vendedor) REFERENCES public.vendedor(dni) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: franco fk_franco_vendedor; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.franco
    ADD CONSTRAINT fk_franco_vendedor FOREIGN KEY (dni_vendedor) REFERENCES public.vendedor(dni) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: horario fk_horario_dia; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.horario
    ADD CONSTRAINT fk_horario_dia FOREIGN KEY (dia_semana) REFERENCES public.dia(dia_semana) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: horario fk_horario_vendedor; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.horario
    ADD CONSTRAINT fk_horario_vendedor FOREIGN KEY (dni_vendedor) REFERENCES public.vendedor(dni) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mayorista fk_mayorista_cliente; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.mayorista
    ADD CONSTRAINT fk_mayorista_cliente FOREIGN KEY (dni) REFERENCES public.cliente(dni) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: minorista fk_minorista_cliente; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.minorista
    ADD CONSTRAINT fk_minorista_cliente FOREIGN KEY (dni) REFERENCES public.cliente(dni) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provee fk_provee_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.provee
    ADD CONSTRAINT fk_provee_proveedor FOREIGN KEY (cuit) REFERENCES public.proveedor(cuit) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: provee fk_provee_zapato; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.provee
    ADD CONSTRAINT fk_provee_zapato FOREIGN KEY (id_zapato) REFERENCES public.zapato(id_zapato) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tiene fk_tiene_stock; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.tiene
    ADD CONSTRAINT fk_tiene_stock FOREIGN KEY (nro_talle) REFERENCES public.stock(nro_talle) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tiene fk_tiene_zapato; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.tiene
    ADD CONSTRAINT fk_tiene_zapato FOREIGN KEY (id_zapato) REFERENCES public.zapato(id_zapato) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: vendedor fk_vendedor_persona; Type: FK CONSTRAINT; Schema: public; Owner: ignacio
--

ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT fk_vendedor_persona FOREIGN KEY (dni) REFERENCES public.persona(dni) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 6G4DOztCsT82q7AKFNvvJVIXbg3mjOShFz5CT3UvCgHRtq2TwwO8sLceTILkRZG

