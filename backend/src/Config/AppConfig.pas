{
  Arquvio de configuração da API.
  Le o config.ini e disponibiliza porta, API Key e dados de conexao SQL Server.
}

unit AppConfig;

interface

uses  System.SysUtils, System.IniFiles;

type
  TAppConfig = class
  private
    class var Finstance: TAppConfig;
    class function  ConfiguracaoPath : string; static;
    constructor create;
  public
    Port: Integer;
    ApiKey: string;
    DbServer: string;
    DbDatabase: string;
    DbUser: string;
    DbPassWord: string;
    DbOsAuth: Boolean;
    DbEncrypt: Boolean;
    DbTrustServerCertificate: Boolean;
    DbOdbcDriver: string;

    class function Instance: TAppConfig; static;
    destructor Destroy; override;
    procedure Load;
    function OdbcConnectionString: string;
  end;

implementation

constructor TAppConfig.create;
begin
  inherited;
  Port := 9000;
  ApiKey := 'desafio-tarefas-api-key';
  DbServer := 'localhost';
  DbDatabase := 'GerenciadorTarefas';
  DbUser := '';
  DbPassWord := '';
  DbOSAuth := True;
  DbEncrypt := False;
  DbTrustServerCertificate := True;
  DbOdbcDriver := 'ODBC Driver 17 for SQL Server';
end;

destructor TAppConfig.Destroy;
begin
  Finstance := nil;
  inherited;
end;

class function TAppConfig.ConfiguracaoPath: string;
begin
 Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'config.ini';
end;

class function TAppConfig.Instance: TAppConfig;
begin
  if not Assigned(Finstance) then
  begin
    Finstance := TAppConfig.create;
    Finstance.Load;
  end;
   Result := Finstance;
end;

procedure TAppConfig.Load;
var
  Lini : TIniFile;
  Lpath : string;
begin
  Lpath := ConfiguracaoPath;
  if not FileExists(Lpath) then
   begin
    Writeln('AVISO: config.ini nao encontrado em: ', LPath);
    Writeln('       Usando valores padrao. Copie config.ini para a pasta do executavel.');
    Exit;
   end;

  Lini := TIniFile.Create(Lpath);
  try
    Port := Lini.ReadInteger('Server', 'Port', Port);
    ApiKey := Lini.ReadString('Server', 'ApiKey', ApiKey);
    DbServer := Lini.ReadString('Database', 'Server', DbServer);
    DbDatabase := Lini.ReadString('Database', 'Database', DbDatabase);
    DbUser := Lini.ReadString('Database', 'User', DbUser);
    DbPassWord := Lini.ReadString('Database', 'Password', DbPassWord);
    DbOsAuth := Lini.ReadBool('Datbase', 'OsAutenth', DbOsAuth);
    DbEncrypt := LIni.ReadBool('Database', 'Encrypt', DbEncrypt);
    DbTrustServerCertificate := LIni.ReadBool('Database', 'TrustServerCertificate', DbTrustServerCertificate);
    DbOdbcDriver := LIni.ReadString('Database', 'OdbcDriver', DbOdbcDriver);
  finally
    Lini.Free;
  end;
end;

function TAppConfig.OdbcConnectionString: string;
var
  LEncrypt: string;
  LTrust: string;
begin
  if DbEncrypt then
    LEncrypt := 'Encrypt=Yes'
  else
    LEncrypt := 'Encrypt=No';

  if DbTrustServerCertificate then
    LTrust := 'TrustServerCertificate=Yes'
  else
    LTrust := 'TrustServerCertificate=No';

  if DbOsAuth then
    Result := Format(
      'Driver={%s};Server=%s;Database=%s;Trusted_Connection=Yes;%s;%s;',
      [DbOdbcDriver, DbServer, DbDatabase, LEncrypt, LTrust])
  else
    Result := Format(
      'Driver={%s};Server=%s;Database=%s;UID=%s;PWD=%s;%s;%s;',
      [DbOdbcDriver, DbServer, DbDatabase, DbUser, DbPassword, LEncrypt, LTrust]);
end;

end.

