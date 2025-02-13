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

  static const getMaintenanceInfo = '''
    SELECT m.*, 
        v.model,  
        v.licensePlate
    FROM maintenance m
        INNER JOIN vehicle v ON m.idVehicle = v.id
  ''';
}