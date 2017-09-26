--ADD NEW COLUMN [DateInsert] WITH DEFAULT GATDATE()
ALTER TABLE [dbo].[OlapQueryLog] ADD DateInsert [datetime] NULL
ALTER TABLE [dbo].[OlapQueryLog] ADD CONSTRAINT [DF_OlapQueryLog_DateInsert] DEFAULT (getdate()) FOR [DateInsert]

--UPDATE COLUMN [DateInsert] IF IT IS NULL
declare @Diff int 
set @Diff = DATEDIFF(hour, GetUTCDate(), GETDATE()) 
--Difference is between UNCDate and Getdate.
update l 
set l.DateInsert = DATEADD(HOUR,@Diff,StartTime) 
-- select DATEADD(HOUR,@Diff,StartTime) 
from [dbo].[OlapQueryLog] l
where l.DateInsert is null


