import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/rental_constants.dart';
import 'package:projeto_auto_locacao/screens/rental_management/rental/rental_register.dart';
import 'package:projeto_auto_locacao/widgets/filter_bar.dart';

import '../../../constants/collection_names.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/buttons/new_register_button.dart';
import '../../../widgets/search_input.dart';
import '../../constants/app_icons.dart';
import '../../models/rental.dart';

class RentalListScreen extends StatefulWidget {
  const RentalListScreen({super.key});

  @override
  RentalListScreenState createState() => RentalListScreenState();
}

class RentalListScreenState extends State<RentalListScreen> {
  final DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.rental);

  @override
  void initState() {
    super.initState();
    dbHandler.fetchRentals(false);
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
                "Pendente",
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
                        return _buildRentalCard(rental: rentals[index]);
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

  Widget _buildRentalCard({required Rental rental}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ColorsConstants.yellowFields,
                child: Image.asset(AppIcons.vehicles, color: Colors.white, width: 30, height: 30,),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${rental.vehicle?.model}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      color: ColorsConstants.yellowFields,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Pendente',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Placa: ${rental.vehicle?.licensePlate}", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text("Cliente: ${rental.naturalPerson?.name}",
              style: const TextStyle(color: Color(0xFF666666))),
          
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
