program ProjetoConsultaCEP;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {Form1},
  ICepService in 'Interface\ICepService.pas',
  Cep in 'Models\Cep.pas',
  CepServiceJSON in 'Services\CepServiceJSON.pas',
  CepServiceXML in 'Services\CepServiceXML.pas',
  CepServiceFactory in 'Services\CepServiceFactory.pas',
  ConsultaCepComponent in 'Components\ConsultaCepComponent.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
