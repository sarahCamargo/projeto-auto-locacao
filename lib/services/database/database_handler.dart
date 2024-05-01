import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/models/dao_interface.dart';

import 'database_helper.dart';

class DatabaseHandler {

  final String collection;

  final _dataController = StreamController<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get dataStream => _dataController.stream;

  final DatabaseHelper databaseHelper = DatabaseHelper();

  DatabaseHandler(this.collection);

  void save(BuildContext context, int? id, DaoInterface daoInterface) {
    saveHandler(id, daoInterface).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados salvos com sucesso'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context, true);
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar dados: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  Future<void> saveHandler(int? id, DaoInterface daoInterface) async {
    if (id != null) {
      daoInterface.setId(id);
      await databaseHelper.update(daoInterface.getId()!, daoInterface.toMap(), collection);
    } else {
      await databaseHelper.insert(daoInterface, collection);
    }
  }

  Future<void> fetchDataFromDatabase() async {
    List<Map<String, dynamic>> results =
    await DatabaseHelper().fetchData(collection);
    _dataController.add(results);
  }

  Future<void> delete(int id) async {
    await DatabaseHelper().delete(id, collection).then((value) {
      fetchDataFromDatabase();
    });
  }

}