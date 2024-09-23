unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, ConsultaCepComponent, Cep,
  Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.FMTBcd, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.DB,
  Data.SqlExpr, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    btnConsultarCep: TBitBtn;
    memoResultado: TMemo;
    edtLogradouro: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    cbFormato: TComboBox;
    btconsultarEndereco: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtCEP: TMaskEdit;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    btGravarAlt: TBitBtn;
    OpenDialog1: TOpenDialog;
    edtConexao: TEdit;
    BitBtn1: TBitBtn;
    Label7: TLabel;
    Label8: TLabel;
    procedure btnConsultarCepClick(Sender: TObject);
    procedure btconsultarEnderecoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btGravarAltClick(Sender: TObject);
    procedure edtEstadoKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    FConsultaCep: TConsultaCepComponent;
    procedure ExibirResultado(const AResultado: string; AFormato: string);
    procedure AtualizarInformacoesCEP(const ACep, ALogradouro, ABairro,AComplemento, ACidade, AUF: string);
    procedure CadastrarCEP(const ACep, ALogradouro, ABairro,AComplemento, ACidade, AUF: string);
    procedure CarregarDadosCEPParaEdits(const ACep: string);
    procedure LimparEdits;
    function VerificaCEPJaCadastrado(const ACep: string): Boolean;
    function SoNumeros(const AValor: string): String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  vlCep, vlLogradouro, vlCidade, vlUF, vlBairro, vlComplemento: string;

implementation

{$R *.dfm}

uses
  CepServiceFactory;

procedure TForm1.AtualizarInformacoesCEP(const ACep, ALogradouro, ABairro, AComplemento,
  ACidade, AUF: string);
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;
    FDQuery.SQL.Text := 'UPDATE TB_CEP SET logradouro = :logradouro, bairro = :bairro, complemento = :complemento, cidade = :cidade, uf = :uf WHERE cep = :cep';
    FDQuery.ParamByName('cep').AsString := vlCep;
    FDQuery.ParamByName('logradouro').AsString := ALogradouro;
    FDQuery.ParamByName('bairro').AsString := ABairro;
    FDQuery.ParamByName('complemento').AsString := AComplemento;
    FDQuery.ParamByName('cidade').AsString := ACidade;
    FDQuery.ParamByName('uf').AsString := AUF;
    FDQuery.ExecSQL;

    ShowMessage('Informações do CEP atualizadas com sucesso.');
    FDQuery1.Refresh;
  finally
    FDQuery.Free;
  end;
end;

procedure TForm1.btGravarAltClick(Sender: TObject);
begin
  if Application.MessageBox('Confirma as alterações?', '', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION) = IDYES then
  begin
    AtualizarInformacoesCEP(sonumeros(edtCEP.Text), EdtLogradouro.Text,'', '', EdtCidade.Text, edtEstado.Text);
  end
  else
    ShowMessage('Alteração cancelada.');

  btGravarAlt.Visible := False;
  btconsultarEndereco.Visible := True;
  LimparEdits;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    // Se um arquivo foi selecionado, exibe o nome do arquivo no Edit
    edtConexao.Text := OpenDialog1.FileName;
    if trim(edtConexao.Text) <> '' then
    begin
      FDConnection1.Params.Database := edtConexao.Text;
      try
        // Tentativa de conectar ao banco de dados
        FDConnection1.Connected := False;
        FDConnection1.Connected := True;

        if FDConnection1.Connected then
        begin
          Label8.Caption := 'Conexão bem-sucedida';
          ShowMessage('Conexão com o banco de dados estabelecida.');
          FDQuery1.Active := True;
        end;
      except
        on E: Exception do
        begin
          Label8.Caption := 'Erro de conexão';
          ShowMessage('Erro ao conectar ao banco de dados: ' + E.Message);
        end;
      end
    end
    else
    begin
      ShowMessage('Informe a base de dados para prosseguir');
    end;
  end;
end;

procedure TForm1.btconsultarEnderecoClick(Sender: TObject);
var
  Resposta: string;
begin
  try
    // Tentativa de conectar ao banco de dados
    if not FDConnection1.Connected then
    begin
      if edtConexao.Text <> '' then
      begin
        FDConnection1.Params.Database := edtConexao.Text;
        FDConnection1.Connected := True;
        FDQuery1.Active := True;
      end
      else
      begin
        ShowMessage('Informe o banco de dados para prosseguir.');
        exit;
      end;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar ao banco de dados: ' + E.Message);
      exit;
    end;
  end;
  // Validação dos campos de endereço
  if (Trim(edtEstado.Text) = '') or
     (Trim(edtCidade.Text) = '') or
     (Trim(edtLogradouro.Text) = '') then
  begin
    ShowMessage('Preencha todos os campos de endereço.');
    Exit;
  end;
  if Length(Trim(edtCidade.Text)) <= 3 then
  begin
    ShowMessage('A Cidade deve conter mais que 3 dígitos.');
    Exit;
  end;
  if Length(Trim(edtLogradouro.Text)) <= 3 then
  begin
    ShowMessage('O Logradouro deve conter mais que 3 dígitos.');
    Exit;
  end;
  FConsultaCep.Free;
  FConsultaCep := TConsultaCepComponent.Create(Self, cbFormato.Text);

  try
    Resposta := FConsultaCep.ConsultarCepPorEndereco(Trim(edtEstado.Text),
                                                     Trim(edtCidade.Text),
                                                     Trim(edtLogradouro.Text));
    ExibirResultado(Resposta, cbFormato.Text);
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;

