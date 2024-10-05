class RentalQueries {
  static const String createTableQuery = '''
    CREATE TABLE rental (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleId INTEGER,
        naturalPersonId INTEGER,
        legalPersonId INTEGER,
        startDate TEXT,
        endDate TEXT,
        paymentType TEXT,
        paymentValue REAL,
        FOREIGN KEY (vehicleId) REFERENCES vehicle(id),
        FOREIGN KEY (naturalPersonId) REFERENCES natural_person(id),
        FOREIGN KEY (legalPersonId) REFERENCES legal_person(id)
    )
  ''';

  static const getRentalInfo = '''
    SELECT r.*, 
        v.model, 
        v.brand, 
        v.licensePlate, 
        v.imageUrl, 
        v.year, 
        v.color, 
        v.renavam, 
        v.owner, 
        np.name,
        np.cpf,
        np.street,
        np.addressNumber,
        np.neighborhood,
        np.addressComplement,
        np.city,
        np.state,
        np.cep,
        lp.tradingName,
        lp.companyName,
        lp.cnpj
    FROM rental r
        INNER JOIN vehicle v ON r.vehicleId = v.id
        LEFT JOIN natural_person np ON r.naturalPersonId = np.id
        LEFT JOIN legal_person lp ON r.legalPersonId = lp.id 
    WHERE r.endDate is null;
  ''';

  static const getRentalHistory = '''
    SELECT r.*, 
        v.model, 
        v.brand, 
        v.licensePlate,
        v.imageUrl,
        np.name,
        np.cpf,
        lp.companyName
    FROM rental r
        INNER JOIN vehicle v ON r.vehicleId = v.id
        LEFT JOIN natural_person np ON r.naturalPersonId = np.id
        LEFT JOIN legal_person lp ON r.legalPersonId = lp.id 
    WHERE r.endDate is not null;
  ''';

  static const getVehicleToRent = '''
    SELECT DISTINCT v.id, 
        v.model, 
        v.brand, 
        v.licensePlate, 
        v.imageUrl
    FROM vehicle v
    LEFT JOIN rental r ON v.id = r.vehicleId
    WHERE v.id NOT IN (
        SELECT r2.vehicleId
        FROM rental r2
        WHERE r2.endDate IS NULL
    )
  ''';
}