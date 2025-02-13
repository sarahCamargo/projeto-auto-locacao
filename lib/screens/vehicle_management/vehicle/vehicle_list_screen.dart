import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_register.dart';

import '../../../constants/collection_names.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/buttons/NewRegisterFloatingButton.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  VehicleScreenListState createState() => VehicleScreenListState();
}

class VehicleScreenListState extends State<VehicleListScreen> {
  final DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.vehicle);

  @override
  void initState() {
    super.initState();
    dbHandler.fetchDataFromDatabase(); // Busca os dados iniciais
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
                  _buildFilterButton("Todos", isSelected: true),
                  _buildFilterButton("Disponível"),
                  _buildFilterButton("Locado"),
                  _buildFilterButton("Em manutenção"),
                  _buildFilterButton("Locação pendente"),
                  _buildFilterButton("Manutenção pendente"),
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
                    return const Center(child: Text("Nenhum veículo encontrado"));
                  }

                  var vehicles = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      return _buildVehicleCard(
                        vehicle: vehicles[index]
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // Botão para adicionar novo veículo
        NewRegisterFloatingButton(
          text: 'Novo veículo',
          onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VehicleRegister(vehicle: {}),
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

  // Card de veículo atualizado
  Widget _buildVehicleCard({
    required var vehicle
  }) {
    return Card(
      color: Colors.white.withOpacity(1.0),
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                vehicle['imageUrl'] != null && vehicle['imageUrl'].isNotEmpty ?
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    io.File(vehicle['imageUrl']),
                    width: 100,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ) : const Icon(Icons.image_not_supported_outlined) ,
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle['model'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Placa: ${vehicle['licensePlate']}", style: const TextStyle(color: Colors.grey)),
                      //Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      dbHandler.delete(vehicle['id']); // Exclui o veículo
                    },
                    child: const Text("Excluir", style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleRegister(vehicle: vehicle),
                        ),
                      ).then((value) {
                        if (value == true) {
                          dbHandler.fetchDataFromDatabase(); // Atualiza após edição
                        }
                      });
                    },
                    child: const Text("Editar", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