procedure TForm1.btnConsultarCepClick(Sender: TObject);
var
  Resposta, vCEP: string;
  CepObj: TCep;
begin
  try
    // Tentativa de conectar ao banco de dados
    if not FDConnection1.Connected then
    begin
      if edtConexao.Text <> '' then
      begin
        FDConnection1.Params.Database := edtConexao.Text;
        FDConnection1.Connected := True;
        FDQuery1.Active := True;
      end
      else
      begin
        ShowMessage('Informe o banco de dados para prosseguir.');
        exit;
      end;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar ao banco de dados: ' + E.Message);
      exit;
    end;
  end;
  vCEP := SoNumeros(edtCEP.Text);
  // Validação do CEP
  if Length(Trim(vCEP)) <> 8 then
  begin
    ShowMessage('O CEP deve conter 8 dígitos.');
    Exit;
  end;

  FConsultaCep.Free;
  FConsultaCep := TConsultaCepComponent.Create(Self, cbFormato.Text);
  try
    Resposta := FConsultaCep.ConsultarCepPorCep(Trim(vCEP));
    ExibirResultado(Resposta, cbFormato.Text)
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;

procedure TForm1.CadastrarCEP(const ACep, ALogradouro, ABairro, AComplemento, ACidade,
  AUF: string);
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;
    FDQuery.SQL.Text := 'INSERT INTO TB_CEP (cep, logradouro, bairro, complemento, cidade, uf) VALUES (:cep, :logradouro, :bairro, :complemento, :cidade, :uf)';
    FDQuery.ParamByName('cep').AsString := SoNumeros(ACep);
    FDQuery.ParamByName('logradouro').AsString := ALogradouro;
    FDQuery.ParamByName('bairro').AsString := ABairro;
    FDQuery.ParamByName('complemento').AsString := AComplemento;
    FDQuery.ParamByName('cidade').AsString := ACidade;
    FDQuery.ParamByName('uf').AsString := AUF;
    FDQuery.ExecSQL;

    ShowMessage('CEP cadastrado com sucesso.');
  finally
    FDQuery.Free;
  end;
end;

procedure TForm1.CarregarDadosCEPParaEdits(const ACep: string);
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;  // Defina a conexão
    FDQuery.SQL.Text := 'SELECT cep, logradouro, bairro, cidade, uf FROM TB_CEP WHERE cep = :cep';
    FDQuery.ParamByName('cep').AsString := ACep;
    FDQuery.Open;

    // Verifica se encontrou o CEP e carrega os dados nos edits
    if not FDQuery.IsEmpty then
    begin
      vlCep := FDQuery.FieldByName('cep').AsString;
      EdtLogradouro.Text := FDQuery.FieldByName('logradouro').AsString;
      EdtEstado.Text := FDQuery.FieldByName('uf').AsString;
      EdtCidade.Text := FDQuery.FieldByName('cidade').AsString;
      EdtLogradouro.Text := FDQuery.FieldByName('logradouro').AsString;
    end
    else
      raise Exception.Create('CEP não encontrado no banco de dados.');
  finally
    FDQuery.Free;
  end;
end;

