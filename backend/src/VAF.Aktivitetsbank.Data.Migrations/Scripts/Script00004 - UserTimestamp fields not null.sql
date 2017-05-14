DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Deltaker') AND [c].[name] = N'Opprettet');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Deltaker] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [Deltaker] ALTER COLUMN [Opprettet] datetime2 NOT NULL;

GO

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Deltaker') AND [c].[name] = N'Endret');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [Deltaker] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [Deltaker] ALTER COLUMN [Endret] datetime2 NOT NULL;

GO

DECLARE @var2 sysname;
SELECT @var2 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Aktivitet') AND [c].[name] = N'Opprettet');
IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [Aktivitet] DROP CONSTRAINT [' + @var2 + '];');
ALTER TABLE [Aktivitet] ALTER COLUMN [Opprettet] datetime2 NOT NULL;

GO

DECLARE @var3 sysname;
SELECT @var3 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Aktivitet') AND [c].[name] = N'Endret');
IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [Aktivitet] DROP CONSTRAINT [' + @var3 + '];');
ALTER TABLE [Aktivitet] ALTER COLUMN [Endret] datetime2 NOT NULL;

GO


DECLARE @var4 sysname;
SELECT @var4 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Deltaker') AND [c].[name] = N'OpprettetAv');
IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [Deltaker] DROP CONSTRAINT [' + @var4 + '];');
ALTER TABLE [Deltaker] ALTER COLUMN [OpprettetAv] nvarchar(max) NOT NULL;

GO

DECLARE @var5 sysname;
SELECT @var5 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Deltaker') AND [c].[name] = N'EndretAv');
IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [Deltaker] DROP CONSTRAINT [' + @var5 + '];');
ALTER TABLE [Deltaker] ALTER COLUMN [EndretAv] nvarchar(max) NOT NULL;

GO

DECLARE @var6 sysname;
SELECT @var6 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Aktivitet') AND [c].[name] = N'OpprettetAv');
IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [Aktivitet] DROP CONSTRAINT [' + @var6 + '];');
ALTER TABLE [Aktivitet] ALTER COLUMN [OpprettetAv] nvarchar(max) NOT NULL;

GO

DECLARE @var7 sysname;
SELECT @var7 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Aktivitet') AND [c].[name] = N'EndretAv');
IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [Aktivitet] DROP CONSTRAINT [' + @var7 + '];');
ALTER TABLE [Aktivitet] ALTER COLUMN [EndretAv] nvarchar(max) NOT NULL;

GO
