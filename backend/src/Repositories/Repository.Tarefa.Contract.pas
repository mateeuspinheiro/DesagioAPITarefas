unit Repository.Tarefa.Contract;

interface

uses
  System.Generics.Collections,
  Entidade.Tarefa,
  DTO.Estatisticas;

type
  ITarefaRepository = interface
    ['{B4C6D9E2-3D5E-5F7B-0C1D-2E3F4A5B6C7D}']
    function ListarTodas: TObjectList<TTarefa>;
    function BuscarPorId(AId: Integer): TTarefa;
    function Inserir(const ATitulo, ADescricao: string; APrioridade: Integer): TTarefa;
    function AtualizarStatus(AId: Integer; const AStatus: string): TTarefa;
    function Excluir(AId: Integer): Boolean;
    function ObterEstatisticas: TEstatisticasDTO;
  end;

implementation

end.
