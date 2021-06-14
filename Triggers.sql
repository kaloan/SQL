--Тригери за MovieExec

--TESTTRIGGER
GO
CREATE TRIGGER Checker ON MOVIEEXEC AFTER INSERT,UPDATE
AS
	BEGIN
		(SELECT *
		FROM MOVIEEXEC)

		ROLLBACK
	END
GO

INSERT INTO MOVIEEXEC VALUES (111,'Test Person','Some Place',200000)

DELETE FROM MOVIEEXEC WHERE CERT#=111

ALTER TABLE MOVIEEXEC DISABLE TRIGGER Checker

DROP TRIGGER Checker



--Да се напише тригер за таблицата MovieExec, който не позволява средната стойност на
--Networth да е по-малка от 500 000 (ако при промени в таблицата тази стойност стане по-малка
--от 500 000, промените да бъдат отхвърлени).

GO
CREATE TRIGGER NetWorth500k ON MOVIEEXEC AFTER INSERT,UPDATE
AS
	IF	(SELECT AVG(NETWORTH) 
		FROM MOVIEEXEC)	< 500000
	BEGIN
		PRINT 'ERROR: EXECUTIVE FOUND WITH LESS THAN 500 000 NETWORTH'
		ROLLBACK
	END
GO

INSERT INTO MOVIEEXEC VALUES (111,'Test Person','Some Place',200000)

ALTER TABLE MOVIEEXEC DISABLE TRIGGER NetWorth500k

DROP TRIGGER NetWorth500k

--Тригери за PC


--При промяна на цената на някой компютър се уверете, че няма компютър с по-ниска цена и
--същата честота на процесора
GO
CREATE TRIGGER BestValue ON PC AFTER UPDATE
AS
	IF EXISTS	(SELECT * 
				FROM inserted i 
				JOIN pc ON pc.speed=i.speed 
				WHERE pc.price<i.price)
	BEGIN
		PRINT 'ERROR: FOUND PC WITH CLOCKSPEED WITH LESSER PRICE'
		ROLLBACK
	END
GO

INSERT INTO pc VALUES (999,1232,750,11,11,'12x',1500)

ALTER TABLE PC DISABLE TRIGGER BestValue

-- Никой производител на компютри не може да произвежда и принтери

GO
CREATE TRIGGER PCONLY ON product AFTER INSERT,UPDATE
AS
	IF EXISTS	(SELECT * 
				FROM inserted p1 
				JOIN product p2 ON p1.maker=p2.maker 
				WHERE p1.type='PC' AND p2.type='Printer')
	BEGIN
		PRINT 'ERROR: MAKER FOUND THAT PRODUCES BOTH PCS AND PRINTERS'
		ROLLBACK
	END
GO

INSERT INTO product VALUES ('D',9999,'PC')

ALTER TABLE product DISABLE TRIGGER PCONLY

--Всеки производител на компютър трябва да произвежда и лаптоп, който да има същата или
--по-висока честота на процесора

GO
CREATE TRIGGER PCWITHLAPTOP ON product AFTER INSERT,UPDATE
AS
	IF EXISTS	(SELECT pr.maker 
				FROM ((SELECT * FROM inserted) UNION ((SELECT * FROM product) EXCEPT (SELECT * FROM deleted))) pr
				JOIN ((SELECT * FROM inserted) UNION (SELECT * FROM product)) pr2 ON pr2.maker=pr.maker
				LEFT JOIN pc p ON p.model=pr.model AND pr.type='PC' 
				LEFT JOIN laptop l ON l.model=pr2.model AND pr2.type='Laptop'
				WHERE p.speed>=l.speed
				GROUP BY pr.maker
				HAVING COUNT(p.model)>0 AND COUNT(l.model)>=0)
	BEGIN
		PRINT 'ERROR: PC MAKERS MUST ALSO HAVE A FASTER LAPTOP'
		ROLLBACK
	END
GO


ALTER TABLE product DISABLE TRIGGER PCWITHLAPTOP

