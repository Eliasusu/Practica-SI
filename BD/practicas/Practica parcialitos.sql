-- Active: 1721298484659@@127.0.0.1@3306@guarderia_gaghiel

use guarderia_gaghiel;

-- PRACTICA HAVING Y GROUP BY

-- Ejercicio 1 
-- Realiza un análisis que muestre para cada instructor, las actividades que ha realizado, 
-- el número total de cursos que ha dictado y la duración promedio de esos cursos. Además, 
-- incluye aquellos instructores que no tienen asignada ninguna actividad, y filtra los resultados 
-- para mostrar solo aquellos instructores que han dictado más de 5 cursos en total.

SELECT ins.nombre, ins.apellido, act.nombre as Nombre_Actividad, COUNT(cur.numero) as Cantidad_Cursos_Realizados, AVG(DATEDIFF(cur.fecha_fin, cur.fecha_inicio)) AS Duracion_Promedio_Dias
FROM instructor ins
LEFT JOIN instructor_actividad i_a ON ins.legajo = i_a.legajo_instructor
LEFT JOIN actividad act ON i_a.numero_actividad = act.numero
LEFT JOIN curso cur ON ins.legajo = cur.legajo_instructor
GROUP BY 1,2,3
HAVING Cantidad_Cursos_Realizados > 5;

-- Ejercicio 2
-- Genera un informe que muestre las actividades más populares (es decir, con más cursos asignados) 
-- y el instructor que más ha dictado esa actividad. Solo se deben considerar las actividades que han tenido 
-- al menos 3 cursos dictados. 

SELECT act.nombre, CONCAT(ins.nombre, ' ' ,ins.apellido) as Instructor, COUNT(cur.numero) as Curso 
FROM curso cur
INNER JOIN instructor ins ON cur.legajo_instructor = ins.legajo
INNER JOIN actividad act ON cur.numero_actividad = act.numero
GROUP BY 1,2
HAVING Curso >= 3; 

-- Ejercicio 3
-- muestre todas las actividades que tienen más de un instructor asociado. Para cada actividad, 
-- muestra los nombres de los instructores y el número de cursos en los que cada instructor participó.

SELECT act.nombre as Actividad, CONCAT(ins.nombre, ' ' ,ins.apellido) as Instructor, COUNT(cur.numero) as Cantidad_Cursos
FROM instructor_actividad i_a 
INNER JOIN actividad act ON i_a.numero_actividad = act.numero
INNER JOIN instructor ins ON i_a.legajo_instructor = ins.legajo
INNER JOIN curso cur ON ins.legajo = cur.legajo_instructor
GROUP BY 1,2

-- Consulta para ver que curso hizo cada instructor y con que actividad
SELECT act.nombre as Actividad, CONCAT(ins.nombre, ' ' ,ins.apellido) as Instructor, cur.numero as Cursos, cur.fecha_fin as Fecha_Fin_Curso
FROM curso cur
INNER JOIN instructor ins ON cur.legajo_instructor = ins.legajo
INNER JOIN actividad act ON cur.numero_actividad = act.numero;

-- Ejercicio 4
-- Realiza una consulta que muestre todas las actividades que no han tenido cursos asignados en los últimos 6 meses. 
-- Incluye también aquellas actividades que no tienen cursos en absoluto.

SELECT act.nombre as Actividad, COUNT(cur.numero) as Cantidad_Cursos
FROM actividad act
LEFT JOIN curso cur ON act.numero = cur.numero_actividad 
    AND cur.fecha_inicio >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 1
HAVING Cantidad_Cursos >= 0

-- Ejercicio 5
-- Crea una consulta que liste las actividades en las que, en promedio, 
-- han participado menos de 10 personas por curso. Muestra el nombre de la actividad y el número promedio de participantes.

SELECT act.nombre as Actividad, AVG( (SELECT COUNT(*) 
          FROM inscripcion ins
          WHERE ins.numero_curso = cur.numero) ) as PromedioParticipantes
FROM actividad act 
JOIN curso cur ON act.numero = cur.numero_actividad
GROUP BY 1
HAVING PromedioParticipantes < 10;

-- Ejercicio 6
-- Socios con pocos cursos recientes
-- Listar todos los socios que realizaron menos de 5 cursos
-- Indicar número y nombre del socio; cantidad de cursos de 2024, (si no realizó ningún
-- curso este año indicar 0) y la fecha en la que se inscribió por última vez a un
-- curso (si no se inscribió a ninguno mostrar 'sin inscripciones'). Ordenar por
-- cantidad de cursos descendente.

