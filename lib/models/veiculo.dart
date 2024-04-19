import 'package:projeto_auto_locacao/models/dao_interface.dart';

class Veiculo implements DaoInterface {
  String? id;
  String? placa;
  String? modelo;
  String? marca;
  int? anoFabricacao;
  int? renavan;
  String? cor;
  int? quilometragem;
  String? tipoCombustivel;
  int? numeroPortas;
  String? tipoTransmissao;
  String? condicao;
  int? numeroAssentos;
  String? descricao;

  Veiculo(
      {this.id,
      this.placa,
      this.modelo,
      this.marca,
      this.anoFabricacao,
      this.renavan,
      this.cor,
      this.quilometragem,
      this.tipoCombustivel,
      this.numeroPortas,
      this.tipoTransmissao,
      this.condicao,
      this.numeroAssentos,
      this.descricao});

  @override
  String? getId() {
    return id;
  }

  @override
  void setId(final String id) {
    this.id = id;
  }

  @override
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
