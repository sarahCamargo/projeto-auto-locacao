class Veiculo {
  String id;
  String placa;
  String modelo;
  String marca;
  int anoFabricacao;
  int renavan;
  String cor;
  int quilometragem;
  String tipoCombustivel;
  int numeroPortas;
  String tipoTransmissao;
  String condicao;
  int numeroAssentos;
  String descricao;

  Veiculo(
      {this.id = "",
      this.placa = "",
      this.modelo = "",
      this.marca = "",
      this.anoFabricacao = 0,
      this.renavan = 0,
      this.cor = "",
      this.quilometragem = 0,
      this.tipoCombustivel = "",
      this.numeroPortas = 0,
      this.tipoTransmissao = "",
      this.condicao = "",
      this.numeroAssentos = 0,
      this.descricao = ""
      });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "placa": placa,
      "modelo": modelo,
      "marca": marca,
      "anoFabricacao": anoFabricacao,
      "renavan": renavan,
      "cor": cor,
      "quilometragem": quilometragem,
      "tipoCombustivel": tipoCombustivel,
      "numeroPortas": numeroPortas,
      "tipoTransmissao": tipoTransmissao,
      "condicao": condicao,
      "numeroAssentos": numeroAssentos,
      "descricao": descricao
    };
  }
}
