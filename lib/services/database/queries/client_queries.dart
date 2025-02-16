class ClientQueries {
  static const String getAllClientes = '''
    SELECT pf.id, pf.cpf as documentNumber, pf.name as name, pf.cellPhone, pf.email, 1 as typeClient
    FROM natural_person pf
    UNION
    SELECT pj.id, pj.cnpj as documentNumber, pj.companyName as name, pj.cellPhone, pj.email, 2 as typeClient
    FROM legal_person pj
  ''';
}
