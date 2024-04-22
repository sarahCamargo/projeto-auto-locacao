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

Future<bool> isCnpjAlreadyRegistered(String cnpj) async {
  final logger = Logger();

  try {
    CollectionReference legalPersonsCollection =
    FirebaseFirestore.instance.collection('pessoa_juridica');

    QuerySnapshot querySnapshot =
    await legalPersonsCollection.where('cnpj', isEqualTo: cnpj).get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    logger.e('Erro ao verificar CNPJ', error: e);
    return false;
  }
}