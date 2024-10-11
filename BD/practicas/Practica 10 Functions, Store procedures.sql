use afatse;

SET GLOBAL log_bin_trust_function_creators = 1;

-- //? FUNCTIONS Y STORE PROCEDURES
-- Ejercicio 1
-- Crear un procedimiento almacenado llamado plan_lista_precios_actual que devuelva los
-- planes de capacitación indicando:
-- nom_plan modalidad valor_actual

delimiter;

create procedure plan_lista_precios_actual()
begin
    select val.nom_plan, pc.modalidad, val.valor_plan as valor_actual
    from valores_plan val
    inner join plan_capacitacion pc
    on val.nom_plan = pc.nom_plan
    inner join (
        select nom_plan, max(fecha_desde_plan) as fecha
        from valores_plan 
        group by nom_plan
    ) fecha
    on val.nom_plan = fecha.nom_plan and val.fecha_desde_plan = fecha.fecha;
end

delimiter;

-- Ejercicio 2
-- Crear un procedimiento almacenado llamado plan_lista_precios_a_fecha que dada una
-- fecha devuelva los planes de capacitación indicando:
-- nom_plan modalidad valor_a_fecha

delimiter; 

create procedure plan_lista_precios_a_fecha (in fecha DATE)
begin 
    select val.nom_plan, pc.modalidad, val.valor_plan
    from valores_plan val
    inner join plan_capacitacion pc on val.nom_plan = pc.nom_plan
    inner join (
        select nom_plan, max(fecha_desde_plan) as fechaMax
        from valores_plan
        group by nom_plan
    ) fecha
    on val.nom_plan = fecha.nom_plan and val.fecha_desde_plan = fecha.fechaMax
    where val.fecha_desde_plan <= fecha;
end 

delimiter;

call plan_lista_precios_a_fecha('2022-10-01');

-- Ejercicio 3
-- Modificar el procedimiento almacenado creado en 1) para que internamente invoque al
-- procedimiento creado en 2).

delimiter;
DROP PROCEDURE plan_lista_precios_actual;
CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_lista_precios_actual`()
begin
    call plan_lista_precios_a_fecha(CURRENT_DATE());
end

delimiter;
call plan_lista_precios_actual();

-- Ejercicio 4
-- Crear una función llamada plan_valor que reciba el nombre del plan y una fecha y
-- devuelva el valor de dicho plan a esa fecha.

delimiter;

create function plan_valor (nom_plan VARCHAR(20), fecha_valor DATE)
returns DECIMAL
begin 
    select val.valor_plan into @valor
    from valores_plan val
    where val.nom_plan = nom_plan and val.fecha_desde_plan<=fecha_valor
    order by val.fecha_desde_plan desc
    limit 1;
    return @valor;
end 

delimiter;

select plan_valor('Reparacion PC', '2009-10-01');


-- Ejercicio 5
-- Modifique el procedimiento almacenado creado en 2) para que internamente utilice la
-- función creada en 4).

delimiter;
DROP PROCEDURE plan_lista_precios_a_fecha;
CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_lista_precios_a_fecha`(in fecha DATE)
begin
    select DISTINCT(val.nom_plan), pc.modalidad, plan_valor(val.nom_plan, fecha) as valor_a_fecha
    from valores_plan val
    inner join plan_capacitacion pc on val.nom_plan = pc.nom_plan;
end

delimiter;
call plan_lista_precios_a_fecha('2009-10-01');

-- Ejercicio 6
-- Crear un procedimiento almacenado llamado alumnos_pagos_deudas_a_fecha que dada
-- una fecha y un alumno indique cuanto ha pagado hasta esa fecha y cuantas cuotas
-- adeudaba a dicha fecha (cuotas emitidas y no pagadas). Devolver los resultados en
-- parámetros de salida.

delimiter;
drop procedure alumnos_pagos_deudas_a_fecha;
create procedure alumnos_pagos_deudas_a_fecha(
    in fecha DATE, 
    in nombre varchar(20), 
    in apellido varchar(20),
    out cuotasPagadas float(9,3), 
    out cantAdeudado int
    )
begin

    select sum(c.importe_pagado) into @cuotasPagadas
    from cuotas c
    inner join alumnos a on c.dni = a.dni
    where c.fecha_pago is not null
    and a.nombre = nombre
    and a.apellido = apellido
    and c.fecha_emision <= fecha
    group by c.dni, a.nombre, a.apellido;

    select count(*) into @cantAdeudado
    from cuotas c
    inner join alumnos a on c.dni = a.dni
    where c.fecha_pago is null
    and a.nombre = nombre
    and a.apellido = apellido
    and c.fecha_emision <= fecha
    group by c.dni, a.nombre, a.apellido;

    set cuotasPagadas = @cuotasPagadas;
    set cantAdeudado = @cantAdeudado;

end

delimiter;

call alumnos_pagos_deudas_a_fecha('2014-10-02', 'José', 'Ortega y Gasset', @cuotasPagadas, @cantAdeudado);

select @cuotasPagadas as CuotasPagadas, @cantAdeudado as CuotasImpagas;
