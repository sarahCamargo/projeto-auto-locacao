import 'package:projeto_auto_locacao/models/dao_interface.dart';

class LegalPerson implements DaoInterface{
  String? id;
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
  String? getId() {
    return id;
  }

  @override
  void setId(final String id) {
    this.id = id;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "cnpj": cnpj,
      "email": email,
      "trading_name": tradingName,
      "company_name": companyName,
      "legal_responsible": legalResponsible,
      "legal_responsible_cpf": legalResponsibleCPF,
      "legal_responsible_role": legalResponsibleRole,
      "state_registration": stateRegistration,
      "cell_phone": cellPhone,
      "cep": cep,
      "street": street,
      "state": state,
      "city": city,
      "neighborhood": neighborhood,
      "address_number": addressNumber,
      "address_complement": addressComplement
    };
  }
}