--При променяне на данните в таблицата Laptop се уверете, че средната цена на лаптопите за
--всеки производител е поне 2000

GO
CREATE TRIGGER AVGLAPTOP ON laptop AFTER UPDATE
AS
	IF EXISTS	(SELECT p.maker
				FROM ((SELECT * FROM inserted) UNION ((SELECT * FROM laptop) EXCEPT (SELECT * FROM deleted))) l
				JOIN product p ON p.model=l.model AND p.type='Laptop'
				GROUP BY p.maker
				HAVING AVG(l.price)<2000)
	BEGIN
		PRINT 'ERROR: LAPTOP AVERAGE PRICE FOR EACH MAKER MUST BE AT LEAST 2000'
		ROLLBACK
	END
GO

ALTER TABLE laptop DISABLE TRIGGER AVGLAPTOP

--При обновяване на RAM или HD полетата на даден компютър се уверете, че твърдия диск е
--поне 100 пъти по-голям от паметта

GO
CREATE TRIGGER MINIMUMHD ON pc AFTER UPDATE
AS
	IF EXISTS	(SELECT * 
				FROM inserted i 
				WHERE i.hd<100*i.ram)
	BEGIN
		PRINT 'ERROR: PC FOUND WITH HD LESS THAN 100 TIMES RAM'
		ROLLBACK
	END
GO

UPDATE pc SET hd=3 WHERE model=1121

ALTER TABLE pc DISABLE TRIGGER MINIMUMHD


--Ако някой лаптоп има повече памет от някой компютър трябва да бъде и по-скъп от него

GO
CREATE TRIGGER LAPTOPHDEXPENSIVE ON laptop AFTER INSERT,UPDATE
AS
	IF EXISTS	(SELECT *
				FROM inserted l,pc p
				WHERE l.hd>p.hd AND NOT l.price>p.price)
	BEGIN
		PRINT 'ERROR: FOUND LAPTOP WITH LARGE HD SIZE THAT IS CHEAPER THAN PC WITH LESS'
		ROLLBACK
	END
GO

ALTER TABLE laptop DISABLE TRIGGER LAPTOPHDEXPENSIVE

--При добавянето на нов компютър, лаптоп или принтер се уверете, че модела не съществува
--в таблиците PC, Laptop и Printer

GO
CREATE TRIGGER UNIQUEPCMODEL ON pc AFTER INSERT
AS
	IF EXISTS	(SELECT * 
				FROM inserted i 
				JOIN pc p ON p.model=i.model)
	BEGIN
		PRINT 'ERROR: MODELS IN TABLE "PC" MUST BE UNIQUE'
		ROLLBACK
	END
GO

GO
CREATE TRIGGER UNIQUELAPTOPMODEL ON laptop AFTER INSERT
AS
	IF EXISTS	(SELECT * 
				FROM inserted i 
				JOIN laptop l ON l.model=i.model)
	BEGIN
		PRINT 'ERROR: MODELS IN TABLE "LAPTOP" MUST BE UNIQUE'
		ROLLBACK
	END
GO

GO
CREATE TRIGGER UNIQUEPRINTERMODEL ON printer AFTER INSERT
AS
	IF EXISTS	(SELECT *
				FROM inserted i 
				JOIN printer pr ON pr.model=i.model)
	BEGIN
		PRINT 'ERROR: MODELS IN TABLE "PRINTER" MUST BE UNIQUE'
		ROLLBACK
	END
GO


INSERT INTO pc VALUES (999,1232,750,11,11,'12x',1500)
INSERT INTO laptop VALUES (999,1298,750,11,11,1500,12)
INSERT INTO printer VALUES (999,1433,'n','Laser',500)


ALTER TABLE pc DISABLE TRIGGER UNIQUEPCMODEL
ALTER TABLE laptop DISABLE TRIGGER UNIQUELAPTOPMODEL
ALTER TABLE printer DISABLE TRIGGER UNIQUEPRINTERMODEL


