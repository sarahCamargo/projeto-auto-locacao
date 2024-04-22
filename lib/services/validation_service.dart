import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

Future<bool> isCpfAlreadyRegistered(String cpf) async {
  final logger = Logger();

  try {
    CollectionReference personsCollection =
        FirebaseFirestore.instance.collection('pessoa_fisica');

    QuerySnapshot querySnapshot =
        await personsCollection.where('cpf', isEqualTo: cpf).get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    logger.e('Erro ao verificar CPF', error: e);
    return false;
  }
}
