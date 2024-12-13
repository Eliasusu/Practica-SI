/*AD.A1- Embarcación de mayor almacenamiento por tipo de embarcación. La empresa desea identificar a las embarcaciones que llevan más tiempo
 total almacenadas para cada tipo de embarcación. El total de horas de almacenamiento de cada embarcación se calcula como la sumatoria de
 las diferencia en horas entre la fecha y hora de fin de contrato y la fecha y hora de contrato (atención: en los contratos que no tienen
 aún fecha y hora de fin deberá usarse la actual). La embarcación con mayor hs totales será considerada como la de mayor almacenamiento
Se requiere listar para cada tipo de embarcación la embarcación con más horas totales almacenadas, indicando: código y nombre del tipo de 
embarcación; hin y nombre de la embarcación; número y nombre del propietario, fecha de la primera vez que almacenó la embarcación, 
cantidad de horas totales de almacenamiento, y de las salidas con dicha embarcación la última fecha de salida en 2024 y la cantidad de
 salidas durante 2024.
Si una embarcación no tiene tiempo de almacenamiento indicar 0 en las horas totales.
Se deberán listar todos los tipos de embarcación y aún si no tienen ningún almacenamiento indicando 0.
Se deberá mostrar la embarcación con más tiempo de almacenamiento aún si no tuvo salidas indicando 0 en la cantidad de salidas.
Ordenar los datos por horas totales de almacenamiento descendente, fecha del primer almacenamiento ascendente y cantidad de salidas descendente.
#### Resolución*/

with te_alm as (
    select te.codigo cod_tipo, te.nombre tipo
        , e.hin, e.nombre emb, e.numero_socio
        , s.nombre propietario
        , min(ec.fecha_hora_contrato) desde
        , sum(coalesce(timestampdiff(hour, fecha_hora_contrato, coalesce(fecha_hora_baja_contrato,now())),0)) hs_tot
    from tipo_embarcacion te
    left join embarcacion e
        on te.codigo=e.codigo_tipo_embarcacion
    left join embarcacion_cama ec
        on e.hin=ec.hin
    left join socio s
    on e.numero_socio=s.numero
    group by te.codigo, e.hin
), max_alm as (
    select te_alm.cod_tipo, max(hs_tot) max_hs   -- tipo embarc con mas hs almacenadas
    from te_alm
    group by te_alm.cod_tipo
)
select te_alm.cod_tipo, te_alm.tipo, te_alm.hin, te_alm.emb
    , te_alm.numero_socio, te_alm.propietario
    , te_alm.desde, te_alm.hs_tot
    , max(sal.fecha_hora_salida) ult_salida, count(sal.fecha_hora_salida) salidas
from te_alm
inner join max_alm
    on te_alm.cod_tipo=max_alm.cod_tipo
    and te_alm.hs_tot=max_alm.max_hs    -- igualar por la cantidad hs 
left join salida sal
    on te_alm.hin=sal.hin
    and sal.fecha_hora_salida between '20240101' and '20241201'
group by te_alm.cod_tipo, te_alm.tipo, te_alm.hin, te_alm.emb, te_alm.numero_socio, te_alm.propietario,
te_alm.desde, te_alm.hs_tot
order by te_alm.hs_tot desc, te_alm.desde, salidas desc
/*
### AD.A2
#### Enunciado
AD.A2- Estado camas. La empresa ha decidido que necesita más información sobre el estado de las camas. Se decidió separar del estado la situación de uso en una nueva columna y mantener esta información actualizada por medio de triggers.
Se requiere:
Agregar en la tabla cama la columna en_uso (utilizar el tipo de dato apropiado).
Reflejar el valor de dicha columna según esta regla. Si tiene un contrato en embarcacion_cama sin fecha y hora de baja de contrato está en uso. Caso contrario no lo está.
A través del uso de triggers al registrar un nuevo contrato de una embarcación sin fecha y hora de baja de contrato cambiar el valor de la columna en_uso para reflejar que se encuentra utilizada y al registrar una fecha y hora de baja de contrato reflejar que se encuentra libre.

Usa los siguientes datos para probar
*/
insert into embarcacion_cama values ('ESP010',2,8,now(),null);

##y luego

update embarcacion_cama set fecha_hora_baja_contrato=now() where hin='ESP010' and fecha_hora_baja_contrato is null;
#### Resolución

alter table cama add column en_uso boolean null;

update cama
set en_uso=true
where exists (
    select 1
    from embarcacion_cama ec
    where ec.codigo_sector=cama.codigo_sector
    and ec.numero_cama=cama.numero
    and ec.fecha_hora_baja_contrato is null
);

update cama set en_uso=false where en_uso is null;

alter table cama change column en_uso en_uso boolean not null;

delimiter (︶︹︶)
drop trigger if exists tr_embarcacion_cama_contrata (︶︹︶)
create trigger tr_embarcacion_cama_contrata after insert on embarcacion_cama
for each row
begin
    update cama set en_uso=true
    where cama.codigo_sector=new.codigo_sector
    and cama.numero=new.numero_cama
    and new.fecha_hora_baja_contrato is null;
end; (︶︹︶)

drop trigger if exists tr_embarcacion_cama_fin_contrato (︶︹︶)
create trigger tr_embarcacion_cama_fin_contrato after update on embarcacion_cama
for each row
begin
    update cama set en_uso=false
    where cama.codigo_sector=new.codigo_sector
    and cama.numero=new.numero_cama
    and new.fecha_hora_baja_contrato is not null;
