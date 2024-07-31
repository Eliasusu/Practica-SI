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
where c.estado = "Mantenimiento" and con.fecha_hora_contrato > "2023-07-01" and con.fecha_hora_contrato < "2023-07-31" ;

-- Ejercicio 4
-- Embarcaciones que salieron el domingo pasado y no salieron el domingo anterior. Indicar datos de la embarcacion y datos del socio

-- Ejercicio 5
-- Cantidad de veces que salieron las embarcaciones en el presente año indicando datos de la embarcacion
-- datos del socio y cantidad de veces
