# Projeto CadastroCEP

Este projeto em Delphi realiza consultas e cadastro de CEP utilizando a API ViaCEP. Ele permite obter informações detalhadas sobre endereços, como logradouro, bairro, cidade, estado e outras informações, tanto em formato JSON quanto XML. Além disso, permite validar, alterar e salvar os dados retornados em um banco de dados Firebird.

## Funcionalidades

- **Consulta por CEP (Formato JSON e XML)**: 
  - Consulta os dados de endereço a partir de um CEP.
  - Exibe os resultados na interface do usuário.
  
- **Consulta por Endereço (Formato JSON e XML)**: 
  - Permite a busca de endereços por estado, cidade e logradouro.
  
- **Integração com Banco de Dados**: 
  - Verifica se o CEP já está cadastrado no banco de dados.
  - Permite a alteração de informações de um CEP previamente cadastrado.
  
- **Preenchimento Automático**: 
  - Ao consultar um CEP já existente no banco de dados, os campos são preenchidos automaticamente na interface do usuário.

## Pré-requisitos

Para executar este projeto, é necessário ter:

- **Delphi**: versão compatível com FMX/VCL e suporte a TNetHTTPClient ou Indy.
- **Banco de Dados Firebird**.
- **Bibliotecas**: `Xml.XMLIntf`, `Xml.XMLDoc`, `System.SysUtils`, `System.Classes`, `Data.DB`, e `FireDAC`.

## Dependências Externas

- **Firebird**: [Download Firebird](https://firebirdsql.org/en/firebird-2-5/).
- **ViaCEP API**: A API utilizada para as consultas de CEP pode ser acessada no seguinte link: [ViaCEP](https://viacep.com.br/).

## Instalação

1. Clone o repositório para a sua máquina local:
   ```bash
   git clone https://github.com/giuus/CadastroCEP/
2. Configure o banco de dados Firebird:
   - Crie a base de dados Firebird para armazenar as informações de CEP.
   - Ajuste as configurações de conexão com o banco no código Delphi.
3. Abra o projeto no Delphi e configure os caminhos das bibliotecas utilizadas (se necessário).

4. Execute o projeto.


## Uso

### Consultar CEP
- Insira um CEP na caixa de entrada e clique em **"Consultar"**.
- As informações retornadas (logradouro, bairro, cidade, etc.) serão exibidas na interface do usuário.

### Validação no Banco de Dados
- O sistema verificará automaticamente se o CEP já existe no banco de dados.
- Se o CEP estiver cadastrado, os dados serão carregados automaticamente para edição.

### Alteração de Dados
- Caso o CEP já exista no banco, o sistema perguntará se o usuário deseja atualizar as informações existentes.
- Ao confirmar, os dados retornados da consulta serão preenchidos nos campos de edição, permitindo que o usuário faça alterações e salve novamente no banco.

## Estrutura do Projeto

### Units
- **CepServiceJSON.pas**: Implementação das consultas utilizando o formato JSON.
- **CepServiceXML.pas**: Implementação das consultas utilizando o formato XML.
- **Principal.pas**: Interface principal com os campos de entrada e botões de ação e gerenciamento da conexão com o banco de dados Firebird.

### Banco de Dados
- O banco de dados armazena os dados de CEP consultados, permitindo a validação e alteração das informações conforme necessário.

## Contribuição
Sinta-se à vontade para abrir *issues* e *pull requests* para sugerir melhorias ou correções.

### Autor 
  - Giovani de Santi ([Giuus](https://github.com/giuus/))
