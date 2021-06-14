SELECT * FROM MOVIESTAR
SELECT * FROM MOVIEEXEC


SELECT * FROM PC
SELECT * FROM PRODUCT
SELECT * FROM LAPTOP
SELECT * FROM printer


SELECT * FROM SHIPS
SELECT * FROM CLASSES



-- Да се добави информация за актрисата Nicole Kidman. За нея знаем само, че е родена на 20-и юни 1967.

INSERT INTO MOVIESTAR(NAME,BIRTHDATE) 
VALUES('Nicole Kidman','1967-06-20');

-- Да се изтрият всички продуценти с печалба (networth) под 10 милиона.

DELETE FROM MOVIEEXEC 
WHERE NETWORTH<10000000

-- Да се изтрие информацията за всички филмови звезди, за които не се знае адреса.

DELETE FROM MOVIESTAR 
WHERE ADDRESS IS NULL

-- Използвайки две INSERT заявки, съхранете в базата данни факта, 
-- че персонален компютър модел 1100 е направен от производителя C, 
-- има процесор 2400 MHz, RAM 2048 MB, твърд диск 500 GB, 52x DVD устройство и струва $299. 
-- Нека новият компютър има код 12. 
-- Забележка: моделът и CD са от тип низ.
-- Упътване: самото вмъкване на данни е очевидно как ще стане, помислете в какъв ред е по-логично да са двете заявки.

INSERT INTO PRODUCT 
VALUES('C','1100','PC');

INSERT INTO PC
VALUES(12,'1100',2400,2048,500,'52x',299);

-- Да се изтрие всичката налична информация за компютри модел 1100.

DELETE FROM PRODUCT 
WHERE model='1100' AND type='PC'

DELETE FROM PC 
WHERE model='1100'

-- За всеки персонален компютър се продава и 15-инчов лаптоп със същите параметри, но с $500 по-скъп. 
-- Кодът на такъв лаптоп е със 100 по-голям от кода на съответния компютър. Добавете тази информация в базата.

INSERT INTO LAPTOP VALUES(code,model,speed,ram,hd,price+500,15) 
SELECT p.code + 100 AS code,
p.model AS model,p.speed AS speed,p.ram AS speed,p.hd AS hd,
p.price + 500 AS price 
FROM pc p

INSERT INTO laptop (code, model, speed, ram, hd, price, screen)
    SELECT code + 100 as code, model, speed, ram, hd, price + 500 as price, 15 FROM pc


-- Да се изтрият всички лаптопи, направени от производител, който не произвежда принтери.
-- Упътване: Мислете си, че решавате задача от познат тип - "Да се изведат всички лаптопи, ...". Накрая ще е нужна съвсем малка промяна. Ако започнете директно да триете, много е вероятно при някой грешен опит да изтриете всички лаптопи и ще трябва често да възстановявате таблицата или да работите на сляпо.

DELETE FROM LAPTOP WHERE code NOT IN 
	(SELECT l.code
	FROM laptop l
	JOIN product p ON l.model=p.model AND p.type='Laptop'
	WHERE p.maker IN 
		(SELECT DISTINCT pp.maker 
		FROM product pp
		JOIN printer pr ON pp.model=pr.model AND pp.type='Printer')
	)

-- Производител А купува производител B. На всички продукти на В променете производителя да бъде А.

UPDATE product SET maker='A' WHERE maker='B'

-- Да се намали два пъти цената на всеки компютър и да се добавят по 20 GB към всеки твърд диск. 
-- Упътване: няма нужда от две отделни заявки.

UPDATE pc SET price=2*price, hd=hd+20
-- За всеки лаптоп от производител B добавете по един инч към диагонала на екрана.

UPDATE laptop SET screen=screen+1 WHERE code IN 
	(SELECT l.code 
	FROM laptop l 
	JOIN product p ON p.model=l.model AND p.type='Laptop'
	WHERE p.maker='B')

UPDATE laptop SET screen=screen+1 WHERE model IN 
	(SELECT model
	 FROM product
	 WHERE maker='B' AND type='Laptop')

-- Два британски бойни кораба от класа Nelson - Nelson и Rodney - са били пуснати на вода едновременно през 1927 г. 
-- Имали са девет 16-инчови оръдия (bore) и водоизместимост от 34 000 тона (displacement). 
-- Добавете тези факти към базата от данни.

INSERT INTO CLASSES VALUES('Nelson','bb','Gt.Britain',9,16,34000)
INSERT INTO SHIPS VALUES('Nelson','Nelson',1927)
INSERT INTO SHIPS VALUES('Rodney','Nelson',1927)

-- Изтрийте от Ships всички кораби, които са потънали в битка.

DELETE FROM SHIPS WHERE NAME IN 
	(SELECT SHIP
	 FROM OUTCOMES
	 WHERE RESULT='sunk')

-- Променете данните в релацията Classes така, че калибърът (bore) да се измерва в сантиметри 
-- (в момента е в инчове, 1 инч ~ 2.5 см) и водоизместимостта да се измерва в метрични тонове (1 м.т. = 1.1 т.)

UPDATE CLASSES SET BORE=2.54*BORE , DISPLACEMENT=DISPLACEMENT/11

-- Изтрийте всички класове, от които има по-малко от три кораба.

DELETE FROM CLASSES
WHERE CLASS NOT IN (SELECT CLASS
                    FROM SHIPS
                    GROUP BY CLASS
                    HAVING COUNT(*) >= 3)

-- Променете калибъра на оръдията и водоизместимостта на класа Iowa, така че да са същите като тези на класа Bismarck.

UPDATE CLASSES 
SET BORE = (SELECT c.BORE FROM CLASSES c WHERE c.CLASS='Bismarck'),
	DISPLACEMENT = (SELECT c.DISPLACEMENT FROM CLASSES c WHERE c.CLASS='Bismarck')
WHERE CLASS='Iowa'