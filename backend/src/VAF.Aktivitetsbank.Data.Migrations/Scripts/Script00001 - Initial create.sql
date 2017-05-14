
CREATE TABLE [Aktivitetstype] (
    [Id] uniqueidentifier NOT NULL,
    [Navn] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Aktivitetstype] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [Fag] (
    [Id] uniqueidentifier NOT NULL,
    [Navn] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Fag] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [Skole] (
    [Id] uniqueidentifier NOT NULL,
    [Kode] nvarchar(max) NOT NULL,
    [Navn] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Skole] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [Trinn] (
    [Id] uniqueidentifier NOT NULL,
    [Navn] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Trinn] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [Utdanningsprogram] (
    [Id] uniqueidentifier NOT NULL,
    [Navn] nvarchar(max) NOT NULL,
    [OverordnetUtdanningsprogramId] uniqueidentifier,
    CONSTRAINT [PK_Utdanningsprogram] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [Aktivitet] (
    [Id] uniqueidentifier NOT NULL,
    [AktivitetstypeId] uniqueidentifier NOT NULL,
    [Beskrivelse] nvarchar(max) NOT NULL,
    [Navn] nvarchar(50) NOT NULL,
    [OmfangTimer] int NOT NULL,
    [SkoleId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_Aktivitet] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Aktivitet_Aktivitetstype_AktivitetstypeId] FOREIGN KEY ([AktivitetstypeId]) REFERENCES [Aktivitetstype] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Aktivitet_Skole_SkoleId] FOREIGN KEY ([SkoleId]) REFERENCES [Skole] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [Deltaker] (
    [Id] uniqueidentifier NOT NULL,
    [AktivitetId] uniqueidentifier NOT NULL,
    [FagId] uniqueidentifier NOT NULL,
    [Kompetansemaal] nvarchar(max) NOT NULL,
    [Timer] int NOT NULL,
    [TrinnId] uniqueidentifier NOT NULL,
    [UtdanningsprogramId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_Deltaker] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Deltaker_Aktivitet_AktivitetId] FOREIGN KEY ([AktivitetId]) REFERENCES [Aktivitet] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Deltaker_Fag_FagId] FOREIGN KEY ([FagId]) REFERENCES [Fag] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Deltaker_Trinn_TrinnId] FOREIGN KEY ([TrinnId]) REFERENCES [Trinn] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Deltaker_Utdanningsprogram_UtdanningsprogramId] FOREIGN KEY ([UtdanningsprogramId]) REFERENCES [Utdanningsprogram] ([Id]) ON DELETE CASCADE
);

GO

CREATE INDEX [IX_Aktivitet_AktivitetstypeId] ON [Aktivitet] ([AktivitetstypeId]);

GO

CREATE INDEX [IX_Aktivitet_SkoleId] ON [Aktivitet] ([SkoleId]);

GO

CREATE INDEX [IX_Deltaker_AktivitetId] ON [Deltaker] ([AktivitetId]);

GO

CREATE INDEX [IX_Deltaker_FagId] ON [Deltaker] ([FagId]);

GO

CREATE INDEX [IX_Deltaker_TrinnId] ON [Deltaker] ([TrinnId]);

GO

CREATE INDEX [IX_Deltaker_UtdanningsprogramId] ON [Deltaker] ([UtdanningsprogramId]);

GO


