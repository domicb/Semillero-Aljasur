-- Generado por Oracle SQL Developer Data Modeler 4.0.0.825
--   en:        2015-03-25 19:00:46 CET
--------------TABLAS----------
CREATE TABLE Ambiente
  (
    id_ambiente        NUMBER (8) NOT NULL ,
    Especie_id_especie NUMBER (8) NOT NULL
  );
ALTER TABLE Ambiente ADD CONSTRAINT Ambiente_PK PRIMARY KEY ( id_ambiente ) ;
ALTER TABLE Ambiente ADD CONSTRAINT Ambiente_Especie_FK FOREIGN KEY ( Especie_id_especie ) REFERENCES Especie ( id_especie ) ;

create table Carnivora
  (
    id_especie_carni NUMBER (8) primary key
  ) ;
ALTER TABLE Carnivora ADD CONSTRAINT FK_ASS_2 FOREIGN KEY ( id_especie_carni ) REFERENCES Especie ( id_especie ) ;

CREATE TABLE Comer
  (
    Carnivora_id_especie  NUMBER (8) NOT NULL ,
    Especie_id_especie    NUMBER (8) NOT NULL 
  ) ;
ALTER TABLE Comer ADD CONSTRAINT FK_comer FOREIGN KEY ( Carnivora_id_especie ) REFERENCES Carnivora ( id_especie_carni) ;
ALTER TABLE Comer ADD CONSTRAINT Comer__IDX PRIMARY KEY ( Carnivora_id_especie, Especie_id_especie ) ;
ALTER TABLE Comer ADD CONSTRAINT FK_ASS_4 FOREIGN KEY ( Especie_id_especie ) REFERENCES Especie ( id_especie ) ;

CREATE TABLE Consume
  (
    Herbivora_id_especie1 NUMBER (8) NOT NULL ,
    Planta_id_planta      NUMBER (8) NOT NULL
  ) ;
ALTER TABLE Consume ADD CONSTRAINT FK_1Consume FOREIGN KEY ( Herbivora_id_especie1 ) REFERENCES Herbivora ( id_especie_herbi ) ;
ALTER TABLE Consume ADD CONSTRAINT FK_ASS_3 FOREIGN KEY ( Planta_id_planta ) REFERENCES Planta ( id_planta ) ;
ALTER TABLE Consume ADD CONSTRAINT Consume__IDX PRIMARY KEY ( Herbivora_id_especie1, Planta_id_planta ) ;

CREATE TABLE Ejemplar
  (
    id_ejemplar NUMBER (8) NOT NULL ,
    sexo        CHAR (1) ,
    fecha_nac   DATE ,
    comentario  VARCHAR2 (50)
  ) ;
ALTER TABLE Ejemplar ADD CONSTRAINT Ejemplar_PK PRIMARY KEY ( id_ejemplar ) ;
alter table Ejemplar add constraint ejemplar_FK foreign key (id_ejemplar) references Especie (id_especie);

CREATE TABLE Especie
  (
    id_especie           NUMBER (8) NOT NULL ,
    nombre_popular       VARCHAR2 (15) ,
    nombre_cientifico    VARCHAR2 (15) ,
    descripcion          VARCHAR2 (50) ,
    Especie_TYPE         VARCHAR2 (9) NOT NULL
  ) ;
ALTER TABLE Especie ADD CONSTRAINT CH_INH_Especie CHECK ( Especie_TYPE IN ('Carnivora', 'Herbivora')) ;
ALTER TABLE Especie ADD CONSTRAINT Especie_PK PRIMARY KEY ( id_especie ) ;

CREATE TABLE Estado
  (
    id_estado            NUMBER (8) NOT NULL ,
    estado               VARCHAR2 (50) ,
    Ejemplar_id_ejemplar NUMBER (8) NOT NULL
  ) ;
ALTER TABLE Estado ADD CONSTRAINT Estado_Ejemplar_FK FOREIGN KEY ( Ejemplar_id_ejemplar ) REFERENCES Ejemplar ( id_ejemplar ) ;
ALTER TABLE Estado ADD CONSTRAINT Estado_PK PRIMARY KEY ( id_estado ) ;

CREATE TABLE Herbivora
  (
    id_especie_herbi  NUMBER (8) primary key 
  ) ;
