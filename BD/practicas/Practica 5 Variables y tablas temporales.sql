-- Active: 1721298484659@@127.0.0.1@3306@agencia_personal
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
group by 1;

-- Ejercicio 6
-- Seleccionar los empleados que no tengan educación no formal o terciario.


-- Ejercicio 7
-- Mostrar los empleados cuyo salario supere al promedio de sueldo de la empresa que los contrató. 

-- Ejercicio 8
-- Determinar las empresas que pagaron en promedio la mayor o menor de  las comisiones
