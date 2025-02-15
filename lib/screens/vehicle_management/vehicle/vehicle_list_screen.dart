import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/vehicle_constants.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_register.dart';
import 'package:projeto_auto_locacao/widgets/buttons/delete_button.dart';
import 'package:projeto_auto_locacao/widgets/buttons/edit_button.dart';
import 'package:projeto_auto_locacao/widgets/filter_bar.dart';

import '../../../constants/collection_names.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/buttons/new_register_button.dart';
import '../../../widgets/search_input.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  VehicleScreenListState createState() => VehicleScreenListState();
}

class VehicleScreenListState extends State<VehicleListScreen> {
  final DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.vehicle);
  String _selectedFilter = "Todos";

  @override
  void initState() {
    super.initState();
    dbHandler.fetchDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SearchInput(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FilterBar(filters: const [
                "Todos",
                "Disponível",
                "Locado",
                "Em manutenção",
                "Locação pendente",
                "Manutenção pendente"
              ],
                onFilterSelected: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
                print(_selectedFilter);
              },
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: dbHandler.dataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(VehicleConstants.noneVehicle),
                    );
                  }

                  var vehicles = snapshot.data!;
                  return Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 70),
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        return _buildVehicleCard(vehicle: vehicles[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        NewRegisterFloatingButton(
          text: VehicleConstants.newVehicle,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VehicleRegister(vehicle: {}),
              ),
            ).then(
              (value) {
                if (value == true) {
                  dbHandler.fetchDataFromDatabase();
                }
              },
            );
          },
        )
      ],
    );
  }

  Widget _buildVehicleCard({required var vehicle}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 120,
                child: vehicle['imageUrl'] != null &&
                        vehicle['imageUrl'].isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          io.File(vehicle['imageUrl']),
                          width: 100,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.image_not_supported_outlined),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle['model'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    Text(
                      "${VehicleConstants.licensePlateLabel}: ${vehicle['licensePlate']}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DeleteButton(onPressed: () {
                          dbHandler.delete(vehicle['id']);
                        }),
                        const SizedBox(width: 10),
                        EditButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VehicleRegister(vehicle: vehicle),
                            ),
                          ).then((value) {
                            if (value == true) {
                              dbHandler.fetchDataFromDatabase();
                            }
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: ColorsConstants.dividerColor,
            thickness: 1,
            indent: 5,
            endIndent: 5,
          )
        ],
      ),
    );
  }
}
