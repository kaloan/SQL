USE master

CREATE DATABASE myships
GO
USE myships
GO


DROP TABLE Classes
DROP TABLE Ships
DROP TABLE Outcomes
DROP TABLE Battles


CREATE TABLE Classes(
	class varchar(32) NOT NULL,
	type char(2),
	country varchar(32) NOT NULL,
	numGuns int,
	bore int,
	displacement int
);

CREATE TABLE Ships(
	name varchar(32) NOT NULL,
	class varchar(32) NOT NULL,
	launched int CHECK(launched>0)
);

CREATE TABLE Outcomes(
	ship varchar(32) NOT NULL,
	battle varchar(64) NOT NULL,
	result varchar(16)
);

CREATE TABLE Battles(
	name varchar(64) NOT NULL,
	date datetime NOT NULL
);



ALTER TABLE Classes 
ADD CONSTRAINT pk_classes PRIMARY KEY(class);

ALTER TABLE Ships
ADD CONSTRAINT pk_ships PRIMARY KEY(name);

ALTER TABLE Outcomes
ADD CONSTRAINT pk_outcomes PRIMARY KEY(ship,battle);

ALTER TABLE Battles
ADD CONSTRAINT pk_battles PRIMARY KEY(name);



ALTER TABLE Ships
ADD FOREIGN KEY(class) REFERENCES Classes(class)

ALTER TABLE Outcomes
ADD FOREIGN KEY(ship) REFERENCES Ships(name)

ALTER TABLE Outcomes
ADD FOREIGN KEY(battle) REFERENCES Battles(name)



insert into classes values('Bismarck','bb','Germany',8,15,42000)
insert into classes values('Iowa','bb','USA',9,16,46000)
insert into classes values('Kongo','bc','Japan',8,14,32000)
insert into classes values('North Carolina','bb','USA',12,16,37000)
insert into classes values('Renown','bc','Gt.Britain',6,15,32000)
insert into classes values('Revenge','bb','Gt.Britain',8,15,29000)
insert into classes values('Tennessee','bb','USA',12,14,32000)
insert into classes values('Yamato','bb','Japan',9,18,65000)

insert into battles values('Guadalcanal','19421115 00:00:00.000')
insert into battles values('North Atlantic','19410525 00:00:00.000')
insert into battles values('North Cape','19431226 00:00:00.000')
insert into battles values('Surigao Strait','19441025 00:00:00.000')

insert into ships values('California','Tennessee',1921)
insert into ships values('Haruna','Kongo',1916)
insert into ships values('Hiei','Kongo',1914)
insert into ships values('Iowa','Iowa',1943)
insert into ships values('Kirishima','Kongo',1915)
insert into ships values('Kongo','Kongo',1913)
insert into ships values('Missouri','Iowa',1944)
insert into ships values('Musashi','Yamato',1942)
insert into ships values('New Jersey','Iowa',1943)
insert into ships values('North Carolina','North Carolina',1941)
insert into ships values('Ramillies','Revenge',1917)
insert into ships values('Renown','Renown',1916)
insert into ships values('Repulse','Renown',1916)
insert into ships values('Resolution','Renown',1916)
insert into ships values('Revenge','Revenge',1916)
insert into ships values('Royal Oak','Revenge',1916)
insert into ships values('Royal Sovereign','Revenge',1916)
insert into ships values('Tennessee','Tennessee',1920)
insert into ships values('Washington','North Carolina',1941)
insert into ships values('Wisconsin','Iowa',1944)
insert into ships values('Yamato','Yamato',1941)
insert into ships values('South Dakota','North Carolina',1941) 

insert into outcomes values('California','Surigao Strait','ok')
insert into outcomes values('King George V','North Atlantic','ok')
insert into outcomes values('Kirishima','Guadalcanal','sunk')
insert into outcomes values('South Dakota','Guadalcanal','damaged')
insert into outcomes values('Tennessee','Surigao Strait','ok')
insert into outcomes values('Washington','Guadalcanal','ok')
insert into outcomes values('California','Guadalcanal','damaged')




UPDATE Ships SET launched=1927 WHERE class='Kongo'
UPDATE Classes SET numGuns=9, bore=16, displacement=34000 WHERE class='Kongo'