ALTER TABLE Herbivora ADD CONSTRAINT FK_ASS_1 FOREIGN KEY ( id_especie_herbi ) REFERENCES Especie ( id_especie ) ;

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
ALTER TABLE Reproduce ADD CONSTRAINT FK_ASS_7 FOREIGN KEY ( Recipiente_id_recipiente ) REFERENCES Recipiente ( id_recipiente ) ;
ALTER TABLE Reproduce ADD CONSTRAINT FK_ASS_8 FOREIGN KEY ( Ambiente_id_ambiente ) REFERENCES Ambiente ( id_ambiente ) ;
ALTER TABLE Reproduce ADD CONSTRAINT Reproduce__IDX PRIMARY KEY ( Recipiente_id_recipiente, Ambiente_id_ambiente ) ;

CREATE TABLE Residir
  (
    Ejemplar_id_ejemplar     NUMBER (8) NOT NULL ,
    Recipiente_id_recipiente NUMBER (8) NOT NULL ,
    fecha_ini                DATE ,
    fecha_fin                DATE
  ) ;
ALTER TABLE Residir ADD CONSTRAINT FK_ASS_10 FOREIGN KEY ( Recipiente_id_recipiente ) REFERENCES Recipiente ( id_recipiente ) ;
ALTER TABLE Residir ADD CONSTRAINT FK_ASS_9 FOREIGN KEY ( Ejemplar_id_ejemplar ) REFERENCES Ejemplar ( id_ejemplar ) ;
ALTER TABLE Residir ADD CONSTRAINT Residir__IDX PRIMARY KEY ( Ejemplar_id_ejemplar, Recipiente_id_recipiente ) ;

create table HistoricoOcupaciones
(
    Ejemplar_id_ejemplar     NUMBER (8) NOT NULL ,
    Recipiente_id_recipiente NUMBER (8) NOT NULL ,
    fecha_ini                DATE ,
    fecha_fin                DATE
);
ALTER TABLE HistoricoOcupaciones ADD CONSTRAINT Historico__IDX PRIMARY KEY ( Ejemplar_id_ejemplar, Recipiente_id_recipiente ) ;
--------DISCRMINADOR------
CREATE OR REPLACE TRIGGER ARC_FKArc_1_Herbivora BEFORE
  INSERT OR
  UPDATE OF id_especie ON Herbivora FOR EACH ROW DECLARE d VARCHAR2(9);
  BEGIN
    SELECT A.Especie_TYPE
    INTO d
    FROM Especie A,
      Herbivora B
    WHERE A.id_especie = B.id_especie ;
    IF (d             IS NULL OR d <> 'Herbivora') THEN
      raise_application_error(-20223,'FK Herbivora.FK_ASS_1 in Table Herbivora violates Arc constraint on Table Especie - only one FK is permitted');
    END IF;
  END;
  --
CREATE OR REPLACE TRIGGER ARC_FKArc_1_Carnivora BEFORE
  INSERT OR
  UPDATE OF id_especie ON Carnivora FOR EACH ROW DECLARE d VARCHAR2(9);
  BEGIN
    SELECT A.Especie_TYPE
    INTO d
    FROM Especie A,
      Carnivora B
    WHERE A.id_especie = B.id_especie ;
    IF (d             IS NULL OR d <> 'Carnivora') THEN
      raise_application_error(-20223,'FK Carnivora.FK_ASS_2 in Table Carnivora violates Arc constraint on Table Especie - only one FK is permitted');
    END IF;
  END;
  --
------------VISTAS---------------
create or replace view Omnivoras as (
select * from ESPECIE where id_especie in (
  select id_especie from carnivora
    where id_especie in ( 
      select id_especie from herbivora
)));
  
create or replace view Capturas as (
  select * from ejemplar where id_ejemplar not in (
    select id_ejemplar from ejemplar where fecha_nac is null
));

create or replace view Ausencias as (
  select * from especie where id_especie not in(
    select id_ejemplar from ejemplar
));

create or replace view Superficie as (
select count(alto+ancho+largo) as superficie from recipiente r, reproduce re, ambiente am 
  where r.ID_RECIPIENTE=re.RECIPIENTE_ID_RECIPIENTE 
    and am.ID_AMBIENTE=re.AMBIENTE_ID_AMBIENTE);

