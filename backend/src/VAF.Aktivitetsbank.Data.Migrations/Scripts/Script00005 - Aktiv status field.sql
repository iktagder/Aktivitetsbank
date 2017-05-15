ALTER TABLE [Deltaker] ADD [Aktiv] bit;

GO

ALTER TABLE [Aktivitet] ADD [Aktiv] bit;

GO

UPDATE dbo.Aktivitet SET Aktiv = 1
              where Aktiv IS NULL;

GO

UPDATE dbo.Deltaker SET Aktiv = 1
              where Aktiv IS NULL;

GO


DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Deltaker') AND [c].[name] = N'Aktiv');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Deltaker] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [Deltaker] ALTER COLUMN [Aktiv] bit NOT NULL;

GO

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Aktivitet') AND [c].[name] = N'Aktiv');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [Aktivitet] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [Aktivitet] ALTER COLUMN [Aktiv] bit NOT NULL;

GO
