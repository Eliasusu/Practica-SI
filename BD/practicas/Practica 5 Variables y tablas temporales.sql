-- Active: 1721298484659@@127.0.0.1@3306@afatse
use agencia_personal;
-- Ejercicio 1 ✅
-- Primero hacerlo con una subconsulta y luego con variables y tabla temporal
-- ¿Qué personas fueron contratadas por las mismas empresas que Stefanía Lopez?

select distinct per.dni, per.nombre, per.apellido , con.cuit
from contratos con 
inner join personas per on con.dni_persona = per.dni
where con.cuit in (
    select con1.cuit
    from contratos con1
    inner join personas per1
    on per1.dni = con1.dni_persona
    where per1.nombre = 'Stefanía' and per1.apellido = 'Lopez'
);

select per.dni into @dniPersona
from personas per 
where per.nombre = 'Stefanía' and per.apellido = 'Lopez';

set @cuitEmpresa = (select distinct con.cuit
from contratos con
inner join personas per on con.dni_persona = per.dni
where per.dni = @dniPersona);

select distinct per.dni, per.nombre, per.apellido , con.cuit
from contratos con
inner join personas per on con.dni_persona = per.dni
where con.cuit = @cuitEmpresa;

-- Ejercicio 2 ✅
-- Encontrar a aquellos empleados que ganan menos que el máximo sueldo de los empleados de Viejos Amigos. 
SET @sueldoMaximo = (
    SELECT MAX(con.sueldo)
    FROM contratos con 
    INNER JOIN empresas em ON con.cuit = em.cuit AND em.razon_social = 'Viejos Amigos'
);

SELECT @sueldoMaximo;

SELECT per.dni as DNI, CONCAT(per.nombre, ' ', per.apellido) as Nombre, con.sueldo as Sueldo
FROM contratos con 
INNER JOIN personas per ON con.dni_persona = per.dni
WHERE Sueldo < @sueldoMaximo

-- Ejercicio 3 ✅
-- Mostrar empresas contratantes y sus promedios de comisiones pagadas o a pagar, 
-- pero sólo de aquellas cuyo promedio supere al promedio de Tráigame eso.

SET @promedioComision = (
    SELECT AVG(com.importe_comision)
    FROM contratos con 
    INNER JOIN empresas em ON con.cuit = em.cuit AND em.razon_social = 'Traigame eso'
    INNER JOIN comisiones com ON con.nro_contrato = com.nro_contrato
);
SELECT @promedioComision;

SELECT em.cuit as Cuit, em.razon_social as Razon_Social, AVG(com.importe_comision) as Promedio_Comisiones
FROM contratos con 
INNER JOIN empresas em ON con.cuit = em.cuit
INNER JOIN comisiones com ON con.nro_contrato = com.nro_contrato
GROUP BY 1,2
HAVING Promedio_Comisiones > @promedioComision;

-- Ejercicio 4 ✅
-- Seleccionar las comisiones pagadas que tengan un importe menor al promedio de todas las comisiones(pagas y no pagas), 
-- mostrando razón social de la empresa contratante, mes contrato, año contrato , nro. contrato, nombre y apellido del empleado.

SET @promedioDeTodasLasComisiones = (
    SELECT AVG(com.importe_comision)
    FROM comisiones com 
);

SELECT @promedioDeTodasLasComisiones;

SELECT em.razon_social as Razon_Social, com.nro_contrato as Nro_Contrato, com.mes_contrato as Mes_Contrato, com.anio_contrato as Año_Contrato, CONCAT(per.nombre, ' ', per.apellido) as Nombre, com.importe_comision as Importe_Comision
FROM contratos con 
INNER JOIN empresas em ON con.cuit = em.cuit
INNER JOIN comisiones com ON con.nro_contrato = com.nro_contrato
INNER JOIN personas per ON con.dni_persona = per.dni
WHERE Importe_Comision < @promedioDeTodasLasComisiones


-- Ejercicio 5 ✅
-- Determinar las empresas que pagaron en promedio la mayor de las comisiones.

set @promedioComisiones = (
select avg(c.importe_comision) 
from comisiones c
);

select em.razon_social, avg(co.importe_comision) EstaPagaBien
from contratos c
inner join comisiones co on c.nro_contrato = co.nro_contrato
inner join empresas em on c.cuit = em.cuit
group by 1
having @promedioComisiones < EstaPagaBien;

-- Ejercicio 6 ✅
-- Seleccionar los empleados que no tengan educación no formal o terciario.