create or replace view Inventario as 
select ej.* from ejemplar ej, especie es 
  where ej.id_ejemplar=es.id_especie
    order by es.NOMBRE_POPULAR;

-------------PROCEDIMIENTOS Y FUNCIONES------------

create or replace function volumenLitros(alto in number,ancho in number, largo in number) return number as
litros number(12,4);
begin
  return (alto*ancho*largo)/1000;
exception
  when others then
    dbms_output.put_line('error');
end;
--Codigo libre para probrar la fución
declare
litros number(6,2);
begin
litros := volumenLitros(2,3,4);
dbms_output.put_line('En litros son '|| litros);
end;
--

create or replace procedure Historico(fecha IN residir.fecha_fin%type) as
v_contador number(4);
cursor c_historico is
 select * from residir where fecha_fin<fecha ; 
begin
if fecha > sysdate then
      dbms_output.put_line('La fecha introducida es posterior a la del dia de hoy');
end if;
  for r_historico in c_historico loop
   v_contador:=v_contador+1;
   insert into Historicoocupaciones values (r_historico.ejemplar_id_ejemplar, r_historico.recipiente_id_recipiente, 
   r_historico.fecha_fin, r_historico.fecha_ini );
  end loop;
dbms_output.put_line('Se han movido '||v_contador||' registros.');
exception 
  when no_data_found then
      dbms_output.put_line('No se encontraron registros con esa fecha, grácias.');
  when others then
      dbms_output.put_line('Escenario inesperado, acuda al proveedor del codigo, grácias.');
end;
--

--Función Posible: comprueba que el ambiente de un recipiente y de una especie dada son el mismo. Es una función lógica. 
create or replace function Posible (idEspecie especie.id_especie%type) return boolean  as
ambienteRE reproduce.ambiente_id_ambiente%type;
ambienteES ambiente.id_ambiente%type;
recipienteES recipiente.id_recipiente%type;
begin 
--sacamos el ambiente de esa especie para compararlo
select id_ambiente into ambienteES from ambiente am 
      where am.especie_id_especie=idEspecie;
  if (ambienteES = 0) then
    raise no_data_found;
  end if;
--sacamos el recipiente y lo guardamos para poder guardar el ambiente que reproduce ese recipiente
select recipiente_id_recipiente into recipienteES  from reproduce
      where ambiente_id_ambiente=ambienteRE;
  if (recipienteES = 0) then
    raise no_data_found;
  end if;
--sacamos el ambiente de el recipiente para comprarlarlo
select ambiente_id_ambiente into ambienteRE from reproduce
      where recipiente_id_recipiente=recipienteES;
  if (ambienteRE = 0) then
    raise no_data_found;
  end if;
--UNA VEZ TENEMOS TODOS LOS DOS AMBIENTES EN DOS VARIABLES LAS COMPARAMOS
if (ambienteRE=ambienteES) then
  return true;
  else
  return false;
end if;
exception 
  when no_data_found then
      dbms_output.put_line('No se encontraron registros, grácias.');
  when others then
      dbms_output.put_line('Escenario inesperado, acuda al proveedor del codigo, grácias.');
end;
--
--Función alimentación: devuelve el tipo de alimentación (carnívoro, herbívoro, omnívoro) de un ejemplar dado. Es una función de tipo texto. 
create or replace function alimentacion(ejemplar ejemplar.id_ejemplar%type)return varchar2 as
v_carni carnivora.id_especie_carni%type;
v_herbi herbivora.id_especie_herbi%type;
v_onmivora herbivora.id_especie_herbi%type;
cadena1 varchar2(15):='La especie es carnivora';
cadena2 varchar2(15):='La especie es herbivora';
cadena3 varchar2(15):='La especie es omnivora';
begin
v_carni:=0;
v_herbi:=0; --iniciamos las variables a 0 si siguen a 0 es que no encontro ninguno
select id_especie_carni into v_carni from carnivora where id_especie_carni=ejemplar; 
if (v_carni<>0) then
  return cadena1;
end if;
select id_especie_herbi into v_herbi from herbivora where id_especie_herbi=ejemplar; 
if (v_herbi<>0) then
  return cadena2;
