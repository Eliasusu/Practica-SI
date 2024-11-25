-- Active: 1721298484659@@127.0.0.1@3306@recursos_humanos
-- //? Ejercicio 2 DML
-- //? Cantidad de registro de proceso de selección por Empleado

-- //* Guardo el codigo del area que me piden
set @codAreaRRHH = (
select a.cod_area
from areas a
where denominacion = 'RRHH');


-- //* Seleccion de los ultimos puestos en donde trabajan los empleados

drop temporary table if exists empleadosRRHH;

create temporary table empleadosRRHH(
select ep.legajo, max(ep.fecha_ini) as fecha
from empleados_puestos ep 
where ep.fecha_ini <= CURRENT_DATE() and ep.cod_area = @codAreaRRHH
group by ep.legajo);

-- //* Seleccion de empleados que trabajan en RRHH y La cantidad de Procesos que completaron

select em.legajo, concat(em.apellido, ' ', em.nombre) as nombre, count(distinct(ps.nro_doc)) as cant_procesos_seleccion
from empleados em
inner join empleadosRRHH emRH on em.legajo = emRH.legajo
left join proceso_seleccion ps on emRH.legajo = ps.legajo
where year(ps.fecha_hora) = '2018'
group by em.legajo, nombre;

-- //? Ejercicio 3 DML
-- //? Ranking de solicitudes

-- //? Ejercicio 5 TCL
-- //? Nuevos valores Salario 

--//! 01-03-2019
start transaction;

--//* Sacar el ultimo valor hora por cod de puesto

drop temporary table if exists ultimo_valor_hora;
create temporary table ultimo_valor_hora(
    select sa.cod_area, sa.cod_puesto, max(sa.fecha) as ultima_fecha
    from salario sa
    where sa.fecha <= CURRENT_DATE()
    group by sa.cod_area, sa.cod_puesto
);

insert into salario
select uvh.cod_area, uvh.cod_puesto, '2019-03-01', round(sa.valor_hora * 1.25, 2)
from ultimo_valor_hora uvh
inner join salario sa on uvh.cod_area = sa.cod_area 
    and uvh.cod_puesto = sa.cod_puesto
    and uvh.ultima_fecha = sa.fecha
where sa.valor_hora < 150;

insert into salario
select uvh.cod_area, uvh.cod_puesto, '2019-03-01', round(sa.valor_hora * 1.20, 2)
from ultimo_valor_hora uvh
inner join salario sa on uvh.cod_area = sa.cod_area 
    and uvh.cod_puesto = sa.cod_puesto
    and uvh.ultima_fecha = sa.fecha
where sa.valor_hora >= 150;

commit;

