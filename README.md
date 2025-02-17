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

Na tela inicial da aplicação, é possível utilizar o menu de Ações Rápidas para utilizar as funções:

- Novo Cliente: Ao clicar nesta opção, será aberta uma tela na qual é possível cadastras pessoas físicas ou jurídicas.
- Nova Locação: Esta opção abre uma tela na qual é possível registrar uma nova locação de veículo.
- Novo Veículo: Nesta opção, é possível realizar o registro de um novo veículo.

No canto superior esquerdo, podemos acessar a aba de Configurações.
Nela, é possível cadastrar a frequência de notificações do aplicativo.
Também é possível configurar os templates para geração de contratos, explicado na seção de [Configuração do Template do Contrato](#configuração-do-template-do-contrato).

Na parte inferior da aplicação, é possível acessar os menus de Início, Clientes, Locações, Veículos e Manutenções.

### Clientes

Nesta tela, é apresentada uma listagem das clientes cadastrados no sistema.

- Para cadastrar uma nova pessoa, clique no botão "Novo Cliente" para exibir o formulário de cadastro.
- Para editar os dados de uma pessoa já cadastrada, clique no ícone de edição.
- Para excluir, clique no ícone de remoção
- Para pesquisar pelo nome do cliente, utilze o campo de pesquisa na parte superior da tela.
- Também é possível filtrar por pessoas Físicas, Jurídicas, ou Todas, utilizando o filtro na parte superior da tela.

#### Cadastro de Pessoa Física e Jurídica
Esta tela permite o cadastro e a edição dos dados da pessoa física e jurídica. Para escolher qual tipo de pessoa cadastrar, utilize as opções contidas em "Escolha o tipo de pessoa". Os campos obrigatórios estão circulados em vermelho. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados.

### Veículos
Nesta tela, é apresentada uma listagem dos veículos cadastrados no sistema.

- Para cadastrar um novo veículo, clique no botão "Novo Veículo" para exibir o formulário de cadastro.
- Para editar os dados de um veículo já cadastrado, clique no ícone de edição.
- Para excluir, clique no ícone de remoção
- Para pesquisar pelo modelo do veículo, utilze o campo de pesquisa na parte superior da tela.
- Também é possível filtrar por veículos Disponíveis, Locados, ou Todos, utilizando o filtro na parte superior da tela.

#### Cadastrar Veículo
Esta tela permite o cadastro e a edição dos dados do veículo. Os campos obrigatórios estão circulados em vermelho. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados. O botão "Selecionar Imagem" abre o explorador de arquivos para a seleção de uma imagem do veículo.

### Manutenções
Esta tela lista as manutenções de veículos cadastrados.
- Para pesquisar pelo modelo do veículo, utilze o campo de pesquisa na parte superior da tela.

#### Cadastrar Manutenção de Veículo
Esta tela permite o cadastro dos dados da manutenção. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados.

### Locações
Nesta tela, é apresentada uma listagem das locações cadastradas no sistema. 

- Para cadastrar uma nova locação, clique no botão "Nova Locação" para exibir o formulário de cadastro. 
- Para finalizar a locação, clique em "Finalizar locação"
- Para pesquisar pelo modelo do veículo, utilze o campo de pesquisa na parte superior da tela.
- Também é possível filtrar por locações Ativas, Concluídas, ou Todas, utilizando o filtro na parte superior da tela.

#### Cadastrar Locação
Esta tela permite o cadastro dados da locação. Os campos obrigatórios estão circulados em vermelho. Após preencher os campos, o usuário deve clicar no botão "Salvar" para gravar os dados.

#### Gerar Contratos
Para gerar contratos, é possível utilizar a opção "Gerar Contrato" na tela de locações.
É necessário ter um template cadastrado na tela de configurações.
Na tela de configurações, clique em "Adicionar arquivo" e escolha um arquivo no formato ".ODT" configurado conforme descrito abaixo.
É possível adicionar vários templates, os quais poderão ser selecionados ao clicar em "Gerar Contrato"

##### Configuração do Template do Contrato
Para que as informações no template sejam aplicadas corretamente conforme os cadastros no sistema, utilize as marcações abaixo no documento, conforme imagem de exemplo.

Pessoa Física:
| Marcação | Descrição |
| ------ | ------ |
|{nome}|Substitui pelo nome completo da pessoa física vinculada à locação.|
|{cpf}|Substitui pelo CPF da pessoa física vinculada à locação.|

Pessoa Jurídica:
| Marcação | Descrição |
| ------ | ------ |
|{razaoSocial}|Substitui pela razão social da pessoa jurídica.|
|{nomeFantasia}|Substitui pelo nome fantasia da pessoa jurídica.|
|{cnpj}|Substitui pelo CNPJ da pessoa jurídica.|

Endereço:
| Marcação | Descrição |
| ------ | ------ |
|{endereco}|	Substitui pelo nome da rua, bairro, complemento e número do endereço.|
|{cidade}|	Substitui pela cidade da pessoa física vinculada à locação.|
|{cep}|	Substitui pelo CEP da pessoa física vinculada à locação.|
|{estado}|	Substitui pelo estado da pessoa física vinculada à locação.|

Veículo:
| Marcação | Descrição |
| ------ | ------ |
|{modelo}|Substitui pelo modelo do veículo vinculado à locação.|
|{ano}|Substitui pelo ano do veículo vinculado à locação.|
|{cor}|Substitui pela cor do veículo vinculado à locação.|
|{placa}|Substitui pela placa do veículo vinculado à locação.|
|{renavam}|Substitui pelo RENAVAM do veículo vinculado à locação.|
|{proprietario}|Substitui pelo proprietário do veículo vinculado à locação.|

Locação:
| Marcação | Descrição |
| ------ | ------ |
|{valor}|Substitui pelo valor vinculado à locação.|
|{frequencia}|Substitui pela frequência de pagamento vinculada à locação.|

Outros:
| Marcação | Descrição |
| ------ | ------ |
|{data}|Substitui pela data atual formatada como DD/MM/AAAA.|
|{nomeAssinatura}|Substitui pelo nome da pessoa vinculada à locação em caixa alta.|


# Manual de Instalação do Aplicativo

Siga o passo a passo abaixo para realizar a instação do aplicativo.

- No repositório, acesse a aba de "Releases" e clique no arquivo .APK. Após a finalização do Download do arquivo clique em "Abrir".
  
  <img src="https://github.com/sarahCamargo/projeto-auto-locacao/blob/master/img/installation/1.jpg" width="250">
  
  <img src="https://github.com/sarahCamargo/projeto-auto-locacao/blob/master/img/installation/2.jpg" width="250">

- Ao selecionar a opção, será necessário permitir no dispositivo a instalação de aplicativos de fontes desconhecidas. Clique em configurações e após isso, autorize a permissão.
  
  <img src="https://github.com/sarahCamargo/projeto-auto-locacao/blob/master/img/installation/3.jpg" width="250">
  
  <img src="https://github.com/sarahCamargo/projeto-auto-locacao/blob/master/img/installation/4.jpg" width="250">

- Clique em abrir com o instalador de pacotes. Em seguida, o aplicativo será instalado e poderá ser utilizado.

  <img src="https://github.com/sarahCamargo/projeto-auto-locacao/blob/master/img/installation/5.jpg" width="250">

  <img src="https://github.com/sarahCamargo/projeto-auto-locacao/blob/master/img/installation/6.jpg" width="250">

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
