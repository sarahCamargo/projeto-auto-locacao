import 'package:projeto_auto_locacao/models/dao_interface.dart';

class Veiculo implements DaoInterface {
  String? id;
  String? placa;
  String? modelo;
  String? marca;
  String? anoFabricacao;
  int? renavan;
  String? cor;
  String? tipoCombustivel;
  String? tipoTransmissao;
  String? condicao;
  String? descricao;
  String? image;

  Veiculo(
      {this.id,
      this.placa,
      this.modelo,
      this.marca,
      this.anoFabricacao,
      this.renavan,
      this.cor,
      this.tipoCombustivel,
      this.tipoTransmissao,
      this.condicao,
      this.descricao,
      this.image});

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
      "tipoCombustivel": tipoCombustivel,
      "tipoTransmissao": tipoTransmissao,
      "condicao": condicao,
      "descricao": descricao,
      "image": image
    };
  }
}
