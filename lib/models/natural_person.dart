import 'package:projeto_auto_locacao/models/dao_interface.dart';

class NaturalPerson implements DaoInterface{
  String? id;
  String? name;
  String? cpf;
  String? email;
  String? civilState;
  String? career;
  String? sex;
  String? cellPhone;
  String? birthDate;
  String? cep;
  String? street;
  String? state;
  String? city;
  String? neighborhood;
  int? addressNumber;
  String? addressComplement;

  NaturalPerson(
      {this.id,
      this.name,
      this.cpf,
      this.email,
      this.civilState,
      this.career,
      this.sex,
      this.cellPhone,
      this.birthDate,
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
      "name": name,
      "cpf": cpf,
      "email": email,
      "cep": cep,
      "civilState": civilState,
      "career": career,
      "sex": sex,
      "cellPhone": cellPhone,
      "birthDate": birthDate,
      "street": street,
      "state": state,
      "city": city,
      "neighborhood": neighborhood,
      "addressNumber": addressNumber,
      "addressComplement": addressComplement
    };
  }
}