SELECT soc.numero, soc.nombre, IFNULL(MAX(ins.fecha_hora_inscripcion), 'Sin inscripciones') as Ultima_inscripcion, COUNT(ins.numero_curso) as Cantidad_cursos
FROM socio soc 
LEFT JOIN inscripcion ins ON soc.numero = ins.numero_socio 
LEFT JOIN curso cur ON ins.numero_curso = cur.numero AND YEAR(cur.fecha_inicio) = YEAR(CURDATE())
GROUP BY 1,2
HAVING Cantidad_cursos < 5
ORDER BY Cantidad_cursos DESC

-- ENUNCIADO PARCIALITO
-- Listar todos los instructores que hayan tenido menos de 4 socios inscriptos en total a los cursos que dictaron y ya terminaron. 
-- Indicar legajo, nombre y apellido del instructor, cantidad de alumnos inscriptos (debe mostrar 0 si no hubo) 
-- y última fecha que dictó un curso (debe mostrar 'sin cursos' en caso que no haya dictado ninguno ya finalizado). 
-- Ordenar por cantidad de inscriptos descendente.

SELECT ins.legajo as Legajo_Instructor , CONCAT(ins.nombre, ' ' ,ins.apellido) as Instructor, COUNT(insc.numero_socio) as Cantidad_Alumnos_Inscriptos, IFNULL(MAX(cur.fecha_fin), 'Sin cursos') as Ultimo_Dictado
FROM instructor ins 
LEFT JOIN curso cur ON ins.legajo = cur.legajo_instructor AND cur.fecha_fin < CURDATE()
LEFT JOIN inscripcion insc ON cur.numero = insc.numero_curso
GROUP BY 1,2
HAVING Cantidad_Alumnos_Inscriptos < 4
ORDER BY Cantidad_Alumnos_Inscriptos DESC;


-- PRACTICA SUBCONSULTAS, VARIABLES, TABLAS TEMPORALES Y CTE

-- Ejercicio 1
-- Embarcaciones que no renovaron contrato.

-- Listar embarcaciones que hayan estado almacenadas el año pasado (segun la fecha de contrato) 
-- pero no tengan contratos activos actualmente.
-- Indicar hin, nombre y descripcion de la embarcacion. Ordenar por nombre.

with embarcacionesAnioPasado as (
    select ec.hin, ec.fecha_hora_contrato, ec.fecha_hora_baja_contrato
    from embarcacion_cama ec   
    where YEAR(ec.fecha_hora_contrato) = '2023' and ec.fecha_hora_baja_contrato is not null
) select distinct em.hin, em.nombre, em.descripcion
from embarcacionesAnioPasado eap
inner join embarcacion em on eap.hin = em.hin
order by em.nombre  

-- Ejercicio 2
-- Sectores con muchas embarcaciones.

-- Listar los sectores que tienen mas embarcaciones almacenadas actualmente
-- que el promedio de la cantidad de embarcaciones actualmente almacenadas en cada sector.
-- Se deben tener en cuenta para el promedio los sectores que podrian no tener embarcaciones actualmente almacenadas.
-- Indicar código, nombre, cantidad de embarcaciones actualmente almacenadas.

set @promedio = (
select  AVG(EmbarcacionesAlmacenadas) as Promedio
from ( select emca.codigo_sector, count(*) as EmbarcacionesAlmacenadas
    from embarcacion_cama emca
    where emca.fecha_hora_baja_contrato is null
    group by emca.codigo_sector
) as subconsulta
);

select sec.codigo, sec.nombre, count(*) as CantidadEmbarcacionesAlmacenadas
from embarcacion_cama emca
inner join sector sec on emca.codigo_sector = sec.codigo
where emca.fecha_hora_baja_contrato is null
group by sec.codigo, sec.nombre
having CantidadEmbarcacionesAlmacenadas > @promedio

-- ENUNCIADO PARCIALITO 

-- Ejercicio 1
-- Socios que dejaron de hacer cursos.

-- Listar los socios que se hayan inscripto a cursos el año pasado pero no este. 
-- Indicar número y nombre del socio. Ordenar por nombre.

select so.numero, so.nombre
from inscripcion ins
inner join socio so on ins.numero_socio = so.numero 
where YEAR(ins.fecha_hora_inscripcion) = '2023' and so.numero not in (
    select so.numero 
    from inscripcion ins
    inner join socio so on ins.numero_socio = so.numero 
    where YEAR(ins.fecha_hora_inscripcion) = '2024'
)
order by so.nombre


