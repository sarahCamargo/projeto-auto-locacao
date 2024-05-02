import 'package:logger/logger.dart';
import 'package:projeto_auto_locacao/constants/collection_names.dart';
import 'package:projeto_auto_locacao/services/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

Future<bool> isCpfAlreadyRegistered(String cpf) async {
  final logger = Logger();

  try {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database db = await databaseHelper.database;

    var result = await db.query(CollectionNames.naturalPerson,
        where: 'cpf = ?', whereArgs: [cpf]);

    return result.isNotEmpty;
  } catch (e) {
    logger.e('Erro ao verificar CPF', error: e);
    return false;
  }
}

Future<bool> isCnpjAlreadyRegistered(String cnpj) async {
  final logger = Logger();

  try {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database db = await databaseHelper.database;

    var result = await db.query(CollectionNames.legalPerson,
        where: 'cnpj = ?', whereArgs: [cnpj]);
    return result.isNotEmpty;
  } catch (e) {
    logger.e('Erro ao verificar CNPJ', error: e);
    return false;
  }
}
