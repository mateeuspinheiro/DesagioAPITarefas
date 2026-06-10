unit Middleware.ApiKey;

interface

uses
  Horse, Horse.Commons, AppConfig;

procedure MiddlewareApiKey(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  System.SysUtils;

procedure MiddlewareApiKey(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LApiKey: string;
  LExpected: string;
begin
  // Rotas públicas de verificação do serviço
  if (Req.PathInfo = '/ping') or (Req.PathInfo = '/health') then
  begin
    Next;
    Exit;
  end;

  LExpected := TAppConfig.Instance.ApiKey;
  LApiKey := Req.Headers['X-API-Key'];

  if (LApiKey = '') or (not SameText(LApiKey, LExpected)) then
  begin
    Res.Status(THTTPStatus.Unauthorized);
    Res.Send('{"erro":"API Key inválida ou não informada. Utilize o header X-API-Key."}');
    Exit;
  end;

  Next;
end;

end.
