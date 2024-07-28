class MaintenanceQueries {
  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS maintenance (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      idVehicle INTEGER,
      type TEXT,
      other TEXT,
      frequency TEXT,
      lastCheck TEXT,
      nextCheck TEXT
    )
  ''';
}