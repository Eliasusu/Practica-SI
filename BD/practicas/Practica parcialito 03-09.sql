-- Active: 1721298484659@@127.0.0.1@3306@guarderia_gaghiel

use guarderia_gaghiel;

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
SELECT act.nombre as Actividad, CONCAT(ins.nombre, ' ' ,ins.apellido) as Instructor, cur.numero as Cursos
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