ALTER TABLE [Deltaker] ADD [Endret] datetime2;

GO

ALTER TABLE [Deltaker] ADD [EndretAv] nvarchar(max);

GO

ALTER TABLE [Deltaker] ADD [Opprettet] datetime2;

GO

ALTER TABLE [Deltaker] ADD [OpprettetAv] nvarchar(max);

GO

ALTER TABLE [Aktivitet] ADD [Endret] datetime2;

GO

ALTER TABLE [Aktivitet] ADD [EndretAv] nvarchar(max);

GO

ALTER TABLE [Aktivitet] ADD [Opprettet] datetime2;

GO

ALTER TABLE [Aktivitet] ADD [OpprettetAv] nvarchar(max);

GO

UPDATE dbo.Aktivitet SET Opprettet = GETDATE()
              where Opprettet IS NULL;

GO

UPDATE dbo.Aktivitet SET Endret = GETDATE()
              where Endret IS NULL;

GO

UPDATE dbo.Deltaker SET Opprettet = GETDATE()
              where Opprettet IS NULL;

GO

UPDATE dbo.Deltaker SET Endret = GETDATE()
              where Endret IS NULL;

GO


UPDATE dbo.Aktivitet SET OpprettetAv = 'System'
              where OpprettetAv IS NULL;

GO

UPDATE dbo.Aktivitet SET EndretAv = 'System'
              where EndretAv IS NULL;

GO

UPDATE dbo.Deltaker SET OpprettetAv = 'System'
              where OpprettetAv IS NULL;

GO

UPDATE dbo.Deltaker SET EndretAv = 'System'
              where EndretAv IS NULL;

GO
