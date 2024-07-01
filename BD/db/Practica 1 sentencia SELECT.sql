-- Active: 1719338576084@@127.0.0.1@3306@agencia_personal
use agencia_personal;

-- 1 ejercicio practica 
-- Mostrar la estructura de la tabla empresa, seleccionar toda la información de la tabla empresa y mostrarla en pantalla.

desc empresas;

select * 
from empresas;


-- Ejemplos en clase
select nro_contrato, anio_contrato, mes_contrato
from comisiones
order by nro_contrato asc, anio_contrato;

select nombre, apellido
from personas
where nombre like 'E%';

-- Pasar todas las comisiones que me deben
select * from comisiones
where fecha_pago is null;


select ifnull(fecha_pago, 'No pagado')
from comisiones; 


-- Pasar todos los que me pagaron
select * from comisiones
where fecha_pago is not null;

-- funcion concatenar

select concat(nombre, ' ', apellido) as nombre_completo
from personas;

-- Ejericio 3
-- Guardar el siguiente query en un archivo de extensión .sql, para luego correrlo. Mostrar los títulos con el formato de columna: Código Descripción y Tipo ordenarlo alfabéticamente por descripción.

select cod_titulo as 'Código', desc_titulo as 'Descripción', tipo_titulo
from titulos
order by desc_titulo asc;

-- Ejercicio 4
-- Mostrar de la persona con DNI nro. 28675888. El nombre y apellido, fecha de nacimiento, teléfono, y su dirección. Las cabeceras de las columnas serán:

select concat(nombre, ' ', apellido) as 'Nombre y Apellido', fecha_nacimiento as 'Fecha de Nacimiento', Telefono as 'Teléfono', direccion as 'Dirección'
from personas 
where dni = 28675888;

-- Ejercicio 5
-- Mostrar los datos de ej. Anterior, pero para las personas 27890765, 29345777 y 31345778. Ordenadas por fecha de Nacimiento
select concat(nombre, ' ', apellido) as 'Nombre y Apellido', fecha_nacimiento as 'Fecha de Nacimiento', Telefono as 'Teléfono', direccion as 'Dirección'
from personas 
where dni in (27890765, 29345777, 31345778)
order by fecha_nacimiento;

-- Ejercicio 6
-- Mostrar las personas cuyo apellido empiece con la letra 'G'
select * from personas
where apellido like 'G%';

-- Ejercicio 7
-- Mostrar el nombre, apellido y fecha de nacimiento de las personas nacidas entre 1980 y 2000
select nombre, apellido, fecha_nacimiento from personas
where fecha_nacimiento between '1980-01-01' and '2000-12-31'
order by fecha_nacimiento;

-- Ejercicio 8
-- Mostrar las solicitudes que hayan sido hechas alguna vez ordenados en forma ascendente por fecha de solicitud.
select * from solicitudes_empresas
order by fecha_solicitud asc;

-- Ejercicio 9
-- Mostrar los antecedentes laborales que aún no hayan terminado su relación laboral ordenados por fecha desde
select * from antecedentes
where fecha_hasta is null
order by fecha_desde;