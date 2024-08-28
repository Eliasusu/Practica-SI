-- Active: 1721298484659@@127.0.0.1@3306@guarderia_gaghiel
use guarderia_gaghiel;

-- Ejercicio 1 
select s.hin, so.nombre
from salida s
inner join embarcacion e on s.hin = e.hin
left join socio so on e.numero_socio = so.numero
where s.fecha_hora_salida = current_date() and s.fecha_hora_regreso_real is null;


-- Ejercicio 2
-- Para seleccionar un instructor para un nuevo curso se necesita listar los instructores que pueden dictar la actividad
-- "Carrera de asteroides" y que durante el año 2024 no hayan dictado ningún curso

select i.nombre, i.apellido, i.legajo
from actividad a 
inner join instructor_actividad ia on ia.numero_actividad = a.numero
inner join instructor i on ia.legajo_instructor = i.legajo
left join curso c on c.legajo_instructor = ia.legajo_instructor and year(c.fecha_inicio) = 2023
where a.nombre = "Carrera de asteroides" and c.numero is null;


-- Ejercicio 3
-- Camas ocupadas en el presente indicando numero de cama, sector, fecha contrato, HIN, apellido y nombre del socio

select con.numero_cama, con.codigo_sector, s.nombre, con.fecha_hora_contrato, con.hin, so.nombre, c.estado
from embarcacion_cama con
inner join embarcacion e on con.hin = e.hin
inner join socio so on e.numero_socio = so.numero
inner join cama c on con.numero_cama = c.numero
inner join sector s on con.codigo_sector = s.codigo
where c.estado = "Mantenimiento" and con.fecha_hora_contrato > "2023-07-01" and con.fecha_hora_contrato < "2023-07-31";

-- Ejercicio 4
-- Embarcaciones que salieron el domingo pasado y no salieron el domingo anterior. Indicar datos de la embarcacion y datos del socio

select s.hin, so.nombre, s.fecha_hora_salida
from salida s 
inner join embarcacion e on s.hin = e.hin
inner join socio so on e.numero_socio = so.numero
where DATE(s.fecha_hora_salida) = '2023-07-16' and DATE(s.fecha_hora_salida) != '2023-07-09';

-- Ejercicio 5
-- Cantidad de veces que salieron las embarcaciones en el presente año indicando datos de la embarcacion
-- datos del socio y cantidad de veces


-- Ejercicio 6
-- Listar los cursos que se dictarán en el futuro para los tipos de embarcaciones de tabla (contengan la palabra tabla en el nombre). 
-- Indicar número y nombre de actividad; número, fecha de inicio y fin del curso, 
-- código y nombre del tipo de embarcación; días y horarios de inicio y fin de dictado.
-- Ordenar alfabéticamente por nombre de tipo de embarcación y ascendente por fecha de inicio del curso.

select a.numero, a.nombre, c.numero, c.fecha_inicio, c.fecha_fin, t.codigo, t.nombre, d.dia_semana, d.hora_inicio, d.hora_fin
from actividad a
inner join curso c on a.numero = c.numero_actividad
inner join dictado_curso d on c.numero = d.numero_curso
inner join tipo_embarcacion t on a.codigo_tipo_embarcacion = t.codigo
where t.nombre like '%tabla%' AND c.fecha_inicio > NOW()
order by t.nombre, c.fecha_inicio asc;

-- Ejercicio 7 
-- Listar los socios con embarcaciones de tipo 'No convencional' y, si salieron con dicha embarcación este año (2024), 
-- mostrar datos de dichas salidas. Indicar número y nombre del socio; hin, nombre y descripción de la embarcación, 
-- fecha y hora de salida, regreso tentativo y regreso real.

select so.numero, so.nombre, em.hin, em.nombre, em.descripcion, sa.fecha_hora_salida, sa.fecha_hora_regreso_tentativo, sa.fecha_hora_regreso_real
from socio so  
inner join embarcacion em on so.numero = em.numero_socio
left join salida sa on em.hin = sa.hin and year(sa.fecha_hora_salida) = 2024
where em.codigo_tipo_embarcacion = 8;

SELECT s.numero, s.nombre, emb.hin, emb.nombre, emb.descripcion, sal.
fecha_hora_salida, sal.fecha_hora_regreso_tentativo, sal.fecha_hora_regreso_real
FROM socio as s
INNER JOIN embarcacion as emb
ON s.numero = emb.numero_socio
INNER JOIN tipo_embarcacion as t_emb
ON emb.codigo_tipo_embarcacion = t_emb.codigo
LEFT JOIN salida as sal
ON emb.hin = sal.hin AND year(sal.fecha_hora_salida) = 2024
WHERE t_emb.nombre = 'No convencional';

-- Ejercicio 8
-- TEMA: VARIABLES Y TABLAS TEMPORALES
-- Listar todos los cursos que hayan dictado la actividad: Carrera de asteroides.

set @id_actividad = (select numero from actividad where nombre = "Carrera de asteroides");

-- Otra forma de setear la variable ⬇️
-- select act.numero into @id_actividad 
-- from actividad act
-- where act.nombre = "Carrera de asteroides";

select * from curso
where numero_actividad = @id_actividad;

-- Ejercicio 9
-- Indicar para cada embarcación, cuál ha sido la máxima fecha_hora_salida
-- y sus fecha_hora de regreso tentativo y real. Indicar número de hin, nombre de la embarcación
drop temporary table if exists max_salida;
create temporary table max_salida
select sa.hin, MAX(sa.fecha_hora_salida) fechaHoraSalida
from salida sa
group by sa.hin;

select sa.hin, sa.fecha_hora_salida, sa.fecha_hora_regreso_tentativo, sa.fecha_hora_regreso_real
from salida sa 
inner join max_salida ms on sa.hin = ms.hin and sa.fecha_hora_salida = ms.fechaHoraSalida;