end if;
select he.id_especie_herbi ,ca.id_especie_carni into v_carni, v_herbi from herbivora he, carnivora ca
    where he.id_especie_herbi=ejemplar and ca.id_especie_carni=ejemplar;
if (v_carni<>0 and v_herbi<>0) then
  return cadena3;
end if;
exception 
  when others then
      dbms_output.put_line('Escenario inesperado, acuda al proveedor del codigo, grácias.');
end;

--
--Función Vacio: Comprueba que un recipiente esta sin ejemplar. Es una función lógica. 

create or replace function Vacio(recipiente recipiente.id_recipiente%type) return boolean is
v_ejemplar residir.ejemplar_id_ejemplar%type;
begin
v_ejemplar:=0;
select ejemplar_id_ejemplar into v_ejemplar from residir where recipiente_id_recipiente=recipiente;
if (v_ejemplar=0)then
  return false;
  else
  return true;
end if;
exception 
  when to_many_rows then
      dbms_output.put_line('Demasiados registros a procesar.');
  when others then
      dbms_output.put_line('Escenario inesperado, acuda al proveedor del codigo, grácias.');
end;
--
--Función compatible: Comprueba que dos ejemplares dados se puedan ubicar en el mismo recipiente sin que se devoren. 

create or replace function Compatible(ejemplar1 in ejemplar.id_ejemplar%type, ejemplar2 in ejemplar.id_ejemplar%type) return boolean is
v_especie1 especie.id_especie%type;
v_especie2 especie.id_especie%type;
v_especiecomida1 comer.especie_id_especie%type;
v_carnivora2 comer.carnivora_id_especie%type;
begin
--primero obtenemos el codigo de la especie
select es.id_especie into v_especie1 from especie es, ejemplar ej
    where ej.id_ejemplar=ejemplar1; 
  if (v_especie1=0)then
    raise no_data_found;
  end if;
select es.id_especie into v_especie2 from especie es, ejemplar ej
      where ej.id_ejemplar=ejemplar2;
  if (v_especie2=0)then
    raise no_data_found;
  end if;
--averiguamos si la especie está en la lista de las que se comen     
select co.especie_id_especie, co.carnivora_id_especie into v_especiecomida1, v_carnivora2 from comer co, especie es 
  where es.id_especie=v_especie1;
select co.especie_id_especie, co.carnivora_id_especie into v_carnivora2, v_especiecomida1 from comer co, especie es where 
  es.id_especie=v_especie2;
if (v_especiecomida1 = ejemplar1) and ( v_carnivora2= ejemplar2)  or (v_especiecomida1 = ejemplar2) and ( v_carnivora2= ejemplar1) then
  return false;
  else
  return true;
end if;
exception 
  when no_data_found then
      dbms_output.put_line('No se encontraron registros, grácias.');
  when others then
      dbms_output.put_line('Escenario inesperado, acuda al proveedor del codigo, grácias.');
end;
--

create or replace procedure Estadistica is
v_machos number(4);
v_hembras number(4);
nacidos_machos number(4);
nacidos_hembras number(4);
v_contador_cap number(4);
v_contador_nac number(4);

--sacamos todos los que han sido capturados
select count(*) into v_contador_cap from ejemplar where (fecha_nac<sysdate);
--
select count(*) into v_hembras from ejemplar where sexo='h' and fecha_nac<sysdate;
select count(*) into v_machos from ejemplar where sexo='m' and fecha_nac<sysdate;
--sacamos todos los que han sido capturados
select count(*) into v_contador_nac from ejemplares where fecha_nac is null;
--
select count(*) into nacidos_machos number(4) from ejemplar where sexo='h' and fecha_nac is null;
select count(*) into nacidos_hembras number(4) from ejemplar where sexo='m' and fecha_nac is null;
begin
dbms.output.put_line('El porcentaje de hembras capturadas es '||v_hembras/v_contador_cap);
dbms.output.put_line('El porcentaje de machos capturados es '||v_machos/v_contador_cap);
dbms.output.put_line('El porcentaje de hembras nacidos en el zoo es '||nacidos_hembras/v_contador_nac);
dbms.output.put_line('El porcentaje de machos nacidos en el zoo es '||nacidos_machos/v_contador_nac);
exception 
  when others then
      dbms_output.put_line('Escenario inesperado, acuda al proveedor del codigo, grácias.');
end;
