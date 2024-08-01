import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_constants.dart';
import 'package:projeto_auto_locacao/screens/rental_management/rental/rental_register.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_register.dart';
import 'package:projeto_auto_locacao/widgets/custom_card.dart';
import '../../../constants/collection_names.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/general_constants.dart';
import '../../../models/rental.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/custom_text_label.dart';

class RentalScreen extends StatefulWidget {
  const RentalScreen({super.key});

  @override
  RentalScreenState createState() => RentalScreenState();
}

class RentalScreenState extends State<RentalScreen> {
  String searchString = '';
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.rental);

  @override
  void initState() {
    super.initState();
    dbHandler.fetchRentals();
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RentalRegister(
                        rental: {},
                      ),
                    ),
                  ).then((value) {
                    if (value == true) {
                      dbHandler.fetchRentals();
                    }
                  }),
                },
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: StreamBuilder<List<Rental>>(
                stream: dbHandler.rentalStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  var rentals = snapshot.data!;
                  var filteredRentals = rentals.where((rental) =>
                      rental.id.toString().toLowerCase().contains(searchString.toLowerCase())
                  ).toList();
                  return ListView.builder(
                    itemCount: filteredRentals.length,
                    itemBuilder: (context, index) {
                      var rentals = filteredRentals[index];
                      return GestureDetector(
                        child: CustomCard(
                          title: 'Locação nº ${rentals.id} - ${rentals.vehicle?.brand} ',
                          data: _getCardInfo(rentals),
                          id: rentals.id ?? 0,
                          imageUrl: rentals.vehicle?.imageUrl,
                          hasImage: true,
                          hasDelete: true,
                          dbHandler: dbHandler,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _getCardInfo(var rentals) {
    List<Widget> info = [];
    info.add(CustomTextLabel(
        label:
        '${VehicleConstants.licensePlateLabel}: ${rentals.vehicle.licensePlate}'));
    info.add(CustomTextLabel(
        label:
        'Locador: ${rentals.naturalPerson.name}'));
    info.add(CustomTextLabel(
        label:
        'CPF: ${rentals.naturalPerson.cpf}'));
    return info;
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
            dbHandler.fetchRentals();
          });
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
  }
}
