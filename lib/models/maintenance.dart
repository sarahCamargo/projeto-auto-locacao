import 'package:projeto_auto_locacao/models/dao_interface.dart';

class Maintenance implements DaoInterface{

  int? id;
  int? idVehicle;
  String? type;
  String? other;
  String? frequency;
  String? lastCheck;
  String? nextCheck;

  Maintenance(
      {this.id,
        this.idVehicle,
        this.type,
        this.other,
        this.frequency,
        this.lastCheck,
        this.nextCheck});

  @override
  int? getId() {
    return id;
  }

  @override
  void setId(int id) {
    this.id = id;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "idVehicle": idVehicle,
      "type": type,
      "other": other,
      "frequency": frequency,
      "lastCheck": lastCheck,
      "nextCheck": nextCheck
    };
  }

}