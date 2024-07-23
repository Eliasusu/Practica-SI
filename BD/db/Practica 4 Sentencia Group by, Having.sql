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
