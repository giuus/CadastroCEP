// Cep.pas
unit Cep;

interface

uses
  REST.JSON;

type
  TCep = class
  private
    FCep: string;
    FLogradouro: string;
    FBairro: string;
    FComplemento: string;
    FLocalidade: string;
    FUF: string;
  public
    property Cep: string read FCep write FCep;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Bairro: string read FBairro write FBairro;
    property Complemento: string read FComplemento write FComplemento;
    property Localidade: string read FLocalidade write FLocalidade;
    property UF: string read FUF write FUF;

    class function FromJSON(const AJson: string): TCep;
    function ToJSON: string;
  end;

implementation

class function TCep.FromJSON(const AJson: string): TCep;
begin
  Result := TJson.JsonToObject<TCep>(AJson);
end;

function TCep.ToJSON: string;
begin
  Result := TJson.ObjectToJsonString(Self);
end;

end.

