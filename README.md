<h1 align="center"> Executivo Locações - EXL </h1>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white" alt="flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white" alt="dart">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=flat&logo=Android&logoColor=white" alt="android">
  <img src="https://img.shields.io/badge/SQLite-003B57?style=flat-square&logo=SQLite&logoColor=white" alt="sqLite">
</p>

# Índice 
* [Manual do Usuário](#manual-do-usuário)
* [Manual de Instalação do Aplicativo](#manual-de-instalação-do-aplicativo)
* [Área de Desenvolvedor](#área-de-desenvolvedor)

# Manual do Usuário

## Página Inicial

Esta é a tela de menu principal do aplicativo. Abaixo, uma breve descrição de cada item:

- Pessoas: Ao clicar nesta opção, será aberta uma tela que lista as pessoas físicas e jurídicas cadastradas no sistema.
- Veículos: Esta opção abre uma tela que lista os veículos cadastrados e as manutenções relacionadas a esses veículos.
- Locações: Ao clicar nesta opção, é exibida a tela que lista as locações pendentes e o histórico de locações já finalizadas. Além disso, permite gerar os contratos referentes à locação.

### Gerenciar Pessoas
Nesta tela, é apresentada uma listagem das pessoas cadastradas no sistema. Na parte inferior da tela, há dois botões: um que lista as pessoas físicas e outro que lista as pessoas jurídicas. Para cadastrar uma nova pessoa, clique no botão correspondente para exibir o formulário de cadastro. Para editar os dados de uma pessoa já cadastrada, basta clicar no card da pessoa desejada.

#### Cadastro de Pessoa Física
Esta tela permite o cadastro e a edição dos dados da pessoa física. Os campos obrigatórios estão circulados em vermelho. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados.

### Gerenciar Veículos
Nesta tela, é apresentada uma listagem dos veículos cadastrados no sistema. Na parte inferior da tela, há dois botões: um que lista os veículos e outro que permite o gerenciamento das manutenções. Para cadastrar um veículo, clique no botão correspondente para exibir o formulário de cadastro. Para editar os dados de um veículo já cadastrado, basta clicar no card do veículo desejado. Para excluir um veículo, clique no botão "Excluir".

#### Cadastrar Veículo
Esta tela permite o cadastro e a edição dos dados do veículo. Os campos obrigatórios estão circulados em vermelho. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados. O botão "Selecionar Imagem" abre o explorador de arquivos para a seleção de uma imagem do veículo.

#### Gerenciar Manutenções
Esta tela lista os veículos cadastrados. Para abrir a listagem de manutenções de um veículo, basta clicar no card do veículo desejado.

##### Cadastrar Manutenção de Veículo
Esta tela permite o cadastro e a edição dos dados da manutenção. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados.

### Gerenciar Locações
Nesta tela, é apresentada uma listagem das locações cadastradas no sistema. Na parte inferior da tela, há dois botões: um que lista as locações em aberto e outro que lista as locações finalizadas. Para cadastrar uma nova locação, clique no botão correspondente para exibir o formulário de cadastro. Para editar os dados de uma locação já cadastrada, clique no botão "Editar". Para finalizar uma locação, clique no botão "Finalizar".

#### Cadastrar Locação
Esta tela permite o cadastro e a edição dos dados da locação. Os campos obrigatórios estão circulados em vermelho. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados.

#### Gerar Contratos
Para gerar contratos, deve-se informar um template. Para isso:

Acesse a página inicial.
Clique no botão "Configurações".
Em seguida, clique no botão "Selecionar Template" e escolha um arquivo no formato .ODT.
Com o template definido, acesse a locação desejada e clique no botão "Gerar Contrato".

##### Configuração do Template do Contrato
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

# Manual de Instalação do Aplicativo

# Área de Desenvolvedor

## Clonando o Repositório

Clone o repositório para sua máquina local:

```bash
git clone https://github.com/sarahCamargo/projeto-auto-locacao
cd projeto-auto-locacao
```

## Subindo o Ambiente

### Pré-requisitos
- [Android Studio](https://developer.android.com/studio/install?hl=pt-br#windows)
- [Flutter](https://docs.flutter.dev/get-started/install/windows/mobile)

Necessário seguir o passo a passo da instalação de Flutter para iniciar o desenvolvimento.

- No Android Studio, instale os plugins Dart e Flutter
- Configure o SDK do Flutter conforme instalação anterior
- Para configuração do SDK do Dart, utilize o caminho "bin/cache/dart-sd", dentro da instalação do flutter.

### Realizar atualizações de depêndencias:

```bash
flutter pub get
```

### Subindo o ambiente local

Necessário utilizar emulador local ou conectar um dispositivo móvel ao computador.

```bash
flutter run lib/main.dart
```

### Criando um arquivo executável para o Projeto:

```bash
flutter build apk --release
```
