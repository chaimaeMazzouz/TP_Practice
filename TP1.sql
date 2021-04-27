create database Gestion_ecole
-----------------------------------------------
create table Secteur(
codSecteur varchar(10) primary key ,
NomSecteur varchar(20)
);
--------------------------------------------------------------------------------------
create table Module(
NumModule int primary key ,
NomModule varchar(20)
);
--------------------------------------------------------------------------------------
create table filiere(
NumFiliere int Primary key,
NomFiliere varchar(20),
codSecteur varchar(10) FOREIGN KEY REFERENCES Secteur(codSecteur)
);
--------------------------------------------------------------------------------------
create table stagiaire(
NumStagiaire int Primary key,
NomStagiaire varchar(20),
PrenomStagiaire varchar(20),
sexeStagiaire varchar(10),
DateNaissance Date,
NumFiliere int FOREIGN KEY REFERENCES filiere(NumFiliere)
);
--------------------------------------------------------------------------------------
create table Programme(
NumFiliere int FOREIGN KEY REFERENCES filiere(NumFiliere),
NumModule int FOREIGN KEY REFERENCES Module(NumModule),
coefficient int,
PRIMARY KEY CLUSTERED (NumFiliere, NumModule )
);
--------------------------------------------------------------------------------------
create table Notation(
NumModule int FOREIGN KEY REFERENCES Module(NumModule),
NumStagiaire int FOREIGN KEY REFERENCES Stagiaire(NumStagiaire),
Note float,
PRIMARY KEY CLUSTERED ( NumModule,NumStagiaire )
);
-------------------------------------------------------------------------------------------
insert into Secteur values ('A1','Ecocomie'),('A2','Informatique'),('A3','Mathématique')
--------------------------------------------------------------------------------------
insert into filiere values (1,'Finance','A1'),(2,'Gstion d entreprise','A1'),(3,'Commerce','A1'),
(4,'Developpement','A2'),(5,'Reseau','A2'),(6,'Infographique','A2'),
(7,'Analyse','A3'),(8,'Algebre','A3'),(9,'Statistique','A3')
--------------------------------------------------------------------------------------
insert into Module values (1,'Web cote client'),(2,'web cote serveur'),(3,'base de donnée'),
 (4,'management'),(5,'fiscalité'), (6,'Analyse1'),(7,'Algebre2')
--------------------------------------------------------------------------------------
insert into stagiaire values(101,'hassani','laila','F','2000-12-17',1), (102,'Name','Ayman','M','2000-12-17',2),
 (103,'Alaoui','Salma','F','2000-12-17',3)

--------------------------------------------------------------------------------------
insert into Programme values(1,5,4),(4,2,5),(8,7,3)
 --------------------------------------------------------------------------------------
insert into Notation values(1,102,14),(2,102,15),(3,102,13),(4,101,14),(5,101,15),(6,103,13),(7,103,17)
-----------------------------------------------------------------
Create procedure Infostagiaire
as
select NumStagiaire, Nomstagiaire from stagiaire 
where NumStagiaire not in(select Numstagiaire from notation)
--Add to test the procedure
insert into stagiaire values(104,'Mazzouz','Chaimae','F','2000-12-17',1)

exec Infostagiaire
----------------------------------------------------------------------
alter Procedure ListFiliere
as
Select filiere.NumFiliere, filiere.NomFiliere
from filiere  , Programme
where filiere.numFiliere=Programme.NumFiliere
Group by filiere.NumFiliere,NomFiliere
having count(NumModule)>=1

exec ListFiliere
----------------------------------------------------------------------
ALTER procedure ListeModuleParSec
@CodeSec varchar(6)
as
select NomModule 
from Module m, Programme P, Filiere F
where m.NumModule=P.numModule and 
p.numFiliere=F.NumFiliere and
CodSecteur=@CodeSec
group by NomModule
Having count(F.numFiliere)=(select count(numfiliere) from filiere where CodSecteur=@CodeSec)

exec ListeModuleParSec 'A2'
---------------------------------------------------------------------------------
Create Procedure NoteStagiaire
@NumSta int
as
Select m.NumModule, m.NomModule, note, coefficient
from Module m, Notation n, programme p
where n.numModule=m.numModule and m.numModule=p.numModule
and numStagiaire=@NumSta

exec NoteStagiaire 101

--------------------------------------------------------------
Create Procedure MAJnote
@NUmSta int, @Note float
as
update Notation set Note=@Note where NumStagiaire=@NUmSta

exec MAJnote 101,15


-------------------------------------------------
Create function MoyeNotes(@NuSt int)
returns float
as 
begin
DECLARE @moyNote float
Set @moyNote =(Select AVG(note)
From Notation
Where NumStagiaire =@NuSt
)
return @moyNote
end

--Exécution--
select dbo.MoyeNotes(101) as 'MoyNotes'

----------------------------------------------
Create function NbreModule(@NumF int)
returns int
as 
begin
DECLARE @nbre int
set @nbre = (select count(NumModule)from Programme where NumFiliere =@NumF)
return @nbre
end

select dbo.NbreModule(1) as 'Nombre Module'
----------------------------------------------------------------------------
Create function MoyeGen(@NuSt int)
returns float
as 
begin
DECLARE @moy float
Set @moy =(Select SUM(Notation.note*Programme.coefficient)/SUM(coefficient)
From Notation,Programme,stagiaire 
Where Notation.NumModule = Programme.NumModule
and stagiaire.NumStagiaire =@NuSt
group by stagiaire.NumStagiaire)
return @moy
end

--Exécution--
select dbo.MoyeGen(101) as 'MoyGen'
----------------------------------------------------------------------------