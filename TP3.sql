--Q1
Alter Trigger Tr_Ajout_LC  On LigneCommande 
Instead of insert 
as
declare @numarAj int
set @numarAj =(select NumArt from inserted)
IF not EXISTS(
select NumArt from Article  where NumArt = @numarAj)
 BEGIN
 print('la commande n''existe pas')
 ROLLBACK
 END

 insert into LigneCommande values (10,30,300)
 --Q2
alter Trigger Tr_Supp_Ar  On Article 
Instead of delete 
as
declare @qtee int
set @qtee =(select QteEnStock from deleted)
IF(@qtee>0) 
 BEGIN
 print('suppression Annuler')
 ROLLBACK
 END
 else
 Begin
 commit
 end

 insert into Article values(15,'Mouse','4',0,10,20),(16,'Camera','4',0,10,20)

 select *from LigneCommande
 select *from Article
 delete from Article where NumArt =15