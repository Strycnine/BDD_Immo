--------------- Question n°1 ---------------

-- /!\ BETWEEN inclusif ou exclusif /!\
SELECT count(dates_mutation) AS 'Vente semestre 1'
FROM address
NATURAL JOIN mutation
WHERE code_type_local = 2
AND dates_mutation BETWEEN '2020-01-01' AND '2020-06-30';


--------------- Question n°2 ---------------

SELECT
	nombre_pieces_principales AS 'Nb pièces',
	count(nombre_pieces_principales) AS 'Nb de logements',
	count(nombre_pieces_principales) * 100 / (
		SELECT count(nombre_pieces_principales)
		FROM locals
		WHERE code_type_local=2) AS 'Taux de logements'
FROM locals
WHERE code_type_local = 2
GROUP BY nombre_pieces_principales
ORDER BY nombre_pieces_principales;


--------------- Question n°3 ---------------

SELECT code_department AS 'Département', round(AVG(valeur_fonciere / surface_carrez_du_1er_lot),2) AS 'Prix m²'
FROM address
NATURAL JOIN department
NATURAL JOIN lot
NATURAL JOIN mutation
GROUP by code_department
ORDER BY AVG(valeur_fonciere / surface_carrez_du_1er_lot) DESC
LIMIT 10;


--------------- Question n°4 ---------------

SELECT round(AVG(valeur_fonciere / surface_carrez_du_1er_lot),2) AS 'Prix m² moyen'
FROM address
NATURAL JOIN typelocal
NATURAL JOIN department
NATURAL JOIN mutation
NATURAL JOIN lot
WHERE type_local = 'Maison'
GROUP BY code_department IN ('75','92','77','78','91','92','93','94','95')
HAVING code_department IN ('75','92','77','78','91','92','93','94','95');


--------------- Question n°5 ---------------

SELECT
valeur_fonciere AS Prix,
code_department AS Département,
round(valeur_fonciere/surface_carrez_du_1er_lot,2) AS 'Prix m²'
FROM address
NATURAL JOIN mutation
NATURAL JOIN department
NATURAL JOIN lot
WHERE code_type_local = 2
ORDER BY CAST(valeur_fonciere AS int) DESC
LIMIT 10;


--------------- Question n°6 ---------------

WITH
table1 AS (
SELECT count(dates_mutation) AS trim1
FROM mutation
WHERE dates_mutation LIKE '2020-01%'
OR dates_mutation LIKE '2020-02%'
OR dates_mutation LIKE '2020-03%'),
table2 AS (
SELECT count(dates_mutation) AS trim2
FROM mutation
WHERE dates_mutation LIKE '2020-04%'
OR dates_mutation LIKE '2020-05%'
OR dates_mutation LIKE '2020-06%')
SELECT
trim1 AS 'Vente trimestre 1',
trim2 AS 'Vente trimestre 2',
ROUND((trim2-trim1)*100.0/trim1, 2) AS "Taux d'évolution des ventes"
FROM table1,table2;


--------------- Question n°7 ---------------

WITH
table1 AS (
SELECT commune, count(commune) AS trim1
FROM commune
NATURAL JOIN address
NATURAL JOIN mutation
WHERE dates_mutation LIKE '2020-01%'
OR dates_mutation LIKE '2020-02%'
OR dates_mutation LIKE '2020-03%'
GROUP BY commune),
table2 AS (
SELECT count(commune) AS trim2
FROM commune
NATURAL JOIN address
NATURAL JOIN mutation
WHERE dates_mutation LIKE '2020-04%'
OR dates_mutation LIKE '2020-05%'
OR dates_mutation LIKE '2020-06%'
GROUP BY commune)
SELECT
commune,
trim1 AS 'Vente trimestre 1',
trim2 AS 'Vente trimestre 2',
ROUND((trim2-trim1)*100.0/trim1, 2) AS "Taux d'évolution des ventes"
FROM table1,table2
GROUP BY commune HAVING (trim2-trim1)*100.0/trim1 >20
ORDER BY (trim2-trim1)*100.0/trim1;


--------------- Question n°8 ---------------

WITH
table1 AS (
SELECT avg(valeur_fonciere/surface_carrez_du_1er_lot) AS pri2
FROM mutation
NATURAL JOIN address
NATURAL JOIN lot
NATURAL JOIN locals
WHERE nombre_pieces_principales = 2 AND code_type_local = 2),
table2 AS (
SELECT avg(valeur_fonciere/surface_carrez_du_1er_lot) AS pri3
FROM mutation
NATURAL JOIN address
NATURAL JOIN lot
NATURAL JOIN locals
WHERE nombre_pieces_principales = 3 AND code_type_local = 2)
SELECT
pri2 AS 'Prix 2 pieces',
pri3 AS 'Prix 3 pieces',
ROUND((pri3-pri2)*100.0/pri2, 2) AS "Taux entre 2 et 3 pieces"
FROM table1,table2;


--------------- Question n°9 ---------------

WITH
table1 AS (
WITH
table2 AS (
SELECT code_department, commune, avg(valeur_fonciere) AS moy
FROM address
NATURAL JOIN department
NATURAL JOIN commune
NATURAL JOIN mutation
WHERE code_department IN (6,13,33,59,69)
GROUP BY commune
ORDER BY code_department ASC, moy DESC)
SELECT *, ROW_NUMBER() OVER (PARTITION BY code_department ORDER BY moy DESC) AS RowNum
FROM table2)
SELECT code_department AS 'Département', commune, moy AS 'Prix moyen', RowNum
FROM table1
WHERE RowNum <= 3
