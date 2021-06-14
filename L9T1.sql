GO

SELECT *
FROM SHIPS

SELECT *
FROM CLASSES


SELECT *
FROM BritishShips


SELECT *
FROM AllSunk

SELECT s.CLASS,c.TYPE,c.NUMGUNS,c.BORE,c.DISPLACEMENT,s.LAUNCHED,c.CLASS
FROM SHIPS s
JOIN CLASSES c ON s.CLASS=c.CLASS
WHERE c.COUNTRY='Gt.Britain'

GO
-- 1. Дефинирайте изглед наречен BritishShips, който дава за всеки британски кораб неговият клас, 
--    тип, брой оръдия, калибър, водоизместимост и годината, в която е пуснат на вода


CREATE VIEW BritishShips
AS
SELECT s.NAME,s.CLASS,c.TYPE,c.NUMGUNS,c.BORE,c.DISPLACEMENT,s.LAUNCHED
FROM SHIPS s
JOIN CLASSES c ON s.CLASS=c.CLASS
WHERE c.COUNTRY='Gt.Britain'
GO


-- 2. Напишете заявка, която използва изгледа от предната задача, за да покаже броят оръдия и 
--    водоизместимост на британските бойни кораби, пуснати на вода преди 1917


SELECT NAME,NUMGUNS, DISPLACEMENT
FROM BritishShips
WHERE LAUNCHED<1917


-- 3. Напищете съответната SQL заявка, реализираща задача 2, но без да използвате изглед


SELECT s.NAME,c.NUMGUNS, c.DISPLACEMENT
FROM CLASSES c
JOIN SHIPS s ON s.CLASS=c.CLASS
WHERE c.COUNTRY='Gt.Britain' AND s.LAUNCHED<1917



-- 4. Средната стойност на най-тежките класове кораби от всяка страна
--    Презюмираме, че може да има повече от един клас с максималната изместимост за страна


SELECT AVG(m.MAXDISPLACEMENT) AS MAX_AVG
FROM CLASSES c
JOIN	(SELECT COUNTRY, MAX(DISPLACEMENT) AS MAXDISPLACEMENT
        FROM CLASSES
        GROUP BY COUNTRY) m 
		ON c.COUNTRY = m.COUNTRY AND c.DISPLACEMENT = m.MAXDISPLACEMENT

SELECT *
FROM CLASSES
ORDER BY COUNTRY


-- 5. Създайте изглед за всички потънали кораби по битки


CREATE VIEW AllSunk
AS
SELECT b.NAME AS BATTLENAME,s.NAME AS SHIPNAME
FROM BATTLES b
JOIN OUTCOMES o ON o.BATTLE=b.NAME AND o.RESULT='sunk'
JOIN SHIPS s ON s.NAME=o.SHIP

DROP VIEW AllSunk

CREATE VIEW AllSunk
AS
SELECT BATTLE, SHIP
FROM OUTCOMES
WHERE RESULT = 'sunk'

-- 6. Въведете кораба California като потънал в битката при Guadalcanal чрез изгледа от задача 5.
--    За целта задайте подходяща стойност по премълчаване на колоната result от таблицата Outcomes


ALTER TABLE OUTCOMES ADD CONSTRAINT DC_OUTCOMES_RESULT DEFAULT 'sunk' FOR RESULT

INSERT INTO AllSunk (BATTLE,SHIP) VALUES ('Guadalcanal','California')

ALTER TABLE OUTCOMES DROP CONSTRAINT DC_OUTCOMES_RESULT


-- 7. Създайте изглед за всички класове с поне 9 оръдия. Използвайте WITH CHECK OPTION. Опитайте се 
-- да промените през изгледа броя оръдия на класа Iowa последователно на 15 и 5.


CREATE VIEW ManyGuns
AS
SELECT *
FROM CLASSES
WHERE NUMGUNS>=9
WITH CHECK OPTION


UPDATE ManyGuns SET	NUMGUNS=15 WHERE CLASS='Iowa'

-- Следващото не работи, заради WITH CHECK OPTION. Подобна модификация би извадила обновявания запис
-- извън обсега на изгледа.
UPDATE ManyGuns SET	NUMGUNS=12 WHERE CLASS='Iowa'


-- 8. Променете изгледа от задача 7, така че броят оръдия да може да се променя без ограничения.


ALTER VIEW ManyGuns
AS
SELECT *
FROM CLASSES
WHERE NUMGUNS>=9

SELECT * FROM ManyGuns
-- 9. Създайте изглед с имената на битките, в които са участвали поне 3 кораба с под 9 оръдия и 
--    от тях поне един е бил увреден.


CREATE VIEW BigBattles
AS
SELECT o.BATTLE
FROM OUTCOMES o
JOIN SHIPS s ON s.NAME=o.SHIP
JOIN CLASSES c ON c.CLASS=s.CLASS
WHERE c.NUMGUNS<9
GROUP BY o.BATTLE
HAVING COUNT(*) >= 3 AND SUM(CASE RESULT WHEN 'damaged' THEN 1 ELSE 0 END) >= 1