select CONCAT(per1.apellido, ' ', per1.nombre) as Nombre
from personas per1
where per1.dni
not in (
select per.dni
from personas per 
inner join personas_titulos pertit on per.dni = pertit.dni
inner join titulos tit on pertit.cod_titulo = tit.cod_titulo
where tipo_titulo in('Educacion no formal', 'Terciario'));

-- Ejercicio 7 ✅
-- Mostrar los empleados cuyo salario supere al promedio de sueldo de la empresa que los contrató. 

drop temporary table if exists avgSueldosPorEmp;
create temporary table avgSueldosPorEmp
select emp.cuit, avg(con.sueldo) as AvgSueldo
from contratos con
inner join empresas emp on con.cuit = emp.cuit
group by emp.cuit, emp.razon_social;

select * from avgSueldosPorEmp;

select per.dni, con.sueldo, ase.AvgSueldo
from avgSueldosPorEmp ase
inner join contratos con on ase.cuit = con.cuit
inner join personas per on con.dni_persona = per.dni
where con.sueldo > ase.AvgSueldo

-- Haciendolo con CTE
with promedio as (
    select emp.cuit, avg(con.sueldo) as AvgSueldo
    from contratos con
    inner join empresas emp on con.cuit = emp.cuit
    group by emp.cuit)
select per.dni, con.sueldo, AvgSueldo
from promedio prom
inner join contratos con on prom.cuit = con.cuit
inner join personas per on con.dni_persona = per.dni
where con.sueldo > prom.AvgSueldo;

-- Ejercicio 8 ✅
-- Determinar las empresas que pagaron en promedio la mayor o menor de  las comisiones
drop temporary table if exists avgComPorEmp;
create temporary table avgComPorEmp
select em.razon_social, avg(co.importe_comision) avgComisiones
from contratos c
inner join comisiones co on c.nro_contrato = co.nro_contrato
inner join empresas em on c.cuit = em.cuit
group by em.razon_social;

select max(avgComisiones) as MaxComision, min(avgComisiones) as MinComision into @maxComision, @minComision
from avgComPorEmp

select @maxComsion, @minComision;
select razon_social, avgComisiones
from avgComPorEmp
where avgComisiones in (@maxComision, @minComision);

-- BASE DE DATOS: AFATSE
use afatse;

-- Ejercicio en clase 10/09/2021 ✅
-- Listar los alumnos que se inscribieron a mas cursos en 2014 que el promedio de alumnos por cursos
-- en el mismo año (2014)

with promedioCurso as (
    select ins.dni, count(*)
    from inscripciones ins
    where YEAR(ins.fecha_inscripcion) = '2014'
    group by ins.dni)
select *
from inscripciones ins  
where promedioCurso > (select avg(promedioCurso) from ins)


with inscr_cursos as (SELECT alu.nombre, alu.apellido, count(ins1.dni) cantInscr2014
FROM alumnos alu 
LEFT JOIN inscripciones ins1 
on ins1.dni = alu.dni and  year(ins1.fecha_inscripcion) = 2014
group by alu.nombre, alu.apellido)
select * 
from inscr_cursos
where cantInscr2014 > 
(select avg(cantInscr2014) from inscr_cursos);

select ins.nro_curso, count(*)
from inscripciones ins
where YEAR(ins.fecha_inscripcion) = '2014'
group by ins.nro_curso

-- Ejercicio 9 ✅
-- Alumnos que se hayan inscripto a más cursos que Antoine de Saint-Exupery. 
-- Mostrar todos los datos de los alumnos, la cantidad de cursos a la que se inscribió 
-- y cuantas veces más que Antoine de Saint-Exupery.

set @cantCursosAntoine = (
    select count(*)
    from inscripciones ins
    inner join alumnos alu on ins.dni = alu.dni
    where alu.nombre = 'Antoine de' and alu.apellido = 'Saint-Exupery'
);

select @cantCursosAntoine;

select alu.dni, alu.nombre, alu.apellido, alu.tel, alu.email, alu.direccion, count(*) as CantInsc, count(*) - @cantCursosAntoine as Diferencia
from inscripciones ins
inner join alumnos alu on ins.dni = alu.dni
group by alu.dni, alu.nombre, alu.apellido, alu.tel, alu.email, alu.direccion
having CantInsc > @cantCursosAntoine;

-- Ejercicio 10 ✅
-- Indicar qué cantidad de alumnos se han inscripto a los Planes de Capacitación en el año 2014 
-- indicando:
-- 1. Para cada Plan de Capacitación la cantidad de alumnos inscriptos
-- 2: Porcentaje que representa respecto del total de inscriptos a los Planes de Capacitación dictados en el año (2014). 