--Ако в таблицата Products е спомената даден модел и неговия тип, то този модел трябва да се
--намира и в някоя от таблиците в зависимост от типа

GO
CREATE TRIGGER PRODUCTMODELSPC ON product AFTER INSERT
AS
	IF (NOT EXISTS	(SELECT * 
					FROM inserted i 
					JOIN pc p ON p.model=i.model 
					WHERE i.type='PC') AND 'PC' IN (SELECT i.type FROM inserted i)) 
	BEGIN
		PRINT 'ERROR: A PC PRODUCT MUST ALSO BE IN THE "PC" TABLE'
		ROLLBACK
	END
GO

GO
CREATE TRIGGER PRODUCTMODELSLAPTOP ON product AFTER INSERT
AS
	IF (NOT EXISTS	(SELECT * 
					FROM inserted i 
					JOIN laptop l ON l.model=i.model 
					WHERE i.type='Laptop') AND 'Laptop' IN (SELECT i.type FROM inserted i))
	BEGIN
		PRINT 'ERROR: A LAPTOP PRODUCT MUST ALSO BE IN THE "LAPTOP" TABLE'
		ROLLBACK
	END
GO

GO
CREATE TRIGGER PRODUCTMODELSPRINTER ON product AFTER INSERT
AS
	IF (NOT EXISTS	(SELECT * 
					FROM inserted i 
					JOIN printer pr ON pr.model=i.model 
					WHERE i.type='Printer') AND 'Printer' IN (SELECT i.type FROM inserted i))
	BEGIN
		PRINT 'ERROR: A PRINTER PRODUCT MUST ALSO BE IN THE "PRINTER" TABLE'
		ROLLBACK
	END
GO

INSERT INTO product VALUES('Z',9999,'PC')
INSERT INTO product VALUES('Z',9999,'Laptop')
INSERT INTO product VALUES('Z',9999,'Printer')

ALTER TABLE product DISABLE TRIGGER PRODUCTMODELSPC
ALTER TABLE product DISABLE TRIGGER PRODUCTMODELSLAPTOP
ALTER TABLE product DISABLE TRIGGER PRODUCTMODELSPRINTER



--Тригери за Ships

-- При добавянето на нов клас в таблицата Classes добавете и кораб със същото име в
-- таблицата Ships, който да има дата на пускане NULL
GO
CREATE TRIGGER IDEMNOMEN ON CLASSES AFTER INSERT
AS
	INSERT INTO SHIPS (NAME,CLASS)
		SELECT CLASS,CLASS FROM inserted
GO


ALTER TABLE CLASSES DISABLE TRIGGER IDEMNOMEN


--Ако бъде добавен нов клас с водоизместимост по-голяма от 35000, добавете класа в
--таблицата, но му задайте водоизместимост 35000


GO
CREATE TRIGGER MAXDISPLACEMENT ON CLASSES AFTER INSERT,UPDATE
AS
	INSERT INTO CLASSES 
        SELECT CLASS, TYPE, COUNTRY, NUMGUNS, BORE,
			   CASE
					WHEN DISPLACEMENT > 35000 THEN 35000
					ELSE DISPLACEMENT
				END AS DISPLACEMENT
        FROM inserted
GO


--Никой клас не може да има повече от два кораба


GO
CREATE TRIGGER MAXSHIPSINCLASS ON SHIPS AFTER INSERT,UPDATE
AS
	IF EXISTS	(SELECT i.CLASS 
				FROM inserted i 
				GROUP BY i.CLASS 
				HAVING COUNT(*)>2)
	BEGIN
		PRINT 'ERROR: MORE THAN TWO SHIPS IN SAME CLASS'
		ROLLBACK
	END
GO


ALTER TABLE SHIPS DISABLE TRIGGER MAXSHIPSINCLASS


--Кораб с повече от 9 оръдия не може да участва в битка с кораб, който е с по-малко от 9
--оръдия

