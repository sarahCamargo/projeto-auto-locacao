import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/models/dao_interface.dart';
import 'package:uuid/uuid.dart';

class DaoService {
  final String collectionName;

  DaoService({required this.collectionName});

  Future<void> save(DaoInterface daoInterface) async {
    if (daoInterface.getId() == null) {
      daoInterface.setId(const Uuid().v1());
    }
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(daoInterface.getId())
        .set(daoInterface.toMap());
  }

  Future<void> delete(String id) async {
    FirebaseFirestore.instance.collection(collectionName).doc(id).delete();
  }
}
