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
