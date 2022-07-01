---******************************

-- BASE DE DATOS BINAES 2022
    
    -- Grupo LOS CONSTRAINT

--* Integrantes
    --> Fernanda Camila Vásquez Meléndez, #00065221
    --> Alejandra Vanessa Serrano Córdova,, #0010520 ya no me acuerdo aahhhhhh
    --> Henry Eduardo Escobar Lima, #00033721
    --> Andrea Milena Cabrera no recuerdo x2 AHHHHHHHHHH

---******************************

CREATE DATABASE DB_BINAES_2022;
GO
USE DB_BINAES_2022;
GO

--DROP DATABASE DB_BINAES_2022;

--------- EVENTO ---------

CREATE TABLE EVENTO(
    id INT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    asistentes INT NOT NULL, 
    imagen VARBINARY(MAX) NOT NULL, 
);

CREATE TABLE OBJETIVO_EVENTO(
    id INT PRIMARY KEY,
    objetivo VARCHAR(200) NOT NULL, 
    id_evento INT NOT NULL,
);

--------- ACTIVIDAD  ---------

CREATE TABLE ACTIVIDAD(
    id INT PRIMARY KEY,
    fecha_inicio DATETIME NOT NULL,
    fecha_final DATETIME NOT NULL,
    id_evento INT NOT NULL,
    id_area INT NOT NULL,
    id_usuario INT NOT NULL,
);

---------  AREA ---------

CREATE TABLE AREA(
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(250) NOT NULL,
    piso INT NOT NULL,
    id_horario INT NOT NULL,
    id_responsable INT NOT NULL,
    id_disponibilidad_area INT NOT NULL,
);

CREATE TABLE DISPONIBILIDAD_AREA(
    id INT PRIMARY KEY,
    disponible BIT NOT NULL,  
);

CREATE TABLE RESPONSABLE(
    id INT PRIMARY KEY,
    nombre VARCHAR(75) NOT NULL
);

CREATE TABLE HORARIO(
    id INT PRIMARY KEY,
    dias VARCHAR(50) NOT NULL,
    horas VARCHAR(25) NOT NULL,
);

CREATE TABLE ASISTENCIA(
    id_actividad INT NOT NULL,     
    id_usuario INT NOT NULL,
    fecha_entrada DATETIME NOT NULL,
    fecha_salida DATETIME NULL,
);

--------- USUARIO ---------

CREATE TABLE USUARIO(
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(75) NOT NULL,
    foto VARBINARY(MAX) NOT NULL, 
    cod_qr VARBINARY(MAX) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    institucion VARCHAR(125) NOT NULL,
    ocupacion VARCHAR(100) NOT NULL,
    id_rol_usuario INT NOT NULL,
    id_telefono INT NOT NULL,    
    password_user VARCHAR(120) NOT NULL,
);

CREATE TABLE ROL(
    id INT PRIMARY KEY,
    rol VARCHAR(15) NOT NULL,
);

