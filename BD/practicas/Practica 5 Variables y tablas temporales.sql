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