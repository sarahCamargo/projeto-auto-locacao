class Veiculo {
  String id;
  String placa;
  String modelo;
  String marca;
  int ano_fabricacao;

  Veiculo({required this.id, required this.placa, required this.modelo, required this.marca, required this.ano_fabricacao});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "placa": placa,
      "modelo": modelo,
      "marca": marca,
      "ano_fabricacao": ano_fabricacao
    };
  }
}