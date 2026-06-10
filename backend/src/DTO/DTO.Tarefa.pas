unit DTO.Tarefa;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  Entidade.Tarefa,
  Enums.Tarefa;

type
  TTarefaDTO = record
    Id: Integer;
    Titulo: string;
    Descricao: string;
    Prioridade: Integer;
    Status: string;
    DataCriacao: TDateTime;
    DataConclusao: TDateTime;

    class function FromEntity(const AEntity: TTarefa): TTarefaDTO; static;
    function ToJSON: TJSONObject;
    class function FromJSON(AJson: TJSONObject): TTarefaDTO; static;
  end;

  TTarefaCreateDTO = record
    Titulo: string;
    Descricao: string;
    Prioridade: Integer;

    class function FromJSON(AJson: TJSONObject): TTarefaCreateDTO; static;
  end;

  TTarefaStatusDTO = record
    Status: string;

    class function FromJSON(AJson: TJSONObject): TTarefaStatusDTO; static;
  end;

function TarefasToJSONArray(const AList: TObjectList<TTarefa>): TJSONArray;

implementation

uses
  System.DateUtils;

{ TTarefaDTO }

class function TTarefaDTO.FromEntity(const AEntity: TTarefa): TTarefaDTO;
begin
  Result.Id := AEntity.Id;
  Result.Titulo := AEntity.Titulo;
  Result.Descricao := AEntity.Descricao;
  Result.Prioridade := AEntity.Prioridade;
  Result.Status := StatusToString(AEntity.Status);
  Result.DataCriacao := AEntity.DataCriacao;
  Result.DataConclusao := AEntity.DataConclusao;
end;

class function TTarefaDTO.FromJSON(AJson: TJSONObject): TTarefaDTO;
begin
  Result.Id := 0;
  Result.Titulo := '';
  Result.Descricao := '';
  Result.Prioridade := 1;
  Result.Status := 'Pendente';
  Result.DataCriacao := 0;
  Result.DataConclusao := 0;

  if Assigned(AJson.GetValue('titulo')) then
    Result.Titulo := AJson.GetValue('titulo').Value;
  if Assigned(AJson.GetValue('descricao')) then
    Result.Descricao := AJson.GetValue('descricao').Value;
  if Assigned(AJson.GetValue('prioridade')) then
    Result.Prioridade := StrToIntDef(AJson.GetValue('prioridade').Value, 1);
end;

function TTarefaDTO.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('id', TJSONNumber.Create(Id));
  Result.AddPair('titulo', Titulo);
  Result.AddPair('descricao', Descricao);
  Result.AddPair('prioridade', TJSONNumber.Create(Prioridade));
  Result.AddPair('status', Status);
  Result.AddPair('dataCriacao', DateToISO8601(DataCriacao, True));
  if DataConclusao > 0 then
    Result.AddPair('dataConclusao', DateToISO8601(DataConclusao, True))
  else
    Result.AddPair('dataConclusao', TJSONNull.Create);
end;

{ TTarefaCreateDTO }

class function TTarefaCreateDTO.FromJSON(AJson: TJSONObject): TTarefaCreateDTO;
begin
  Result.Titulo := '';
  Result.Descricao := '';
  Result.Prioridade := 1;

  if Assigned(AJson.GetValue('titulo')) then
    Result.Titulo := Trim(AJson.GetValue('titulo').Value);
  if Assigned(AJson.GetValue('descricao')) then
    Result.Descricao := Trim(AJson.GetValue('descricao').Value);
  if Assigned(AJson.GetValue('prioridade')) then
    Result.Prioridade := StrToIntDef(AJson.GetValue('prioridade').Value, 1);
end;

{ TTarefaStatusDTO }

class function TTarefaStatusDTO.FromJSON(AJson: TJSONObject): TTarefaStatusDTO;
begin
  Result.Status := '';
  if Assigned(AJson.GetValue('status')) then
    Result.Status := Trim(AJson.GetValue('status').Value);
end;

function TarefasToJSONArray(const AList: TObjectList<TTarefa>): TJSONArray;
var
  LTarefa: TTarefa;
  LDto: TTarefaDTO;
  LJson: TJSONObject;
begin
  Result := TJSONArray.Create;
  for LTarefa in AList do
  begin
    LDto := TTarefaDTO.FromEntity(LTarefa);
    LJson := LDto.ToJSON;
    Result.AddElement(LJson);
  end;
end;

end.
