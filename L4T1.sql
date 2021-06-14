SELECT m.TITLE, m.YEAR,m.STUDIONAME,s.ADDRESS
FROM MOVIE m JOIN STUDIO s ON m.STUDIONAME=s.NAME
WHERE m.LENGTH>=120

SELECT m.STUDIONAME,ms.NAME
FROM STARSIN s 
JOIN MOVIE m ON m.TITLE=s.MOVIETITLE
JOIN MOVIESTAR ms ON ms.NAME=s.STARNAME
ORDER BY m.STUDIONAME

SELECT * FROM STARSIN
SELECT * FROM STUDIO
SELECT * FROM MOVIESTAR
SELECT * FROM MOVIE

SELECT me.NAME
FROM MOVIE m 
JOIN MOVIEEXEC me ON me.CERT#=m.PRODUCERC#
JOIN STARSIN s ON s.MOVIETITLE=m.TITLE
WHERE s.STARNAME='Harrison Ford'

SELECT ms.NAME
FROM STARSIN si
JOIN MOVIESTAR ms ON ms.NAME=si.STARNAME
JOIN MOVIE m ON m.TITLE=si.MOVIETITLE
WHERE ms.GENDER='F' AND m.STUDIONAME='MGM'

SELECT me.NAME, m2.TITLE
FROM MOVIE m1
JOIN MOVIE m2 ON m1.PRODUCERC#=m2.PRODUCERC#
JOIN MOVIEEXEC me ON me.CERT#=m1.PRODUCERC#
WHERE m1.TITLE='Star Wars'

SELECT ms.NAME
FROM MOVIESTAR ms
LEFT JOIN STARSIN s ON s.STARNAME=ms.NAME
WHERE s.MOVIETITLE IS NULL




SELECT p.maker, p.model, p.type
FROM PRODUCT p
LEFT JOIN PC pc ON pc.model=p.model
LEFT JOIN printer pr ON pr.model=p.model
LEFT JOIN laptop l ON l.model=p.model
WHERE pc.code IS NULL AND pr.code IS NULL AND l.code IS NULL




SELECT s.NAME,c.COUNTRY,s.LAUNCHED,c.NUMGUNS
FROM SHIPS s
FULL JOIN CLASSES c ON s.CLASS=c.CLASS

SELECT o.SHIP
FROM OUTCOMES o
JOIN BATTLES b ON o.BATTLE=b.NAME
WHERE year(b.DATE)=1942
/*WHERE b.DATE LIKE '%1942%'*/

SELECT c.COUNTRY,s.NAME
FROM SHIPS s
LEFT JOIN OUTCOMES o ON s.NAME=o.SHIP
JOIN CLASSES c ON c.CLASS=s.CLASS
WHERE o.SHIP IS NULL
ORDER BY c.COUNTRY
