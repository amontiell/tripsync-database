-- ============================================================
-- TP2: Modelo Lógico y Físico — TripSync
-- Grupo 15 - Gestión de Datos - ITBA
-- ============================================================
-- DDL inicial derivado del modelo lógico/físico (diagrama ER).
-- Nota: esta es la primera versión del esquema; algunos tipos
-- de datos fueron refinados posteriormente en TP3 (ver
-- tp3_ddl_checks.sql y el README del repo para el detalle).
-- ============================================================

CREATE TABLE categoria (
    id_categoria    int         NOT NULL,
    nombre          varchar(50) NOT NULL,
    fecha_alta      date        NOT NULL,
    fecha_baja      date        NULL,
    CONSTRAINT pk_categoria PRIMARY KEY ( id_categoria )
);
GO

CREATE TABLE metodo_pago (
    id_metodo_pago  int         NOT NULL,
    nombre          varchar(50) NOT NULL,
    fecha_alta      date        NOT NULL,
    fecha_baja      date        NULL,
    CONSTRAINT pk_metodo_pago PRIMARY KEY ( id_metodo_pago )
);
GO

CREATE TABLE moneda (
    id_moneda       int         NOT NULL,
    nombre          varchar(50) NOT NULL,
    fecha_alta      date        NOT NULL,
    fecha_baja      date        NULL,
    CONSTRAINT pk_moneda PRIMARY KEY ( id_moneda )
);
GO

CREATE TABLE pais (
    id_pais         int         NOT NULL,
    nombre          varchar(50) NOT NULL,
    fecha_alta      date        NOT NULL,
    fecha_baja      date        NULL,
    CONSTRAINT pk_pais PRIMARY KEY ( id_pais )
);
GO

CREATE TABLE tipo_transporte (
    id_transporte   int         NOT NULL,
    nombre          varchar(50) NOT NULL,
    fecha_alta      date        NOT NULL,
    fecha_baja      date        NULL,
    CONSTRAINT pk_tipo_transporte PRIMARY KEY ( id_transporte )
);
GO

CREATE TABLE usuario (
    id_usuario          int         NOT NULL,
    numero_documento    int         NOT NULL,
    tipo_documento      text        NOT NULL,
    nombre              varchar(50) NOT NULL,
    apellido            varchar(50) NOT NULL,
    fecha_nacimiento    date        NOT NULL,
    sexo                char(1)     NOT NULL,
    email               text        NOT NULL,
    telefono            varchar(20) NOT NULL,
    cantidad_de_viajes  int         NOT NULL,
    id_pais             int         NOT NULL,
    CONSTRAINT pk_Usuario PRIMARY KEY ( id_usuario )
);
GO

CREATE TABLE destino (
    id_destino      int         NOT NULL,
    nombre          varchar(50) NOT NULL,
    fecha_alta      date        NULL,
    fecha_baja      date        NULL,
    descripcion     text        NULL,
    id_pais         int         NOT NULL,
    CONSTRAINT pk_destino PRIMARY KEY ( id_destino )
);
GO

CREATE TABLE viaje (
    id_viaje                int         NOT NULL,
    fecha_inicio            date        NOT NULL,
    fecha_final             date        NOT NULL,
    descripcion             varchar(50) NOT NULL,
    estado                  varchar(60) NOT NULL,
    presupuesto_estimado    money       NULL,
    cantidad_participantes  int         NOT NULL,
    cantidad_actividades    int         NOT NULL,
    id_destino              int         NOT NULL,
    id_transporte           int         NOT NULL,
    CONSTRAINT pk_viaje PRIMARY KEY ( id_viaje )
);
GO

CREATE TABLE actividad (
    id_actividad    int         NOT NULL,
    nombre          varchar(50) NULL,
    fecha           date        NOT NULL,
    hora            datetime    NULL,
    nota            text        NULL,
    id_viaje        int         NOT NULL,
    CONSTRAINT pk_actividad PRIMARY KEY ( id_actividad )
);
GO

CREATE TABLE usuario_por_viaje (
    id_usuario_por_viaje    int     NOT NULL,
    fecha                   date    NOT NULL,
    id_viaje                int     NOT NULL,
    id_usuario              int     NOT NULL,
    CONSTRAINT pk_usuario_por_viaje PRIMARY KEY ( id_usuario_por_viaje )
);
GO

CREATE TABLE gasto (
    id_gasto                int             NOT NULL,
    nombre                  varchar(50)     NOT NULL,
    fecha                   date            NOT NULL,
    monto                   decimal(10,2)   NOT NULL,
    id_usuario_por_viaje    int             NOT NULL,
    id_categoria            int             NOT NULL,
    id_moneda               int             NOT NULL,
    CONSTRAINT pk_gasto PRIMARY KEY ( id_gasto )
);
GO

