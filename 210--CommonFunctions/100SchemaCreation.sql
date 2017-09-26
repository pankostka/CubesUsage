use DWHCubeUsage
go


-- Schemas are better for project readability 
CREATE SCHEMA stage
GO

CREATE SCHEMA tmp
GO

CREATE SCHEMA star
GO

-- See all schemas:
-- SELECT name  FROM sys.schemas where principal_id = 1


