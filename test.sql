USE master

CREATE DATABASE test
GO

USE test



CREATE TABLE Product(
	maker char(1),
	model char(4),
	type varchar(7)
);

CREATE TABLE Printer(
	code int,
	model char(4),
	color char(1) CHECK(color IN ('y','n')) DEFAULT 'n',
	price decimal(9,2)
);

CREATE TABLE Classes(
	class varchar(50),
	type char(2) CHECK(type IN ('bb','bc'))
)



INSERT INTO Product VALUES ('a', 'abcd', 'printer')
INSERT INTO Printer (code, model) VALUES (1, 'abcd')
INSERT INTO Classes VALUES ('Bismark', 'bb')


ALTER TABLE Classes ADD bore real

ALTER TABLE Printer DROP COLUMN price

DROP TABLE Product
DROP TABLE Printer
DROP TABLE Classes

USE master
GO

DROP DATABASE test
GO