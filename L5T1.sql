SELECT * FROM product
SELECT * FROM pc
SELECT * FROM printer
SELECT * FROM laptop

SELECT AVG(speed)
FROM pc

SELECT p.maker,AVG(l.screen) AS 'Average screen size'
FROM PRODUCT p
JOIN laptop l ON p.model=l.model
GROUP BY p.maker

SELECT AVG(speed)
FROM laptop 
WHERE price>=1000

SELECT AVG(pc.price)
FROM product p
JOIN pc pc ON pc.model=p.model
WHERE p.maker='A'



?????????????????

SELECT AVG(pc.price), AVG(l.price)
FROM product p
FULL JOIN pc pc ON pc.model=p.model
FULL JOIN laptop l ON l.model=p.model
WHERE p.maker='B' AND pc.model IS NOT NULL AND l.model IS NOT NULL

SELECT AVG(c.price), AVG(l.price)
FROM pc c, laptop l
JOIN product p ON p.model=c.model OR p.model=l.model
WHERE p.maker='B' AND c.model IS NOT NULL AND l.model IS NOT NULL

SELECT *
FROM product p
JOIN pc c ON p.model=c.model
GROUP BY p.type

SELECT AVG(price1), AVG(price2)
FROM (SELECT price AS price1
      FROM product p 
          JOIN pc ON p.model = pc.model
      WHERE maker = 'B'
      UNION ALL
      SELECT price AS price2
      FROM product p 
          JOIN laptop ON p.model = laptop.model
      WHERE maker = 'B') u

????????????????????



SELECT speed, AVG(price)
FROM pc
GROUP BY speed

SELECT maker
FROM product p
JOIN pc c ON p.model=c.model
GROUP BY maker
HAVING COUNT(*)>=3

SELECT DISTINCT p.maker
FROM product p
JOIN pc c ON p.model=c.model
GROUP BY p.maker
HAVING c.price=MAX(c.price)

SELECT AVG(c.price)
FROM pc c
WHERE c.speed>=800
GROUP BY c.speed

SELECT AVG(c.hd)
FROM product p
JOIN pc c ON p.model=c.model
JOIN product p2 ON p.maker=p2.maker
JOIN printer pr ON pr.model=p2.model

SELECT MAX(price)-MIN(price) AS 'Price range'
FROM laptop
GROUP BY screen




SELECT COUNT(*)
FROM CLASSES

SELECT AVG(NUMGUNS) 
FROM CLASSES C 
JOIN SHIPS S ON C.CLASS=S.CLASS 

SELECT C.CLASS, MIN(S.LAUNCHED),MAX(S.LAUNCHED)
FROM CLASSES C 
JOIN SHIPS S ON C.CLASS=S.CLASS
GROUP BY C.CLASS 

SELECT s.CLASS,COUNT(*)
FROM SHIPS s
JOIN OUTCOMES o ON s.NAME=o.SHIP
WHERE o.RESULT = 'sunk'
GROUP BY s.CLASS

/*SELECT *
FROM SHIPS s
JOIN OUTCOMES o ON s.NAME=o.SHIP 
JOIN SHIPS s2 ON s.CLASS=s2.CLASS
WHERE o.RESULT='sunk'
ORDER BY s.CLASS
GROUP BY s.CLASS
HAVING COUNT(s.CLASS)>=4*/

SELECT s.CLASS,COUNT(*)/COUNT(DISTINCT s.NAME)
FROM SHIPS s
JOIN OUTCOMES o ON s.NAME=o.SHIP 
JOIN SHIPS s2 ON s.CLASS=s2.CLASS
WHERE o.RESULT='sunk'
GROUP BY s.CLASS
HAVING COUNT(*)>=4

SELECT COUNT(*)
FROM SHIPS s
WHERE s.NAME IN 
(SELECT s.NAME
FROM SHIPS s
JOIN OUTCOMES o ON s.NAME=o.SHIP 
JOIN SHIPS s2 ON s.CLASS=s2.CLASS
WHERE o.RESULT='sunk'
GROUP BY s.NAME
HAVING COUNT(*)>=4)


SELECT c.COUNTRY, AVG(c.DISPLACEMENT)
FROM SHIPS s
JOIN CLASSES c ON s.CLASS=c.CLASS
GROUP BY c.COUNTRY


SELECT * FROM CLASSES
SELECT * FROM SHIPS ORDER BY CLASS
SELECT * FROM OUTCOMES
