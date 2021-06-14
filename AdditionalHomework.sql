-- 1. За всяка филмова звезда да се изведе името, рождената дата и с кое
--    студио е записвала най-много филми. (Ако има две студиа с еднакъв 
--    брой филми, да се изведе кое да е от тях)


SELECT DISTINCT ms.NAME,ms.BIRTHDATE, m.STUDIONAME
FROM STARSIN si
JOIN MOVIESTAR ms ON ms.NAME=si.STARNAME
JOIN MOVIE m ON m.TITLE=si.MOVIETITLE
GROUP BY ms.NAME, ms.BIRTHDATE, m.STUDIONAME
ORDER BY ms.NAME, COUNT(m.STUDIONAME) DESC


-- 2. Да се изведат всички производители, за които средната цена на 
--    произведените компютри е по-ниска от средната цена на техните лаптопи.


SELECT *
FROM product p
LEFT JOIN pc comp ON p.model=comp.model
LEFT JOIN laptop lap ON p.model=lap.model
GROUP BY p.maker
HAVING AVG(comp.price)>=AVG(lap.price)


-- 3. Един модел компютри може да се предлага в няколко конфигурации 
--    с евентуално различна цена. Да се изведат тези модели компютри,
--    чиято средна цена (на различните му конфигурации) е по-ниска
--    от най-евтиния лаптоп, произвеждан от същия производител.


SELECT p.maker, comp.model
FROM product p 
LEFT JOIN pc comp ON p.model=comp.model
GROUP BY p.maker, comp.model
HAVING AVG(comp.price)<=(SELECT MIN(l.price) 
							FROM product p1 
							JOIN laptop l ON p1.model=l.model 
							WHERE p1.maker=p.maker
							GROUP BY p1.maker)
ORDER BY p.maker


-- 4. Битките, в които са участвали поне 3 кораба на една и съща страна.


SELECT o.BATTLE, c.COUNTRY
FROM OUTCOMES o
JOIN SHIPS s ON s.NAME=o.SHIP
JOIN CLASSES c ON c.CLASS=s.CLASS
GROUP BY o.BATTLE, c.COUNTRY
HAVING COUNT(c.COUNTRY)>=3


-- 5. За всеки кораб да се изведе броят на битките, в които е бил увреден.
--    Ако корабът не е участвал в битки или пък никога не е бил
--    увреждан, в резултата да се вписва 0.


SELECT s.NAME, COUNT(o2.BATTLE)
FROM SHIPS s
LEFT JOIN OUTCOMES o ON o.SHIP=s.NAME
LEFT JOIN OUTCOMES o2 ON o2.SHIP=s.NAME AND o2.RESULT='damaged'
GROUP BY s.NAME,o2.RESULT
ORDER BY s.NAME


-- 6. За всеки клас да се изведе името, държавата и първата година, в която 
--    е пуснат кораб от този клас


SELECT c.COUNTRY, c.CLASS, MIN(s.LAUNCHED)
FROM CLASSES c
JOIN SHIPS s ON s.CLASS=c.CLASS
GROUP BY c.CLASS, c.COUNTRY
ORDER BY c.COUNTRY,c.CLASS


-- 7. За всяка държава да се изведе броят на корабите и броят на потъналите 
--    кораби. Всяка от бройките може да бъде и нула.


SELECT c.COUNTRY, COUNT(s.NAME)-COUNT(o.RESULT) AS SHPCNT_CRRNT, COUNT(o.RESULT) AS SNKCNT
FROM SHIPS s
RIGHT JOIN CLASSES c ON c.CLASS=s.CLASS
LEFT JOIN OUTCOMES o ON o.SHIP=s.NAME AND o.RESULT='sunk'
GROUP BY c.COUNTRY


-- 8. Намерете за всеки клас с поне 3 кораба броя на корабите от 
--    този клас, които са с резултат ok.


SELECT s.CLASS, COUNT(o2.RESULT) AS NUM_OK
FROM SHIPS s
JOIN OUTCOMES o ON o.SHIP=s.NAME
LEFT JOIN OUTCOMES o2 ON o2.SHIP=o.SHIP AND o2.RESULT='ok'
GROUP BY s.CLASS
HAVING COUNT(s.NAME)>=3


-- 9. За всяка битка да се изведе името на битката, годината на 
--    битката и броят на потъналите кораби, броят на повредените
--    кораби и броят на корабите без промяна.


SELECT b.NAME, b.DATE, o.RESULT, COUNT(o.RESULT)
FROM OUTCOMES o
RIGHT JOIN BATTLES b ON b.NAME=o.BATTLE
GROUP BY b.NAME, b.DATE, o.RESULT
ORDER BY b.DATE, b.NAME, o.RESULT


-- 10. Да се изведат имената на корабите, които са участвали в битки в
--     продължение поне на две години.


SELECT s.NAME, MAX(YEAR(b.DATE))-MIN(YEAR(b.DATE)) AS WARTIME_SPAN
FROM SHIPS s
JOIN OUTCOMES o ON o.SHIP=s.NAME
JOIN BATTLES b ON b.NAME=o.BATTLE
GROUP BY s.NAME
HAVING MAX(YEAR(b.DATE))-MIN(YEAR(b.DATE))>=2


-- 11. За всеки потънал кораб колко години са минали от пускането му на вода 
--     до потъването.


SELECT s.NAME,YEAR(b.DATE)-s.LAUNCHED AS LFT
FROM SHIPS s
LEFT JOIN OUTCOMES o ON o.SHIP=s.NAME AND o.RESULT='sunk'
JOIN BATTLES b ON o.BATTLE=b.NAME


-- 12. Имената на класовете, за които няма кораб, пуснат на вода след 1921 г., 
--     но имат пуснат поне един кораб. 


SELECT c.CLASS
FROM CLASSES c
JOIN SHIPS s ON s.CLASS=c.CLASS
GROUP BY c.CLASS
HAVING MAX(s.LAUNCHED)<=1921
