unit ConsultaCepComponent;

interface

uses
  System.Classes, ICepService;

type
  TConsultaCepComponent = class(TComponent)
  private
    FCepService: ICepServices;
  public
    constructor Create(AOwner: TComponent; AServiceType: string); reintroduce;
    destructor Destroy; override;
    function ConsultarCepPorCep(const ACep: string): string;
    function ConsultarCepPorEndereco(const AEstado, ACidade, ALogradouro: string): string;
  end;

implementation

uses
  CepServiceFactory;

{ TConsultaCepComponent }

constructor TConsultaCepComponent.Create(AOwner: TComponent; AServiceType: string);
begin
  inherited Create(AOwner);
  FCepService := TCepServiceFactory.CreateCepService(AServiceType);
end;

destructor TConsultaCepComponent.Destroy;
begin
  FCepService := nil;
  inherited;
end;

function TConsultaCepComponent.ConsultarCepPorCep(const ACep: string): string;
begin
  Result := FCepService.ConsultarCepPorCep(ACep);
end;

function TConsultaCepComponent.ConsultarCepPorEndereco(const AEstado, ACidade, ALogradouro: string): string;
begin
  Result := FCepService.ConsultarCepPorEndereco(AEstado, ACidade, ALogradouro);
end;

end.

