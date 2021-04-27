--Q1--
Declare @Mont float
set @Mont=(select sum(PUArt *QteCommandee) 
from Commande Cm, Article Ar, LigneCommande Lc
where Cm.NumCom =Lc.NumCom AND Lc.NumArt = Ar.NumArt and Cm.NumCom=10)
if @Mont is null
Begin 
Print 'cette commade n''existe pas';
Return
End
if @Mont <= 10000
Print 'Commande Normale'
Else
Print 'Commande Spéciale'

--Q2--
Declare @Qte float
set @Qte=(select QteCommandee from LigneCommande 
where NumCom=1 and NumArt =2)
Delete from LigneCommande where NumCom=1 and NumArt =2
Update Article set QteEnStock = QteEnStock + @Qte where NumArt=2
if not exists (select NumCom from LigneCommande  where NumCom =1)
Begin
Delete From Commande where NumCom =1
End

--Q3--
select Commande.NumCom,DatCom,Sum(PUArt*QteCommandee)as 'Montant','Type'=
case
 when Sum(PUArt*QteCommandee)<=10000
 THEN 'Commande Normale'
 Else 'Commande Spéciale'
End
From Article,LigneCommande,Commande
where  LigneCommande.NumArt=Article.NumArt
group by Commande.NumCom,DatCom

--Q4--
Create table tab (
NumCom int,
DatCom Date,
MontantCom float)
insert into tab Select Top 5 Commande.NumCom,DatCom,Sum(PUArt*QteCommandee)as 'Mt'
From Commande, Article, LigneCommande
Where Commande.NumCom = LigneCommande.NumCom
and LigneCommande.NumArt = Article.NumArt
Group by Commande.NumCom,DatCom
order by Mt Desc

select * from tab
--Q5--
if exists(select NumArt from Article where QteEnStock<=SeuilMin)
Begin
Declare @a int
set @a=(select max(NumCom) From Commande)+1
insert into Commande values(@a,getdate())
insert into LigneCommande Select @a, NumArt, SeuilMin
From Article where  QteEnStock<=SeuilMin
End
--------------------------------------------------------------------------------------

Select * from Commande
Select * from Article
Select * from LigneCommande

-----------------------------------------------------------------
Create function MontTotal(@NumCom int)
returns float
as 
begin
DECLARE @MontT float
Set @MontT =(Select Sum(PUArt*QteCommandee)
From  Article,LigneCommande
Where Article.NumArt=LigneCommande.NumArt And LigneCommande.NumCom =@NumCom
)
return @MontT
end

select dbo.MontTotal(1)

-----------------------------------------------
Alter procedure MontTot @NumCom int ,@MontT float Output
as
Set @MontT =(Select Sum(PUArt*QteCommandee) 
From  Article,LigneCommande
Where Article.NumArt=LigneCommande.NumArt And LigneCommande.NumCom =@NumCom)

Declare @R int
Select @R=1
Exec MontTot @R