set @cantInscriptos = (
    select count(*)
    from inscripciones ins
)

select @cantInscriptos

select ins.nom_plan, count(*) as cantidadInscriptos, (count(*)/@cantInscriptos)*100 as PorcentajeTotal
from inscripciones ins 
GROUP BY ins.nom_plan

-- Ejercicio 11 ✅ (resuelto con copilot)
-- Indicar el valor actual de los planes de Capacitación 

SELECT vp.nom_plan, vp.fecha_desde_plan, vp.valor_plan
FROM valores_plan vp
INNER JOIN (
    SELECT nom_plan, MAX(fecha_desde_plan) AS FechaActual
    FROM valores_plan
    GROUP BY nom_plan
) sub ON vp.nom_plan = sub.nom_plan AND vp.fecha_desde_plan = sub.FechaActual;

-- Ejercicio 12 ✅ (resuelto con copilot)
-- Plan de capacitacion mas barato. 
-- Indicar los datos del plan de capacitacion y el valor actual

SELECT vp.nom_plan, vp.fecha_desde_plan, vp.valor_plan
FROM valores_plan vp
INNER JOIN (
    SELECT nom_plan, MAX(fecha_desde_plan) AS FechaActual
    FROM valores_plan
    GROUP BY nom_plan
) sub ON vp.nom_plan = sub.nom_plan AND vp.fecha_desde_plan = sub.FechaActual
order by vp.valor_plan ASC
limit 1;

-- Ejercicio 13 ✅
-- ¿Qué instructores que han dictado algún curso del Plan de Capacitación “Marketing 1” 
-- el año 2014 y no vayan a dictarlo este año? (año 2015)

select ins.cuil, ins.nombre, ins.apellido
from cursos_instructores curins 
inner join instructores ins on curins.cuil = ins.cuil
inner join cursos cur on curins.nro_curso = cur.nro_curso and cur.nom_plan = 'Marketing 1'
where YEAR(cur.fecha_fin) = '2014' and  ins.cuil not in (
    select distinct ins.cuil
    from cursos_instructores curins 
    inner join instructores ins on curins.cuil = ins.cuil
    inner join cursos cur on curins.nro_curso = cur.nro_curso and cur.nom_plan = 'Marketing 1'
    where YEAR(cur.fecha_fin) = '2015' 
) 

-- Ejercicio 14 ✅
-- Alumnos que tengan todas sus cuotas pagas hasta la fecha.

select distinct alu.dni, alu.nombre, alu.apellido
from cuotas cuo 
inner join alumnos alu on cuo.dni = alu.dni
where cuo.fecha_pago is not null and alu.dni not in(
    select alu.dni
    from cuotas cuo 
    inner join alumnos alu on cuo.dni = alu.dni
    where cuo.fecha_pago is null
) order by alu.dni asc

-- Ejercicio 15 ✅
-- Alumnos cuyo promedio supere al del curso que realizan. Mostrar dni, nombre y apellido, promedio y promedio del curso.

with promedioPorCurso as (
    select ev.nro_curso, avg(ev.nota) as PromedioCurso
    from evaluaciones ev
    group by ev.nro_curso
) select alu.dni, concat(alu.nombre, ' ', alu.apellido) as Nombre, ppc.PromedioCurso as PromedioCurso, avg(ev.nota) as PromedioAlumno
from promedioPorCurso ppc
inner join evaluaciones ev on ppc.nro_curso = ev.nro_curso
inner join alumnos alu on ev.dni = alu.dni
group by alu.dni, Nombre, PromedioCurso
having PromedioAlumno > PromedioCurso;

-- Ejercicio 16
-- Para conocer la disponibilidad de lugar en los cursos que empiezan en abril para lanzar una campaña 
-- se desea conocer la cantidad de alumnos inscriptos a los cursos que comienzan a partir del 1/04/2014 indicando: 
-- Plan de Capacitación, curso, fecha de inicio, salón, cantidad de alumnos inscriptos y diferencia con el cupo de alumnos registrado 
-- para el curso que tengan al más del 80% de lugares disponibles respecto del cupo.

-- Ayuda💡
-- tener en cuenta el uso de los paréntesis y la precedencia de los operadores matemáticos.


-- Ejercicio 17
-- Indicar el último incremento de los valores de los planes de capacitación, 
-- consignando nombre del plan fecha del valor actual, fecha del valor anterior, valor actual, valor anterior y diferencia entre los valores. Si el curso tiene un único valor mostrar la fecha anterior en NULL el valor anterior en 0 y la diferencia a 0.
