class VehicleQueries {
  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS vehicle (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      licensePlate TEXT,
      model TEXT,
      brand TEXT,
      year TEXT,
      renavam INTEGER,
      color TEXT,
      fuelType TEXT,
      transmissionType TEXT,
      condition TEXT,
      description TEXT,
      imageUrl TEXT,
      owner TEXT
    )
  ''';
}
