-- Active: 1719338576084@@127.0.0.1@3306@agencia_personal
use agencia_personal;

-- Ejercicio 1 🕛
-- Mostrar del Contrato 5:  DNI, Apellido y Nombre de la persona contratada y el sueldo acordado en el contrato.

SELECT dni_persona, sueldo, nro_contrato
FROM contratos c
INNER JOIN personas p 
ON p.dni = c.dni_persona
WHERE c.nro_contrato = 5;

-- Ejercicio 2 🕛
-- ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso? 
-- Mostrar el DNI, número de contrato, fecha de incorporación, fecha de solicitud en la agencia de los contratados y 
-- fecha de caducidad (si no tiene fecha de caducidad colocar ‘Sin Fecha’). 
-- Ordenado por fecha de incorporación y nombre de empresa.

SELECT dni_persona, nro_contrato, fecha_incorporacion, fecha_solicitud, ifnull(fecha_caducidad,'Sin fecha'), cuit
FROM contratos c
INNER JOIN empresas e
ON c.cuit = e.cuit_empresa
WHERE e.razon_social = 'Viejos Amigos' OR e.razon_social = 'Tráigame Eso'
ORDER BY fecha_incorporacion, e.razon_social;

-- Ejercicio 3 🕛
-- Listado de las solicitudes consignando razón social, dirección y e_mail de la empresa, 
-- descripción del cargo solicitado y años de experiencia solicitados, ordenado por fecha de solicitud y 
-- descripción de cargo.

SELECT anios_experiencia, razon_social, direccion, e_mail, desc_cargo
FROM solicitudes_empresas s JOIN empresas e JOIN cargos c 
ON s.cuit = e.cuit_empresa AND s.cod_cargo = c.cod
ORDER BY fecha_solicitud, desc_cargo;

-- Ejercicio 4 🕛
-- ¿Listar todos los candidatos con título de bachiller o un título de educación no formal. 
-- Mostrar nombre y apellido, descripción del título y DNI.

SELECT nombre, apellido, desc_titulo, dni
FROM personas p JOIN titulos t JOIN personas_titulos pt
ON p.dni = pt.dni_persona AND pt.cod_titulo = t.cod
WHERE tipo_titulo = 'Secundario' OR tipo_titulo = 'Educación no formal';

-- Ejercicio 5 🕛
-- Realizar el punto 4 sin mostrar el campo DNI pero para todos los títulos.

SELECT nombre, apellido, desc_titulo
FROM personas p INNER JOIN titulos t JOIN personas_titulos pt
ON p.dni = pt.dni_persona AND pt.cod_titulo = t.cod
WHERE tipo_titulo = 'Secundario' OR tipo_titulo = 'Educación no formal';

-- Ejercicio 6 🕛
-- Empleados que no tengan referencias o hayan puesto de referencia a Armando Esteban Quito o Felipe Rojas. 
-- Mostrarlos de la siguiente forma:
-- Pérez, Juan tiene como referencia a Felipe Rojas cuando trabajo en Constructora Gaia S.A

DROP TABLE IF EXISTS tabla_temporal;
CREATE TEMPORARY TABLE IF NOT EXISTS tabla_temporal
SELECT DISTINCT apellido, nombre, dni, persona_referencia
FROM personas p JOIN antecedentes a
ON p.dni = a.dni_persona
WHERE persona_referencia = 'Armando Esteban Quito' OR persona_referencia = 'Felipe Rojas';
SELECT DISTINCT CONCAT(apellido, ', ', nombre, ' tiene como referencia a ', persona_referencia, ' cuando trabajó en ', razon_social)
FROM tabla_temporal tt JOIN contratos c JOIN empresas e
ON tt.dni = c.dni_persona AND c.cuit = e.cuit_empresa;

-- Ejercicio 7 🕛
-- Seleccionar para la empresa Viejos amigos, fechas de solicitudes, descripción del cargo solicitado y 
-- edad máxima  y mínima . Si no tiene edad mínima y máxima indicar “sin especificar”. 
-- Encabezado:
-- Empresa | Fecha de Solicitud | Cargo Solicitado | Edad Mínima | Edad Máxima

SELECT 
    razon_social as 'Empresa', fecha_solicitud as 'Fecha de Solicitud', 
    desc_cargo as 'Cargo Solicitado',
    CASE  
        WHEN edad_minima IS NULL THEN 'Sin especificar'
        ELSE edad_minima
        END as 'Edad Mínima',
    CASE
        WHEN edad_maxima IS NULL THEN 'Sin especificar'
        ELSE edad_maxima
        END as 'Edad Máxima'
FROM    
    solicitudes_empresas s INNER JOIN empresas e INNER JOIN cargos c
ON 
    s.cuit = e.cuit_empresa AND s.cod_cargo = c.cod
WHERE 
    razon_social = 'Viejos Amigos';

-- Ejercicio 8 🕛
-- Mostrar los antecedentes de cada postulante:
-- Postulante(nombre y apellido) | Cargo(descripcion del cargo)

SELECT 
    CONCAT(nombre, ' ', apellido) as 'Postulante', desc_cargo as 'Cargo'
FROM 
    antecedentes a INNER JOIN personas p INNER JOIN cargos c
ON 
    a.dni_persona = p.dni AND a.cod_cargo = c.cod;

-- Ejercicio 9 🕛
-- Mostrar todas las evaluaciones realizadas para cada solicitud ordenar en forma ascendente por empresa y 
-- descendente por cargo:
-- Empresa | Cargo | Desc Evaluacion | Resultado

SELECT 
    razon_social as 'Empresa', desc_cargo as 'Cargo', desc_evaluacion as 'Desc Evaluacion', resultado as 'Resultado'
FROM
    entrevistas e INNER JOIN entrevistas_evaluaciones ee INNER JOIN evaluaciones ev INNER JOIN empresas em INNER JOIN cargos c
ON 
    e.nro_entrevista = ee.nro_entrevista AND ee.cod_evaluacion = ev.cod AND e.cuit = em.cuit_empresa AND e.cod_cargo = c.cod
ORDER BY
    razon_social ASC, desc_cargo DESC;