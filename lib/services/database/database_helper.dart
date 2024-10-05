import 'package:projeto_auto_locacao/models/dao_interface.dart';
import 'package:projeto_auto_locacao/models/vehicle.dart';
import 'package:projeto_auto_locacao/services/database/queries/legal_person_queries.dart';
import 'package:projeto_auto_locacao/services/database/queries/maintenance_queries.dart';
import 'package:projeto_auto_locacao/services/database/queries/natural_person_queries.dart';
import 'package:projeto_auto_locacao/services/database/queries/rental_queries.dart';
import 'package:projeto_auto_locacao/services/database/queries/vehicle_queries.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/rental.dart';

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
    String path = await getDatabasesPath();
    String fullPath = join(path, dbName);

    /* Descomentar se necessário criar o banco de novo.*/
    //await deleteDatabase(fullPath);

    _database = await openDatabase(
      fullPath,
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(VehicleQueries.createTableQuery);
    await db.execute(NaturalPersonQueries.createTableQuery);
    await db.execute(LegalPersonQueries.createTableQuery);
    await db.execute(MaintenanceQueries.createTableQuery);
    await db.execute(RentalQueries.createTableQuery);
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

  Future<List<Rental>> getRentalsWithVehicles() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(RentalQueries.getRentalInfo);
    return List.generate(maps.length, (i) => Rental.fromMap(maps[i]));
  }

  Future<List<Rental>> getRentalsHistory() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(RentalQueries.getRentalHistory);
    return List.generate(maps.length, (i) => Rental.fromMap(maps[i]));
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE vehicle ADD COLUMN owner TEXT;');
    }
  }

  Future<List<Vehicle>> getVehicleToRent(int? editVehicle) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(RentalQueries.getVehicleToRent, [editVehicle]);
    return List.generate(maps.length, (i) => Vehicle.fromMap(maps[i]));
  }

  Future<List<Vehicle>> getVehicleRenovation() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(RentalQueries.getVehicleToRenovate);
    return List.generate(maps.length, (i) => Vehicle.fromMap(maps[i]));
  }
}
