--------------- Question n°1 ---------------

-- /!\ BETWEEN inclusif ou exclusif /!\
SELECT count(Datemutation) AS 'Vente semestre 1'
FROM data
WHERE Typelocal = 'Appartement'
AND Datemutation BETWEEN '2020-01-01' AND '2020-06-30';


--------------- Question n°2 ---------------

SELECT
Nombrepiecesprincipales AS 'Nb pièces',
count(Nombrepiecesprincipales) AS 'Nb de logements',
count(Nombrepiecesprincipales) * 100 / (SELECT count(Nombrepiecesprincipales) FROM data WHERE Typelocal='Appartement') AS 'Taux de logements'
FROM data
WHERE Typelocal = 'Appartement'
GROUP BY Nombrepiecesprincipales
ORDER BY Nombrepiecesprincipales;


--------------- Question n°3 ---------------

SELECT Codedepartement AS 'Département', round(AVG(Valeurfonciere / SurfaceCarrezdu1erlot),2) AS 'Prix m²'
FROM data
GROUP by Codedepartement
ORDER BY AVG(Valeurfonciere / SurfaceCarrezdu1erlot) DESC
LIMIT 10;


--------------- Question n°4 ---------------

SELECT round(AVG(Valeurfonciere / SurfaceCarrezdu1erlot),2) AS 'Prix m² moyen'
FROM data
WHERE Typelocal = 'Maison'
GROUP BY Codedepartement IN ('75','92','77','78','91','92','93','94','95')
HAVING Codedepartement IN ('75','92','77','78','91','92','93','94','95');


--------------- Question n°5 ---------------

SELECT
Valeurfonciere AS Prix,
Codedepartement AS Département,
round(Valeurfonciere/SurfaceCarrezdu1erlot,2) AS 'Prix m²'
FROM data
WHERE Codetypelocal = 2
ORDER BY CAST(Valeurfonciere AS int) DESC
LIMIT 10;


--------------- Question n°6 ---------------

-- Méthode 1 :
SELECT
(SELECT count(Datemutation)
FROM data
WHERE Datemutation LIKE '2020-01%'
OR Datemutation LIKE '2020-02%'
OR Datemutation LIKE '2020-03%') AS 'Vente trimestre 1',
(SELECT count(Datemutation)
FROM data
WHERE Datemutation LIKE '2020-04%'
OR Datemutation LIKE '2020-05%'
OR Datemutation LIKE '2020-06%') AS 'Vente trimestre 2',
ROUND(((SELECT count(Datemutation)
FROM data
WHERE Datemutation LIKE '2020-04%'
OR Datemutation LIKE '2020-05%'
OR Datemutation LIKE '2020-06%') -
(SELECT count(Datemutation)
FROM data
WHERE Datemutation LIKE '2020-01%'
OR Datemutation LIKE '2020-02%'
OR Datemutation LIKE '2020-03%')) * 100.0 /
(SELECT count(Datemutation)
FROM data
WHERE Datemutation LIKE '2020-01%'
OR Datemutation LIKE '2020-02%'
OR Datemutation LIKE '2020-03%'),2) AS "Taux d'évolution des ventes"
FROM data
GROUP BY (SELECT count(Datemutation)
FROM data
WHERE Datemutation LIKE '2020-01%'
OR Datemutation LIKE '2020-02%'
OR Datemutation LIKE '2020-03%') -
(SELECT count(Datemutation)
FROM data
WHERE Datemutation LIKE '2020-04%'
OR Datemutation LIKE '2020-05%'
OR Datemutation LIKE '2020-06%');

-- Méthode 2 :
WITH
table1 AS (
SELECT count(Datemutation) AS trim1
FROM data
WHERE Datemutation BETWEEN '2019-12-31' AND '2020-03-31'),
table2 AS (
SELECT count(Datemutation) AS trim2
FROM data
WHERE Datemutation BETWEEN '2020-04-01' AND '2020-06-30')
SELECT
trim1 AS 'Vente trimestre 1',
trim2 AS 'Vente trimestre 2',
ROUND((trim2-trim1)*100.0/trim1, 2) AS "Taux d'évolution des ventes"
FROM table1,table2;


--------------- Question n°7 ---------------

WITH
table1 AS (
SELECT Commune, count(Commune) AS trim1
FROM data
WHERE Datemutation LIKE '2020-01%'
OR Datemutation LIKE '2020-02%'
OR Datemutation LIKE '2020-03%'
GROUP BY Commune),
table2 AS (
SELECT count(Commune) AS trim2
FROM data
WHERE Datemutation LIKE '2020-04%'
OR Datemutation LIKE '2020-05%'
OR Datemutation LIKE '2020-06%'
GROUP BY Commune)
SELECT
Commune,
trim1 AS 'Vente trimestre 1',
trim2 AS 'Vente trimestre 2',
ROUND((trim2-trim1)*100.0/trim1, 2) AS "Taux d'évolution des ventes"
FROM table1,table2
GROUP BY Commune HAVING (trim2-trim1)*100.0/trim1 >20
ORDER BY (trim2-trim1)*100.0/trim1;


--------------- Question n°8 ---------------

WITH
table1 AS (
SELECT avg(Valeurfonciere/SurfaceCarrezdu1erlot) AS pri2
FROM data
WHERE Nombrepiecesprincipales=2 AND Typelocal = 'Appartement'),
table2 AS (
SELECT avg(Valeurfonciere/SurfaceCarrezdu1erlot) AS pri3
FROM data
WHERE Nombrepiecesprincipales=3 AND Typelocal = 'Appartement')
SELECT
pri2 AS 'Prix 2 pieces',
pri3 AS 'Prix 3 pieces',
ROUND((pri3-pri2)*100.0/pri2, 2) AS "Ecart entre 2 et 3 pieces"
FROM table1,table2;


--------------- Question n°9 ---------------

WITH
table1 AS (
WITH
table2 AS (
SELECT Codedepartement, Commune, round(avg(Valeurfonciere),1) AS moy
FROM data
WHERE Codedepartement IN (6,13,33,59,69)
GROUP BY Commune
ORDER BY Codedepartement ASC, moy DESC)
SELECT *, ROW_NUMBER() OVER (PARTITION BY Codedepartement ORDER BY moy DESC) AS RowNum
FROM table2)
SELECT Codedepartement AS 'Département', Commune, moy AS 'Prix moyen' FROM table1 WHERE RowNum <= 3
