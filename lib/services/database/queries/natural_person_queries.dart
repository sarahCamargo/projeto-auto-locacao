class NaturalPersonQueries {
  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS natural_person (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      cpf TEXT NOT NULL,
      email TEXT,
      cep TEXT,
      civilState TEXT,
      career TEXT,
      sex TEXT,
      cellPhone TEXT NOT NULL,
      birthDate TEXT,
      street TEXT,
      state TEXT,
      city TEXT,
      neighborhood TEXT,
      addressNumber INTEGER,
      addressComplement TEXT
    )
  ''';
}
