import 'package:projeto_auto_locacao/models/dao_interface.dart';

class Vehicle implements DaoInterface{
  int? id;
  String? licensePlate;
  String? model;
  String? brand;
  String? year;
  int? renavam;
  String? color;
  String? fuelType;
  String? transmissionType;
  String? condition;
  String? description;
  String? imageUrl;

  Vehicle(
      {this.id,
      this.licensePlate,
      this.model,
      this.brand,
      this.year,
      this.renavam,
      this.color,
      this.fuelType,
      this.transmissionType,
      this.condition,
      this.description,
      this.imageUrl});

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
      "licensePlate": licensePlate,
      "model": model,
      "brand": brand,
      "year": year,
      "renavam": renavam,
      "color": color,
      "fuelType": fuelType,
      "transmissionType": transmissionType,
      "condition": condition,
      "description": description,
      "imageUrl": imageUrl
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      licensePlate: map['licensePlate'],
      brand: map['brand'],
      model: map['model'],
      imageUrl: map['imageUrl']
    );
  }
}
