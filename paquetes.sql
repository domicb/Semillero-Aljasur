-- Carrasco Bueno Domingo
--1 Funcion booleana
create or replace function es_componente (codigo number, elemento number) return boolean is
v_contador number(3);
sin_valor exception;
begin
if (codigo = 0 or elemento = 0) then
  raise sin_valor;
end if;
select count(*) into v_contador from componer where cod_tipo = codigo and n_elemento = elemento;
if (v_contador>0)then
  return true;
else
  return false;
end if;
exception
  when sin_valor then
    raise_application_error(-20010,'Por favor introduce el codigo del elemento y el numero de elemento');
  when others then
    raise_application_error(-sqlcode,'sqlermm');
end es_componente;

--2 Disparador
create or replace trigger elemento
after insert on encargo
for each row
declare
no_encontro exception;
v_precio number(3);
begin
if inserting then
select sum(precio_c) into v_precio from encargo where cod_tipo = :new.cod_tipo and n_elemento = :new.n_elemento and id_empresa = :new.id_empresa;
  update elemento set precio_v = :new.precio_c*1.02 where cod_tipo = :new.cod_tipo and n_elemento = :new.n_elemento;
end if;
if (v_precio = 0)then
  raise no_encontro;
end if;
exception
  when no_encontro then
    raise_application_error(-20012,'No se encontro ningun encargo con esos datos');
  when others then
     raise_application_error(-20011,'Error en el disparador elemento sobre la tabla encargos, escenario inesperado');
end elemento;

--3 Disparador registro AL COMPILAR NOS DICE QUE FALTA LA TABLA SI ME DA TIEMPO LA CREO
create or replace trigger registro
after insert or delete or update on elemento
for each row
declare
tipo varchar2(25);
fecha date;
usuario varchar2(25);
begin
fecha:=sysdate;
usuario:=user();
if inserting then
  tipo:='Se inserto un nuevo elemento';
  insert into cambios_elementos values(:new.cod_tipo, :new.n_elemento, tipo, null , :new.precio_v, fecha, usuario );
end if;
--PONEMOS UN CAMPO COMO NULL PARA PODER REALIZAR EL INSERT
if updating then
  tipo:='Se ha realizado una actualizacion';
  insert into cambios_elementos values(:new.cod_tipo, :new.n_elemento, tipo, :old.precio_v ,:new.precio_v, fecha, usuario );
end if;

if deleting then
  tipo:='Se ha borrado un registro';
  insert into cambios_elementos values(:old.cod_tipo, :old.n_elemento, tipo, :old.precio_v ,null, fecha, usuario );
end if;
exception
  when others then
  raise_application_error(-20011,'Error en el disparador registro sobre la tabla elemento, escenario inesperado');
end registro;

--4 Procedimiento cursores

create or replace procedure listado is
v_contador number(4);
v_interna number(4);
v_tipo varchar2(15);
sin_encargos exception;
cursor encargo is
select en.cod_tipo, en.n_elemento, en.precio_c, en.fecha, em.nombre_e, em.id_empresa
  from encargo en, empresa em where en.id_empresa = em.id_empresa;
r_lista encargo%rowtype;
begin
for r_lista in encargo loop
  select count(*) into v_interna from internas where cod_tipo = r_lista.cod_tipo and n_elemento = r_lista.n_elemento;
  if (v_interna > 0 )then
    v_tipo:='Es interna';
  else
    v_tipo:='Es externa';
  end if;
  select count(*) into v_contador from encargo
    where cod_tipo = r_lista.cod_tipo and n_elemento = r_lista.n_elemento and id_empresa = r_lista.id_empresa;
  dbms_output.put_line('Nombre Empresa: '||r_lista.nombre_e || 'Nº Total encargos: ' || v_contador );
  
  dbms_output.put_line('Tipo elemento: '|| v_tipo || 'Numero de elemento: '||r_lista.n_elemento ||
    'Precio de compra: '||r_lista.precio_c||'La fecha es: '|| r_lista.fecha );
if (v_contador = 0)then
  raise sin_encargos;
end if;
end loop;
exception
  when sin_encargos then
  raise_application_error(-20011,'El elemento introducido no tiene encargos');
    when others then
   raise_application_error(-20011,'Error en el procedimiento listado, escenario inesperado');
end;
--set serveroutput on;
--execute listado;

--5 Procedimiento actualizar
create or replace procedure actualizar is
v_variable varchar2(15);
v_precio number(8);
v_cantidad number(8);
no_encontro exception;
no_compone exception;
cursor c_datos is
select * from elemento;
r_datos c_datos%rowtype;
begin
for r_datos in c_datos loop
if(quetipo(r_datos.cod_tipo,r_datos.n_elemento)=true)then
  select n_elemento_com into v_cantidad from componer where cod_tipo = r_datos.cod_tipo and n_elemento = r_datos.n_elemento;
  update elemento set precio_v= precio_v*v_cantidad where cod_tipo = r_datos.cod_tipo and n_elemento = r_datos.n_elemento;
else
  select sum(precio_c) into v_precio from encargo where cod_tipo = r_datos.cod_tipo and n_elemento = r_datos.n_elemento;
  update elemento set precio_v= v_precio*1.20 where cod_tipo = r_datos.cod_tipo and n_elemento = r_datos.n_elemento;
end if;
if (v_precio = 0 or v_cantidad = 0) then
  raise no_encontro;
end if;
if (v_cantidad = 0)then
  raise no_compone;
end if;
end loop;
exception
    when no_compone then
    raise_application_error(-20015,'Este elemento no esta compuesto por ningún otro');
    when no_encontro then
    raise_application_error(-20015,'No se encontro ningun elemento encargado con esos datos');
    when others then
    raise_application_error(-20011,'Error en el procedimiento actualizar, escenario inesperado');
end actualizar;
--funcion necesaria para saber el tipo y no complicar demasiado el procedimiento
create or replace function quetipo(tipo number,elemento number)return boolean is
v_interna number(3);
v_externa number(3);
begin
select count(*) into v_externa from externas where cod_tipo = tipo and n_elemento = elemento;
if(v_externa>0)then
return true;
else
return false;
end if;
end quetipo;


