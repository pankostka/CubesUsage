USE [KostkyDermacol]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[nsp_FACT_KostkyVyuzivani]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[nsp_FACT_KostkyVyuzivani]
go

CREATE PROCEDURE [dbo].[nsp_FACT_KostkyVyuzivani] AS
BEGIN
	SET NOCOUNT ON;

/* 

POMOCNE SELECTY:
exec KOstkyDermacol.dbo.nsp_FACT_KostkyVyuzivani

select top 100 * from star.FACT_KostkyVyuzivani where uzivatel = 'dvorak'
select top 100 * from OlapLog.dbo.OLAPQueryLog_agg
select top 100 * from analyzy.dbo.OlapQueryLog with (nolock)


*/

----------------------------- A. Vyprázdnìní -------------------------------------------------------------------
truncate table star.FACT_KostkyVyuzivani



----------------------------- B. Naplnìní -------------------------------------------------------------------
--INSERT INTO star.FACT_KostkyVyuzivani (Databaze, Kostka, Uzivatel, FK_Datum, FK_Hodina, Trvani, Pocet)
INSERT INTO star.FACT_KostkyVyuzivani (DIM_DatumID, DIM_CasID, DIM_UzivatelID, Uzivatel, DIM_UtvarID, DIM_CubeID, Trvani, Pocet)
select
	YYYYMMDD as DIM_DatumID
	,HH as DIM_CasID
	,isnull( 
				(select top 1 u.dim_uzivatelID from star.dim_uzivatel u where u.DomainLogin = Replace(a.MSOLAP_user,'ALPHADUCT\','') collate Czech_CI_AS  --select * from star.dim_uzivatel
			),-1) as DIM_UzivatelID
	,Replace(a.MSOLAP_user,'ALPHADUCT\','') as Uzivatel ---pro kontrolu
	,-1 as DIM_UtvarID --zpìtný update
	,isnull(c.ID,-1) as DIM_CubeID
	,convert(numeric(26, 6), Duration/1000.0) as Trvani
	,Counting as Pocet
-- select top 100 * 
-- select count(*)
from stage.OlapQueryLog_agg a
left outer join	star.dim_cube c on c.FullPathName = a.MSOLAP_ObjectPath	collate Czech_CI_AS --select * from star.dim_cube
left outer join	star.dim_uzivatel u on u.DomainLogin = a.MSOLAP_user collate Czech_CI_AS --select * from star.dim_uzivatel
where 1=1
	and a.MSOLAP_user is not null
	




---------------------------------- C. Ruèní úpravy --------------------------------------------------------
--Pokud se uživatel nedohledá, moc se mi to nelíbí. Takže ruènì upravuji... 
-- select distinct uzivatel from star.FACT_KostkyVyuzivani  where DIM_UzivatelID = -1

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/ if 1 =0 begin
--tady dojhledávám toho správného
select * from star.dim_uzivatel where mail like '%lenka.boumova%'
select * from star.dim_uzivatel where jmeno like '%Gološová Leila%'


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/ end

update a set DIM_UzivatelID = isnull( (select top 1 u.dim_uzivatelID from star.dim_uzivatel u where u.mail = 'simona.zajicova@dermacol.cz' order by u.dim_uzivatelID desc),-1)
-- select *
from star.FACT_KostkyVyuzivani a where a.Uzivatel = 'zajicova' and DIM_UzivatelID = -1

update a set DIM_UzivatelID = isnull( (select top 1 u.dim_uzivatelID from star.dim_uzivatel u where u.mail like '%groch%' order by u.dim_uzivatelID desc),-1)
-- select *
from star.FACT_KostkyVyuzivani a where a.Uzivatel = 'groch' and DIM_UzivatelID = -1

update a set DIM_UzivatelID = isnull( (select top 1 u.dim_uzivatelID from star.dim_uzivatel u where mail like '%zdenek.polak%' order by u.dim_uzivatelID desc),-1)
-- select *
from star.FACT_KostkyVyuzivani a where a.Uzivatel = 'polak' and DIM_UzivatelID = -1

update a set DIM_UzivatelID = isnull( (select top 1 u.dim_uzivatelID from star.dim_uzivatel u where mail like '%kozohorsky%' order by u.dim_uzivatelID desc),-1)
-- select *
from star.FACT_KostkyVyuzivani a where a.Uzivatel = 'kozohorsky' and DIM_UzivatelID = -1

update a set DIM_UzivatelID = isnull( (select top 1 u.dim_uzivatelID from star.dim_uzivatel u where mail like '%lenka.boumova%' order by u.dim_uzivatelID desc),-1)
-- select *
from star.FACT_KostkyVyuzivani a where a.Uzivatel = 'petrova' and DIM_UzivatelID = -1

--petrová je novì boumová
update a set DIM_UzivatelID = isnull( (select top 1 u.dim_uzivatelID from star.dim_uzivatel u where mail like '%lenka.boumova%' order by u.dim_uzivatelID desc),-1)
-- select *
from star.FACT_KostkyVyuzivani a where a.Uzivatel = 'petrova' and DIM_UzivatelID = -1

update a set DIM_UzivatelID = isnull( (select top 1 u.dim_uzivatelID from star.dim_uzivatel u where jmeno like '%Toušková Kamila%' order by u.dim_uzivatelID desc),-1)
-- select *
from star.FACT_KostkyVyuzivani a where a.Uzivatel = 'touskova' and DIM_UzivatelID = -1

update a set DIM_UzivatelID = isnull( (select top 1 u.dim_uzivatelID from star.dim_uzivatel u where jmeno like '%Gološová Leila%' order by u.dim_uzivatelID desc),-1)
-- select *
from star.FACT_KostkyVyuzivani a where a.Uzivatel = 'golosova' and DIM_UzivatelID = -1


/*zbývá  z roku 2010
frankova
jandova
kozelkova
lechnerova
mazurovova
pekna
roucek
schneiderova
*/





---------------------------------- D. Zpìtný update--------------------------------------------------------
update a
set a.DIM_UtvarID = isnull(u.DIM_UtvarID,-1)
-- select u.*
from star.FACT_KostkyVyuzivani a
join star.dim_uzivatel u on u.DIM_UzivatelID = a.DIM_UzivatelID
--	where a.Uzivatel = 'zajicova'


---------------------------------- --úprava Slivonì --------------------------------------------------------

delete from f
/*
update f set 
	 f.DIM_UzivatelID  = (select DIM_UzivatelID from star.DIM_Uzivatel u where Domainlogin = 'borovicka')
	,f.uzivatel = 'borovicka'
*/
--select top 100 f.* 
--select distinct uzivatel, dim_UzivatelID
from star.FACT_KostkyVyuzivani f
join star.DIM_Cube c on c.id = f.DIM_CubeID -- select distinct databaseName from star.DIM_Cube where databaseName like '%Korun%'
where uzivatel in ('slivone')
and c.databaseName like '%Korun%'
and DIM_DatumID >= 20170220

-- select * from star.DIM_Uzivatel u where Domainlogin in ('borovicka','slivone')





----------------------------------Testovací data mažu--------------------------------------------------------
/*delete
-- select top 10 * 
from FACT_KostkyVyuzivani
where Databaze like 'AnalyzyIT' 

delete
--select top 10 * 
from FACT_KostkyVyuzivani
where Databaze like '%Test%'


delete
--select top 10 * 
from FACT_KostkyVyuzivani
where Kostka like '%KK Expedice%'

*/



END