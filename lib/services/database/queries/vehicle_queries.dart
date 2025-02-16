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

  static const String getVehicles = '''
    SELECT v.*
    FROM vehicle v
  ''';

  static const String getVehiclesListScreen = '''
    SELECT v.*,
   CASE 
        WHEN EXISTS (
            SELECT 1 FROM rental r 
            WHERE r.vehicleId = v.id 
            AND r.startDate IS NOT NULL 
            AND (r.endDate IS NULL OR r.endDate = '')
        ) THEN 1 ELSE 0 
    END AS hasOpenRental
    FROM vehicle v
  ''';
}
