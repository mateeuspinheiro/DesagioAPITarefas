# DesagioAPITarefas
Repositório para controle do Desafio de criação de uma API e aplicação para controle e consulta de tarefas.

----------------------------------------------------------------------------------------------------------
Projeto desenvolvido como prova técnica para vaga de Desenvolvedor Delphi.
A solução é composta por dois módulos: 

1 - Backend(API Rest): Serviço desenvolvido em Delphi, com framework Horse. Responsável por gerenciar tarefas e disponbilizar os endpoints Rest;

2 - Frontend(VCL): Aplicação VCL responsável por consumir a API e gerenciar as tarefas através dos endpoints disponibilizados.

---Tecnologias Utilizadas---
Backend:
.Delphi
.Horse
.FireDAC
.SQL Server
.Json
.API Key Auth

Frontend:
.Delphi VCL
.RR4D
.Json

----------------------------------------------------------------------------------------------------------
Padrões de Projeto Utilizados

.Factory: Responsável pela criação e gerenciamento das conexões com o bd
.Repository: Responsável pela abstração do acesso aos dados
.Service Layer: Responsável pelas regras de negócio da applicação
.DTO: Utilizado para transferência de dados entre as camadas
