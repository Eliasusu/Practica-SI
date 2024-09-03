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
HAVING Cantidad_Cursos_Realizados > 5

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


