# DesafioAPITarefas
Repositório para controle do Desafio de criação de uma API e aplicação para controle e consulta de tarefas.

----------------------------------------------------------------------------------------------------------
Projeto desenvolvido como prova técnica para vaga de Desenvolvedor Delphi.
A solução é composta por dois módulos: 

1 - <b>Backend(API Rest):</b> Serviço desenvolvido em Delphi, com framework Horse. Responsável por gerenciar tarefas e disponbilizar os endpoints Rest;

2 - <b>Frontend(VCL):</b> Aplicação VCL responsável por consumir a API e gerenciar as tarefas através dos endpoints disponibilizados.

<b>Tecnologias Utilizadas</b>  
<b>Backend:</b>  
.Delphi  
.Horse  
.FireDAC  
.SQL Server  
.Json  
.API Key Auth

<b>Frontend:</b>  
.Delphi VCL  
.JSON

----------------------------------------------------------------------------------------------------------
<b>Padrões de Projeto Utilizados</b>

<b>.Factory:</b> Responsável pela criação e gerenciamento das conexões com o bd  
<b>.Repository:</b> Responsável pela abstração do acesso aos dados  
<b>.Service Layer:</b> Responsável pelas regras de negócio da applicação  
<b>.DTO:</b> Utilizado para transferência de dados entre as camadas  
