USE Master
CREATE DATABASE AnnaBrzezinskaZadanieDomowe_3;
USE AnnaBrzezinskaZadanieDomowe_3
CREATE TABLE Meetings (
	
	Name nvarchar(63),
	Meeting date
);

CREATE TABLE Pernsons (
	 ID int IDENTITY(1,1) PRIMARY KEY,
	 FirstName nvarchar(255),
	 LastName nvarchar(255),
	 Adres nvarchar(255),
	 PhoneNumber int,
	 OcupationID int,
	 FavouriteID int
	 );
	 
CREATE TABLE ToDo (
	ID int IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(63),
	Deadline date);

CREATE TABLE Ocupation (
	OcupationID int PRIMARY KEY,
	Ocupation nvarchar(63),
	Salary int	
	);
	CREATE TABLE Favourite (
	
	FavouriteID int PRIMARY KEY,
	Animal nvarchar(63),
	Colour nvarchar(63),
        Food nvarchar(63)
);
INSERT INTO Meetings( Name,Meeting) 
	VALUES('Wizyta u lekarza','2018/12/02'),
	('spotkanie z dyrektorem','2018/11/28');
	--Wprowadzamy przyk³adowe dane do tabe
INSERT INTO Pernsons(FirstName, LastName, Adres, PhoneNumber,OcupationID,FavouriteID)
	VALUES ('Jan','Kowalski','ul.Polna 1, Wroclaw 50-100', 1233322334,1,1),
			('Marek','Nowak','Nowakowskiego 322, Wroclaw 51-222', 226705223,2,2),
			('Staœ','Burczymucha','Padewskiego 1/3, Wroc³aw 51-200',20000000,3,3),
                         ('Ania','Brzeska','Kosciuszki2/3,Wroc³aw51-009', 123654890,4,4),
                          ('Kasia','Kusko','Cicha 20,2,Wroc³aw 51-980',345871000,5,5);

						  INSERT INTO Ocupation(OcupationID,Ocupation,Salary) 
	VALUES (1,'Menager',3000),
	(2,'Programista',10000),
	(3,'Kucharz',5000),
	(4,'In¿ynier',12000),
	(5,'Tester oprogramowañ',2000);

INSERT INTO Favourite(FavouriteID, Colour,Animal,Food) 
	VALUES(1,'Niebeski','Pies','Frytki'),
	(2,'Czerwony','Kot','Schabowy'),
	(3,'¯ó³ty','W¹¿','Hamburger'),
	(4,'Ró¿owy','Wieloryb','Krewetki'),
	(5,'Zielony','Hiena','Tofu');
	INSERT INTO toDo(Name, Deadline) 
	VALUES ('Zrobiæ projekt samolotu','2018/11/28'),
		('Zrobiæ baze danch','2018/11/29'),		
		('Upiec sernik','2018/11/30'),
           ('Napisaæ program','2018/12/01');
		   ALTER TABLE Pernsons
	ADD FOREIGN KEY (OcupationID) REFERENCES Ocupation(OcupationID);

ALTER TABLE Pernsons
	ADD FOREIGN KEY (FavouriteID) REFERENCES Favourite(FavouriteID);

	CREATE VIEW MeetingView
AS
SELECT Name,Meeting
FROM Meetings ;
SELECT * FROM Meetings;

CREATE VIEW ToDoView
AS
SELECT Name,Deadline
FROM ToDo ;


CREATE VIEW PersonsView1
AS
SELECT p.FirstName,p.LastName,o.Ocupation,o.Salary
FROM  Ocupation o
join Pernsons p on o.OcupationID=p.OcupationID;

CREATE VIEW PersonsView2
AS
SELECT p.FirstName,p.LastName,f.Food,f.Animal,f.Colour
FROM Favourite f
join Pernsons p on f.FavouriteID =p.FavouriteID;
