import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_constants.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle_register.dart';
import 'package:projeto_auto_locacao/services/database/database_helper.dart';

import '../../constants/collection_names.dart';
import '../../constants/colors_constants.dart';
import '../../constants/general_constants.dart';
import '../../utils/confirmation_dialog.dart';
import '../../widgets/custom_app_bar.dart';
import 'vehicle_card.dart';
import '../../widgets/custom_text_label.dart';

class VehiclesManagement extends StatefulWidget {
  const VehiclesManagement({super.key});

  @override
  VehiclesManagementState createState() => VehiclesManagementState();
}

class VehiclesManagementState extends State<VehiclesManagement> {
  String searchString = '';
  final StreamController<List<Map<String, dynamic>>> _streamController =
  StreamController<List<Map<String, dynamic>>>();

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: VehicleConstants.vehicleManagementTitle,
          hasReturnScreen: true,
        ),
        body: TabBarView(children: [listVehicles(), Container()]),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: const TabBar(tabs: [
            Tab(
              icon:
              Icon(FontAwesomeIcons.car, color: ColorsConstants.iconColor),
            ),
            Tab(
              icon: Icon(FontAwesomeIcons.screwdriverWrench,
                  color: ColorsConstants.iconColor),
            )
          ]),
        ),
      ),
    );
  }

  Widget listVehicles() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchString = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                        labelText: GeneralConstants.search,
                        prefixIcon: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: ColorsConstants.iconColor,
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.plus,
                  color: ColorsConstants.iconColor,
                  size: 40,
                ),
                onPressed: () =>
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const VehicleRegister(
                        vehicle: {},
                      ),
                    ),
                  ).then((value) {
                    if (value == true) {
                      fetchDataFromDatabase();
                    }
                  }),
                },
              )
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: _streamController.stream,
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              var items = snapshot.data!.where((element) =>
                  element['licensePlate']
                      .toString()
                      .toLowerCase()
                      .contains(searchString));
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var vehicle = items.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationDialog(
                                content: GeneralConstants.confirmEdit,
                                confirmationWidget:
                                confirmationAction(context, vehicle));
                          });
                    },
                    child: CustomCardVehicle(
                        vehicle['brand'],
                        vehicle['year'],
                        vehicle['licensePlate'],
                        vehicle['id'],
                        vehicle['imageUrl'], (id) async {
                      await deleteVehicle(vehicle['id']);
                    }),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget confirmationAction(BuildContext context, var vehicle) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleRegister(vehicle: vehicle),
            ),
          ).then((value) {
            fetchDataFromDatabase();
          });
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
  }

  Future<List<Map<String, dynamic>>> fetchDataFromDatabase() async {
    List<Map<String, dynamic>> results =
    await DatabaseHelper().fetchData(CollectionNames.vehicle);
    _streamController.add(results);
    return results;
  }

  Future<void> deleteVehicle(int id) async {
    await DatabaseHelper().delete(id, CollectionNames.vehicle).then((value) {
      fetchDataFromDatabase();
    });
  }
}
