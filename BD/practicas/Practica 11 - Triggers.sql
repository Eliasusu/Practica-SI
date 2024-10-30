-- //? TRIGGERS

/* Ejercicio 1

a) Crear una tabla para registrar el histórico de cambios en los datos de los alumnos con
el siguiente script:
CREATE TABLE `alumnos_historico` (
`dni` int(11) NOT NULL,
`fecha_hora_cambio` datetime NOT NULL,
`nombre` varchar(20) default NULL,
`apellido` varchar(20) default NULL,
`tel` varchar(20) default NULL,
`email` varchar(50) default NULL,
`direccion` varchar(50) default NULL,
`usuario_modificacion` varchar(50) default NULL,
PRIMARY KEY (`dni`,`fecha_hora_cambio`),
CONSTRAINT `alumnos_historico_alumnos_fk` FOREIGN KEY (`dni`) REFERENCES
`alumnos` (`dni`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

b) Luego crear TRIGGERS para insertar los nuevos valores en archivo_historico cuando los
alumnos sean ingresados o sus datos sean modificados. Registrar la fecha y hora actual
con CURRENT_TIMESTAMP y el usuario actual con CURRENT_USER.

c) Probarlo ejecutando INSERTS y UPDATES dentro de transacciones. Probar con
ROLLBACK y luego con COMMIT. */


/*
-- Ejercicio 2
a) Crear la tabla stock_movimientos para registrar las cambios en las existencias de
artículos con el siguiente script:
CREATE TABLE `stock_movimientos` (
`cod_material` char(6) NOT NULL,
`fecha_movimiento` timestamp NOT NULL default CURRENT_TIMESTAMP on update
CURRENT_TIMESTAMP,
`cantidad_movida` int(11) NOT NULL,
`cantidad_restante` int(11) NOT NULL,
`usuario_movimiento` varchar(50) NOT NULL,
PRIMARY KEY (`cod_material`,`fecha_movimiento`),
CONSTRAINT `stock_movimientos_fk` FOREIGN KEY (`cod_material`) REFERENCES

`materiales` (`cod_material`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

? Aclaración: En este caso utilizamos el tipo de datos timestamp en lugar de datetime
? para registrar la fecha y hora de la modificación.
? En el ejercicio anterior utilizamos el tipo de dato datetime pero entonces debemos
? registrar el dato a nosotros (en ese caso lo hicimos con CURRENT_TIMESTAMP). En los
? casos donde queremos hacer históricos o asegurarnos de que se registra el momento
? exacto en que se inserta un dato es mejor utilizar el tipo de dato timestamp que hace
? esto automáticamente pero en los INSERT que realicemos sobre las tablas con estos
? datos deberemos omitir este campo.

b) Crear TRIGGERS para registrar los movimientos en las cantidades de los materiales en
la tabla del histórico. En el caso de un nuevo material se debe registrar la cantidad
inicial como la cantidad movida y SÓLO en el caso de un cambio en la cantidad
registrar el cambio.

c) Probarlo ejecutando INSERTS y UPDATES dentro de transacciones. Probar con
ROLLBACK y luego con COMMIT.

*/
CREATE TABLE `stock_movimientos` (
`cod_material` char(6) NOT NULL,
`fecha_movimiento` timestamp NOT NULL default CURRENT_TIMESTAMP on update
CURRENT_TIMESTAMP,
`cantidad_movida` int(11) NOT NULL,
`cantidad_restante` int(11) NOT NULL,
`usuario_movimiento` varchar(50) NOT NULL,
PRIMARY KEY (`cod_material`,`fecha_movimiento`),
CONSTRAINT `stock_movimientos_fk` FOREIGN KEY (`cod_material`) REFERENCES

`materiales` (`cod_material`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


delimiter $$;

$$;

CREATE DEFINER=`root`@`localhost` TRIGGER `materiales_after_ins_tr` AFTER INSERT ON `materiales` FOR EACH ROW BEGIN
if new.cant_disponible is not null then
insert into stock_movimientos( cod_material, cantidad_movida,
cantidad_restante, usuario_movimiento)
values (new.cod_material,new.cant_disponible,new.cant_disponible,CURRENT_USER);
end if;
END

$$;

delimiter $$;

$$;
CREATE DEFINER=`root`@`localhost` TRIGGER `materiales_before_upd_tr` BEFORE UPDATE ON `materiales` FOR EACH ROW BEGIN
	if new.cant_disponible is not null then
	set @cant_movida= ABS(new.cant_disponible-old.cant_disponible);
		if @cant_movida!=0 then
			insert into stock_movimientos( cod_material, cantidad_movida,
			cantidad_restante, usuario_movimiento)
			values (new.cod_material,@cant_movida,
			new.cant_disponible,CURRENT_USER);
		end if;
	end if;
END
$$;


/* 
-- Ejercicio 3
a) Modificar la tabla cursos, agregarle una columna llamada cant_inscriptos que será un
atributo calculado de la cantidad de inscriptos al curso con el siguiente script:
alter table `cursos`
add column cant_inscriptos int(11) default null;

b) Completar el campo con la cantidad actual de inscriptos con el script:
START TRANSACTION;
drop temporary table if exists insc_curso;
create temporary table insc_curso
select c.`nom_plan`, c.`nro_curso`, count(i.`nro_curso`) cant
from cursos c left join `inscripciones` i
on c.`nom_plan`=i.`nom_plan` and c.`nro_curso`=i.`nro_curso`
group by c.`nom_plan`,c.`nro_curso`;

update cursos c inner join insc_curso ic on c.`nom_plan`=ic.`nom_plan`
and c.`nro_curso`=ic.`nro_curso`
set c.`cant_inscriptos`=ic.cant;

commit;

c) Hacer obligatorio el campo cant_inscriptos con el script:
alter table `cursos`
modify cant_inscriptos int(11) not null;

d) Crear los TRIGGERS necesarios para actualizar la cantidad de inscriptos del curso, los
mismos deberán dispararse al inscribir un nuevo alumno y al eliminar una inscripción.

e) Probarlo inscribiendo y anulando inscripciones dentro de transacciones. Realizar las
pruebas con ROLLBACK y con COMMIT.
*/

alter table `cursos`
add column cant_inscriptos int(11) default null;

START TRANSACTION;
drop temporary table if exists insc_curso;
create temporary table insc_curso
select c.`nom_plan`, c.`nro_curso`, count(i.`nro_curso`) cant
from cursos c left join `inscripciones` i
on c.`nom_plan`=i.`nom_plan` and c.`nro_curso`=i.`nro_curso`
group by c.`nom_plan`,c.`nro_curso`;

update cursos c inner join insc_curso ic on c.`nom_plan`=ic.`nom_plan`
and c.`nro_curso`=ic.`nro_curso`
set c.`cant_inscriptos`=ic.cant;

commit;

alter table `cursos`
modify cant_inscriptos int(11) not null;




