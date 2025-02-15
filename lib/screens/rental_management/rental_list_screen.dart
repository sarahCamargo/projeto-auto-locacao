import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/rental_constants.dart';
import 'package:projeto_auto_locacao/screens/rental_management/rental/generate_contract_screen.dart';
import 'package:projeto_auto_locacao/screens/rental_management/rental/rental_register.dart';
import 'package:projeto_auto_locacao/widgets/buttons/save_add_button.dart';
import 'package:projeto_auto_locacao/widgets/filter_bar.dart';

import '../../../constants/collection_names.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/buttons/new_register_button.dart';
import '../../../widgets/search_input.dart';
import '../../constants/app_icons.dart';
import '../../models/rental.dart';
import '../../widgets/buttons/action_button.dart';

class RentalListScreen extends StatefulWidget {
  const RentalListScreen({super.key});

  @override
  RentalListScreenState createState() => RentalListScreenState();
}

class RentalListScreenState extends State<RentalListScreen> {
  final DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.rental);
  Map<int, bool> expandedCards = {}; // Controla os cards expandidos

  @override
  void initState() {
    super.initState();
    dbHandler.fetchRentals();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SearchInput(),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FilterBar(filters: [
                "Todos",
                "Ativa",
                "Concluída",
              ]),
            ),
            Expanded(
              child: StreamBuilder<List<Rental>>(
                stream: dbHandler.rentalStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(RentalConstants.noneRental),
                    );
                  }

                  var rentals = snapshot.data!;
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
                      itemCount: rentals.length,
                      itemBuilder: (context, index) {
                        return _buildRentalCard(rental: rentals[index], index: index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        NewRegisterFloatingButton(
          text: RentalConstants.newRental,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RentalRegister(rental: Rental()),
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

  Widget _buildRentalCard({required Rental rental, required int index}) {
    bool isExpanded = expandedCards[index] ?? false; // Verifica se o card está expandido
    bool isCompleted = rental.endDate != null && rental.endDate!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: isCompleted ? ColorsConstants.blueFields : ColorsConstants.greenFields,
                child: Image.asset(AppIcons.vehicles, color: Colors.white, width: 30, height: 30,),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${rental.vehicle?.model}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  Text(
                    "${rental.paymentValue}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsConstants.blueFields),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCompleted ? ColorsConstants.blueFields : ColorsConstants.greenFields,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isCompleted ? "Concluída" : "Ativa",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Placa: ${rental.vehicle?.licensePlate}", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text("Cliente: ${rental.naturalPerson?.name} • ${rental.startDate} ${rental.endDate != null && rental.endDate!.isNotEmpty ? " à ${rental.endDate}" : ''}",
              style: const TextStyle(color: Color(0xFF666666))),

          // **Botão para expandir/opções**
          Center(
            child: IconButton(
              icon: Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.grey[400],
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  expandedCards[index] = !isExpanded;
                });
              },
            ),
          ),

          if (isExpanded)
            Center(
              child: Column(
                children: [
                  ActionButton(text: "Gerar contrato", onPressed: () {
                    print('Gerando contrato...');
                    GenerateContractScreen(rental).showFileSelectionDialog(context);
                  }),
                  const SizedBox(height: 8),
                  if (!isCompleted)
                    ActionButton(text: "Finalizar locação", onPressed: (){
                      print('Finalizando locação...');
                      endRental(context, rental).then((value) {
                        dbHandler.fetchRentals();
                      });
                    }),
                ],
              ),
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

  Future<void> endRental(BuildContext context, var rental) async {
    await dbHandler.updateRentalStatus(context, rental.id,
        {"endDate": DateFormat('dd/MM/yyyy').format(DateTime.now())}, 'rental', "Locação Finalizada com Sucesso");
  }
}
