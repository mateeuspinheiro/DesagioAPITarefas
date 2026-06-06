--Verifica a existência do banco e cria se necessário. Bem como a tabela para armazenar as terafas

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'GerenciadorTarefas')
BEGIN
    CREATE DATABASE GerenciadorTarefas;
END
GO

USE GerenciadorTarefas;
GO

IF OBJECT_ID(N'dbo.Tarefas', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tarefas
    (
        Id            INT IDENTITY(1,1) NOT NULL,
        Titulo        NVARCHAR(200)     NOT NULL,
        Descricao     NVARCHAR(MAX)     NULL,
        Prioridade    INT               NOT NULL CONSTRAINT CK_Tarefas_Prioridade CHECK (Prioridade BETWEEN 1 AND 5),
        Status        NVARCHAR(20)      NOT NULL CONSTRAINT DF_Tarefas_Status DEFAULT N'Pendente',
        DataCriacao   DATETIME          NOT NULL CONSTRAINT DF_Tarefas_DataCriacao DEFAULT GETDATE(),
        DataConclusao DATETIME          NULL,
        CONSTRAINT PK_Tarefas PRIMARY KEY CLUSTERED (Id)
    );

    CREATE INDEX IX_Tarefas_Status ON dbo.Tarefas (Status);
    CREATE INDEX IX_Tarefas_DataConclusao ON dbo.Tarefas (DataConclusao);
END