-- Ejercicio 2
--Instructores haraganes. 
-- Listar los instructores que dictan menos cursos durante 2024 que el promedio de la cantidad 
-- de cursos que dicta cada instructor en 2024. Se deben tener en cuenta para el promedio 
-- los instructores que no dictan cursos. Indicar legajo, nombre y apellido del instructor y 
-- la cantidad de cursos que dicta en 2024. Ordenar por cantidad de cursos descendente.


set @promedio = (
select  AVG(CantidadCursos) as Promedio
from ( select distinct  ins.legajo, count(cur.numero) as CantidadCursos
    from instructor ins
    left join curso cur on ins.legajo = cur.legajo_instructor and year(cur.fecha_inicio) = '2024'
    group by ins.legajo
) as subconsulta
);

select @promedio

select ins.legajo, concat(ins.nombre, ' ',ins.apellido) as Nombre, count(cur.numero) as CantidadCursosDictados
from instructor ins
left join curso cur on ins.legajo = cur.legajo_instructor and YEAR(cur.fecha_inicio) = '2024'
group by ins.legajo, ins.nombre, ins.apellido
having CantidadCursosDictados < @promedio
order by CantidadCursosDictados desc;



-- //! PRACTICA PARA PARCIALITO 08/10/2024
-- //! TEMAS: SENTENCIAS DML (insert, update, delete, truncate con joins)

-- Ejercicio 1
-- Agregar un nuevo socio.

start TRANSACTION;
insert into socio(numero, tipo_doc, nro_doc, nombre)
values(40, 'DNI', 34235643, 'Juan Perez');

select soc.numero, soc.tipo_doc, soc.nro_doc, soc.nombre
from socio soc
where soc.numero = 40;

commit;

-- Ejercicio 2
-- Eliminar un socio

start transaction;
delete from socio
where numero = 40;

commit;

-- Ejercicio 3
-- Actualizar el nombre de un socio

start transaction;
update socio
set nombre = 'Juan Pereztica'
where numero = 40;

select soc.numero, soc.tipo_doc, soc.nro_doc, soc.nombre
from socio soc
where soc.numero = 40;

commit;

-- Ejercicio 4 
-- Inscribe al socio Juan Pereztica a los cursos cuya actividad sea: 3D Maneuvering y Jedi Surf
-- Ten en cuenta que si no hay cupo en el curso no se podra inscribir y ademas la fecha fin del curso debe ser menor a la fecha actual.

-- //* Primero crearia un tabla temporal en donde guarde los cursos cuya actividad sea 
-- //* 3D Maneuvering y Jedi Surf, con los atributos nro_curso, cupo, cupoRestante, fechaFin
-- //* Teniendo en cuenta que si el cupoRestante es <= 0 no aparecerá en la tabla 
-- //* Y si fechaFin <= CURDATE() tampoco estarián en la tabla

START TRANSACTION;
DROP TEMPORARY TABLE IF EXISTS cursos_temporal;
CREATE TEMPORARY TABLE cursos_temporal
SELECT cur.numero as numero_curso, cur.cupo, cur.cupo - COUNT(ins.numero_socio) as cupo_restante, cur.fecha_inicio as fecha_inicio
FROM curso cur
INNER JOIN inscripcion ins ON cur.numero = ins.numero_curso
INNER JOIN actividad act ON cur.numero_actividad = act.numero
WHERE act.nombre = '3D Maneuvering' OR act.nombre = 'Jedi Surf'
GROUP BY numero_curso, cur.cupo, cur.fecha_fin
HAVING cupo_restante > 0 AND fecha_inicio > CURDATE(); 

-- //? Verifico que la tabla temporal se haya creado correctamente
SELECT * FROM cursos_temporal;
-- //* Teniendo esa tabla, inscribo a Juan Pereztica a los cursos ya que tengo el numero del curso de la tabla temporal
INSERT INTO inscripcion(numero_curso, numero_socio, fecha_hora_inscripcion)
SELECT cur_temp.numero_curso, soc.numero, CURDATE()
FROM cursos_temporal cur_temp
CROSS JOIN socio soc
WHERE soc.nombre = 'Juan Pereztica';

-- //? Verificación final
SELECT ins.numero_curso, ins.numero_socio, ins.fecha_hora_inscripcion
FROM inscripcion ins
WHERE ins.numero_socio = 40;

COMMIT;


INSERT INTO inscripcion(numero_curso, numero_socio, fecha_hora_inscripcion)
VALUES 


-- Ejercicio 5
-- Cambia la fecha de inscripcion del socio 40 al curso 1 para el '2024-10-08 10:00:00'


-- Ejercicio 6
-- Elimina la inscripción del socio 40 al curso 3


-- Ejercicio 7
-- Elimina todas las inscripciones del socio 40
