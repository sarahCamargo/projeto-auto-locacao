class PessoaFisica {
  String id;
  String nome;
  String cpf;
  String email;
  String endereco;
  String estadoCivil;
  String profissao;
  String sexo;
  String telefone;
  String dtNascimento;

  PessoaFisica({required this.id, required this.nome, required this.cpf, required this.email, required this.endereco,
    required this.estadoCivil, required this.profissao, required this.sexo, required this.telefone, required this.dtNascimento});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "cpf": cpf,
      "email": email,
      "endereco": endereco,
      "estado_civil": estadoCivil,
      "profissao": profissao,
      "sexo": sexo,
      "telefone": telefone,
      "dtNascimento": dtNascimento
    };
  }
}