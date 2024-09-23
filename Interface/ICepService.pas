unit ICepService;

interface

type
  ICepServices = interface
    ['{A4C8B877-BA88-4EE6-B676-F63D8274CF48}']  // GUID único para a interface
    function ConsultarCepPorCep(const ACep: string): string;
    function ConsultarCepPorEndereco(const AEstado, ACidade, ALogradouro: string): string;
  end;

implementation

end.
