{Enum de status da Tarefa}
unit Enums.Tarefa;

interface

type
  TStatusTarefa = (stPendente, stEmAndamento, stConcluida, stCancelada);

function StatusToString(AStatus : TStatusTarefa): string;
function StringToStatus(const AValue: string): TStatusTarefa;
function StatusValido(const AValue: string): Boolean;

implementation

uses
  System.SysUtils;

function StatusToString(AStatus : TStatusTarefa): string;
begin
  case AStatus of
    stPendente:    Result := 'Pendente';
    stEmAndamento: Result := 'Em Andamento';
    stConcluida:   Result := 'Concluída';
    stCancelada:   Result := 'Cancelada';
  else
   Result := 'Pendente';
  end;
end;

function StringToStatus(const AValue: string): TStatusTarefa;
var
  LValue: string;
begin
  LValue := Trim(AValue);
  if SameText(LValue, 'Pendente') then
    Exit(stPendente);
  if SameText(LValue, 'Em Andamento') then
    Exit(stEmAndamento);
  if SameText(LValue, 'Concluída') then
    Exit(stConcluida);
  if SameText(LValue, 'Cancelada') then
    Exit(stCancelada);
  raise Exception.CreateFmt('Status inválido: %s', [AValue]);
end;

function StatusValido(const AValue: string): Boolean;
begin
  Result:= SameText(AValue, 'Pendente')
    or SameText(AValue, 'Em Andamento')
    or SameText(AValue, 'Concluída')
    or SameText(AValue, 'Cancelada');
end;

end.