CREATE TABLE pago (
    id_pago                 int     NOT NULL,
    fecha_pago              date    NOT NULL,
    monto                   money   NOT NULL,
    id_usuario_por_viaje    int     NOT NULL,
    id_metodo_pago          int     NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY ( id_pago )
);
GO

CREATE TABLE participacion_en_actividad (
    id_participacion        int         NOT NULL,
    estado_asistencia       varchar(50) NOT NULL,
    id_actividad             int        NOT NULL,
    id_usuario_por_viaje     int        NOT NULL,
    CONSTRAINT pk_participacion_en_actividad PRIMARY KEY ( id_participacion )
);
GO

CREATE TABLE detalle_gasto (
    id_detalle_gasto        int         NOT NULL,
    participacion_gasto     varchar(50) NOT NULL,
    estado_de_cuenta        varchar(50) NOT NULL,
    id_gasto                int         NOT NULL,
    id_usuario_por_viaje    int         NOT NULL,
    CONSTRAINT pk_detalle_gasto PRIMARY KEY ( id_detalle_gasto )
);
GO

-- ------------------------------------------------------------
-- Claves foráneas
-- ------------------------------------------------------------

ALTER TABLE actividad ADD CONSTRAINT fk_actividad_viaje FOREIGN KEY ( id_viaje )
    REFERENCES viaje( id_viaje );
GO

ALTER TABLE destino ADD CONSTRAINT fk_destino_pais FOREIGN KEY ( id_pais )
    REFERENCES pais( id_pais );
GO

ALTER TABLE detalle_gasto ADD CONSTRAINT fk_detalle_gasto_gasto FOREIGN KEY ( id_gasto )
    REFERENCES gasto( id_gasto );
GO

ALTER TABLE detalle_gasto ADD CONSTRAINT fk_detalle_gasto_usuario_por_viaje
    FOREIGN KEY ( id_usuario_por_viaje ) REFERENCES usuario_por_viaje( id_usuario_por_viaje );
GO

ALTER TABLE gasto ADD CONSTRAINT fk_gasto_usuario_por_viaje
    FOREIGN KEY ( id_usuario_por_viaje ) REFERENCES usuario_por_viaje( id_usuario_por_viaje );
GO

ALTER TABLE gasto ADD CONSTRAINT fk_gasto_categoria FOREIGN KEY ( id_categoria )
    REFERENCES categoria( id_categoria );
GO

ALTER TABLE gasto ADD CONSTRAINT fk_gasto_moneda FOREIGN KEY ( id_moneda )
    REFERENCES moneda( id_moneda );
GO

ALTER TABLE pago ADD CONSTRAINT fk_pago_usuario_por_viaje
    FOREIGN KEY ( id_usuario_por_viaje ) REFERENCES usuario_por_viaje( id_usuario_por_viaje );
GO

ALTER TABLE pago ADD CONSTRAINT fk_pago_metodo_pago FOREIGN KEY ( id_metodo_pago )
    REFERENCES metodo_pago( id_metodo_pago );
GO

ALTER TABLE participacion_en_actividad ADD CONSTRAINT fk_participacion_en_actividad_actividad
    FOREIGN KEY ( id_actividad ) REFERENCES actividad( id_actividad );
GO

ALTER TABLE participacion_en_actividad ADD CONSTRAINT fk_participacion_en_actividad_usuario_por_viaje
    FOREIGN KEY ( id_usuario_por_viaje ) REFERENCES usuario_por_viaje( id_usuario_por_viaje );
GO

ALTER TABLE usuario ADD CONSTRAINT fk_usuario_pais FOREIGN KEY ( id_pais )
    REFERENCES pais( id_pais );
GO

ALTER TABLE usuario_por_viaje ADD CONSTRAINT fk_usuario_por_viaje_viaje
    FOREIGN KEY ( id_viaje ) REFERENCES viaje( id_viaje );
GO

ALTER TABLE usuario_por_viaje ADD CONSTRAINT fk_usuario_por_viaje_usuario
    FOREIGN KEY ( id_usuario ) REFERENCES usuario( id_usuario );
GO

ALTER TABLE viaje ADD CONSTRAINT fk_viaje_destino FOREIGN KEY ( id_destino )
    REFERENCES destino( id_destino );
GO

ALTER TABLE viaje ADD CONSTRAINT fk_viaje_tipo_transporte FOREIGN KEY ( id_transporte )
    REFERENCES tipo_transporte( id_transporte );
GO
