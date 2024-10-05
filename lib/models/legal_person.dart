import 'package:projeto_auto_locacao/models/dao_interface.dart';

class LegalPerson implements DaoInterface{
  int? id;
  String? cnpj;
  String? email;
  String? tradingName;
  String? companyName;
  String? legalResponsible;
  String? legalResponsibleCPF;
  String? legalResponsibleRole;
  String? stateRegistration;
  String? cellPhone;
  String? cep;
  String? street;
  String? state;
  String? city;
  String? neighborhood;
  int? addressNumber;
  String? addressComplement;

  LegalPerson(
      {this.id,
        this.cnpj,
        this.email,
        this.tradingName,
        this.companyName,
        this.legalResponsible,
        this.legalResponsibleCPF,
        this.legalResponsibleRole,
        this.stateRegistration,
        this.cellPhone,
        this.cep,
        this.street,
        this.state,
        this.city,
        this.neighborhood,
        this.addressNumber,
        this.addressComplement});

  @override
  int? getId() {
    return id;
  }

  @override
  void setId(final int id) {
    this.id = id;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "cnpj": cnpj,
      "email": email,
      "tradingName": tradingName,
      "companyName": companyName,
      "legalResponsible": legalResponsible,
      "legalResponsibleCpf": legalResponsibleCPF,
      "legalResponsibleRole": legalResponsibleRole,
      "stateRegistration": stateRegistration,
      "cellPhone": cellPhone,
      "cep": cep,
      "street": street,
      "state": state,
      "city": city,
      "neighborhood": neighborhood,
      "addressNumber": addressNumber,
      "addressComplement": addressComplement
    };
  }

  factory LegalPerson.fromMap(Map<String, dynamic> map) {
    return LegalPerson(
      id: map['id'],
      tradingName: map['tradingName'],
      companyName: map['companyName'],
      cnpj: map['cnpj'],
    );
  }
}
