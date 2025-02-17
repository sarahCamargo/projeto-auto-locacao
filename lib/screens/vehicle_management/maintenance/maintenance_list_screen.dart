import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/maintenance_constants.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/maintenance/maintenance_register.dart';

import '../../../constants/app_icons.dart';
import '../../../constants/collection_names.dart';
import '../../../constants/colors_constants.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/buttons/delete_button.dart';
import '../../../widgets/buttons/edit_button.dart';
import '../../../widgets/buttons/new_register_button.dart';
import '../../../widgets/search_input.dart';

class MaintenanceListScreen extends StatefulWidget {
  const MaintenanceListScreen({super.key});

  @override
  MaintenanceListScreenState createState() => MaintenanceListScreenState();
}

class MaintenanceListScreenState extends State<MaintenanceListScreen> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.maintenance);
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    dbHandler.fetchMaintenancesWithVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SearchInput(onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            }),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              // child: FilterBar(filters: [
              //   "Todos",
              //   "Em manutenção",
              //   "Pendente",
              //   "Concluída",
              // ]),
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
                      child: Text(MaintenanceConstants.noneMaintenance),
                    );
                  }

                  var maintenances = _filteredMaintenances(snapshot.data!);
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
                      itemCount: maintenances.length,
                      itemBuilder: (context, index) {
                        return _buildMaintenanceCard(maintenance: maintenances[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        NewRegisterFloatingButton(
          text: MaintenanceConstants.newMaintenance,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MaintenanceRegister(idVehicle: 0, maintenance: {},),
              ),
            ).then(
                  (value) {
                if (value == true) {
                  dbHandler.fetchMaintenancesWithVehicles();
                }
              },
            );
          },
        )
      ],
    );
  }

  List<Map<String, dynamic>> _filteredMaintenances(List<Map<String, dynamic>> maintenances) {
    var filteredMaintenances = maintenances;

    if (_searchQuery.isNotEmpty) {
      filteredMaintenances = filteredMaintenances.where((m) => m['model'].toLowerCase().contains(_searchQuery)).toList();
    }

    return filteredMaintenances;
  }

  Widget _buildMaintenanceCard({required var maintenance}) {
    print(maintenance);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ColorsConstants.blueFields,
                child: Image.asset(AppIcons.maintenance, color: Colors.white, width: 30, height: 30,),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${maintenance['model']}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Placa: ${maintenance['licensePlate']}", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text("Serviço: ${maintenance['type']} • ${maintenance['nextCheck']}",
              style: const TextStyle(color: Color(0xFF666666))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DeleteButton(onPressed: () {
                dbHandler.delete(maintenance['id']).then((e) => {
                    dbHandler.fetchMaintenancesWithVehicles()
                });
              }),
              const SizedBox(width: 10),
              EditButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MaintenanceRegister(idVehicle: maintenance['idVehicle'], maintenance: maintenance,),
                  ),
                ).then((value) {
                  if (value == true) {
                    dbHandler.fetchMaintenancesWithVehicles();
                  }
                });
              }),
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
