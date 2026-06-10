unit Controller.Tarefa;

interface

uses
  Horse, Horse.Commons;

procedure Registry;

implementation

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  Entidade.Tarefa,
  DTO.Tarefa,
  DTO.Estatisticas,
  Service.Tarefa,
  Repository.Tarefa,
  Factory.Connection,
  Factory.Connection.Contract,
  Repository.Tarefa.Contract;

var
  GService: TTarefaService;

procedure InicializarServicos;
var
  LFactory: IConnectionFactory;
  LRepository: ITarefaRepository;
begin
  if not Assigned(GService) then
  begin
    LFactory := TFireDACConnectionFactory.Create;
    LRepository := TTarefaRepository.Create(LFactory);
    GService := TTarefaService.Create(LRepository);
  end;
end;

procedure EnviarErro(Res: THorseResponse; AStatus: THTTPStatus; const AMensagem: string);
var
  LJson: TJSONObject;
begin
  LJson := TJSONObject.Create;
  try
    LJson.AddPair('erro', AMensagem);
    Res.Status(AStatus).Send(LJson.ToJSON);
  finally
    LJson.Free;
  end;
end;

procedure DoGetTarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LLista: TObjectList<TTarefa>;
  LJson: TJSONArray;
begin
  try
    LLista := GService.ListarTodas;
    try
      LJson := TarefasToJSONArray(LLista);
      try
        Res.Send(LJson.ToJSON).ContentType('application/json; charset=utf-8');
      finally
        LJson.Free;
      end;
    finally
      LLista.Free;
    end;
  except
    on E: Exception do
      EnviarErro(Res, THTTPStatus.InternalServerError, E.Message);
  end;
end;

procedure DoPostTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRequest: TJSONObject;
  LCreate: TTarefaCreateDTO;
  LTarefa: TTarefa;
  LResponse: TJSONObject;
begin
  try
    LRequest := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    if not Assigned(LRequest) then
    begin
      EnviarErro(Res, THTTPStatus.BadRequest, 'Corpo da requisição JSON inválido.');
      Exit;
    end;

    try
      LCreate := TTarefaCreateDTO.FromJSON(LRequest);
      LTarefa := GService.Adicionar(LCreate.Titulo, LCreate.Descricao, LCreate.Prioridade);
      try
        LResponse := TTarefaDTO.FromEntity(LTarefa).ToJSON;
        try
          Res.Status(THTTPStatus.Created)
            .ContentType('application/json; charset=utf-8')
            .Send(LResponse.ToJSON);
        finally
          LResponse.Free;
        end;
      finally
        LTarefa.Free;
      end;
    finally
      LRequest.Free;
    end;
  except
    on E: Exception do
      EnviarErro(Res, THTTPStatus.BadRequest, E.Message);
  end;
end;

procedure DoPutStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LId: Integer;
  LRequest: TJSONObject;
  LStatusDto: TTarefaStatusDTO;
  LTarefa: TTarefa;
  LResponse: TJSONObject;
begin
  try
    LId := StrToIntDef(Req.Params['id'], 0);
    if LId <= 0 then
    begin
      EnviarErro(Res, THTTPStatus.BadRequest, 'Identificador da tarefa inválido.');
      Exit;
    end;

    LRequest := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    if not Assigned(LRequest) then
    begin
      EnviarErro(Res, THTTPStatus.BadRequest, 'Corpo da requisição JSON inválido.');
      Exit;
    end;

    try
      LStatusDto := TTarefaStatusDTO.FromJSON(LRequest);
      LTarefa := GService.AtualizarStatus(LId, LStatusDto.Status);
      try
        LResponse := TTarefaDTO.FromEntity(LTarefa).ToJSON;
        try
          Res.ContentType('application/json; charset=utf-8').Send(LResponse.ToJSON);
        finally
          LResponse.Free;
        end;
      finally
        LTarefa.Free;
      end;
    finally
      LRequest.Free;
    end;
  except
    on E: Exception do
      EnviarErro(Res, THTTPStatus.BadRequest, E.Message);
  end;
end;

procedure DoDeleteTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LId: Integer;
begin
  try
    LId := StrToIntDef(Req.Params['id'], 0);
    if LId <= 0 then
    begin
      EnviarErro(Res, THTTPStatus.BadRequest, 'Identificador da tarefa inválido.');
      Exit;
    end;

    GService.Excluir(LId);
    Res.Status(THTTPStatus.NoContent).Send('');
  except
    on E: Exception do
      EnviarErro(Res, THTTPStatus.NotFound, E.Message);
  end;
end;

procedure DoGetEstatisticas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LStats: TEstatisticasDTO;
  LJson: TJSONObject;
begin
  try
    LStats := GService.ObterEstatisticas;
    LJson := LStats.ToJSON;
    try
      Res.ContentType('application/json; charset=utf-8').Send(LJson.ToJSON);
    finally
      LJson.Free;
    end;
  except
    on E: Exception do
      EnviarErro(Res, THTTPStatus.InternalServerError, E.Message);
  end;
end;

procedure DoPing(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('{"status":"ok"}').ContentType('application/json; charset=utf-8');
end;

procedure Registry;
begin
  InicializarServicos;

  THorse.Get('/ping', DoPing);
  THorse.Get('/health', DoPing);

  THorse
    .Group
      .Prefix('/api')
        .Get('/tarefas', DoGetTarefas)
        .Post('/tarefas', DoPostTarefa)
        .Put('/tarefas/:id/status', DoPutStatus)
        .Delete('/tarefas/:id', DoDeleteTarefa)
        .Get('/estatisticas', DoGetEstatisticas);
end;

initialization

finalization
  FreeAndNil(GService);

end.