GO
CREATE TRIGGER BIGSHIPBATTLE ON OUTCOMES AFTER INSERT,UPDATE
AS
	IF EXISTS	(SELECT i.SHIP 
				FROM inserted i 
				JOIN OUTCOMES o ON i.BATTLE=o.BATTLE
				JOIN SHIPS s1 ON s1.NAME=i.SHIP
				JOIN SHIPS s2 ON s2.NAME=o.SHIP
				JOIN CLASSES c1 ON c1.CLASS=s1.CLASS
				JOIN CLASSES c2 ON c2.CLASS=s2.CLASS
				WHERE c1.NUMGUNS>9 AND c2.NUMGUNS<9
				GROUP BY i.SHIP
				HAVING COUNT(*)>0)
	BEGIN
		PRINT 'ERROR: SHIPS WITH MORE THAN 9 GUNS FIGHT ONLY SHIPS WITH NO LESS THAN 9 GUNS'
		ROLLBACK
	END
GO


ALTER TABLE OUTCOMES DISABLE TRIGGER BIGSHIPBATTLE


--При добавянето на нов запис в таблицата Outcomes се уверете, че корабът и битката
--съществуват в таблиците Ships и Battles. Ако не съществуват добавете информацията за тях в
--съответната таблицата като добавите NULL стойности, където е необходимо


GO
CREATE TRIGGER EXISTINGINFO ON OUTCOMES INSTEAD OF INSERT
AS
	INSERT INTO SHIPS (NAME,CLASS)
	(SELECT SHIP,'Yamato' AS CLASS FROM inserted WHERE SHIP NOT IN (SELECT NAME FROM SHIPS))

	INSERT INTO BATTLES (NAME,DATE)
	(SELECT BATTLE, '1900-01-01 00:00:00.000' AS DATE FROM inserted WHERE BATTLE NOT IN (SELECT NAME FROM BATTLES))

	INSERT INTO OUTCOMES
	SELECT * FROM inserted
GO

INSERT INTO OUTCOMES VALUES ('TESTINGSHIP','TESTINGBATTLE','ok')
DELETE FROM OUTCOMES WHERE SHIP='TESTINGSHIP'
DELETE FROM BATTLES WHERE NAME='TESTINGBATTLE'
DELETE FROM SHIPS WHERE NAME='TESTINGSHIP'

ALTER TABLE OUTCOMES DISABLE TRIGGER EXISTINGINFO

DROP TRIGGER EXISTINGINFO


--При добавянето на нов кораб или при промяна на класа на някой кораб се уверете, че никоя
--държава няма повече от 20 кораба


GO
CREATE TRIGGER MAXSHIPSPERCOUNTRY ON SHIPS AFTER INSERT,UPDATE
AS
	IF EXISTS		(SELECT c.COUNTRY 
					FROM inserted s 
					JOIN CLASSES c ON c.CLASS=s.CLASS 
					GROUP BY c.COUNTRY 
					HAVING COUNT(s.NAME)>=20)
	BEGIN
		PRINT 'ERROR: A COUNTRY HAS MORE THAN 20 SHIPS'
		ROLLBACK
	END
GO

ALTER TABLE SHIPS DISABLE TRIGGER MAXSHIPSPERCOUNTRY

--Кораб, който вече е потънал не може да участва в битка, чиято дата е след датата на
--потъването му

GO
CREATE TRIGGER SUNKNOBATTLE ON OUTCOMES AFTER INSERT
AS
	IF EXISTS	(SELECT * 
				FROM inserted i 
				JOIN OUTCOMES o ON i.SHIP=o.SHIP
				JOIN BATTLES b ON b.NAME=o.BATTLE
				JOIN BATTLES bi ON bi.NAME=i.BATTLE
				WHERE o.RESULT='sunk' AND b.DATE<bi.DATE)
	BEGIN
		PRINT 'ERROR: A SHIP CANNOT BE IN A BATTLE AFTER IT IS SUNK'
		ROLLBACK
	END
GO

ALTER TABLE OUTCOMES DISABLE TRIGGER SUNKNOBATTLE