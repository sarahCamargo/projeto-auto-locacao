import 'package:projeto_auto_locacao/models/dao_interface.dart';
import 'package:projeto_auto_locacao/models/legal_person.dart';
import 'package:projeto_auto_locacao/models/natural_person.dart';
import 'package:projeto_auto_locacao/models/vehicle.dart';

class Rental implements DaoInterface {
  int? id;
  int? vehicleId;
  int? naturalPersonId;
  int? legalPersonId;
  String? startDate;
  String? endDate;
  String? paymentType;
  String? paymentValue;
  final Vehicle? vehicle;
  final NaturalPerson? naturalPerson;
  final LegalPerson? legalPerson;

  Rental(
      {this.id,
      this.vehicleId,
      this.naturalPersonId,
      this.legalPersonId,
      this.startDate,
      this.endDate,
      this.paymentType,
      this.paymentValue,
      this.naturalPerson,
      this.legalPerson,
      this.vehicle});

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
      "vehicleId": vehicleId,
      "naturalPersonId": naturalPersonId,
      "legalPersonId": legalPersonId,
      "startDate": startDate,
      "endDate": endDate,
      "paymentType": paymentType,
      "paymentValue": paymentValue
    };
  }

  factory Rental.fromMap(Map<String, dynamic> map) {
    return Rental(
        id: map['id'],
        vehicleId: map['vehicleId'],
        naturalPersonId: map['naturalPersonId'],
        legalPersonId: map['legalPersonId'],
        startDate: map['startDate'],
        endDate: map['endDate'],
        paymentType: map['paymentType'],
        paymentValue: map['paymentValue'],
        vehicle: Vehicle.fromMap(map),
        naturalPerson: NaturalPerson.fromMap(map),
        legalPerson: LegalPerson.fromMap(map));
  }
}
