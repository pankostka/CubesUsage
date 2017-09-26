USE [KostkyDermacol]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE id = object_id('star.FACT_KostkyVyuzivani') AND  OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE  [star].FACT_KostkyVyuzivani;

CREATE TABLE [star].[FACT_KostkyVyuzivani](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	--dimenze
	[DIM_DatumID] [int] NOT NULL,
	[DIM_CasID] [int] NOT NULL, --hodina
	[DIM_UzivatelID] [int] NOT NULL,
	[Uzivatel] varchar(255) NOT NULL,
	[DIM_UtvarID] [int] NOT NULL,
	[DIM_CubeID] [int] NOT NULL,
	--ukazatele
	[Trvani] [numeric](26, 6) NOT NULL,
	[Pocet] [bigint] NOT NULL,
 CONSTRAINT [PK_FACT_KostkyVyuzivani] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