procedure TForm1.edtEstadoKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['A'..'Z', 'a'..'z', #8, #32]) then
    Key := #0;  // Bloqueia qualquer outra tecla
end;

procedure TForm1.ExibirResultado(const AResultado: string; AFormato: string);
var
  CepObj: TCep;
  AJson : String;
  FDQuery: TFDQuery;
begin
  memoResultado.Clear;
  if SameText(AFormato, 'JSON') then
  begin
    // Desserializa o JSON para o objeto TCep
    AJson := StringReplace(AResultado, '['#$A'', '', [rfReplaceAll]); // Remove #$A
    AJson := StringReplace(AJson, ''#$A']', '', [rfReplaceAll]); // Remove #$A
    try
      CepObj := TCep.FromJSON(AJson);
    Except
      on E: Exception do
      begin
        // Tratamento da exceção
        ShowMessage('Não foi possível encontrar os dados do CEP!');
        exit;
      end;
    end;
    try
      memoResultado.Lines.Add('CEP: ' + CepObj.Cep);
      memoResultado.Lines.Add('Logradouro: ' + CepObj.Logradouro);
      memoResultado.Lines.Add('Bairro: ' + CepObj.Bairro);
      memoResultado.Lines.Add('Cidade: ' + CepObj.Localidade);
      memoResultado.Lines.Add('UF: ' + CepObj.UF);
      if CepObj.Cep = '' then
      begin
        ShowMessage('O CEP informado não existe.');
        Exit;
      end;
      //
      if VerificaCEPJaCadastrado(Sonumeros(CepObj.Cep)) then
      begin
        if Application.MessageBox('Este CEP já está cadastrado, deseja alterar as informações manualmente? Clicando em não, o sistema irá atualizar os dados do CEP na base de dados automaticamente.', '', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION) = IDYES then
        begin
          btGravarAlt.Visible := True;
          btconsultarEndereco.Visible := False;
          CarregarDadosCEPParaEdits(Sonumeros(CepObj.Cep));
        end
        else
        begin
          FDQuery := TFDQuery.Create(nil);
          try
            FDQuery.Connection := FDConnection1;  // Defina a conexão
            FDQuery.SQL.Text := 'SELECT * FROM TB_CEP WHERE CEP = :cep';
            FDQuery.ParamByName('CEP').AsString := SoNumeros(Sonumeros(CepObj.Cep));
            FDQuery.Open;
            FDQuery.Edit;
            FDQuery.FieldByName('logradouro').AsString := CepObj.Logradouro;
            FDQuery.FieldByName('bairro').AsString := CepObj.Bairro;
            FDQuery.FieldByName('cidade').AsString := CepObj.Localidade;
            FDQuery.FieldByName('uf').AsString :=  CepObj.UF;
            FDQuery.Post;
            FDQuery1.Refresh;
          finally
            FDQuery.Free;
          end;
        end;
      end
      else
      begin
        CadastrarCEP(SoNumeros(CepObj.Cep), CepObj.Logradouro, CepObj.Bairro, CepObj.Complemento, CepObj.Localidade, CepObj.UF);
        LimparEdits;
        FDQuery1.Refresh;
      end;
    finally
      CepObj.Free;
    end;
  end
  else if SameText(AFormato, 'XML') then
  begin
    if SoNumeros(trim(edtCEP.Text)) <> '' then
      vlCep := SoNumeros(edtCEP.Text);
    memoResultado.Lines.Text := AResultado;
    if VerificaCEPJaCadastrado(Sonumeros(vlCep)) then
    begin
        if Application.MessageBox('Este CEP já está cadastrado, deseja alterar as informações manualmente? Clicando em não, o sistema irá atualizar os dados do CEP na base de dados automaticamente.', '', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION) = IDYES then
      begin
        btGravarAlt.Visible := True;
        btconsultarEndereco.Visible := False;
        CarregarDadosCEPParaEdits(Sonumeros(vlCep));
      end
      else
        begin
          FDQuery := TFDQuery.Create(nil);
          try
            FDQuery.Connection := FDConnection1;  // Defina a conexão
            FDQuery.SQL.Text := 'SELECT * FROM TB_CEP WHERE CEP = :cep';
            FDQuery.ParamByName('CEP').AsString := SoNumeros(vlCep);
            FDQuery.Open;
            FDQuery.Edit;
            FDQuery.FieldByName('logradouro').AsString  := vlLogradouro;
            FDQuery.FieldByName('bairro').AsString      := vlBairro;
            FDQuery.FieldByName('complemento').AsString := vlcomplemento;
            FDQuery.FieldByName('cidade').AsString      := vlCidade;
            FDQuery.FieldByName('uf').AsString          := vlUF;
            FDQuery.Post;
            FDQuery1.Refresh;
          finally
            FDQuery.Free;
          end;
        end;
    end
    else
    begin
      if vlCep = '' then
      begin
        ShowMessage('O CEP informado não existe.');
        Exit;
      end;
      CadastrarCEP(vlCep, vlLogradouro, vlBairro, vlComplemento,vlCidade, vlUF);
      LimparEdits;
    end;
    FDQuery1.Refresh;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Inicializa o ComboBox com os formatos disponíveis
  cbFormato.Items.Add('JSON');
  cbFormato.Items.Add('XML');
  cbFormato.ItemIndex := 0;  // Seleciona JSON por padrão

  // Inicializa o componente
  FConsultaCep := nil;
end;

procedure TForm1.LimparEdits;
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
    begin
      TEdit(Components[i]).Clear;  // Limpa o conteúdo do TEdit
    end;
    if Components[i] is TMaskEdit then
    begin
      TMaskEdit(Components[i]).Clear;  // Limpa o conteúdo do TMaskEdit
    end;
  end;
end;

function TForm1.SoNumeros(const AValor: string): String;
var
  I: Integer;
begin
  Result := ''; // Inicializa a string de resultado
  for I := 1 to Length(AValor) do
  begin
    if AValor[I] in ['0'..'9'] then
      Result := Result + AValor[I]; // Adiciona o dígito à string de resultado
  end;
end;

function TForm1.VerificaCEPJaCadastrado(const ACep: string): Boolean;
var
  FDQuery: TFDQuery;
begin
  Result := False;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;  // Defina a conexão
    FDQuery.SQL.Text := 'SELECT COUNT(1) FROM TB_CEP WHERE CEP = :cep';
    FDQuery.ParamByName('CEP').AsString := SoNumeros(ACep);
    FDQuery.Open;

    // Se o COUNT for maior que 0, significa que o CEP já está cadastrado
    if FDQuery.Fields[0].AsInteger > 0 then
      Result := True;
  finally
    FDQuery.Free;
  end;
end;

end.
