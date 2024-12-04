-- Active: 1721298484659@@127.0.0.1@3306@guarderia_gaghiel
-- Ejercicios 

-- //? Ejercicio 1 DML
-- //?Embarcaciones en sectores a reacondicionar

select ec.numero_cama, em.hin, em.nombre, so.numero, so.nombre
from sector sec
inner join embarcacion_cama ec on sec.codigo = ec.codigo_sector
inner join embarcacion em on ec.hin = em.hin
inner join socio so on em.numero_socio = so.numero
where sec.nombre = 'Mars'
order by ec.numero_cama ASC;

-- //? Ejercicio 2 DML
-- //? Personas fisicas que regresaron tarde en 2024
select so.nro_doc, so.nombre, em.hin, em.nombre, sa.fecha_hora_salida as salida_con_regreso_tarde
from socio so 
inner join embarcacion em on so.numero = em.numero_socio
left join salida sa on em.hin = sa.hin
where so.tipo_doc = 'dni'
and sa.fecha_hora_salida is null 
or sa.fecha_hora_regreso_tentativo < sa.fecha_hora_regreso_real;

-- //* Prueba de si esta bien la resolucion
select so.nro_doc, so.nombre, em.hin, count(sa.fecha_hora_salida) as cantidad_salidas
from socio so 
inner join embarcacion em on so.numero = em.numero_socio
left join salida sa on em.hin = sa.hin
where so.tipo_doc = 'dni'
and sa.fecha_hora_salida is null 
or sa.fecha_hora_regreso_tentativo < sa.fecha_hora_regreso_real
group by so.nro_doc, so.nombre, em.hin;

select so.nro_doc, so.nombre, count(em.hin) as cantidad_embarcaciones
from socio so
left join embarcacion em on so.numero = em.numero_socio
where so.tipo_doc = 'dni'
group by so.nro_doc, so.nombre;

-- //? Ejercicio 3 DML
-- //? Canoas y Kayas con pocas salidas.

select te.codigo, te.nombre, em.hin, em.nombre, 
    count(sa.fecha_hora_salida) as cantidad_de_salidas, 
    case 
        when count(sa.fecha_hora_salida) = 0 then 'Sin salidas'
        else max(sa.fecha_hora_salida) 
    end as ultima_salida
from tipo_embarcacion te
inner join embarcacion em on em.codigo_tipo_embarcacion = te.codigo
left join salida sa on em.hin = sa.hin
where te.nombre = 'Canoa'
or te.nombre = 'Kayak'
group by te.codigo, te.nombre, em.hin, em.nombre
order by cantidad_de_salidas desc, em.hin asc;

-- //? Ejercicio 4 DML
-- //? Instructores de windsurf libres.

select ins.legajo, concat(ins.nombre , ' ', ins.apellido) as Nombre, a.nombre, a.descripcion
from instructor ins
inner join instructor_actividad ia on ins.legajo = ia.legajo_instructor
inner join actividad a on ia.numero_actividad = a.numero
inner join tipo_embarcacion te on a.codigo_tipo_embarcacion = te.codigo and te.nombre = 'Tabla Wind Surf'
where ins.legajo not in (select cur.legajo_instructor
from curso cur);

-- //? Ejercicio 5 DML 
-- //? Variación en salidas de cada embarcación.

drop temporary table if exists cantidad_salidas;
create temporary table cantidad_salidas as
select em.hin, te.codigo, year(sa.fecha_hora_salida) as anio, count(sa.fecha_hora_salida) as cantidad_salidas
from embarcacion em
inner join tipo_embarcacion te on em.codigo_tipo_embarcacion = te.codigo
left join salida sa on em.hin = sa.hin  
where year(sa.fecha_hora_salida) = 2024
group by em.hin, te.codigo, year(sa.fecha_hora_salida);

select * from cantidad_salidas;

drop temporary table if exists promedios;
create temporary table if not exists promedios
select codigo, anio, avg(cs.cantidad_salidas) as promedio_salidas
from cantidad_salidas cs
group by codigo, anio;

select * from promedios

select cs.hin, cs.cantidad_salidas
from cantidad_salidas cs
inner join promedios pr on cs.codigo = pr.codigo and cs.anio = pr.anio
where cs.cantidad_salidas > pr.promedio_salidas


-- //? Ejercicio 7 DML
-- //? Instructores posibles

delimiter $$

drop procedure if exists posibles_instructores;

create procedure posibles_instructores(
    in numero_actividad int,
    in fecha_inicio date,
    in fecha_fin date)
begin
    select ins.legajo, concat(ins.nombre, ' ', ins.apellido) as nombre, ins.telefono
    from instructor ins
    inner join instructor_actividad ia on ins.legajo = ia.legajo_instructor and ia.numero_actividad = numero_actividad
    where ins.legajo not in (
        select cur.legajo_instructor
        from curso cur
        where cur.fecha_inicio = fecha_inicio and cur.fecha_fin = fecha_fin
    );
