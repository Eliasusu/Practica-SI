-- Active: 1721298484659@@127.0.0.1@3306@afatse
use afatse;

-- //? INSERT SELECT

-- Ejercicio 1
-- Crear una nueva lista de precios para todos los planes de capacitación, a partir del 01/06/2009 
-- con un 20 por ciento más que su último valor. Eliminar las filas agregadas.

start transaction;


insert into valores_plan(nom_plan, fecha_desde_plan, valor_plan)
select val.nom_plan, '2009-06-01', val.valor_plan * 1.2
from valores_plan val
inner join (
    select nom_plan, max(fecha_desde_plan) as fecha
    from valores_plan 
    group by nom_plan
) fecha
on val.nom_plan = fecha.nom_plan and val.fecha_desde_plan = fecha.fecha;

commit;

delete from valores_plan
where fecha_desde_plan = '2009-06-01';

-- Ejercicio 2
-- Crear una nueva lista de precios para todos los planes de capacitación, 
-- a partir del 01/08/2009, con la siguiente regla: Los cursos cuyo último valor sea menor a $90 aumentarlos en un 20% al resto aumentarlos un 12%.

start transaction;

insert into valores_plan(nom_plan, fecha_desde_plan, valor_plan)
select val.nom_plan, '2009-08-01',
case 
    when val.valor_plan < 90 then val.valor_plan * 1.2
    else val.valor_plan * 1.12
end
from valores_plan val
inner join (
    select nom_plan, max(fecha_desde_plan) as fecha
    from valores_plan 
    group by nom_plan
) fecha
on val.nom_plan = fecha.nom_plan and val.fecha_desde_plan = fecha.fecha;

commit;

-- Ejercicio 3
-- Crear un nuevo plan: Marketing 1 Presen. Con los mismos datos que el plan Marketing 1 pero con modalidad presencial. 
-- Este plan tendrá los mismos temas, exámenes y materiales que Marketing 1 pero con un costo un 50% superior, 
-- para todos los períodos de este año que ya estén definidos costos del plan.

start transaction;

insert into plan_capacitacion(nom_plan, desc_plan, hs, modalidad)
select 'Marketing 1 Presen.', desc_plan, hs, 'Presencial'
from plan_capacitacion
where nom_plan = 'Marketing 1';

insert into valores_plan(nom_plan, fecha_desde_plan, valor_plan)
select 'Marketing 1 Presen.', fecha_desde_plan, valor_plan * 1.5
from valores_plan
where nom_plan = 'Marketing 1' AND year(fecha_desde_plan) = year('2014-01-01');

insert into plan_temas(nom_plan, titulo, detalle)
select 'Marketing 1 Presen.', titulo, detalle
from plan_temas
where nom_plan = 'Marketing 1';

insert into materiales_plan(nom_plan, cod_material, cant_entrega)
select 'Marketing 1 Presen.', cod_material, cant_entrega
from materiales_plan
where nom_plan = 'Marketing 1';

insert into examenes(nom_plan, nro_examen)
select 'Marketing 1 Presen.', nro_examen
from examenes
where nom_plan = 'Marketing 1';

insert into examenes_temas(nom_plan, titulo, nro_examen)
select 'Marketing 1 Presen.', titulo, nro_examen
from examenes_temas
where nom_plan = 'Marketing 1';

commit;


-- //? UPDATE CON JOIN
-- Ejercicio 4
-- Cambiar el supervisor de aquellos instructores que dictan Reparac PC Avanzada este año a 66-66666666-6 (Franz Kafka).

start transaction;

update instructores i
inner join cursos_instructores ci on i.cuil = ci.cuil
set cuil_supervisor = '66-66666666-6'
where ci.nom_plan = 'Reparac PC Avanzada'

commit;


-- Ejercicio 5
-- Cambiar el horario de los cursos de que dicta este año Franz Kafka (cuil ) desde las 16 hs. Moverlos una hora más temprano.

start transaction;

update cursos_horarios ch
inner join cursos_instructores ci on ch.nom_plan = ci.nom_plan and ch.nro_curso = ci.nro_curso
inner join instructores i on ci.cuil = i.cuil
set hora_inicio = '15:00:00'
where i.cuil = '66-66666666-6';

commit;

-- Ejercicio 6 
/* Eliminar los exámenes donde el promedio general de las evaluaciones sea menor a 5.5.
Eliminar también los temas que sólo se evalúan en esos exámenes. Ayuda: Usar una tabla
temporal para determinar el/los exámenes que cumplan en las condiciones y utilizar
dichas tabla para los joins. Tener en cuenta las CF para poder eliminarlos. */

start transaction;
drop temporary table if exists examenes_eliminar;
create temporary table examenes_eliminar as (
    select e.nom_plan, e.nro_examen, AVG(ev.nota) as promedio
    from examenes e
    inner join examenes_temas et on e.nom_plan = et.nom_plan and e.nro_examen = et.nro_examen
    inner join evaluaciones ev on e.nom_plan = ev.nom_plan and e.nro_examen = ev.nro_examen
    group by e.nom_plan, e.nro_examen
    having AVG(ev.nota) > 5.5
);

select * from examenes_eliminar;
delete from examenes_temas
where (nom_plan, nro_examen) not in (select nom_plan, nro_examen from examenes_eliminar);

delete from examenes
where (nom_plan, nro_examen) not in (select nom_plan, nro_examen from examenes_eliminar);

rollback;