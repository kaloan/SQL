/*INSERT INTO MOVIEEXEC VALUES (115, 'Debra Winger', 'A way', 200000000)

SELECT * FROM MOVIEEXEC
SELECT * FROM MOVIESTAR

SELECT name, address
FROM MOVIESTAR WHERE gender='F'
INTERSECT
SELECT name, address 
FROM MovieExec WHERE networth > 10000000*/

/*SELECT * FROM STARSIN s JOIN MOVIE f
ON s.movietitle=f.title


SELECT m.name
FROM MOVIESTAR m JOIN STARSIN s
ON m.gender='M' AND m.name=s.starname AND s.movietitle='Terms of Endearment'

SELECT s.starname
FROM STARSIN s JOIN MOVIE f
ON s.movietitle=f.title AND f.year=1995 AND f.studioname='MGM'

SELECT * 
FROM MOVIE
ORDER BY LENGTH ASC

SELECT m.title
FROM MOVIE m JOIN MOVIE s
ON s.title='Star Wars' AND m.length>s.length*/

/*SELECT p.maker, l.speed
FROM product p JOIN laptop l
ON p.model=l.model AND l.hd>=9

SELECT *
FROM pc
ORDER BY hd

SELECT m.model, m.price
FROM product p JOIN laptop m
ON p.maker='B' AND p.model=m.model

SELECT m.model, m.price
FROM product p JOIN pc m
ON p.maker='B' AND p.model=m.model

SELECT m.model, m.price
FROM product p JOIN printer m
ON p.maker='B' AND p.model=m.model



SELECT m.model, m.price
FROM product p JOIN laptop m
ON p.maker='B' AND p.model=m.model
UNION ALL
SELECT m.model, m.price
FROM product p JOIN pc m
ON p.maker='B' AND p.model=m.model
UNION ALL
SELECT m.model, m.price
FROM product p JOIN printer m
ON p.maker='B' AND p.model=m.model
ORDER BY m.price DESC

/*(SELECT p.hd
FROM PC p)
EXCEPT
(SELECT DISTINCT p.hd
FROM PC p)*/

SELECT DISTINCT p.hd
FROM PC p JOIN PC f
ON p.hd=f.hd AND p.code!=f.code

SELECT DISTINCT m.model, n.model
FROM PC m JOIN PC n ON m.model<n.model
WHERE m.speed=n.speed AND m.ram=n.ram


SELECT DISTINCT p.maker, c.speed
FROM product p JOIN PC c ON p.model=c.model



SELECT DISTINCT p.maker
FROM product p, PC c 
JOIN PC m ON c.code!=m.code
WHERE p.model=c.model AND p.model=m.model AND c.speed>=750 AND m.speed>=750

SELECT DISTINCT p.maker
FROM product p 
JOIN PC c ON p.model=c.model
JOIN PC m ON p.model=m.model
WHERE c.code!=m.code AND c.speed>=750 AND m.speed>=750 */

SELECT *
FROM OUTCOMES

SELECT * 
FROM BATTLES



SELECT s.name
FROM SHIPS s JOIN CLASSES c
ON s.class=c.class 
WHERE c.displacement>=35000

SELECT s.name, c.displacement, c.numguns
FROM CLASSES c
JOIN SHIPS s ON s.class=c.class 
JOIN OUTCOMES o ON s.name=o.ship
WHERE o.battle='Guadalcanal'

SELECT country
FROM CLASSES
WHERE type='bb'
INTERSECT
SELECT country
FROM CLASSES
WHERE type='bc'

SELECT o1.ship
FROM OUTCOMES o1
JOIN OUTCOMES o2 ON o1.ship=o2.ship
JOIN BATTLES b1 ON o1.battle=b1.name
JOIN BATTLES b2 ON o2.battle=b2.name
WHERE o1.battle!=o2.battle AND o1.result='damaged' AND b1.date<b2.date






