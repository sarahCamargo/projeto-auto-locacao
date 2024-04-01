class PessoaFisica {
  String id;
  String nome;
  String cpf;
  String email;
  String estadoCivil;
  String profissao;
  String sexo;
  String telefone;
  String dtNascimento;
  String cep;
  String street;
  String state;
  String city;
  String neighborhood;
  int addressNumber;
  String addressComplement;

  PessoaFisica(
      {required this.id,
      required this.nome,
      required this.cpf,
      required this.email,
      required this.estadoCivil,
      required this.profissao,
      required this.sexo,
      required this.telefone,
      required this.dtNascimento,
      required this.cep,
      required this.street,
      required this.state,
      required this.city,
      required this.neighborhood,
      required this.addressNumber,
      required this.addressComplement});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "cpf": cpf,
      "email": email,
      "cep": cep,
      "estado_civil": estadoCivil,
      "profissao": profissao,
      "sexo": sexo,
      "telefone": telefone,
      "dtNascimento": dtNascimento,
      "street": street,
      "state": state,
      "city": city,
      "neighborhood": neighborhood,
      "addressNumber": addressNumber,
      "addressComplement": addressComplement
    };
  }
}
