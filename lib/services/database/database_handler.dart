import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/models/dao_interface.dart';
import 'package:projeto_auto_locacao/models/vehicle.dart';

import '../../models/rental.dart';
import 'database_helper.dart';

class DatabaseHandler {

  final String collection;

  final _dataController = StreamController<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get dataStream => _dataController.stream;

  final StreamController<List<Rental>> _rentalController = StreamController.broadcast();

  Stream<List<Rental>> get rentalStream => _rentalController.stream;

  final DatabaseHelper databaseHelper = DatabaseHelper();

  DatabaseHandler(this.collection);

  Future<void> save(BuildContext context, int? id, DaoInterface daoInterface) async {
    await saveHandler(id, daoInterface).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados salvos com sucesso'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context, true);
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar dados: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  Future<void> saveHandler(int? id, DaoInterface daoInterface) async {
    if (id != null) {
      daoInterface.setId(id);
      await databaseHelper.update(daoInterface.getId()!, daoInterface.toMap(), collection);
    } else {
      int idInsert = await databaseHelper.insert(daoInterface, collection);
      daoInterface.setId(idInsert);
    }
  }

  Future<void> fetchDataFromDatabase() async {
    List<Map<String, dynamic>> results =
    await DatabaseHelper().fetchData(collection);
    _dataController.add(results);
  }

  Future<void> delete(int id) async {
    await DatabaseHelper().delete(id, collection).then((value) {
      fetchDataFromDatabase();
    });
  }

  Future<void> fetchRentals(bool isHistory) async {
    if (!isHistory) {
      List<Rental> results =
      await DatabaseHelper().getRentalsWithVehicles();
      _rentalController.add(results);
    } else {
      List<Rental> results =
      await DatabaseHelper().getRentalsHistory();
      _rentalController.add(results);
    }
  }

  Future<List<Vehicle>> fetchVehiclesToRent(int? editVehicle) async {
      List<Vehicle> results;
      if (editVehicle != null) {
        results = await DatabaseHelper().getVehicleToRent(editVehicle);
      } else {
        results = await DatabaseHelper().getVehicleRenovation();
      }
      return results;
  }

  Future<void> fetchMaintenancesWithVehicles() async {
    List<Map<String, dynamic>> results =
    await DatabaseHelper().getMaintenancesWithVehicles();
    _dataController.add(results);
  }

  Future<List<Map<String, dynamic>>> getData(String collection) async {
    List<Map<String, dynamic>> results =
    await DatabaseHelper().fetchData(collection);
    return results;
  }

  Future<void> updateRentalStatus(BuildContext context, int id, Map<String, dynamic> newData,String collection, String successMessage) async {
    await databaseHelper.update(id, newData, collection).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context, true);
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao finalizar locação: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }
}