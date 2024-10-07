import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_constants.dart';
import 'package:projeto_auto_locacao/screens/rental_management/rental/rental_register.dart';
import 'package:projeto_auto_locacao/utils/contract_file_manipulation.dart';
import 'package:projeto_auto_locacao/widgets/custom_card.dart';
import '../../../constants/collection_names.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/general_constants.dart';
import '../../../models/rental.dart';
import '../../../services/database/database_handler.dart';
import '../../../utils/confirmation_dialog.dart';
import '../../../widgets/custom_text_label.dart';

class RentalScreen extends StatefulWidget {
  final bool isHistory;

  const RentalScreen({super.key, this.isHistory = false});

  @override
  RentalScreenState createState() => RentalScreenState();
}

class RentalScreenState extends State<RentalScreen> {
  String searchString = '';
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.rental);

  @override
  void initState() {
    super.initState();
    dbHandler.fetchRentals(widget.isHistory);
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
              if (!widget.isHistory)
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
                        builder: (context) => RentalRegister(
                          rental: Rental(),
                        ),
                      ),
                    ).then((value) {
                      if (value == true) {
                        dbHandler.fetchRentals(widget.isHistory);
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
                  var filteredRentals = rentals
                      .where((rental) => rental.id
                          .toString()
                          .toLowerCase()
                          .contains(searchString.toLowerCase()))
                      .toList();

                  filteredRentals.where((element) =>
                  (element.vehicle?.id == null)
                  );

                  return ListView.builder(
                    itemCount: filteredRentals.length,
                    itemBuilder: (context, index) {
                      var rentals = filteredRentals[index];
                      return GestureDetector(
                        child: CustomCard(
                          title:
                              'Locação nº ${rentals.id} - ${rentals.vehicle?.brand} ',
                          data: _getCardInfo(rentals),
                          id: rentals.id ?? 0,
                          imageUrl: rentals.vehicle?.imageUrl,
                          hasImage: true,
                          dbHandler: dbHandler,
                          hasOptions: true,
                          isHistory: widget.isHistory ? true : false,
                          onEdit: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationDialog(
                                      content: GeneralConstants.confirmEdit,
                                      confirmationWidget:
                                          confirmationAction(context, rentals));
                                });
                          },
                          onFinalize: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationDialog(
                                      content:
                                          GeneralConstants.confirmEndRental,
                                      confirmationWidget: confirmationEndRental(
                                          context, rentals));
                                });
                          },
                          onGenerateContract: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationDialog(
                                      content: 'Confirma geração do contrato?',
                                      confirmationWidget:
                                          generateContract(context, rentals));
                                });
                          },
                          onRenovateContract: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationDialog(
                                      content:
                                          'Confirma renovação do contrato?',
                                      confirmationWidget:
                                          confirmationRenovateRental(context, rentals));
                                });
                          },
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
    if (rentals.naturalPersonId != null) {
      info.add(
          CustomTextLabel(label: 'Locador: ${rentals.naturalPerson.name}'));
      info.add(CustomTextLabel(label: 'CPF: ${rentals.naturalPerson.cpf}'));
    }
    if (rentals.legalPersonId != null) {
      info.add(
          CustomTextLabel(label: '${rentals.legalPerson.tradingName}/${rentals.legalPerson.companyName}'));
      info.add(CustomTextLabel(label: '${rentals.legalPerson.cnpj}'));
    }
    return info;
  }

  Widget confirmationAction(BuildContext context, var rental) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RentalRegister(rental: rental),
            ),
          ).then((value) {
            dbHandler.fetchRentals(widget.isHistory);
          });
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
  }

  Widget confirmationEndRental(BuildContext context, var rental) {
    return TextButton(
        onPressed: () {
          endRental(context, rental).then((value) {
            dbHandler.fetchRentals(widget.isHistory);
          });
          ;
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
  }

  Widget confirmationRenovateRental(BuildContext context, var rental) {
    return TextButton(
        onPressed: () {
          renovateRental(context, rental).then((value) {
            dbHandler.fetchRentals(widget.isHistory);
          });
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
  }

  Future<void> endRental(BuildContext context, var rental) async {
    await dbHandler.updateRentalStatus(context, rental.id,
        {"endDate": DateFormat('dd/MM/yyyy').format(DateTime.now())}, 'rental', "Locação Finalizada com Sucesso");
  }

  Future<void> renovateRental(BuildContext context, var rental) async {
    final vehicles = await dbHandler.fetchVehiclesToRent(null);
    if (vehicles.any((vehicle) => vehicle.id == rental.vehicleId)) {
      await dbHandler.updateRentalStatus(context, rental.id,
          {"endDate": null}, 'rental', "Locação Renovada com Sucesso");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Locação não pode ser renovada. Veículo em uso.'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  Widget generateContract(BuildContext context, var rental) {
    return TextButton(
        onPressed: () {
          ContractFileManipulation().contractFileManipulation(rental);
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
  }
}
