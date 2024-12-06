 -- Active: 1721298484659@@127.0.0.1@3306@afatse
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

-- //? a) Crear una tabla para registrar el histórico de cambios en los datos de los alumnos

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

-- //? b) Luego crear TRIGGERS para insertar los nuevos valores en archivo_historico cuando los
-- //? alumnos sean ingresados o sus datos sean modificados. Registrar la fecha y hora actual
-- //? con CURRENT_TIMESTAMP y el usuario actual con CURRENT_USER.

drop trigger if exists alumnos_after_upd_tr;

create trigger alumnos_after_upd_tr after update on alumnos for each row
begin
	update alumnos_historico ah
	set ah.dni = new.dni,
	ah.fecha_hora_cambio = CURRENT_TIMESTAMP(),
	ah.nombre = new.nombre,
	ah.apellido = new.apellido,
	ah.tel = new.tel,
	ah.email = new.email,
	ah.direccion = new.direccion,
	ah.usuario_modificacion = CURRENT_USER()
	where ah.dni = new.dni;
end;

drop trigger if exists alumnos_after_ins_tr;

create trigger alumnos_after_ins_tr after insert on alumnos for each row
begin
	insert into alumnos_historico(dni, fecha_hora_cambio, nombre, apellido, tel, email, direccion, usuario_modificacion)
	values(new.dni, CURRENT_TIMESTAMP(), new.nombre, new.apellido, new.tel, new.email, new.direccion, CURRENT_USER());
end;

-- //? c) Probarlo ejecutando INSERTS y UPDATES dentro de transacciones

start transaction;
insert into alumnos
values(25252525, 'Elias', 'Koteas', '2525252', 'eliaskoteas@gmail.com', 'Salta 2525');

update alumnos
set direccion = 'Saavedra 2525'
where dni = 25252525;


insert into alumnos
values(26262626, 'Laura', 'Hernandez', '2626262', 'lau@gmail.com', 'Salta 2525');

update alumnos
set direccion = 'Garibaldi 2525'
where dni = 26262626;

rollback;

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

-- //? a) Modificar la tabla cursos, agregarle una columna llamada cant_inscriptos que será un
-- //? atributo calculado de la cantidad de inscriptos al curso con el siguiente script:

alter table `cursos`
add column cant_inscriptos int(11) default null;

alter table cursos
drop column cant_inscriptos;

-- //? b) Completar el campo con la cantidad actual de inscriptos
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

-- //? c) Hacer obligatorio el campo cant_inscriptos

alter table `cursos`
modify cant_inscriptos int(11) not null;

-- //? d) Crear los TRIGGERS necesarios para actualizar la cantidad de inscriptos del curso, los
-- //? mismos deberán dispararse al inscribir un nuevo alumno y al eliminar una inscripción.

drop trigger if exists inscripciones_before_ins_tr;
create trigger inscripciones_before_ins_tr after insert on inscripciones for each row
begin
	update cursos c
	set c.cant_inscriptos = cant_inscriptos + 1
	where c.nom_plan = new.nom_plan 
	and c.nro_curso = new.nro_curso;
end;

drop trigger if exists inscripciones_before_del_tr;
create trigger inscripciones_before_del_tr after delete on inscripciones for each row
begin
	update cursos c
	set c.cant_inscriptos = cant_inscriptos - 1
	where c.nom_plan = old.nom_plan 
	and c.nro_curso = old.nro_curso;
end;


-- //? e) Probarlo inscribiendo y anulando inscripciones dentro de transacciones

call alumno_inscripcion(10101010, 'Reparac PC Avanzada', 1);

call alumno_anula_inscripcion(10101010, 'Reparac PC Avanzada', 1);


-- Ejercicio 4
-- a) Agregar la columna usuario_alta a la tabla valores_plan con el siguiente script

-- b) Crear un TRIGGER que una vez insertado el nuevo precio registre el usuario que lo ingresó.

-- c) Probar el TRIGGER dentro de una transacción. Realizar las pruebas con ROLLABACK y COMMIT.

-- //? a)

alter table valores_plan
add column usuario_alta varchar(50);

-- //? b)

drop trigger if exists valores_plan_before_ins_tr;

create trigger valores_plan_before_ins_tr before insert on valores_plan for each row
begin
	set @usuario = current_user();
	set new.usuario_alta = current_user();
end;

-- //? c)

start transaction;

insert into valores_plan(nom_plan, fecha_desde_plan, valor_plan)
values('Marketing 3', '2024-11-05', 500000);

rollback;