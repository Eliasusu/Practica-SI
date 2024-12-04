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

-- //* Variable temporal con la cantidad de solicitudes

set @totalSolicitudes = (
    select count(fecha_solic)
    from solicitudes_puestos sp
);

select @totalSolicitudes;

-- //* Consulta enlazando areas, puestos de trabajo y solicitudes y utilizando funciones de grupo

select sp.cod_area, a.denominacion, sp.cod_puesto, p.descripcion, count(fecha_solic) as solicitudes_registradas, round((count(fecha_solic) / @totalSolicitudes) * 100, 2) as porcentaje, sum(sp.cant_puestos_solic) as cant_puestos
from solicitudes_puestos sp
inner join puestos_de_trabajo p on sp.cod_puesto = p.cod_puesto
inner join areas a on sp.cod_area = a.cod_area
group by sp.cod_area, sp.cod_puesto
order by porcentaje desc;

-- //? Ejercicio 4
-- //? Store procedure

delimiter $$

drop procedure if exists registro_inicial_seleccion;
create procedure registro_inicial_seleccion (
    in fecha_dia DATETIME,
    in legajo_emp int
)
begin
    -- //* garantizar que el empleado sea un empleado de RRHH y activo
    if legajo_emp in (
        select emp.legajo
        from empleados emp
        inner join empleados_puestos ep on emp.legajo = ep.legajo
        inner join areas a on ep.cod_area = a.cod_area
        where a.denominacion = 'RRHH'
        and emp.fecha_ini is null
    ) then 

        -- //* Agrupar las solicitudes activas
        drop temporary table if exists solicitudes_activas;

        create temporary table solicitudes_activas (
            select *
            from solicitudes_puestos sp
            where sp.fecha_canc is null
        );

        -- //* Agrupar cv's que no fueron empleados y no estan en una solicitud
        drop temporary table if exists personas_disponibles;
        create temporary table personas_disponibles(
            select * 
            from curriculum c
            where c.nro_doc not in (
                select em.nro_doc
                from empleados em
            )
            and c.nro_doc not in (
                select ps.nro_doc
                from proceso_seleccion ps
            )
        );

        select * from personas_disponibles;
        select * from solicitudes_activas;

        set @codEstado = (
            select e.cod_estado
            from estados e
            where e.descripcion = 'Iniciado'
        );

        start transaction;

        insert into proceso_seleccion 
        select sa.cod_area, sa.cod_puesto, sa.fecha_solic, pd.tipo_doc, pd.nro_doc, fecha_dia, legajo_emp, ' ', @codEstado
        from solicitudes_activas sa
        inner join puestos_competencias pc on sa.cod_puesto = pc.cod_puesto and sa.cod_area = pc.cod_area
        inner join personas_disponibles pd on pc.cod_competencia = pd.cod_competencia
        where pc.excluyente = 'SI'
        group by 1,2,3,4,5
        having count(distinct(pd.cod_competencia)) >= 2;

    else 
        select 'El legajo ingresado no corresponde a una persona que trabaja en RRHH o un empleado activo' as mensaje;
    end if;

    commit;

end$$ 

delimiter;


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