end; (︶︹︶)
delimiter ;
/*
## Parcial AD - Tema B
### AD.B2
#### Enunciado
AD.B2- Cursos más exitosos. La empresa desea conocer para cada tipo de embarcación información de los cursos más exitosos. 
Se considera que el curso más exitoso para cada tipo de embarcación es el que tiene mayor cantidad de socios inscriptos dentro de los
 cursos de dicho tipo de embarcación (que se relaciona según la actividad realizada en el curso). Se requiere listar para cada tipo de
 embarcación el curso más exitoso indicando: código y nombre del tipo de embarcación; número, nombre y descripción de la actividad del 
 curso, número de curso, cuántos días pasaron desde que se comenzó a dictar dicho curso, cantidad de inscriptos que tuvo y la cantidad
 de embarcaciones del tipo de embarcación que están actualmente almacenadas en la guardería.
Si para un tipo de embarcación no se dictó ningún curso debe mostrarse igualmente con 0 inscriptos y sin datos de la actividad o curso y
 si no hay embarcaciones almacenadas actualmente de dicho tipo debe mostrarse con 0.
Ordenar por cantidad de embarcaciones almacenadas descendente, cantidad de inscriptos ascendente y días desde que comenzó el curso 
ascendente.
#### Resolución
*/
with te_ins as (
    select a.codigo_tipo_embarcacion cod_tipo_emb
        , a.numero nro_act, a.nombre actividad
        , c.numero curso, c.fecha_inicio
        , count(i.numero_socio) insc  -- obtengo cantidad de socios inscriptos x tipo embarcacion, no hace falta iffnull o coalesce,
        , datediff(current_date, c.fecha_inicio) dias_desde_inicio   -- Obtengo cant de dias
    from actividad a
    left join curso c
        on a.numero=c.numero_actividad
    left join inscripcion i
        on c.numero=i.numero_curso
    group by a.codigo_tipo_embarcacion, c.numero, a.numero
), ti as  (
    select ti.cod_tipo_emb, max(ti.insc) max_insc    -- obtengo el maximo cant de inscriptos,  
    from te_ins ti
    group by ti.cod_tipo_emb
), emb_tipo as (
    select e.codigo_tipo_embarcacion cod_tipo_emb, count(*) cant_emb_almac    -- cantidad de tipo emb almacenadas
    from embarcacion e
    inner join embarcacion_cama ec
        on e.hin=ec.hin
    where ec.fecha_hora_baja_contrato is null or ec.fecha_hora_baja_contrato > now()
    group by e.codigo_tipo_embarcacion
)
select te.codigo cod_tipo_emb, te.nombre tipo
    , te_ins.dias_desde_inicio
    , te_ins.nro_act, te_ins.actividad
    , te_ins.curso
    , te_ins.insc
    , emb_tipo.cant_emb_almac
from tipo_embarcacion te
left join te_ins                   -- left para mostrar 0 inscriptos
    on te.codigo=te_ins.cod_tipo_emb
left join ti
    on te_ins.cod_tipo_emb=ti.cod_tipo_emb
    and te_ins.insc=ti.max_insc
left join embarcacion e
    on te_ins.cod_tipo_emb=e.codigo_tipo_embarcacion
left join emb_tipo
    on te.codigo=emb_tipo.cod_tipo_emb
order by emb_tipo.cant_emb_almac desc, te_ins.insc, te_ins.dias_desde_inicio
;
### AD.B2
#### Enunciado
/*AD.B2- Embarcaciones almacenadas. La empresa ha detectado dificultad para identificar si las embarcaciones se encuentran almacenadas o 
no a la hora de cierre. Por este motivo se ha decidido agregar una columna “almacenada” en la tabla embarcación que refleje la situación y 
automatizar con triggers el estado de dicha columna.
:Se requiere
Crear una columna almacenada para reflejar el estado (utilizar el tipo de dato que crea apropiado).
Cargar el valor inicial de la columna. Las embarcaciones que no tengan una salida con fecha y hora de regreso real en null está 
almacenadas.
A través del uso de triggers al registrar una nueva salida de una embarcación cambiar el valor de la columna almacenada para reflejar
que salió y al registrar una fecha y hora de regreso real reflejar que se encuentra almacenada.
*/
-- Puede usar los siguientes datos para probar:

insert into salida 
values ('can002',now(),'20241202T200000',null);

update salida 
set fecha_hora_regreso_real=now() 
where fecha_hora_regreso_real is null;
#### Resolución

alter table embarcacion add column almacenada boolean null;

update embarcacion 
set almacenada=true
where hin not in (
    select hin
    from salida
    where fecha_hora_regreso_real is null
);

update embarcacion 
set almacenada=false
where almacenada is null;


alter table embarcacion change column almacenada almacenada boolean not null;

delimiter (︶︹︶)
drop trigger if exists tr_salida_salir (︶︹︶)
create trigger tr_salida_salir after insert on salida
for each row
begin
    update embarcacion set almacenada=false
    where hin = new.hin and new.fecha_hora_regreso_real is null;
end; (︶︹︶)


drop trigger if exists tr_salida_regreso (︶︹︶)
create trigger tr_salida_regreso after update on salida
for each row
begin
    update embarcacion set almacenada=true
    where hin = new.hin and new.fecha_hora_regreso_real is not null;
end; (︶︹︶)

delimiter ;


insert into salida values ('can002',now(),'20241202T200000',null);

##y luego

update salida set fecha_hora_regreso_real=now() where fecha_hora_regreso_real is null;


