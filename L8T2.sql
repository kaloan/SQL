USE master

CREATE DATABASE students
GO

USE students

CREATE TABLE Courses(
	ID int CHECK(ID<1000 AND ID>=100) UNIQUE NOT NULL,
	name varchar(32) NOT NULL,
);

CREATE TABLE Students(
	FN int CHECK(FN>=0 AND FN<=99999) PRIMARY KEY,
	name varchar(100) NOT NULL,
	UCN char(10) UNIQUE NOT NULL,
	email varchar(100) CHECK(email LIKE '%@%.%') NOT NULL,
	birthdate DATE NOT NULL,
	regdate DATE NOT NULL,
	CHECK(YEAR(regdate)>=YEAR(birthdate)+18)
);

CREATE TABLE Taken(
	uid int IDENTITY NOT NULL,
	CourseID int CHECK(CourseID<1000 AND CourseID>=100) UNIQUE NOT NULL,
	StudentFN int CHECK(StudentFN>=0 AND StudentFN<=99999)
);

ALTER TABLE Taken
ADD CONSTRAINT pk_taken PRIMARY KEY(uid)

ALTER TABLE Taken
ADD FOREIGN KEY(CourseID) REFERENCES Courses(ID) ON DELETE CASCADE

ALTER TABLE Taken
ADD FOREIGN KEY(StudentFN) REFERENCES Students(FN) ON DELETE CASCADE