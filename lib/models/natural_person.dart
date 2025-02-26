import 'package:projeto_auto_locacao/models/dao_interface.dart';

class NaturalPerson implements DaoInterface {
  int? id;
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

  factory NaturalPerson.fromMap(Map<String, dynamic> map) {
    return NaturalPerson(
      id: map['id'],
      name: map['name'],
      cpf: map['cpf'],
      email: map['email'],
      cep: map['cep'],
      civilState: map['civilState'],
      career: map['career'],
      sex: map['sex'],
      cellPhone: map['cellPhone'],
      birthDate: map['birthDate'],
      street: map['street'],
      state: map['state'],
      city: map['city'],
      neighborhood: map['neighborhood'],
      addressNumber: map['addressNumber'],
      addressComplement: map['addressComplement'],
    );
  }
}
