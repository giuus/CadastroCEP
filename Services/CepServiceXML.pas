// CepServiceXML.pas
unit CepServiceXML;

interface

uses
  ICepService, System.SysUtils, System.Net.HttpClient, Xml.XMLDoc, Xml.XMLIntf,System.Net.HttpClientComponent;

type
  TCepServiceXML = class(TInterfacedObject, ICepServices)
  public
    function ConsultarCepPorCep(const ACep: string): string;
    function ConsultarCepPorEndereco(const AEstado, ACidade, ALogradouro: string): string;
  end;

implementation

{ TCepServiceXML }

uses uPrincipal;

function TCepServiceXML.ConsultarCepPorCep(const ACep: string): string;
var
  HttpClient: TNetHTTPClient;
  Response: IHTTPResponse;
  RootNode, EnderecoNode: IXMLNode;
  XMLDoc: IXMLDocument;
  Logradouro, Bairro, Localidade, UF, Cep, XML: string;
begin
  HttpClient := TNetHTTPClient.Create(nil);
  try
    Response := HttpClient.Get('https://viacep.com.br/ws/' + ACep + '/xml/');
    if Response.StatusCode = 200 then
    begin
      XMLDoc := TXMLDocument.Create(nil);
      try
        XML := Response.ContentAsString;
        XML := StringReplace(XML, #$A, '', [rfReplaceAll]); // Remove ''#$A'';
        //
        XMLDoc.LoadFromXML(XML);
        XMLDoc.Active := True;
        // Acessar o n� raiz <xmlcep>
        RootNode := XMLDoc.DocumentElement;

        Cep           :=  RootNode.ChildNodes['cep'].Text;
        Logradouro    := RootNode.ChildNodes['logradouro'].Text;
        Bairro        := RootNode.ChildNodes['bairro'].Text;
        Localidade    := RootNode.ChildNodes['localidade'].Text;
        UF            := RootNode.ChildNodes['uf'].Text;
        uPrincipal.vlCep        := Cep;
        uPrincipal.vlLogradouro := Logradouro;
        uPrincipal.vlBairro     := Bairro;
        uPrincipal.vlCidade     := Localidade;
        uPrincipal.vlUF         := UF;

        Result := Format('Cep: %s, Logradouro: %s, Bairro: %s, Cidade: %s, UF: %s',
                         [Cep, Logradouro, Bairro, Localidade, UF]);
      finally
        XMLDoc := nil;
      end;
    end
    else
      raise Exception.CreateFmt('Erro ao consultar CEP (XML): %d - %s', [Response.StatusCode, Response.StatusText]);
  finally
    HttpClient.Free;
  end;
end;

function TCepServiceXML.ConsultarCepPorEndereco(const AEstado, ACidade, ALogradouro: string): string;
var
  HttpClient: TNetHTTPClient;
  Response: IHTTPResponse;
  RootNode, EnderecoNode: IXMLNode;
  URL, XML: string;
  XMLDoc: IXMLDocument;
  Logradouro, Bairro, Localidade, UF, Cep: string;
begin
  HttpClient := TNetHTTPClient.Create(nil);
  try
    URL := Format('https://viacep.com.br/ws/%s/%s/%s/xml/', [AEstado, ACidade, ALogradouro]);
    Response := HttpClient.Get(URL);
    if Response.StatusCode = 200 then
    begin
      XMLDoc := TXMLDocument.Create(nil);
      try
        XML := Response.ContentAsString;
        XML := StringReplace(XML, #$A, '', [rfReplaceAll]); // Remove ''#$A'';
        //
        XMLDoc.LoadFromXML(XML);
        XMLDoc.Active := True;
        // Acessar o n� raiz <xmlcep>
        RootNode := XMLDoc.DocumentElement;

        // Acessar o n� <endereco> dentro de <enderecos>
        EnderecoNode  := RootNode.ChildNodes['enderecos'].ChildNodes['endereco'];
        Cep           :=  EnderecoNode.ChildNodes['cep'].Text;
        uPrincipal.vlCep := Cep;
        Logradouro    := EnderecoNode.ChildNodes['logradouro'].Text;
        Bairro        := EnderecoNode.ChildNodes['bairro'].Text;
        Localidade    := EnderecoNode.ChildNodes['localidade'].Text;
        UF            := EnderecoNode.ChildNodes['uf'].Text;

        uPrincipal.vlCep        := Cep;
        uPrincipal.vlLogradouro := Logradouro;
        uPrincipal.vlBairro     := Bairro;
        uPrincipal.vlCidade     := Localidade;
        uPrincipal.vlUF         := UF;

        Result := Format('Cep: %s, Logradouro: %s, Bairro: %s, Cidade: %s, UF: %s',
                         [Cep, Logradouro, Bairro, Localidade, UF]);
      finally
        XMLDoc := nil;
      end;
    end
    else
      raise Exception.CreateFmt('Erro ao consultar CEP por endere�o (XML): %d - %s', [Response.StatusCode, Response.StatusText]);
  finally
    HttpClient.Free;
  end;
end;

end.

