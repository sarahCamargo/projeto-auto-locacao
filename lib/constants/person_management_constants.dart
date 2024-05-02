class PersonConstants {
  static const String appBarTitle = 'Cadastro Pessoa Física';

  static const String personManagementTitle = "Gerenciar Pessoas";
  static const String naturalPerson = 'Pessoa Física';
  static const String legalPerson = 'Pessoa Jurídica';

  static const List<String?> civilStatus = [
    'Solteiro',
    'Casado',
    'Divorciado',
    'Viúvo',
    null
  ];

  static const String doNotInform = 'Não Informar';

  static const String birthDateHint = 'dd/mm/yyyy';
  static const String cellPhoneHint = '(XX) XXXXX - XXXXX';

  static const String cepMask = '00000-000';
  static const String birthDateMask = '00/00/0000';
  static const String cpfMask = '000.000.000-00';
  static const String cellPhoneMask = '(00) 00000-0000';

  static const String nameLabel = 'Nome';
  static const String cpfLabel = 'CPF';
  static const String birthDateLabel = 'Data de Nascimento';
  static const String sexLabel = 'Sexo';
  static const String emailLabel = 'E-mail';
  static const String civilStatusLabel = 'Estado Civil';
  static const String careerLabel = 'Profissão';
  static const String cellPhoneLabel = 'Telefone';
  static const String cepLabel = 'CEP';
  static const String streetLabel = 'Rua';
  static const String neighborhoodLabel = 'Bairro';
  static const String stateLabel = 'Estado';
  static const String cityLabel = 'Cidade';
  static const String addressNumber = 'Número';
  static const String addressComplement = 'Complemento';

  static const String female = 'Feminino';
  static const String male = 'Masculino';

  static const String personalData = 'Dados Pessoais';
  static const String addressData = 'Endereço';

  static const String saveButton = 'Salvar';

  static const String cpfErrorMessage = 'CPF inválido';

  static const String cpfAlreadyRegistered = 'CPF já cadastrado. Não é possível salvar.';
}