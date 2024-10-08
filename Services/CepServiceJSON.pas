// CepServiceJSON.pas
unit CepServiceJSON;

interface

uses
  ICepService, System.SysUtils, System.Net.HttpClient, System.Classes, System.Net.HttpClientComponent;

type
  TCepServiceJSON = class(TInterfacedObject, ICepServices)
  public
    function ConsultarCepPorCep(const ACep: string): string;
    function ConsultarCepPorEndereco(const AEstado, ACidade, ALogradouro: string): string;
  end;

implementation

{ TCepServiceJSON }

function TCepServiceJSON.ConsultarCepPorCep(const ACep: string): string;
var
  HttpClient: TNetHTTPClient;
  Response: IHTTPResponse;
begin
  HttpClient := TNetHTTPClient.Create(nil);
  try
    Response := HttpClient.Get('https://viacep.com.br/ws/' + ACep + '/json/');
    if Response.StatusCode = 200 then
      Result := Response.ContentAsString
    else
      raise Exception.CreateFmt('Erro ao consultar CEP: %d - %s', [Response.StatusCode, Response.StatusText]);
  finally
    HttpClient.Free;
  end;
end;

function TCepServiceJSON.ConsultarCepPorEndereco(const AEstado, ACidade, ALogradouro: string): string;
var
  HttpClient: TNetHTTPClient;
  Response: IHTTPResponse;
  URL: string;
begin
  HttpClient := TNetHTTPClient.Create(nil);
  try
    URL := Format('https://viacep.com.br/ws/%s/%s/%s/json/', [AEstado, ACidade, ALogradouro]);
    Response := HttpClient.Get(URL);
    if Response.StatusCode = 200 then
      Result := Response.ContentAsString
    else
      raise Exception.CreateFmt('Erro ao consultar CEP por endere�o: %d - %s', [Response.StatusCode, Response.StatusText]);
  finally
    HttpClient.Free;
  end;
end;

end.

