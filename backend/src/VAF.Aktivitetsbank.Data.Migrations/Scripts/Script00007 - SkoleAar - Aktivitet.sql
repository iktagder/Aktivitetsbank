ALTER TABLE [Aktivitet] ADD [SkoleAarId] uniqueidentifier;

GO

UPDATE dbo.Aktivitet SET SkoleAarId = '2720F51B-F73F-4C05-8784-07F230F952A5' where SkoleAarId IS NULL;

GO

DECLARE @default1 sysname;
SELECT @default1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Aktivitet') AND [c].[name] = N'SkoleAarId');
IF @default1 IS NOT NULL EXEC(N'ALTER TABLE [Aktivitet] DROP CONSTRAINT [' + @default1 + '];');
ALTER TABLE [Aktivitet] ALTER COLUMN [SkoleAarId] uniqueidentifier NOT NULL;;

GO

CREATE INDEX [IX_Aktivitet_SkoleAarId] ON [Aktivitet] ([SkoleAarId]);

GO

ALTER TABLE [Aktivitet] ADD CONSTRAINT [FK_Aktivitet_SkoleAar_SkoleAarId] FOREIGN KEY ([SkoleAarId]) REFERENCES [SkoleAar] ([Id]) ON DELETE CASCADE;

GO
