program ProjetoGerenciadorTarefas;

uses
  Vcl.Forms,
  FrmPrincipal in 'FrmPrincipal.pas' {FrmMain},
  ApiClient in 'src\Services\ApiClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
