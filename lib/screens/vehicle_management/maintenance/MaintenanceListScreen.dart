import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/models/vehicle.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/maintenance/maintenance_register.dart';

import '../../../constants/collection_names.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/buttons/NewRegisterFloatingButton.dart';

class MaintenanceListScreen extends StatefulWidget {
  @override
  _MaintenanceListScreenState createState() => _MaintenanceListScreenState();
}

class _MaintenanceListScreenState extends State<MaintenanceListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedFilter = "Todas";
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.maintenance);
  DatabaseHandler dbVehicles = DatabaseHandler(CollectionNames.vehicle);

  @override
  void initState() {
    super.initState();
    dbHandler.fetchDataFromDatabase();
  }

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

            // Filtros
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

            // Lista de veículos dinâmica
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: dbHandler.dataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Nenhuma manutenção encontrada"));
                  }

                  var maintenances = snapshot.data!;

                  print(maintenances);

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70),
                    itemCount: maintenances.length,
                    itemBuilder: (context, index) {
                      return _buildMaintenanceCard(
                          maintenance: maintenances[index]
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // Botão para adicionar nova manutenção
        NewRegisterFloatingButton(
          text: 'Nova manutenção',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MaintenanceRegister(maintenance: {}, idVehicle: 1,),
              ),
            ).then((value) {
              if (value == true) {
                dbHandler.fetchDataFromDatabase(); // Atualiza a lista após o cadastro
              }
            });
          },
        )
      ],
    );
  }

// Botão de filtro estilizado
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

  Widget _buildMaintenanceCard({
    required var maintenance
    
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.yellow, //statusColor,
                  child: Icon(Icons.build, color: Colors.white),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Modelo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Pendente',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text("Placa: ", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text("Serviço: ${maintenance['type']}", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text(maintenance['nextCheck'], style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}