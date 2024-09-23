Projeto ConsultaCEP
Este projeto em Delphi realiza consultas de CEP utilizando a API ViaCEP. Ele permite obter informações detalhadas sobre endereços, como logradouro, bairro, cidade, estado e outras informações, tanto via formato JSON quanto XML. Além disso, permite validar, alterar e salvar os dados retornados em um banco de dados Firebird.

Funcionalidades
Consulta por CEP (Formato JSON e XML)
Consulta os dados de endereço a partir de um CEP.
Exibe os resultados na interface de usuário.
Consulta por Endereço (Formato XML)
Permite a busca de endereços por estado, cidade e logradouro.
Integração com Banco de Dados
Verifica se o CEP já está cadastrado no banco de dados.
Permite a alteração de informações de um CEP previamente cadastrado.
Preenchimento Automático
Ao consultar um CEP já existente no banco de dados, os campos são preenchidos automaticamente na interface de usuário.
Pré-requisitos
Para executar este projeto, é necessário ter:

Delphi (versão compatível com FMX/VCL e suporte a TNetHTTPClient ou Indy).
Banco de Dados Firebird.
Bibliotecas: Xml.XMLIntf, Xml.XMLDoc, System.SysUtils, System.Classes, Data.DB, e FireDAC.
Dependências Externas
Firebird: Download Firebird.
ViaCEP API: A API utilizada para as consultas de CEP pode ser acessada no seguinte link: ViaCEP.
Instalação
Clone o repositório para a sua máquina local:

bash
Copiar código
git clone https://github.com/seu-usuario/projeto-consultacep.git
Configure o banco de dados Firebird:

Crie a base de dados Firebird para armazenar as informações de CEP.
Ajuste as configurações de conexão com o banco no código Delphi.
Abra o projeto no Delphi e configure os caminhos das bibliotecas utilizadas (se necessário).

Execute o projeto.

Uso
Consultar CEP:

Insira um CEP na caixa de entrada e clique em "Consultar".
As informações retornadas (logradouro, bairro, cidade, etc.) serão exibidas.
Validação no Banco de Dados:

O sistema verificará se o CEP já existe no banco de dados. Se existir, os dados serão carregados automaticamente para edição.
Alteração de Dados:

Caso o CEP já exista no banco, o sistema perguntará se o usuário deseja atualizar as informações existentes.
Ao confirmar, os dados retornados da consulta serão preenchidos nos campos de edição, permitindo que o usuário faça alterações e salve novamente no banco.
Estrutura do Projeto
Units:
CepServiceJSON.pas: Implementação das consultas utilizando o formato JSON.
CepServiceXML.pas: Implementação das consultas utilizando o formato XML.
DataModule.pas: Gerenciamento de conexão com o banco de dados Firebird.
MainForm.pas: Interface principal com os campos de entrada e botões de ação.
Banco de Dados:
O banco de dados armazena os dados de CEP consultados, permitindo validação e alteração.
Contribuição
Sinta-se à vontade para abrir issues e pull requests para sugerir melhorias ou correções.

Fork o repositório.
Crie sua feature branch (git checkout -b feature/nova-feature).
Commit suas mudanças (git commit -m 'Adiciona nova feature').
Faça o push para a branch (git push origin feature/nova-feature).
Abra um Pull Request.
Licença
Este projeto está licenciado sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

Autor
