unit DTO.Estatisticas;

interface

uses
  System.JSON;

type
  TEstatisticasDTO = record
    TotalTarefas: Integer;
    MediaPrioridadePendentes: Double;
    TarefasConcluidasUltimos7Dias: Integer;

    function ToJSON: TJSONObject;
  end;

implementation

function TEstatisticasDTO.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('totalTarefas', TJSONNumber.Create(TotalTarefas));
  Result.AddPair('mediaPrioridadePendentes', TJSONNumber.Create(MediaPrioridadePendentes));
  Result.AddPair('tarefasConcluidasUltimos7Dias', TJSONNumber.Create(TarefasConcluidasUltimos7Dias));
end;

end.
