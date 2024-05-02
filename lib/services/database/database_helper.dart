import 'package:projeto_auto_locacao/models/dao_interface.dart';
import 'package:projeto_auto_locacao/services/database/queries/legal_person_queries.dart';
import 'package:projeto_auto_locacao/services/database/queries/natural_person_queries.dart';
import 'package:projeto_auto_locacao/services/database/queries/vehicle_queries.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  final String dbName = 'executivo.db';

  final int dbVersion = 2;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    /* Descomentar se necessário criar o banco de novo.*/
    /*
    String path = await getDatabasesPath();
    String fullPath = join(path, dbName);

    await deleteDatabase(fullPath);*/

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, dbName),
      version: dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(VehicleQueries.createTableQuery);
    await db.execute(NaturalPersonQueries.createTableQuery);
    await db.execute(LegalPersonQueries.createTableQuery);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<int> insert(DaoInterface daoInterface, String collection) async {
    final db = await database;
    int result =  await db.insert(collection, daoInterface.toMap());
    print('Dados inseridos com sucesso na tabela $collection');
    return result;
  }

  Future<List<Map<String, dynamic>>> fetchData(String collection) async {
    final db = await database;
    var result =  await db.query(collection);
    print('Lista $result tabela $collection');
    return result;
  }

  Future<void> delete(int id, String collection) async {
    final db = await database;
    await db.delete(collection, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(int id, Map<String, dynamic> newData, String collection) async {
    final db = await database;
    await db.update(
      collection,
      newData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
