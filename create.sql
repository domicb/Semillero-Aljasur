-- Generado por Oracle SQL Developer Data Modeler 4.0.0.825
--   en:        2015-03-23 16:49:00 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g


CREATE TABLE Ambiente
  (
    id_ambiente        NUMBER (8) NOT NULL ,
    Especie_id_especie NUMBER (8) NOT NULL
  ) ;
ALTER TABLE Ambiente ADD CONSTRAINT Ambiente_PK PRIMARY KEY ( id_ambiente ) ;

CREATE TABLE Carnivora
  ( id_especie NUMBER (8) NOT NULL
  ) ;
ALTER TABLE Carnivora ADD CONSTRAINT Carnivora_PK PRIMARY KEY ( id_especie ) ;

CREATE TABLE Comer
  (
    Carnivora_id_especie NUMBER (8) NOT NULL ,
    Especie_id_especie   NUMBER (8) NOT NULL
  ) ;
ALTER TABLE Comer ADD CONSTRAINT Comer__IDX PRIMARY KEY ( Carnivora_id_especie, Especie_id_especie ) ;

CREATE TABLE Ejemplar
  (
    id_ejemplar NUMBER (8) NOT NULL ,
    sexo        VARCHAR2 (15) ,
    fecha_nac   DATE ,
    comentario  VARCHAR2 (50)
  ) ;
ALTER TABLE Ejemplar ADD CONSTRAINT Ejemplar_PK PRIMARY KEY ( id_ejemplar ) ;

CREATE TABLE Especie
  (
    id_especie           NUMBER (8) NOT NULL ,
    nombre_popular       VARCHAR2 (15) ,
    nombre_cientifico    VARCHAR2 (15) ,
    descripcion          VARCHAR2 (50) ,
    Ejemplar_id_ejemplar NUMBER (8) NOT NULL
  ) ;
ALTER TABLE Especie ADD CONSTRAINT Especie_PK PRIMARY KEY ( id_especie ) ;

CREATE TABLE Estado
  (
    id_estado            NUMBER (8) NOT NULL ,
    estado               VARCHAR2 (50) ,
    Ejemplar_id_ejemplar NUMBER (8) NOT NULL
  ) ;
ALTER TABLE Estado ADD CONSTRAINT Estado_PK PRIMARY KEY ( id_estado ) ;

CREATE TABLE Herbivora
  ( id_especie NUMBER (8) NOT NULL
  ) ;
ALTER TABLE Herbivora ADD CONSTRAINT Herbivora_PK PRIMARY KEY ( id_especie ) ;

CREATE TABLE Planta
  (
    id_planta     NUMBER (8) NOT NULL ,
    nombre_planta VARCHAR2 (25)
  ) ;
ALTER TABLE Planta ADD CONSTRAINT Planta_PK PRIMARY KEY ( id_planta ) ;

CREATE TABLE Recipiente
  (
    id_recipiente   NUMBER (8) NOT NULL ,
    alto            NUMBER (6,2) NOT NULL ,
    ancho           NUMBER (6,2) NOT NULL ,
    largo           NUMBER (6,2) NOT NULL ,
    ambientes_repro VARCHAR2 (50)
  ) ;
ALTER TABLE Recipiente ADD CONSTRAINT Recipiente_PK PRIMARY KEY ( id_recipiente ) ;

CREATE TABLE Reproduce
  (
    Recipiente_id_recipiente NUMBER (8) NOT NULL ,
    Ambiente_id_ambiente     NUMBER (8) NOT NULL
  ) ;
ALTER TABLE Reproduce ADD CONSTRAINT Reproduce__IDX PRIMARY KEY ( Recipiente_id_recipiente, Ambiente_id_ambiente ) ;

CREATE TABLE Residir
  (
    Ejemplar_id_ejemplar     NUMBER (8) NOT NULL ,
    Recipiente_id_recipiente NUMBER (8) NOT NULL ,
    fecha_ini                DATE ,
    fecha_fin                DATE
  ) ;
ALTER TABLE Residir ADD CONSTRAINT Residir__IDX PRIMARY KEY ( Ejemplar_id_ejemplar, Recipiente_id_recipiente ) ;

ALTER TABLE Ambiente ADD CONSTRAINT Ambiente_Especie_FK FOREIGN KEY ( Especie_id_especie ) REFERENCES Especie ( id_especie ) ;

ALTER TABLE Especie ADD CONSTRAINT Especie_Ejemplar_FK FOREIGN KEY ( Ejemplar_id_ejemplar ) REFERENCES Ejemplar ( id_ejemplar ) ;

ALTER TABLE Estado ADD CONSTRAINT Estado_Ejemplar_FK FOREIGN KEY ( Ejemplar_id_ejemplar ) REFERENCES Ejemplar ( id_ejemplar ) ;

ALTER TABLE Herbivora ADD CONSTRAINT FK_ASS_1 FOREIGN KEY ( id_especie ) REFERENCES Especie ( id_especie ) ;

ALTER TABLE Residir ADD CONSTRAINT FK_ASS_10 FOREIGN KEY ( Recipiente_id_recipiente ) REFERENCES Recipiente ( id_recipiente ) ;

ALTER TABLE Carnivora ADD CONSTRAINT FK_ASS_2 FOREIGN KEY ( id_especie ) REFERENCES Especie ( id_especie ) ;

ALTER TABLE Comer ADD CONSTRAINT FK_ASS_3 FOREIGN KEY ( Carnivora_id_especie ) REFERENCES Carnivora ( id_especie ) ;

ALTER TABLE Comer ADD CONSTRAINT FK_ASS_4 FOREIGN KEY ( Especie_id_especie ) REFERENCES Especie ( id_especie ) ;

ALTER TABLE Reproduce ADD CONSTRAINT FK_ASS_7 FOREIGN KEY ( Recipiente_id_recipiente ) REFERENCES Recipiente ( id_recipiente ) ;

ALTER TABLE Reproduce ADD CONSTRAINT FK_ASS_8 FOREIGN KEY ( Ambiente_id_ambiente ) REFERENCES Ambiente ( id_ambiente ) ;

ALTER TABLE Residir ADD CONSTRAINT FK_ASS_9 FOREIGN KEY ( Ejemplar_id_ejemplar ) REFERENCES Ejemplar ( id_ejemplar ) ;

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated
--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated


-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             0
-- ALTER TABLE                             22
-- CREATE VIEW                              0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ERRORS                                   2
-- WARNINGS                                 0

