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


drop temporary table if exists cantidad_salidas_por_tipo_embarcacion;
create temporary table cantidad_salidas_por_tipo_embarcacion
select te.codigo, te.nombre, count(sa.hin) as cantidad_salida_por_tipo
from tipo_embarcacion te
inner join embarcacion em on em.codigo_tipo_embarcacion = te.codigo
inner join salida sa on em.hin = sa.hin
where YEAR(sa.fecha_hora_salida) = '2024'
group by te.codigo, te.nombre;
select * from promedio_salidas_por_tipo_embarcacion;


-- //* incompleto

-- //? Ejercicio 6 DDL y TCL
-- //? Nuevo tipo de embarcación: Catamarán Deportivo

start transaction;

insert into tipo_embarcacion(codigo, nombre, operacion_requerida)
values(9, 'Catamarán deportivo', 'Automática')

insert into sector_tipo_embarcacion (codigo_tipo_embarcacion, codigo_sector)
select codigo_sector, 9
from sector_tipo_embarcacion ste
inner join sector se on ste.codigo_sector = se.codigo
where se.tipo_operacion = 'Automatico'

rollback;
commit;