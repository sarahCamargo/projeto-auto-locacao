class LegalPersonQueries {
  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS legal_person (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cnpj TEXT NOT NULL,
      email TEXT,
      tradingName TEXT NOT NULL,
      companyName TEXT NOT NULL,
      legalResponsible TEXT,
      legalResponsibleCpf TEXT,
      legalResponsibleRole TEXT,
      stateRegistration TEXT NOT NULL,
      cellPhone TEXT NOT NULL,
      cep TEXT,
      street TEXT,
      state TEXT,
      city TEXT,
      neighborhood TEXT,
      addressNumber INTEGER,
      addressComplement TEXT
    )
  ''';
}
