-- Active: 1721298484659@@127.0.0.1@3306@agencia_personal
use agencia_personal;

-- Ejercicio 1 ✅
-- Mostrar las comisiones pagadas por la empresa Tráigame eso.

SELECT sum(importe_comision) as Comisiones_Pagadas, razon_social
FROM comisiones com
JOIN contratos co ON com.nro_contrato = co.nro_contrato
JOIN empresas em on co.cuit = em.cuit
WHERE em.razon_social = 'Traigame eso' AND fecha_pago IS NOT NULL;

-- Ejercicio 2 ✅
-- Ídem 1) pero para todas las empresas.

SELECT em.razon_social as Empresas, sum(importe_comision) as Comisiones_Pagadas
FROM comisiones com
JOIN contratos co ON com.nro_contrato = co.nro_contrato
JOIN empresas em on co.cuit = em.cuit
WHERE fecha_pago IS NOT NULL
GROUP BY em.razon_social

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
ORDER BY avg(ee.resultado) asc, stddev(ee.resultado) desc;

-- Ejercicio 4 ✅
-- Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código de evaluación.

SELECT eva.cod_evaluacion ,eva.desc_evaluacion, ent.nombre_entrevistador, 
    avg(ee.resultado) "Promedio", stddev(ee.resultado) "Desviacion", variance(ee.resultado) "Varianza"
FROM evaluaciones eva
INNER JOIN entrevistas_evaluaciones ee ON eva.cod_evaluacion = ee.cod_evaluacion
INNER JOIN entrevistas ent ON ee.nro_entrevista = ent.nro_entrevista
WHERE ent.nombre_entrevistador = 'Angelica Doria'
GROUP BY 1,2
HAVING avg(ee.resultado) > 71
ORDER BY eva.cod_evaluacion;

-- Ejercicio 5 ✅
-- Cuantas entrevistas fueron hechas por cada entrevistador en oct 2014

SELECT ent.nombre_entrevistador, count(*) "Cantidad entrevistas"
FROM entrevistas ent
WHERE fecha_entrevista between "2014-10-01" and "2014-10-31"
GROUP BY ent.nombre_entrevistador;

-- Ejercicio 6 ✅
-- Ídem 4) pero para todos los entrevistadores. Mostrar nombre y cantidad. Ordenado por cantidad de entrevistas.

SELECT ent.nombre_entrevistador, eva.cod_evaluacion ,eva.desc_evaluacion, COUNT(*) "Cantidad entrevistas",
    avg(ee.resultado) "Promedio", stddev(ee.resultado) "Desviacion", variance(ee.resultado) "Varianza"
FROM evaluaciones eva
INNER JOIN entrevistas_evaluaciones ee ON eva.cod_evaluacion = ee.cod_evaluacion
INNER JOIN entrevistas ent ON ee.nro_entrevista = ent.nro_entrevista
GROUP BY 1,2
ORDER BY COUNT(*) DESC;
 
-- Ejercicio 7 ✅
-- Ídem 6) para aquellos cuya cantidad de entrevistas por codigo de evaluacion sea myor mayor que 1. 
-- Ordenado por nombre en forma descendente y por codigo de evalucacion en forma ascendente

SELECT ent.nombre_entrevistador, eva.cod_evaluacion ,eva.desc_evaluacion, COUNT(*) "Cantidad entrevistas",
    avg(ee.resultado) "Promedio", stddev(ee.resultado) "Desviacion", variance(ee.resultado) "Varianza"
FROM evaluaciones eva
INNER JOIN entrevistas_evaluaciones ee ON eva.cod_evaluacion = ee.cod_evaluacion
INNER JOIN entrevistas ent ON ee.nro_entrevista = ent.nro_entrevista
GROUP BY 1,2
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Ejercicio 8 ✅
-- Mostrar para cada contrato cantidad total de las comisiones, cantidad a pagar, cantidad pagadas.

SELECT com.nro_contrato, COUNT(*) "Cantidad total comisiones", 
    COUNT(CASE WHEN fecha_pago IS NULL THEN 1 END) "Cantidad a pagar",
    COUNT(CASE WHEN fecha_pago IS NOT NULL THEN 1 END) "Cantidad pagadas"
    FROM comisiones com
GROUP BY com.nro_contrato;

-- Ejercicio 9 ✅
-- Mostrar para cada contrato la cantidad de comisiones, el % de comisiones pagas y el % de impagas.

SELECT con.nro_contrato,COUNT(*) 'Total', 
    (COUNT(CASE WHEN fecha_pago IS NOT NULL THEN 1 END) / COUNT(*)) * 100 '% Pagadas',
    (COUNT(CASE WHEN fecha_pago IS NULL THEN 1 END) / COUNT(*)) * 100 '% Impagas'
FROM contratos con
    JOIN comisiones com ON con.nro_contrato = com.nro_contrato
GROUP BY con.nro_contrato;

 
-- Ejercicio 10 ✅
-- Mostrar la cantidad de empresas diferentes que han realizado solicitudes 
-- y la diferencia respecto al total de solicitudes.

SET @total_solicitudes = (SELECT count(*) FROM solicitudes_empresas);

SELECT COUNT(DISTINCT cuit) 'Empresas diferentes', 
    @total_solicitudes - COUNT(DISTINCT cuit) 'Diferencia respecto al total'
FROM solicitudes_empresas;

-- Ejercicio 11 
-- Cantidad de solicitudes por empresas

SELECT e.razon_social, count(*) 'Solicitudes' 
FROM solicitudes_empresas s
INNER JOIN empresas e ON s.cuit = e.cuit 
GROUP BY 1;

-- Ejercicio 12
--- Cantidad de solicitudes por empresas y cargos
SELECT e.razon_social, count(*) 'Solicitudes', count(*) 'Cargos'
FROM solicitudes_empresas s
INNER JOIN empresas e ON s.cuit = e.cuit
INNER JOIN cargos c ON s.cod_cargo = c.cod_cargo
GROUP BY 1;

-- LEFT/RIGHT JOIN
-- Ejercicio 13
-- Listar las empresas, indicando todos sus datos y la cantidad de personas diferentes que han 
-- mencionado dicha empresa como antecedente laboral. Si alguna empresa NO fue mencionada como 
-- antecedente laboral deberá indicar 0 en la cantidad de personas.

SELECT e.razon_social, count(DISTINCT a.dni) 'Cantidad de personas'
FROM empresas e
LEFT JOIN antecedentes a ON e.cuit = a.cuit
GROUP BY 1;

-- Ejercicio 14
-- Indicar para cada cargo la cantidad de veces que fue solicitado. 
-- Ordenado en forma descendente por cantidad de solicitudes. Si un cargo nunca fue solicitado, mostrar 0.
SELECT c.desc_cargo, count(s.cod_cargo)
FROM cargos c
LEFT JOIN solicitudes_empresas s ON c.cod_cargo = s.cod_cargo
GROUP BY 1
ORDER BY count(s.cod_cargo) DESC;

-- Ejercicio 15
-- Indicar los cargos que hayan sido solicitados menos de 2 veces

SELECT c.desc_cargo, count(s.cod_cargo)
FROM cargos c
LEFT JOIN solicitudes_empresas s ON c.cod_cargo = s.cod_cargo
GROUP BY 1
HAVING count(s.cod_cargo) < 2
ORDER BY count(s.cod_cargo) DESC;
