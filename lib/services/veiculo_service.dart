import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/models/veiculo.dart';
import 'package:uuid/uuid.dart';

class VeiculoService {
  static const String _nomeColecao = "veiculos";

  static Future<void> salvaVeiculo(Veiculo veiculo) async {
    if (veiculo.id.isEmpty) {
      veiculo.id = const Uuid().v1();
    }

    FirebaseFirestore.instance.collection(_nomeColecao).doc(veiculo.id).set(veiculo.toMap());
  }

  static Future<void> deletaVeiculo(String id) async {
    FirebaseFirestore.instance.collection(_nomeColecao).doc(id).delete();
  }

}