end $$

delimiter;
call posibles_instructores(15, '2024-12-01', '2025-01-31');


-- //? Ejercicio 6 TCL/DDL
-- //? Nuevo tipo de embarcación: Catamarán Deportivo.

delimiter $$;
set transaction isolation level serializable;
start transaction;

insert into tipo_embarcacion(nombre, operacion_requerida)
values ('Catamaran Deportivo', 'Automática');

set @codTipoEmbarcacion = (
    select te.codigo
    from tipo_embarcacion te
    where te.nombre = 'Catamaran Deportivo'
);

insert into sector_tipo_embarcacion
select @codTipoEmbarcacion, se.codigo
from sector se
where se.tipo_operacion = 'Automático';

insert into actividad(nombre, descripcion, codigo_tipo_embarcacion)
select concat(a.nombre, ' en catamaran'), a.descripcion, @codTipoEmbarcacion
from actividad a
inner join tipo_embarcacion te on a.codigo_tipo_embarcacion = te.codigo
where te.nombre = 'Velero';

rollback;
commit;
$$;

delimiter;


-- //? Ejercicio 8 TCL/DDL
-- //? Tipo operacion

-- //? a) Crear la tabla: tipo_operacion 
drop table if exists tipo_operacion;
create table tipo_operacion (
    cod_operacion int not null AUTO_INCREMENT,
    desc_tipo_operacion varchar(255) not null,
    primary key (cod_operacion)
);

-- //? b) Registrar en la nueva tabla, los diferentes tipos de operaciones utilizados en sector

start transaction;

insert into tipo_operacion(desc_tipo_operacion)
select DISTINCT(se.tipo_operacion)
from sector se;
commit;

-- //? c) y d) 

alter table sector 
add column cod_tipo_operacion int not null;

alter table tipo_embarcacion 
add column cod_tipo_operacion int not null;

start transaction;

update sector se
inner join tipo_operacion toper on se.tipo_operacion = toper.desc_tipo_operacion
set se.cod_tipo_operacion = toper.cod_operacion;

alter table sector
drop column tipo_operacion;

update tipo_embarcacion te
inner join tipo_operacion tiop on te.operacion_requerida = tiop.desc_tipo_operacion
set te.cod_tipo_operacion = tiop.cod_operacion;

alter table tipo_embarcacion
drop column operacion_requerida;

commit;

-- //? e) Modificar las tablas sector y tipo_embarcacion para controlar y mantener la integridad referencial.

alter table sector
add CONSTRAINT fk_tipo_operacion_sector
Foreign Key (cod_tipo_operacion) REFERENCES tipo_operacion(cod_operacion)
on delete cascade
on update cascade;

alter table tipo_embarcacion
add CONSTRAINT fk_tipo_operacion_tipo_embarcacion
Foreign Key (cod_tipo_operacion) REFERENCES tipo_operacion(cod_operacion)
on delete cascade
on update cascade;


*/ 

Embarcaciones almacenadas. La empresa ha detectado dificultad para identificar si las embarcaciones se encuentran almacenadas o no a la hora de cierre. Por este motivo se ha decidido agregar una columna “almacenada” en la tabla embarcación que refleje la situación y automatizar con triggers el estado de dicha columna.

Se requiere:

1- Crear una columna almacenada para reflejar el estado (utilizar el tipo de dato que crea apropiado).

2- Cargar el valor inicial de la columna. Las embarcaciones que no tengan una salida con fecha y hora de regreso real en null está almacenadas.

3- A través del uso de triggers al registrar una nueva salida de una embarcación cambiar el valor de la columna almacenada para reflejar que salió y al registrar una fecha y hora de regreso real reflejar que se encuentra almacenada.

*/

*/ 

Cursos más exitosos. La empresa desea conocer para cada tipo de embarcación información de los cursos más exitosos. Se considera que el curso más exitoso para cada tipo de embarcación es el que tiene mayor cantidad de socios inscriptos dentro de los cursos de dicho tipo de embarcación (que se relaciona según la actividad realizada en el curso). Se requiere listar para cada tipo de embarcación el curso más exitoso indicando: código y nombre del tipo de embarcación; número, nombre y descripción de la actividad del curso, número de curso, cuántos días pasaron desde que se comenzó a dictar dicho curso, cantidad de inscriptos que tuvo y la cantidad de embarcaciones del tipo de embarcación que están actualmente almacenadas en la guardería.

Si para un tipo de embarcación no se dictó ningún curso debe mostrarse igualmente con 0 inscriptos y sin datos de la actividad o curso y si no hay embarcaciones almacenadas actualmente de dicho tipo debe mostrarse con 0.

Ordenar por cantidad de embarcaciones almacenadas descendente, cantidad de inscriptos ascendente y días desde que comenzó el curso ascendente

*/