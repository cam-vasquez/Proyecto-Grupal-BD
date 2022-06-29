--
CREATE DATABASE DB_BINAES_2022;

DROP DATABASE DB_BINAES_2022;

USE DB_BINAES_2022;

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

------------ FK's --------------
---*

ALTER TABLE OBJETIVO_EVENTO ADD CONSTRAINT fk_id_evento_objetivo FOREIGN KEY(id_evento) REFERENCES EVENTO(id)
/*     ON DELETE CASCADE
    ON UPDATE CASCADE */
;

ALTER TABLE ACTIVIDAD ADD CONSTRAINT fk_id_evento FOREIGN KEY(id_evento) REFERENCES EVENTO(id)
   /*  ON DELETE CASCADE
    ON UPDATE CASCADE */
;

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

---*
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_coleccion FOREIGN KEY(id_coleccion) REFERENCES COLECCION(id)
    ON DELETE SET NULL
;

ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_autor FOREIGN KEY(id_autor) REFERENCES AUTOR(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_bibliografico FOREIGN KEY(id_bibliografico) REFERENCES ID_BIBLIOGRAFICO(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_editorial FOREIGN KEY(id_editorial) REFERENCES EDITORIAL(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_idioma FOREIGN KEY(id_idioma) REFERENCES IDIOMA(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_formato FOREIGN KEY(id_formato) REFERENCES FORMATO(id);

ALTER TABLE PALABRA_CLAVE ADD CONSTRAINT fk_id_ejemplar FOREIGN KEY(id_ejemplar) REFERENCES EJEMPLAR(id);

--*
ALTER TABLE COLECCION ADD CONSTRAINT fk_id_tipo FOREIGN KEY(id_tipo) REFERENCES TIPO_COLECCION(id);
ALTER TABLE COLECCION ADD CONSTRAINT fk_id_genero FOREIGN KEY(id_genero) REFERENCES GENERO(id);

ALTER TABLE AREA ADD CONSTRAINT fk_id_disponibilidad_area FOREIGN KEY (id_disponibilidad_area) REFERENCES DISPONIBILIDAD_AREA(id);
ALTER TABLE EJEMPLAR ADD CONSTRAINT fk_id_disponibilidad_ejemplar FOREIGN KEY (id_disponibilidad_ejemplar) REFERENCES DISPONIBILIDAD_EJEMPLAR(id);

----------- INSERTS --------------------------



INSERT INTO EVENTO(id,titulo,asistentes,imagen) VALUES 
    (1 ,'Taller sobre Libros electronicos: uso y aprovechamiento', 75, 0x86f0566281),
	(2 ,'Capacitación sobre ZOTERO: software sobre referencias bibliográficas', 23, 0x4b2742ce7f),
	(3 ,'Capacitación para el desarrollo de competencias del Talento Humano', 58, 0xa2ce6afa6a),
	(4 ,'Cinefórum sobre la historia de la Guerra civil en El Salvador', 100, 0xbdd2ee5b72),
	(5 ,'Foro sobre "El vitalismo desde el punto de vista de Alberto Masferrer"', 88, 0x108bf667b3),
	(6 ,'Foro de divulgación de ciencia y tecnología', 25, 0xdf888d1f02),
	(7 ,'Debate sobre la digitalización del patrinomio cultural', 45, 0xa3e39a9f63),
	(8 ,'Cinefórum: Derechos humanos y personas mayores', 76, 0x550a0385bc),
	(9 ,'Jornada de entrenamiento en el uso de recursos online', 115, 0x5e3bb52393),
	(10,'Exposición sobre la literatura en El Salvador', 90, 0x3d941fb9f1);

INSERT INTO OBJETIVO_EVENTO(id,objetivo,id_evento) VALUES
    (1,'Promover la alfabetización digital y facilitar el acceso a las TICs a los miembros de la sociedad', 1),
	(2,'Posibilitar la gestión y el uso de citaciones bibliograficas, brindar las posibilidades que brinda ZOTERO como gestor bibliografico', 2),
	(3,'Garantizar la agilidad frente a la computadora, implementando tecnicas que haría más eficiente el trabajo del usuario', 3),
	(4,'Conocer y reflexionar sobre los principales motivos por el cual se desarrollo este conflicto belico en El Salvador', 4),
	(5,'Explanar sobre los principios fundamentales de la Educacion Vitalista que propuso Alberto Masferrer a la sociedad', 5),
	(6,'Incitar la divulgación científica y tecnologica a través de la utilización de estrategias que promuevan un mejor desarrollo de la calidad de vida', 6),
	(7,'Exponer la relevancia actual de las técnicas y estudios destinados a la digitalización del patrimonio cultural', 7),
	(8,'Incitar el respeto de los derechos de las personas mayores en una perspectiva actual.', 8),
	(9,'Conocer e implentar estrategias de recuperación de información en bases de datos científicas.', 9 ),
	(10,'Conocer acerca de las principales manifestaciones de la literatura en El Salvador y sus máximos exponentes', 10);

INSERT INTO HORARIO(id,dias,horas) VALUES
    (1,  'Lunes a Viernes'             ,'8:00-17:00'),
	(2,  'Lunes a Domingo'             ,'8:00-17:00'),
	(3,  'Lunes, miércoles y viernes'  ,'7:00-21:00'),
	(4,  'Martes y Jueves'             ,'8:00-13:00'),
	(5,  'Martes, Jueves y Sábado'     ,'9:00-14:00'),
	(6,  'Lunes, Martes y Miércoles'   ,'7:00-18:00'),
	(7,  'Lunes,Martes,Jueves,Viernes' ,'7:00-20:00'),
	(8,  'Sábado'                      ,'8:00-12:00'),
	(9,  'Lunes a Viernes'             ,'8:00-17:45'),
	(10, 'Lunes a sábado'              ,'9:00-21:00');

INSERT INTO DISPONIBILIDAD_AREA(id,disponible) VALUES
    (1, 0),
	(2, 1);

INSERT INTO RESPONSABLE(id,nombre) VALUES
    (1, 'Aura Ivette Morales'),
	(2, 'Gerald Jose Zelaya'),
	(3, 'Roxana Alvarenga de Nerio'),
	(4, 'Franklin Ricardo Abrego'),
	(5, 'Karla Paola Martínez'),
	(6, 'Jaime Esaú Rivera'),
	(7, 'Cristian Marcel Menjívar'),
	(8, 'Gloria Vanessa Estrada'),
	(9, 'Francisco Antonio Mejía'),
	(10, 'Maria Alejandra Arce');

INSERT INTO AREA(id,nombre,descripcion, piso, id_horario,id_responsable, id_disponibilidad_area) VALUES 
    (1, 'Salones lúdicos'                 ,'Área con capacidad para 65 personas, cuenta con espacios recreativos, 3 rincones de lecturas para incentivar la comunicación a ninños y niñas a temprana edad '              , 1, 2, 10, 2),
	(2, 'Área de biblioteca'              ,'Cuenta con 250 puestos de lectura y un sector destinado al servicio de acceso a Internet'                                                                                    , 2, 4, 9, 2),
	(3, 'Auditórium '                     ,'Área moderna con capacidad máxima de 358 personas, diseñado y equipado para presentar diversas actividades artísticas, culturales y educativas'                              , 1, 1, 8, 1),
	(4, 'Área de computación'             ,'Área con capacidad para 70 personas, el cual posee cubículos individuales con ordenadores y 8 terminales de autoconsulta'                                                    , 1, 3, 7, 2),
	(5, 'Sala de investigación'           ,'Cuenta con 50 mesas para estudio e investigación provistos con equipos informáticos con acceso a Internet, '                                                                 , 4, 6, 6, 2),
	(6, 'Área de promoción de inclusión'  ,'Posee 20 equipos, 10 de ellos adaptados para personas con discapacidad, salas de lectura adecuadas, líneas Braïlle, lupas y colecciones de audiolibros.'                     , 1, 9, 5, 2),
	(7, 'Sala de proyección'              ,'Área equipada con 15 mesas y 5 ordenadores en cada mesa, material bibliografico básico recomendado en las asignaturas, así mismo cuenta con una capacidad para 200 personas' , 2, 7, 4, 1),
	(8, 'Área de la biblioteca'           ,'Posee mesas de trabajo individual, cubículo-sofá con pantalla para trabajo en grupo, butacas y 5 ordenadores para consulta de cátalogo virtual'                              , 4, 5, 3, 2),
	(9, 'Área de computación'             ,'Cuenta con 25 equipos para alumnos y uno para el profesor. También disponen de pantalla, pizarra, proyector, conexión WIFI y webcam.'                                        , 3, 10, 2, 2),
	(10, 'Sala de proyección'             ,'Cuenta con 10 mesas y 8 sillas cada mesa, 5 ordenadores disponibles para consultas, conexión WIFI, Webcam y Conexiones HDMI.'                                                , 3, 8, 1, 2);

INSERT INTO ROL(id,rol) VALUES 
    (1,'Administrador'),
    (2,'Usuario'      );

INSERT INTO TELEFONO(id,telefono) VALUES
    (2, '+50375689023'),
	(8, '+50323612089'),
	(1, '+50378750184'),
	(9, '+50361207843'),
	(7, '+50325891267'),
	(3, '+50371988811'),
	(5, '+50375917682'),
	(6, '+50326063456'),
	(4, '+50376892492'),
	(10,'+50368971485');

INSERT INTO TELEFONO (id, telefono) VALUES 
(11,     '+50366702235'),
(12,     '+50364130213'),
(13,     '+50363723560'),
(14,     '+50369339635'),
(15,     '+50366961231'),
(16,     '+50362058103'),
(17,     '+50367469154'),
(18,     '+50369219281'),
(19,     '+50364264311'),
(20,     '+50367304937'),
(21,     '+50367765082'),
(22,     '+50361087066'),
(23,     '+50366520589'),
(24,     '+50366233019'),
(25,     '+50365904852'),
(26,     '+50368240231'),
(27,     '+50369159146'),
(28,     '+50364981574'),
(29,     '+50361570472'),
(30,     '+50369575258'),
(31,     '+50368528177'),
(32,     '+50368321151'),
(33,     '+50368446456'),
(34,     '+50364396921'),
(35,     '+50364214958'),
(36,     '+50369401146'),
(37,     '+50365201697'),
(38,     '+50364725953'),
(39,     '+50367559409'),
(40,     '+50365160020'),
(41,     '+50361551521'),
(42,     '+50367213388'),
(43,     '+50364866546'),
(44,     '+50361781966'),
(45,     '+50361329409'),
(46,     '+50365408283'),
(47,     '+50364338618'),
(48,     '+50364629907'),
(49,     '+50364772419'),
(50,     '+50363192098'),
(51,     '+50366230685'),
(52,     '+50361384017'),
(53,     '+50361863988'),
(54,     '+50364171437'),
(55,     '+50367581080'),
(56,     '+50365948706'),
(57,     '+50364905937'),
(58,     '+50363770004'),
(59,     '+50367736251'),
(60,     '+50367414252'),
(61,     '+50364455578'),
(62,     '+50366179664'),
(63,     '+50363928423'),
(64,     '+50361759621'),
(65,     '+50368557009'),
(66,     '+50363405683'),
(67,     '+50363653270'),
(68,     '+50368557987'),
(69,     '+50369307728'),
(70,     '+50363755417'),
(71,     '+50362361009'),
(72,     '+50365626007'),
(73,     '+50361873213'),
(74,     '+50368229952'),
(75,     '+50368295861'),
(76,     '+50365709081'),
(77,     '+50362470581'),
(78,     '+50365909042'),
(79,     '+50361927710'),
(80,     '+50365845448'),
(81,     '+50364306037'),
(82,     '+50362872065'),
(83,     '+50362133830'),
(84,     '+50366333066'),
(85,     '+50367655726'),
(86,     '+50363560163'),
(87,     '+50362232002'),
(88,     '+50366187982'),
(89,     '+50369097919'),
(90,     '+50364885538'),
(91,     '+50367353275'),
(92,     '+50363995782'),
(93,     '+50365814006'),
(94,     '+50363853008'),
(95,     '+50365197441'),
(96,     '+50366245175'),
(97,     '+50364594731'),
(98,     '+50369004491'),
(99,     '+50368964626'),
(100,    '+50365042661'),
(101,    '+50361633762'),
(102,    '+50367237006'),
(103,    '+50366932703'),
(104,    '+50378902041'),
(105,    '+50376598619'),
(106,    '+50376460383'),
(107,    '+50373407589'),
(108,    '+50371835393'),
(109,    '+50375553373'),
(110,    '+50372358734'),
(111,    '+50373292798'),
(112,    '+50372676826'),
(113,    '+50374173109'),
(114,    '+50373639302'),
(115,    '+50371470081'),
(116,    '+50375295792'),
(117,    '+50373415462'),
(118,    '+50373262483'),
(119,    '+50372855771'),
(120,    '+50378031245'),
(121,    '+50371973367'),
(122,    '+50376188856'),
(123,    '+50375654724'),
(124,    '+50376809757'),
(125,    '+50379643502'),
(126,    '+50375087918'),
(127,    '+50375322758'),
(128,    '+50371019887'),
(129,    '+50376323126'),
(130,    '+50376360576'),
(131,    '+50374664259'),
(132,    '+50372895522'),
(133,    '+50379205174'),
(134,    '+50376204392'),
(135,    '+50376433607'),
(136,    '+50378437407'),
(137,    '+50375371825'),
(138,    '+50375554402'),
(139,    '+50372886514'),
(140,    '+50379435401'),
(141,    '+50371633213'),
(142,    '+50376480894'),
(143,    '+50373692711'),
(144,    '+50377354343'),
(145,    '+50377302027'),
(146,    '+50376033024'),
(147,    '+50379428576'),
(148,    '+50376802294'),
(149,    '+50374997698'),
(150,    '+50375625324'),
(151,    '+50378390931'),
(152,    '+50372590983'),
(153,    '+50377100820'),
(154,    '+50378984640'),
(155,    '+50374055563'),
(156,    '+50374732078'),
(157,    '+50371366709'),
(158,    '+50379212077'),
(159,    '+50377632647'),
(160,    '+50378849349'),
(161,    '+50379759001'),
(162,    '+50371662906'),
(163,    '+50371878606'),
(164,    '+50375015376'),
(165,    '+50374584037'),
(166,    '+50379247036'),
(167,    '+50378899914'),
(168,    '+50377668368'),
(169,    '+50375651618'),
(170,    '+50376088036'),
(171,    '+50372040990'),
(172,    '+50378819734'),
(173,    '+50378118851'),
(174,    '+50376723750'),
(175,    '+50379131969'),
(176,    '+50373425253'),
(177,    '+50374877642'),
(178,    '+50371416501'),
(179,    '+50378416719'),
(180,    '+50373144416'),
(181,    '+50371422770'),
(182,    '+50371970697'),
(183,    '+50377372979'),
(184,    '+50376002181'),
(185,    '+50376527363'),
(186,    '+50377387838'),
(187,    '+50378436991'),
(188,    '+50376549474'),
(189,    '+50376952530'),
(190,    '+50371370562'),
(191,    '+50374108415'),
(192,    '+50371249771'),
(193,    '+50379539860'),
(194,    '+50372290044'),
(195,    '+50375977576'),
(196,    '+50374524647'),
(197,    '+50377424115'),
(198,    '+50375274447'),
(199,    '+50377405316'),
(200,    '+50379562598'),
(201,    '+50375611695'),
(202,    '+50373266612'),
(203,    '+50373980542'),
(204,    '+50379948008'),
(205,    '+50376700728'),
(206,    '+50378683076'),
(207,    '+50372374600'),
(208,    '+50371379212'),
(209,    '+50379137918'),
(210,    '+50377970083'),
(211,    '+50373425153'),
(212,    '+50379113807'),
(213,    '+50371287641'),
(214,    '+50373544175'),
(215,    '+50372119560'),
(216,    '+50373796597'),
(217,    '+50372342530'),
(218,    '+50373997241'),
(219,    '+50372311088'),
(220,    '+50374174200'),
(221,    '+50376926066'),
(222,    '+50377547729'),
(223,    '+50376125394'),
(224,    '+50372740228'),
(225,    '+50371402174'),
(226,    '+50376073848'),
(227,    '+50373087373'),
(228,    '+50371600080'),
(229,    '+50371799100'),
(230,    '+50373468887'),
(231,    '+50373485037'),
(232,    '+50371678720'),
(233,    '+50372098545'),
(234,    '+50376889354'),
(235,    '+50371919304'),
(236,    '+50372151652'),
(237,    '+50373830171'),
(238,    '+50379102931'),
(239,    '+50373619197'),
(240,    '+50379844988'),
(241,    '+50376757421'),
(242,    '+50375902031'),
(243,    '+50371406326'),
(244,    '+50376960145'),
(245,    '+50371757849'),
(246,    '+50371568917'),
(247,    '+50374924227'),
(248,    '+50377257064'),
(249,    '+50376998137'),
(250,    '+50373264724'),
(251,    '+50374185296'),
(252,    '+50378187904'),
(253,    '+50374051967'),
(254,    '+50377144789'),
(255,    '+50371007640'),
(256,    '+50373658208'),
(257,    '+50375636915'),
(258,    '+50375677098'),
(259,    '+50378380210'),
(260,    '+50377649318'),
(261,    '+50372198701'),
(262,    '+50379200193'),
(263,    '+50377065961'),
(264,    '+50372017324'),
(265,    '+50378121669'),
(266,    '+50378227089'),
(267,    '+50375769462'),
(268,    '+50371242083'),
(269,    '+50372694668'),
(270,    '+50373511180'),
(271,    '+50378340470'),
(272,    '+50378858855'),
(273,    '+50371276639'),
(274,    '+50371445787'),
(275,    '+50378591055'),
(276,    '+50372339124'),
(277,    '+50378912665'),
(278,    '+50375427159'),
(279,    '+50378578311'),
(280,    '+50377244236'),
(281,    '+50375783065'),
(282,    '+50372737611'),
(283,    '+50378887743'),
(284,    '+50373791302'),
(285,    '+50373316018'),
(286,    '+50373421984'),
(287,    '+50377888655'),
(288,    '+50378242713'),
(289,    '+50371457119'),
(290,    '+50373936927'),
(291,    '+50375491217'),
(292,    '+50375229554'),
(293,    '+50375837338'),
(294,    '+50373209537'),
(295,    '+50373525016'),
(296,    '+50376945533'),
(297,    '+50374996750'),
(298,    '+50377817210'),
(299,    '+50379077160'),
(300,    '+50375383707'),
(301,    '+50376446490'),
(302,    '+50378255703'),
(303,    '+50379314479'),
(304,    '+50374315494'),
(305,    '+50376546635'),
(306,    '+50376470825'),
(307,    '+50374543959'),
(308,    '+50378358283'),
(309,    '+50377774751'),
(310,    '+50371196814'),
(311,    '+50378135508'),
(312,    '+50373041208'),
(313,    '+50379106272'),
(314,    '+50379870271'),
(315,    '+50374158957'),
(316,    '+50374607649'),
(317,    '+50371062078'),
(318,    '+50375435762'),
(319,    '+50377683157'),
(320,    '+50377213668'),
(321,    '+50378767321'),
(322,    '+50375750618'),
(323,    '+50371339817'),
(324,    '+50372819057'),
(325,    '+50372737382'),
(326,    '+50375346543'),
(327,    '+50371055437'),
(328,    '+50376045735'),
(329,    '+50378083230'),
(330,    '+50374011595'),
(331,    '+50378740041'),
(332,    '+50372176021'),
(333,    '+50375398935'),
(334,    '+50376871225'),
(335,    '+50378920050'),
(336,    '+50375752926'),
(337,    '+50379151861'),
(338,    '+50379350064'),
(339,    '+50372028955'),
(340,    '+50377099960'),
(341,    '+50375013540'),
(342,    '+50378306236'),
(343,    '+50372695458'),
(344,    '+50378813347'),
(345,    '+50378342200'),
(346,    '+50378956231'),
(347,    '+50373230530'),
(348,    '+50379711403'),
(349,    '+50379283325'),
(350,    '+50377906536'),
(351,    '+50377739093'),
(352,    '+50375304774'),
(353,    '+50375890892'),
(354,    '+50378611643'),
(355,    '+50379821529'),
(356,    '+50371061795'),
(357,    '+50377353201'),
(358,    '+50375362142'),
(359,    '+50377524812'),
(360,    '+50372232101'),
(361,    '+50379459960'),
(362,    '+50371409027'),
(363,    '+50378573975'),
(364,    '+50374225740'),
(365,    '+50377478680'),
(366,    '+50375249134'),
(367,    '+50372087388'),
(368,    '+50373526120'),
(369,    '+50374360492'),
(370,    '+50373599164'),
(371,    '+50378861447'),
(372,    '+50377648101'),
(373,    '+50378589096'),
(374,    '+50377881202'),
(375,    '+50376736205'),
(376,    '+50372071731'),
(377,    '+50379660611'),
(378,    '+50371547688'),
(379,    '+50371617242'),
(380,    '+50373625575'),
(381,    '+50374888106'),
(382,    '+50375928649'),
(383,    '+50377829991'),
(384,    '+50376966318'),
(385,    '+50373721078'),
(386,    '+50372385034'),
(387,    '+50378540893'),
(388,    '+50372790336'),
(389,    '+50377515101'),
(390,    '+50372826391'),
(391,    '+50374119742'),
(392,    '+50373535582'),
(393,    '+50378513037'),
(394,    '+50374672050'),
(395,    '+50371849724'),
(396,    '+50375575571'),
(397,    '+50378832472'),
(398,    '+50377810279'),
(399,    '+50379137905'),
(400,    '+50374201491'),
(401,    '+50375028042'),
(402,    '+50371204503'),
(403,    '+50379451510'),
(404,    '+50372037214'),
(405,    '+50373422022'),
(406,    '+50376336793'),
(407,    '+50372764749'),
(408,    '+50379947988'),
(409,    '+50371817480'),
(410,    '+50376861323'),
(411,    '+50377591462'),
(412,    '+50371722090'),
(413,    '+50377028183'),
(414,    '+50377069894'),
(415,    '+50373016156'),
(416,    '+50373800329'),
(417,    '+50374153000'),
(418,    '+50374758408'),
(419,    '+50378699993'),
(420,    '+50377239333'),
(421,    '+50374558310'),
(422,    '+50377058460'),
(423,    '+50371231366'),
(424,    '+50379656991'),
(425,    '+50371848787'),
(426,    '+50379149357'),
(427,    '+50371507246'),
(428,    '+50379766383'),
(429,    '+50371094810'),
(430,    '+50378704453'),
(431,    '+50371006706'),
(432,    '+50375127725'),
(433,    '+50379327709'),
(434,    '+50376341261'),
(435,    '+50379198606'),
(436,    '+50377952846'),
(437,    '+50379147197'),
(438,    '+50375147287'),
(439,    '+50378852782'),
(440,    '+50373990684'),
(441,    '+50373657533'),
(442,    '+50376287955'),
(443,    '+50375429083'),
(444,    '+50371844737'),
(445,    '+50373221201'),
(446,    '+50373771782'),
(447,    '+50377836839'),
(448,    '+50373599769'),
(449,    '+50378875455'),
(450,    '+50377539393'),
(451,    '+50372144412'),
(452,    '+50374075529'),
(453,    '+50375904296'),
(454,    '+50377241762'),
(455,    '+50373424330'),
(456,    '+50374941328'),
(457,    '+50374019715'),
(458,    '+50376211639'),
(459,    '+50371793121'),
(460,    '+50374010532'),
(461,    '+50376863687'),
(462,    '+50374788442'),
(463,    '+50372742616'),
(464,    '+50373004645'),
(465,    '+50371030561'),
(466,    '+50378789587'),
(467,    '+50372310951'),
(468,    '+50376240984'),
(469,    '+50376335589'),
(470,    '+50371876352'),
(471,    '+50376653470'),
(472,    '+50379500826'),
(473,    '+50372767455'),
(474,    '+50378454622'),
(475,    '+50375751188'),
(476,    '+50378608763'),
(477,    '+50376498520'),
(478,    '+50371217986'),
(479,    '+50371365959'),
(480,    '+50373965842'),
(481,    '+50375377054'),
(482,    '+50374631909'),
(483,    '+50372251761'),
(484,    '+50374095570'),
(485,    '+50379515539'),
(486,    '+50376264364'),
(487,    '+50374888249'),
(488,    '+50376729272'),
(489,    '+50375259477'),
(490,    '+50373752946'),
(491,    '+50373976116'),
(492,    '+50376898457'),
(493,    '+50372037938'),
(494,    '+50376784173'),
(495,    '+50377832299'),
(496,    '+50374075756'),
(497,    '+50372788775'),
(498,    '+50373111222'),
(499,    '+50373023147'),
(500,    '+50376181895');

INSERT INTO USUARIO(id,nombre,email,foto,cod_qr,direccion,institucion,ocupacion,id_rol_usuario,id_telefono,password_user) VALUES
    (1, 'Miguel Alejandro Navarro' , 'AleNavarro12@bandesal.gob.sv', 0xe324f0b249, 0x2b3c903a39, '87 Ave. Sur, No. 13, Colonia Escalón',                          'Banco de Desarrollo de la República de El Salvador', 'Director de planificación y desarrollo institucional',               2, 3, HASHBYTES('SHA2_256','PASSWORD')),
	(2, 'Daniela Michelle Torres'  , 'MichelleTorres@hotmail.com'  , 0xd3b0ea90e2, 0x9d3718d217, 'Avenida Monseñor Romero y Final Calle 5 de Noviembre, No. 117', 'Fondo social para la vivienda'                     , 'Analista en gestión ambiental',                                      1, 6, HASHBYTES('SHA2_256','PASSWORD')),
	(3, 'Martín Elías Acosta'      , 'Martin@isss.gob.sv'          , 0xec891e49a3, 0xbcbd383ffa, 'Alameda Juan Pablo II y 39 Avenida Norte, No.23',               'Instituto Salvadoreño del Seguro Social'           , 'Subdirector General del ISSS',                                       1, 5, HASHBYTES('SHA2_256','PASSWORD')),
	(4, 'Valeria Alexandra Escobar', 'Valeria-Escobar@ujmd.edu.sv' , 0xa896ef90b5, 0xe87e91ad41, '81 Avenida Norte, entre 7a y 9a Calle Poniente #162',           'Universidad Dr. José Matías Delgado'               , 'Directora de la Facultad de Cultura General “Francisco Gavidia”',    2, 7, HASHBYTES('SHA2_256','PASSWORD')),
	(5, 'Adriana Carolina Martinez', 'AdrianaMa2018@fonaes.gob.sv' , 0x82164d6a19, 0xc615c67f55, 'Calle La Reforma, Casa #230, Colonia San Benito',               'Fondo Ambiental de El Salvador'                    , 'Técnica de prensa y redacción',                                      2, 1, HASHBYTES('SHA2_256','PASSWORD')),
	(6, 'Carlos Gustavo Sánchez'   , 'Carlos.gustavo1@gmail.com'   , 0x67b0a8b231, 0xcbdefdf2d8, '99 Avenida Norte y final 9a Calle Poniente Bis # 624',          'Consejo Salvadoreño de la Agroindustria Azucarera' , 'Técnico Agroindustrial',                                             2, 10, HASHBYTES('SHA2_256','PASSWORD')),
	(7, 'Adyni Arleht Pocasangre'  , 'AdyniPocasangre@hotmail.com' , 0xa14dc953e7, 0x67c79042ea, 'Boulevard del Hipódromo No. 444, Colonia San Benito',           'Superintendencia del Sistema Financiero'           , 'Coordinador del Departamento de Supervisión de Bancos Cooperativos', 1, 2, HASHBYTES('SHA2_256','PASSWORD')),
	(8, 'Carlos Eduardo Grande'    , 'Carlos.Grande@hotmail.com'   , 0x5fe7b81037, 0x1a3f8b3fd9, 'Boulevard Sergio Vieira de Mello No. 243, San Francisco',       'Consejo Superior de Salud Pública'                 , 'Coordinador de Gestión Documental y Archivo',                        2, 4, HASHBYTES('SHA2_256','PASSWORD')),
	(9, 'Iris Yanet Aguilar'       , 'Iris.yanet@seguridad.gob.sv' , 0x3c74e27a95, 0x8607165eee, 'Bulevar Tutunichapa, Casa N° 510',                              'Dirección General de Centros Penales'              , 'Directora del Consejo Criminológico Nacional',                       2, 8, HASHBYTES('SHA2_256','PASSWORD')),
	(10, 'José Luis Menjívar'      , 'Jose.Menjivar@gmail.com'     , 0x33b116c164, 0x6e80981b8e, 'Calle El Mirador, entre 87 y 89 Av. Norte, No.12',              'Registro Nacional de las Personas Naturales'       , 'Asesor jurídico',                                                    2, 9, HASHBYTES('SHA2_256','PASSWORD'));

INSERT INTO USUARIO (id, id_rol_usuario, id_telefono, nombre, email, password_user, direccion, institucion, ocupacion, foto, cod_qr) VALUES
(11,    2,  142,	    'Astra Vineall',    	'avinealla@ucoz.ru',            	'Qb7GmvD',  	'19 Heffernan Crossing',        'Yost-Kling',   	                'Director of Sales'         ,   0xe324f0b249    ,   0x2b3c903a39    ),
(12,    2,  205,	    'Shane Benediktovich',	'sbenediktovichb@theguardian.com',	'xpe0i4h4',	    '94404 Ronald Regan Street',    'Hills-Ryan',                   	'Nuclear Power Engineer'    ,   0xd3b0ea90e2    ,   0x9d3718d217    ),
(13,    2,  177,	    'Selena Rusted',    	'srustedc@ehow.com',            	'dWSjM6BvoRW',	'81 8th Alley',	                'McKenzie, Gerhold and Hagenes',	'Assistant Professor'       ,   0xec891e49a3    ,   0xbcbd383ffa    ),
(14,    2,  460,	    'Bethany Niess',    	'bniessd@ehow.com',             	'nQzvcGPfBMl',	'09 Ohio Court',        	    'Hane Group',               	    'Pharmacist'                ,   0xa896ef90b5    ,   0xe87e91ad41    ),
(15,    2,  116,	    'Tracey Kahler',    	'tkahlere@cisco.com',           	'ZuQuVL',	    '58 Raven Plaza',	            'Gutmann and Sons',         	    'Recruiter'                 ,   0x82164d6a19    ,   0xc615c67f55    ),
(16,    2,  261,	    'Arabela Emmert',   	'aemmertf@typepad.com',         	'yr9Zx5h',	    '5 4th Avenue',	                'Lynch, Franecki and Cormier',	    'Assistant Manager'         ,   0x67b0a8b231    ,   0xcbdefdf2d8    ),
(17,    2,  29,	        'Gradey Targe',     	'gtargeg@wix.com',              	'VDPuSv',   	'57726 Forest Dale Terrace',	'Morar Group',	                    'Help Desk Operator'        ,   0xa14dc953e7    ,   0x67c79042ea    ),
(18,    2,  299,	    'Olivie Baston',    	'obastonh@spotify.com',         	'F8rGXMl',  	'01 Stuart Road',	            'Mitchell, Conn and Abernathy',	    'Computer Systems Analyst I',   0x5fe7b81037    ,   0x1a3f8b3fd9    ),
(19,    2,  379,	    'Huntlee Lyal',     	'hlyali@kickstarter.com',       	'ibfR7v',   	'8 Shopko Point',	            'Rice, Murray and Rath',	        'Associate Professor'       ,   0x3c74e27a95    ,   0x8607165eee    ),
(20,    2,  20,	        'Olwen Ivanishin',  	'oivanishinj@furl.net',         	'S9OkJp',   	'69 Jana Trail',	            'Runolfsson, Harris and Turcotte',	'Civil Engineer'            ,   0x33b116c164    ,   0x6e80981b8e    ),
(21,    2,  76,	        'Allistir Vanichev',    'avanichevk@mozilla.org',       	'PJRIaH',   	'2 Eagan Drive',	            'Schumm-Hirthe',	                'Research Associate'        ,   0xa14dc953e7    ,   0x67c79042ea    ),
(22,    2,  452,	    'Lucille Lamberto', 	'llambertol@omniture.com',      	'fO0b1d',   	'1 Anniversary Circle',     	'Wilkinson, Considine and Witting',	'Senior Developer'          ,   0x5fe7b81037    ,   0x1a3f8b3fd9    ),
(23,    2,  277,	    'Jimmy Fayerman',   	'jfayermanm@phpbb.com',         	'Ki90wkFEvj0p',	'0416 Oriole Park',         	'Hartmann Group',	                'Senior Cost Accountant'    ,   0x3c74e27a95    ,   0x8607165eee    ),
(24,    2,  21,	        'Kelila Gibbie',    	'kgibbien@rakuten.co.jp',    	    '0gFD74MZbNZn',	'0 Gulseth Parkway',	        'Bergstrom-Cronin', 	            'Staff Scientist'           ,   0x33b116c164    ,   0x6e80981b8e    );




INSERT INTO ACTIVIDAD(id,fecha_inicio,fecha_final,id_evento,id_area,id_usuario) VALUES
    (1, '220312 08:30:00 AM' ,'220313 01:00:00 PM', 1 ,7, 9),
	(2, '220401 09:00:00 AM' ,'220401 11:00:00 AM', 3 ,4, 1),
	(3, '220402 10:45:00 AM' ,'220402 05:45:00 PM', 8 ,6, 6),
	(4, '220217 07:15:00 AM' ,'220219 09:30:00 AM', 5, 3, 4),
	(5, '220501 09:30:00 AM' ,'220501 01:30:00 PM', 7, 10, 10),
	(6, '220312 01:30:00 PM' ,'220312 07:30:00 PM', 2, 9 ,2),
	(7, '220227 02:20:00 PM' ,'220228 04:30:00 PM', 9, 4 ,5),
	(8, '220110 07:00:00 AM' ,'220115 12:00:00 PM', 4, 7, 7),
	(9, '220530 08:30:00 AM' ,'220530 10:30:00 AM', 10, 2, 4),
	(10,'220124 03:50:00 PM' ,'220127 06:50:00 PM', 6, 3, 3),
	(11,'220401 09:00:00 AM' ,'220401 11:00:00 AM', 3, 4, 9),
	(12,'220312 08:30:00 AM' ,'220313 01:00:00 PM', 1, 7, 4),
	(13,'220312 08:30:00 AM' ,'220313 01:00:00 PM', 1, 7, 6),
	(14,'220501 09:30:00 AM' ,'220501 01:30:00 PM', 7, 10, 1),
	(15,'220227 02:20:00 PM' ,'220228 04:30:00 PM', 9 ,4, 8),
	(16,'220217 07:15:00 AM' ,'220219 09:30:00 AM', 5 ,3, 7),
	(17,'220124 03:50:00 PM' ,'220127 06:50:00 PM', 6, 3, 5),
	(18,'220530 08:30:00 AM' ,'220530 10:30:00 AM', 10, 2, 2),
	(19,'220312 08:30:00 AM' ,'220313 01:00:00 PM', 1, 7, 10),
	(20,'220312 01:30:00 PM' ,'220312 07:30:00 PM', 2, 9, 8);

INSERT INTO ASISTENCIA(id_actividad, id_usuario,fecha_entrada,fecha_salida) VALUES
    (1,  9, '220312 08:30:00 AM' ,'220312 01:00:00 PM' ),
	(2,  1, '220401 09:00:00 AM' ,'220401 11:00:00 AM' ),
	(3,  6, '220402 10:45:00 AM' ,'220402 05:45:00 PM' ),
	(4,  4, '220217 07:15:00 AM' ,'220217 09:30:00 AM' ),
	(5,  10,'220501 09:30:00 AM' ,'220501 01:30:00 PM' ),
	(6,  2, '220312 01:30:00 PM' ,'220312 07:30:00 PM' ),
	(7,  5, '220227 02:20:00 PM' ,'220228 04:30:00 PM' ),
	(8,  7, '220111 07:00:00 AM' ,'220111 12:00:00 PM' ),
	(9,  4, '220530 08:30:00 AM' ,'220530 10:30:00 AM' ),
	(10, 3, '220124 03:50:00 PM' ,'220127 06:50:00 PM' ),
	(11, 9, '220401 09:00:00 AM' ,'220401 11:00:00 AM' ),
	(12, 4, '220312 08:30:00 AM' ,'220312 01:00:00 PM' ),
	(13, 6, '220312 08:30:00 AM' ,'220313 01:00:00 PM' ),
	(14, 1, '220501 09:30:00 AM' ,'220501 01:30:00 PM' ),
	(15, 8, '220227 02:20:00 PM' ,'220228 04:30:00 PM' ),
	(16, 7, '220217 07:15:00 AM' ,'220218 09:30:00 AM' ),
	(17, 5, '220125 03:50:00 PM' ,'220126 06:50:00 PM' ),
	(18, 2, '220530 08:30:00 AM' ,'220530 10:30:00 AM' ),
	(19, 10,'220312 08:30:00 AM' ,'220313 01:00:00 PM' ),
	(20, 8, '220312 01:30:00 PM' ,'220312 07:30:00 PM' );

INSERT INTO DISPONIBILIDAD_EJEMPLAR(id, disponible) VALUES
    (1,0),
	(2,1);

INSERT INTO AUTOR(id,nombre) VALUES
    (1, 'Homero'                   ),
	(2, 'Gabriel García Márquez'   ),
	(3, 'Isaac Newton'             ),
	(4, 'George B. Thomas'         ),
	(5, 'Jesús Delgado'            ),
	(6, 'Peter Whitfield'          ),
	(7, 'David Ross'               ), 
	(8, 'Carlos Bosch García'      ),
	(9, 'Felipe Clemente de Diego' ),
	(10,'Jean Breschand'           ),
	(11,'J.K. Rowling'             ),
	(12,'Ahniki'                   ),
	(13,'Marilda Aparecida Behrens'),
	(14,'Dante Alighieri'          ),
	(15,'Beverley Birch'           ),
	(16,'Charles Perrault'         );


INSERT INTO ID_BIBLIOGRAFICO(id,tipo,identificador) VALUES
    (1, 'ISBN', '9781532979685'),
	(2, 'ISBN', '9788418359286'),
	(3, 'ISBN', '9788423433322'),
	(4, 'ISBN', '9788466672276'),
	(5, 'ISBN', '9788408252856'),
	(6, 'ISBN', '9782890192087'),
	(7, 'ISBN', '9788419085726'),
	(8, 'ISBN', '9788418440342'),
	(9, 'ISBN', '9788408258360'),
	(10, 'ISBN', '9788418483448'),
	(11, 'ISBN', '9788432228544'),
	(12, 'ISBN', '9788412539523'),
	(13, 'ISBN', '9788408240662'),
	(14, 'ISBN', '9788491291916'),
	(15, 'ISBN', '9788423361564'),
	(16, 'ISBN', '9788418037429'),
	(17, 'DOI', '10.1007/978-3-642-1757' ),
	(18, 'DOI', '10.1145/1067268.1067287'),
	(19, 'DOI', '10.1912/1808-5245232.59'),
	(20, 'DOI', '10.1653/1064168.153457' ), 
	(21, 'DOI', '10.1825/197768.165637'  ), 
	(22, 'DOI', '10.1233/1756368.1763227'); 
		  
INSERT INTO FORMATO(id,formato) VALUES
    (1,'Físico'),
	(2,'Digital');

INSERT INTO IDIOMA(id,idioma) VALUES
    (1,'Español'),
	(2,'Inglés'),
	(3,'Francés'),
	(4,'Italiano'),
	(5,'Coreano'),
	(6,'Portugués');

INSERT INTO EDITORIAL(id,editorial) VALUES
    (1, 'Casa del libro'), 
	(2, 'Sudamericana'),
	(3, 'CreateSpace Independent Publishing'),
	(4, 'Pearson Education'),
	(5, 'PPC'),
	(6, 'British Library'),
	(7, 'Trillas SA. DE SV.'), 
	(8, 'Les Cahiers du Cinéma'),
	(9, 'Einaudi'),
	(10,'Salamandra Infantil y Juvenil'),
	(11,'Futuropolis'),
	(12,'Revista Portuguesa De Educação' ),
	(13,'La Chispa'), 
	(14,'La Galera');

INSERT INTO GENERO(id,nombre) VALUES
   	(1, 'Científico'              ),
	(2, 'Períodistico'            ),
	(3, 'Documental'              ),
	(4, 'Académico '              ),
	(5, 'Historia'                ),
	(6, 'Literatura clásica'      ),
	(7, 'Literatura contemporánea'), 
	(8, 'Filosófico'              ),
	(9, 'Multimedia'              ),
	(10, 'Artístico'              ),
	(11, 'Literario'              ),
	(12, 'Matématico'             );

INSERT INTO TIPO_COLECCION(id,nombre) VALUES
    (1,  'Tesis'                  ),
	(2,  'Manuscritos'            ),
	(3,  'Libro antiguo'          ),
	(4,  'Libro moderno'          ),
	(5,  'Revistas y periódicos'  ),
	(6,  'Ciencias exactas'       ),
	(7,  'Audio y vídeo'          ), 
	(8,  'Biografía'              ),
	(9,  'Investigaciones'        ),
	(10, 'Archivos y documentales'),
	(11, 'Enciclopedias '         ),
	(12, 'Artículos'              ),
	(13,  'Bibliografías'         ),
	(14,  'Libros juveniles'      ),
	(15,  'Libros infantiles'     ),
	(16,  'Historietas'           ); 

INSERT INTO COLECCION(id,nombre,id_tipo,id_genero) VALUES
	(1,'General'       , 6 , 1),
    (2,'Nacional'      , 10, 5),
    (3,'Internacional' , 10, 5),
    (4,'Tesario'       , 1, 4),
	(5,'Hemeroteca'    , 5, 2), 
	(8,'Referencia'    , 11, 4),
	(9,'Audiovisuales' , 7, 9),
    (10,'Reserva'      , 6, 4),
	(11,'Juventud '    , 14, 11);

INSERT INTO EJEMPLAR(id,nombre,fecha_publicacion,portada,id_coleccion,id_autor,id_bibliografico,id_editorial,id_idioma,id_formato,id_disponibilidad_ejemplar) VALUES
    (1,  'La Ilíada'                                                                                 , '1921-07-13', 0xb14367f3f4,  1, 1, 1, 1, 1, 1, 1),
	(2,  'Cien años de soledad'                                                                      , '1967-06-05', 0xb7c73564d4,  1, 2, 2, 2, 1, 1, 1),
	(3,  'The principia : mathematical principles of natural philosophy'                             , '1687-07-02', 0x481e727aab,  1, 3, 3, 3, 2, 1, 1),
	(4,  'Thomas calculus'                                                                           , '2010-01-01', 0x8b3c35b12e,  10, 4, 4, 4, 2, 1, 1),
	(5,  'Oscar Arnulfo Romero: Biografía'                                                           , '1986-03-30', 0x5811f39237,  2, 5, 5, 5, 1, 1, 2),
	(6,  'The image of the world'                                                                    , '2010-07-10', 0xe8acf7da66,  5, 6, 6, 6, 2, 1, 2),
	(7,  'Teoría de las ideas de Platón'                                                             , '1986-02-28', 0x31d82f8b3e,  4, 7, 7, 1, 1, 1, 1),
	(8,  'La Técnica de investigación documental'                                                    , '1973-08-04', 0x31d82f8b3e,  4, 8, 8, 7, 1, 1, 1),
	(9,  'Derecho judicial'                                                                          , '1942-04-15', 0x6ce8e0be54,  3, 9, 9, 1, 1, 1, 1),
	(10, 'Le documentaire: l autre face du cinéma'                                                   , '2002-12-22', 0xa96368bdb6,  9 , 10, 10, 8, 3, 1, 1),
	(11, 'Harry Potter y las reliquias de la muerte'                                                 , '2007-07-14', 0x7c1b54a949,  11, 11, 11, 9, 1, 1, 1),
	(12, 'Catharsis'                                                                                 , '2009-11-27', 0x7c1b54a949,  10, 12, 12, 10, 5, 1, 1),
	(13, 'Educação Transformadora: As interconexões das teorias de Freire e Morin'                   , '2020-12-30', 0x7c1b54a949,  1, 14, 13, 12, 4, 1, 2),
	(14, 'Louis Pasteur : un jeune chimiste français fit la découverte qui révolutionna la médecine' , '1990-12-26', 0x7c1b54a949,  3, 15, 14, 13, 3, 1, 2),
	(15, 'La Cenicienta'                                                                             , '1637-11-20', 0x7c1b54a949,  11, 11, 15, 14, 1, 1, 2),
	(16, 'La Ilíada'                                                                                 , '1921-07-13', 0xb14367f3f4,  1, 1, 17, 1, 1, 2, 1),
	(17, 'Oscar Arnulfo Romero : biografía'                                                          , '1967-06-05', 0x5811f39237,  2, 5, 18, 5, 1, 2, 1),
	(18, 'La Técnica de investigación documental'                                                    , '1973-08-04', 0x31d82f8b3e,  4, 8, 19, 7, 1, 2, 2),
	(19, 'Le documentaire: l autre face du cinéma'                                                   , '2002-12-22', 0xa96368bdb6,  9, 10, 20, 8, 3, 2, 2),
	(20, 'La Divina Commedia'                                                                        , '1965-08-13', 0x7c1b54a949,  1, 14, 21, 12, 4, 2, 2),
	(21, 'La Cenicienta'                                                                             , '1637-11-20', 0x7c1b54a949,  11, 11, 22, 14, 1, 2, 2);

INSERT INTO PRESTAMO_EJEMPLAR(id_usuario,id_ejemplar,fecha_prestamo,fecha_devolucion) VALUES
    (1, 4,'220315 09:30:00 AM','220325 02:30:00 PM'),
	(2, 8,'220312 07:45:00 AM','220321 09:40:00 AM'),
	(3, 2,'220401 08:32:00 AM','220314 07:25:00 AM'),
	(4, 10,'220327 02:40:00 PM','220329 04:33:00 PM'),
	(5, 16,'220507 07:42:00 AM','220513 01:06:00 PM'),
	(6, 3,'220212 08:14:00 AM','220219 08:30:00 AM'),
	(7, 7,'220423 07:40:00 AM','220428 11:56:00 AM'),
	(8, 12,'220503 10:58:00 AM','220307 02:30:00 PM'),
	(9, 1,'220113 04:30:00 PM','220328 08:23:00 AM'),
	(10, 9,'220318 08:30:00 AM','220324 03:36:00 PM');

INSERT INTO RESERVA_EJEMPLAR(id_usuario,id_ejemplar,fecha_reserva, fecha_devolucion) VALUES
    (1, 9,'220325 02:30:00 PM','220408  10:05:00 AM'),
	(2, 10,'220405 08:45:00 AM','220411 09:33:00 AM'),
	(3, 7,'220512 08:22:00 AM','220523 07:29:00 AM'),
	(4, 4,'220327 01:40:00 PM','220329 02:12:00 PM'),
	(5, 8,'220407 07:15:00 AM','220411 03:06:00 PM'),
	(6, 16,'220603 08:18:00 AM','220616 02:30:00 PM'),
	(7, 1,'220323 09:40:00 AM','220301 10:56:00 AM'),
	(8, 2,'220318 07:58:00 AM','220324 04:20:00 PM'),
	(9, 3,'220312 09:23:00 PM','220317 01:33:00 PM'),
	(10, 12,'220418 07:30:00 AM','220424 02:31:00 PM');

INSERT INTO PALABRA_CLAVE(id,etiqueta,id_ejemplar) VALUES 
    (1 ,'Guerra de Troya'             , 1),
	(2 ,'Aquiles'                     , 1),
	(3 ,'Epopeya griega'              , 1),
	(4 ,'Antigua Grecia'              , 1),
	(5 ,'dioses del Olimpo'           , 1),
	(6 ,'Familia Buendía'             , 2),
	(7 ,'Macondo'                     , 2), 
	(8 ,'Guerra civil'                , 2),
	(9 ,'Coronel Aureliano'           , 2),
	(10,'Cien años de soledad'        , 2),
	(11 ,'History of science'         , 3),
	(12,'Laws of motion'              , 3),
	(13,'Law of universal gravitation', 3),
	(14,'Physics'                     , 3),
	(15,'Science'                     , 3),
	(16,'Engineering'                 , 4),
	(17,'Transcendental Functions'    , 4),
	(18,'Techniques of Integration'   , 4),
	(19,'Derivatives'                 , 4),
	(20,'Integrals'                   , 4),
	(21,'Sacerdote católico'          , 5),
	(22,'Arzobispo '                  , 5),
	(23,'Defensor de los derechos'    , 5),
	(24,'Iglesia Católica '           , 5),
	(25,'Beato Óscar Romero'          , 5),
	(26,'Two thousand years'          , 6),
	(27,'Maps'                        , 6),
	(28,'Image of the World'          , 6),
	(29,'History of world'            , 6),
	(30,'Circular world map'          , 6),
	(31,'filosofía platónica'         , 7),
	(32,'Teoría de las formas'        , 7),
	(33,'Pensador revolucionario'     , 7),
	(34,'Teoría de las ideas'         , 7),
	(35,'Bibliografía'                , 7),
	(36,'Planteamiento del problema'  , 8),
	(37,'investigación documental'    , 8),
	(38,'Métodos'                     , 8),
	(39,'Referencias'                 , 8),
	(40,'Objeto de estudio'           , 8),
	(41,'Doctrinas'                   , 9),
	(42,'Ordenamientos'               , 9),
	(43,'Análisis sistemático'        , 9),
	(44,'Función jurisdiccional'      , 9),
	(45,'Normas jurídicas'            , 9),
	(46,'Fiction '                    , 10),
	(47,'Documentaire'                , 10),
	(48,'Capture d image'             , 10),
	(49,'Télévision les pratique,'    , 10),
	(50,'Histoire du documentaire'    , 10),
	(51,'Hogwarts'                    , 11),
	(52,'Secreto del poder'           , 11),
	(53,'Varita de Saúco'             , 11),
	(54,'Capa de Invisibilidad'       , 11),
	(55,'Piedra de la Resurrección'   , 11),
	(56,'See voices in colours'       , 12), 
	(57,'High school student'         , 12),
	(58,'Nightmares'                  , 12),
	(59,'Monsters'                    , 12),
	(60,'Synesthesia'                 , 12),
	(61,'Prática pedagógica'          , 13),
	(62,'fundamentos epistemológicos' , 13),
	(63,'Educação Transformadora'     , 13),
	(64,'Pensamento complexo'         , 13),
	(65,'Reforma de pensamento'       , 13),
	(66,'Révolutionna la médecine'    , 14),
	(67,'Fermentation'                , 14),
	(68,'Microbiologie'               , 14),
	(69,'Substances chimiques'        , 14),
	(70,'Génération spontanée'        , 14),
	(71,'Hermanastras'                , 15),
	(72,'Princesa'                    , 15),
	(73,'Hada mágica'                 , 15),
	(74,'Hechizo'                     , 15),
	(75,'Príncipe'                    , 15);
