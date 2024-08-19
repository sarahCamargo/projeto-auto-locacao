# Projeto Autolocações

To create a new APK for the project it is necessary to run the following command: flutter build apk --release

## USER MANUAL

## 1. Página Inicial

Esta é a tela de menu principal do aplicativo. Abaixo, uma breve descrição de cada item:

- Pessoas: Ao clicar nesta opção, será aberta uma tela que lista as pessoas físicas e jurídicas cadastradas no sistema.
- Veículos: Esta opção abre uma tela que lista os veículos cadastrados e as manutenções relacionadas a esses veículos.
- Locações: Ao clicar nesta opção, é exibida a tela que lista as locações pendentes e o histórico de locações já finalizadas. Além disso, permite gerar os contratos referentes à locação.

### 1.1 Gerenciar Pessoas
Nesta tela, é apresentada uma listagem das pessoas cadastradas no sistema. Na parte inferior da tela, há dois botões: um que lista as pessoas físicas e outro que lista as pessoas jurídicas. Para cadastrar uma nova pessoa, clique no botão correspondente para exibir o formulário de cadastro. Para editar os dados de uma pessoa já cadastrada, basta clicar no card da pessoa desejada.

1.1.1 Cadastro de Pessoa Física
Esta tela permite o cadastro e a edição dos dados da pessoa física. Os campos obrigatórios estão circulados em vermelho. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados.

### 1.2 Gerenciar Veículos
Nesta tela, é apresentada uma listagem dos veículos cadastrados no sistema. Na parte inferior da tela, há dois botões: um que lista os veículos e outro que permite o gerenciamento das manutenções. Para cadastrar um veículo, clique no botão correspondente para exibir o formulário de cadastro. Para editar os dados de um veículo já cadastrado, basta clicar no card do veículo desejado. Para excluir um veículo, clique no botão "Excluir".

1.2.1 Cadastrar Veículo
Esta tela permite o cadastro e a edição dos dados do veículo. Os campos obrigatórios estão circulados em vermelho. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados. O botão "Selecionar Imagem" abre o explorador de arquivos para a seleção de uma imagem do veículo.

1.2.2 Gerenciar Manutenções
Esta tela lista os veículos cadastrados. Para abrir a listagem de manutenções de um veículo, basta clicar no card do veículo desejado.

1.2.2.1 Cadastrar Manutenção de Veículo
Esta tela permite o cadastro e a edição dos dados da manutenção. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados.

### 1.3 Gerenciar Locações
Nesta tela, é apresentada uma listagem das locações cadastradas no sistema. Na parte inferior da tela, há dois botões: um que lista as locações em aberto e outro que lista as locações finalizadas. Para cadastrar uma nova locação, clique no botão correspondente para exibir o formulário de cadastro. Para editar os dados de uma locação já cadastrada, clique no botão "Editar". Para finalizar uma locação, clique no botão "Finalizar".

1.3.1 Cadastrar Locação
Esta tela permite o cadastro e a edição dos dados da locação. Os campos obrigatórios estão circulados em vermelho. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados.

1.3.2 Gerar Contratos
Para gerar contratos, deve-se informar um template. Para isso:

Acesse a página inicial.
Clique no botão "Configurações".
Em seguida, clique no botão "Selecionar Template" e escolha um arquivo no formato .ODT.
Com o template definido, acesse a locação desejada e clique no botão "Gerar Contrato".

1.3.2.1 Configuração do Template do Contrato
Para que as informações no template sejam aplicadas corretamente conforme os cadastros no sistema, utilize as seguintes marcações no documento:

Marcação	Descrição
- {nome}	Substitui pelo nome da pessoa física vinculada à locação.
- {cpf}	Substitui pelo CPF da pessoa física vinculada à locação.
- {endereco}	Substitui pelo nome da rua, bairro, complemento e número do endereço.
- {cidade}	Substitui pela cidade da pessoa física vinculada à locação.
- {cep}	Substitui pelo CEP da pessoa física vinculada à locação.
- {estado}	Substitui pelo estado da pessoa física vinculada à locação.
- {modelo}	Substitui pelo modelo do veículo vinculado à locação.
- {ano}	Substitui pelo ano do veículo vinculado à locação.
- {cor}	Substitui pela cor do veículo vinculado à locação.
- {placa}	Substitui pela placa do veículo vinculado à locação.
- {renavam}	Substitui pelo RENAVAM do veículo vinculado à locação.
- {proprietario}	Substitui pelo proprietário do veículo vinculado à locação.
- {data}	Substitui pela data atual formatada como DD/MM/AAAA.
- {nomeAssinatura}	Substitui pelo nome da pessoa física vinculada à locação em caixa alta.
- {valor}	Substitui pelo valor vinculado à locação.
- {frequencia}	Substitui pela frequência de pagamento vinculada à locação.