CREATE TABLE TELEFONO(
    id INT PRIMARY KEY,
    telefono CHAR(12) NOT NULL UNIQUE
        CHECK(telefono LIKE '+503[2|6|7][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
);

--------- EJEMPLAR ---------

CREATE TABLE EJEMPLAR(
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    portada VARBINARY(MAX) NOT NULL,
    id_coleccion INT NULL,
    id_autor INT NOT NULL,
    id_bibliografico INT NOT NULL,
    id_editorial INT NOT NULL,
    id_idioma INT NOT NULL,
    id_formato INT NOT NULL,
    id_disponibilidad_ejemplar INT NOT NULL,
);

CREATE TABLE DISPONIBILIDAD_EJEMPLAR(
    id INT PRIMARY KEY,
    disponible BIT NOT NULL, 
);

CREATE TABLE AUTOR(
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
);

CREATE TABLE ID_BIBLIOGRAFICO(
    id INT PRIMARY KEY,
    tipo VARCHAR(15) NULL,
    identificador VARCHAR(50) NULL,
);

CREATE TABLE FORMATO(
    id INT PRIMARY KEY,
    formato VARCHAR(10) NOT NULL,
);

CREATE TABLE IDIOMA(
    id INT PRIMARY KEY,
    idioma VARCHAR(50) NOT NULL,
);

CREATE TABLE EDITORIAL(
    id INT PRIMARY KEY,
    editorial VARCHAR(50) NOT NULL,
);

CREATE TABLE PALABRA_CLAVE(
    id INT PRIMARY KEY,
    etiqueta VARCHAR(100) NOT NULL,
    id_ejemplar INT NOT NULL,
);

--------- PRESTAMO Y RESERVA EJEMPLAR ---------

CREATE TABLE PRESTAMO_EJEMPLAR(
    id_usuario INT NOT NULL,
    id_ejemplar INT NOT NULL,     
    fecha_prestamo DATETIME NOT NULL,
    fecha_devolucion DATETIME NOT NULL,  
);

CREATE TABLE RESERVA_EJEMPLAR(
    id_usuario INT NOT NULL,
    id_ejemplar INT NOT NULL,     
    fecha_reserva DATETIME NOT NULL,
    fecha_devolucion DATETIME NOT NULL, 
);

--------- COLECCION ---------

CREATE TABLE COLECCION(
    id INT PRIMARY KEY,
    nombre VARCHAR(75) NOT NULL,
    id_tipo INT NOT NULL,
    id_genero INT NOT NULL,
);

CREATE TABLE GENERO(
    id INT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
);

CREATE TABLE TIPO_COLECCION(
    id INT PRIMARY KEY,
    nombre VARCHAR(75) NOT NULL,
);


---******************************
------------ FK's --------------

ALTER TABLE OBJETIVO_EVENTO ADD CONSTRAINT fk_id_evento_objetivo FOREIGN KEY(id_evento) REFERENCES EVENTO(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE ;

ALTER TABLE ACTIVIDAD ADD CONSTRAINT fk_id_evento FOREIGN KEY(id_evento) REFERENCES EVENTO(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE ;

ALTER TABLE ACTIVIDAD ADD CONSTRAINT fk_id_area FOREIGN KEY(id_area) REFERENCES AREA(id);
ALTER TABLE ACTIVIDAD ADD CONSTRAINT fk_id_usuario FOREIGN KEY(id_usuario) REFERENCES USUARIO(id);

ALTER TABLE AREA ADD CONSTRAINT fk_id_horario FOREIGN KEY(id_horario) REFERENCES HORARIO(id);
ALTER TABLE AREA ADD CONSTRAINT fk_id_responsable FOREIGN KEY(id_responsable) REFERENCES RESPONSABLE(id);

ALTER TABLE ASISTENCIA ADD CONSTRAINT pk_asitencia  PRIMARY KEY (id_actividad, id_usuario);
ALTER TABLE ASISTENCIA ADD CONSTRAINT fK_id_actividad_asistencia FOREIGN KEY (id_actividad) REFERENCES ACTIVIDAD(id);
ALTER TABLE ASISTENCIA ADD CONSTRAINT fk_id_usuario_asistencia FOREIGN KEY (id_usuario) REFERENCES USUARIO(id);

ALTER TABLE USUARIO ADD CONSTRAINT fk_id_rol_user FOREIGN KEY(id_rol_usuario) REFERENCES ROL(id);
ALTER TABLE USUARIO ADD CONSTRAINT fk_id_telefono FOREIGN KEY(id_telefono) REFERENCES TELEFONO(id);

ALTER TABLE PRESTAMO_EJEMPLAR ADD CONSTRAINT pk_prestamo_ejemplar PRIMARY KEY (id_usuario, id_ejemplar);
ALTER TABLE PRESTAMO_EJEMPLAR ADD CONSTRAINT fk_id_usuario_prestamo FOREIGN KEY (id_usuario) REFERENCES USUARIO(id);
ALTER TABLE PRESTAMO_EJEMPLAR ADD CONSTRAINT fk_id_ejemplar_prestamo FOREIGN KEY (id_ejemplar) REFERENCES EJEMPLAR(id);

ALTER TABLE RESERVA_EJEMPLAR ADD CONSTRAINT pk_reserva_ejemplar PRIMARY KEY (id_usuario, id_ejemplar);
ALTER TABLE RESERVA_EJEMPLAR ADD CONSTRAINT fk_id_usuario_reserva FOREIGN KEY (id_usuario) REFERENCES USUARIO(id);
ALTER TABLE RESERVA_EJEMPLAR ADD CONSTRAINT fk_id_ejemplar_reserva FOREIGN KEY (id_ejemplar) REFERENCES EJEMPLAR(id);

ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_coleccion FOREIGN KEY(id_coleccion) REFERENCES COLECCION(id)
    ON DELETE SET NULL;

ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_autor FOREIGN KEY(id_autor) REFERENCES AUTOR(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_bibliografico FOREIGN KEY(id_bibliografico) REFERENCES ID_BIBLIOGRAFICO(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_editorial FOREIGN KEY(id_editorial) REFERENCES EDITORIAL(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_idioma FOREIGN KEY(id_idioma) REFERENCES IDIOMA(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_formato FOREIGN KEY(id_formato) REFERENCES FORMATO(id);

ALTER TABLE PALABRA_CLAVE ADD CONSTRAINT fk_id_ejemplar FOREIGN KEY(id_ejemplar) REFERENCES EJEMPLAR(id);

ALTER TABLE COLECCION ADD CONSTRAINT fk_id_tipo FOREIGN KEY(id_tipo) REFERENCES TIPO_COLECCION(id);
ALTER TABLE COLECCION ADD CONSTRAINT fk_id_genero FOREIGN KEY(id_genero) REFERENCES GENERO(id);

ALTER TABLE AREA ADD CONSTRAINT fk_id_disponibilidad_area FOREIGN KEY (id_disponibilidad_area) REFERENCES DISPONIBILIDAD_AREA(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_disponibilidad_ejemplar FOREIGN KEY (id_disponibilidad_ejemplar) REFERENCES DISPONIBILIDAD_EJEMPLAR(id);

---******************************

----------- INSERTS -------------