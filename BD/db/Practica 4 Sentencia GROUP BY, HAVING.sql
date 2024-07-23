 -- Clase de teoria 24-07-2024

-- COUNT: Cuenta la cantidad de registros que hay 

SELECT COUNT(*)
FROM alumnos;

SELECT COUNT(c.fecha_pago)
FROM cuotas c;

-- Se pueden hacer operaciones
SELECT COUNT(*) - COUNT(c.fecha_pago)
FROM cuotas c;

-- Mostrar cuanto pagaron las personas por cada curso
SELECT c.dni, a.nombre, a.apellido, 
	SUM(c.importe_pagado)
FROM cuotas c
INNER JOIN alumnos a ON c.dni = a.dni
WHERE a.apellido like "a%"
GROUP BY c.dni, a.nombre, a.apellido
HAVING SUM(c.importe_pagado) > 300
ORDER BY a.nombre, a.apellido;

-- Practica Nro 3 HAVING 

use agencia_personal;

-- Ejercicio 1 ✅
-- Mostrar las comisiones pagadas por la empresa Tráigame eso 

SELECT e.razon_social, SUM(com.importe_comision) "Total comision"
FROM empresas e
INNER JOIN contratos c ON e.cuit = c.cuit
INNER JOIN comisiones com ON c.nro_contrato = com.nro_contrato
WHERE razon_social = "Tráigame eso" AND com.fecha_pago is not null;

-- Ejercicio 2 ✅
-- IDEM pero para todas las empresas

SELECT e.razon_social, SUM(com.importe_comision) "Total comision"
FROM empresas e
INNER JOIN contratos c ON e.cuit = c.cuit
INNER JOIN comisiones com ON c.nro_contrato = com.nro_contrato
WHERE com.fecha_pago is not null
GROUP BY 1;

-- Ejercicio 3 ✅
-- Mostrar el promedio, desviación estándar y varianza del puntaje de las evaluaciones de entrevistas, 
-- por tipo de evaluación y entrevistador. Ordenar por promedio en forma ascendente y 
-- luego por desviación estándar en forma descendente.

SELECT eva.desc_evaluacion, ent.nombre_entrevistador, 
	avg(ee.resultado) "Promedio", stddev(ee.resultado) "Desviacion", variance(ee.resultado) "Varianza"
FROM evaluaciones eva
INNER JOIN entrevistas_evaluaciones ee ON eva.cod_evaluacion = ee.cod_evaluacion
INNER JOIN entrevistas ent ON ee.nro_entrevista = ent.nro_entrevista
GROUP BY 1,2
ORDER BY avg(ee.resultado) asc, stddev(ee.resultado) desc ;
