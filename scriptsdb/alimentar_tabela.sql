--Alimentar a tabela com dados de exemplo

IF NOT EXISTS (SELECT 1 FROM dbo.Tarefas)
BEGIN
    INSERT INTO dbo.Tarefas (Titulo, Descricao, Prioridade, Status)
    VALUES
        (N'Configurar ambiente', N'Instalar SQL Server e configurar FireDAC', 5, N'Concluida'),
        (N'Implementar API REST', N'Criar endpoints com Horse', 4, N'EmAndamento'),
        (N'Criar cliente VCL', N'Desenvolver interface gráfica', 3, N'Pendente');

    UPDATE dbo.Tarefas
    SET DataConclusao = DATEADD(DAY, -2, GETDATE())
    WHERE Titulo = N'Configurar ambiente';
END
GO