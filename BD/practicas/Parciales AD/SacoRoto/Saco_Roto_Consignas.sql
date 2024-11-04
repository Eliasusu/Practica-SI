-- Active: 1721298484659@@127.0.0.1@3306@saco_roto
use saco_roto;

-- //?? Ejercicio 1 de DDL

/* DROP TABLE IF EXISTS `prendas`;

CREATE TABLE `prendas` (
  `nro_persona` int(11) NOT NULL,
  `cod_tipo_prenda` int(11) NOT NULL,
  `nro_pedido` int(11) NOT NULL,
  `fecha_fin_est` date default NULL,
  `fecha_fin_real` date default NULL,
  `fecha_entrega` date default NULL,
  `comentarios` varchar(200) default NULL,
  `fecha_medicion` date default NULL,
  `precio_pactado` decimal(11,0) default NULL,
  `confirmada` tinyint(1) default '0',
  `cantidad` int(11) default NULL,
  PRIMARY KEY  (`nro_persona`,`cod_tipo_prenda`,`nro_pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; */


-- //? Ejercicio 2 DML
-- //? Listado de prendas sin confeccionar

select per.nombre, per.apellido, tp.desc_tipo_prenda, p.fecha_hora_pedido, pre.fecha_fin_est, pre.fecha_entrega, DATEDIFF(pre.fecha_entrega, CURRENT_DATE()) as Demora
-- //! En la resolución oficial el DATEDIFF tiene los parametros invertidos,
-- //! esto hace que el resultado sea negativo, por lo que opte por dejarlo asi para que sea positivo

from prendas pre
inner join personas per on pre.nro_persona = per.nro_persona
inner join tipos_prendas tp on pre.cod_tipo_prenda = tp.cod_tipo_prenda
inner join pedidos p on pre.nro_pedido = p.nro_pedido
where pre.fecha_fin_real is null

-- //? Ejercicio 3 DML
-- //? Estadística de tipos de prendas

select tp.cod_tipo_prenda, tp.desc_tipo_prenda
from tipos_prendas tp
where tp.cod_tipo_prenda not in (select pre.cod_tipo_prenda from prendas pre);

-- // * Las subconsultas se utilizan para comparar un unico atributo que saco de una tabla o joins entre tablas


-- // ! Resolucion con LEFT JOIN

select tp.cod_tipo_prenda, tp.desc_tipo_prenda
from tipos_prendas tp
left join prendas pre on tp.cod_tipo_prenda = pre.cod_tipo_prenda
where pre.cod_tipo_prenda is null;

-- // ? Ejercicio 4 DML
-- // ? Última fecha de prueba

--//* Cuando te piden hallar el ultimo de alguna cosa, hay que hacer una tabla temporal en donde se almacene el maximo de la fecha 

drop procedure if exists ult_prueba;

DELIMITER $$

create procedure ult_prueba(
  IN fecha_in DATE
)
begin

  -- // * En esta tabla estan las ultimas pruebas hechas hasta la fecha que se pasa como parametro 

  drop temporary table if exists max_fecha_prueba;
  
  create temporary table max_fecha_prueba(
    select pr.cod_tipo_prenda, pr.nro_persona, MAX(pr.fecha_prueba) as ultima_fecha
    from pruebas pr
    where pr.fecha_prueba <= fecha_in
    group by pr.cod_tipo_prenda, pr.nro_persona
  );


  -- //* Ahora utilizo la tabla max_fecha_prueba para emparejar con joins para sacar el nombre de la persona y el nombre del tipo de prenda

  select CONCAT(per.nombre, ' ', per.apellido) as cliente, m.cod_tipo_prenda, tp.desc_tipo_prenda, m.ultima_fecha
  from max_fecha_prueba m
  inner join personas per on m.nro_persona = per.nro_persona
  inner join tipos_prendas tp on m.cod_tipo_prenda = tp.cod_tipo_prenda
  order by m.ultima_fecha desc, cliente asc;


end
DELIMITER ;

-- Probar el procedimiento con la fecha: 5/11/2013

call ult_prueba('2013-11-05');

-- //? Consignas de TCL y DDL
-- //? Ejercicio 5

/* 
La tabla MATERIALES tiene el atributo unidad de medida que el usuario registra manualmente sin la posibilidad de 
controlar la integridad del dato. Se requiere entonces mantener la tabla unidades_medida que contenga los distintos 
valores de las unidades de medida hasta ahora registrados para luego vincularla a la tabla materiales. Para ello se 
requiere. 
a)  Crear la tabla: UNIDADES_MEDIDA con los atributos cod_unidad (clave primaria) y desc_unidad. Nota: Se sugiere 
indicar el atributo cod_unidad como auto-incremental  
b)  Registrar en la tabla UNIDADES_MEDIDA creada las diferentes unidades de medida que existan en la tabla de 
MATERIALES. 
c)  Agregar el atributo cod_unidad a la tabla de MATERIALES  
d)  Actualizar el atributo cod_unidad de la tabla de MATERIALES con el correspondiente cod_unidad de la tabla 
UNIDADES_MEDIDA  
e)  Completar la definición de la tabla MATERIALES para lograr controlar la integridad referencial 
  
* NOTAS:  
* 1)  Para las consignas 4a), 4c) y 4e) copiar el DDL que se obtiene de la herramienta utilizada  
* 2)  Todas aquellas operaciones que deban realizar actualizaciones de registros en las tablas de la base de datos 
* deben ser realizadas como una transacción.  
* 3)  En el punto e) revise las opciones de control de la integridad referencial en Borrado o Actualización. 
*/

-- //? a) Crear la tabla UNIDADES_MEDIDA


DROP TABLE IF EXISTS `unidades_medida`;

CREATE TABLE unidades_medida (
  `cod_unidad` int(11) NOT NULL AUTO_INCREMENT,
  `desc_unidad` varchar(50) NOT NULL,
  PRIMARY KEY (`cod_unidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- //? b) Registrar en la tabla UNIDADES_MEDIDA creada las diferentes unidades de medida que existan en la tabla de MATERIALES.

start transaction;

insert into unidades_medida(desc_unidad)
select distinct unidad
from materiales;

commit;

-- //? c) Agregar el atributo cod_unidad a la tabla de MATERIALES

alter table materiales
add column cod_unidad int(11) not null;

-- //? d) Actualizar el atributo cod_unidad de la tabla de MATERIALES con el correspondiente cod_unidad de la tabla UNIDADES_MEDIDA

start transaction;

update materiales m
inner join unidades_medida u on m.unidad = u.desc_unidad
set m.cod_unidad = u.cod_unidad;


-- // * Este alter no esta en la resolución y no se si está del todo bien, pero me parece redundante tener la columna unidad y cod_unidad
alter table materiales
drop column unidad;

commit;

-- //? e) Completar la definición de la tabla MATERIALES para lograr controlar la integridad referencial

alter table materiales
add constraint fk_cod_unidad
foreign key (cod_unidad)
references unidades_medida(cod_unidad)
on delete cascade
on update cascade;

-- //? Horarios de consulta Jueves 09:00 AM y 19:15 PM
-- //? Horarios de consulta Martes 17:30 PM