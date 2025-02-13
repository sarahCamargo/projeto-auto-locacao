import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/maintenance/maintenance_register.dart';

import '../../../constants/collection_names.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/buttons/NewRegisterFloatingButton.dart';

class MaintenanceListScreen extends StatefulWidget {
  const MaintenanceListScreen({super.key});

  @override
  MaintenanceListScreenState createState() => MaintenanceListScreenState();
}

class MaintenanceListScreenState extends State<MaintenanceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedFilter = "Todas";
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.maintenance);
  DatabaseHandler dbVehicles = DatabaseHandler(CollectionNames.vehicle);

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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Pesquisar",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  _buildFilterButton("Todas", isSelected: true),
                  _buildFilterButton("Em manutenção"),
                  _buildFilterButton("Pendente"),
                  _buildFilterButton("Concluída"),
                ],
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
                        child: Text("Nenhuma manutenção encontrada"));
                  }

                  var maintenances = snapshot.data!;

                  print(maintenances);

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70),
                    itemCount: maintenances.length,
                    itemBuilder: (context, index) {
                      return _buildMaintenanceCard(
                          maintenance: maintenances[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        NewRegisterFloatingButton(
          text: 'Nova manutenção',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MaintenanceRegister(
                  maintenance: {},
                  idVehicle: 1,
                ),
              ),
            ).then((value) {
              if (value == true) {
                dbHandler.fetchDataFromDatabase();
              }
            });
          },
        )
      ],
    );
  }

  Widget _buildFilterButton(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black87 : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {},
        child: Text(label),
      ),
    );
  }

  Widget _buildMaintenanceCard({required var maintenance}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.yellow,
                  child: Icon(Icons.build, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Modelo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Pendente',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text("Placa: ", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text("Serviço: ${maintenance['type']}",
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(maintenance['nextCheck'],
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
