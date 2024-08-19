import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/maintenance_management_constants.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_constants.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/maintenance/maintenance_register.dart';
import 'package:projeto_auto_locacao/widgets/custom_card.dart';
import '../../../constants/collection_names.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/general_constants.dart';
import '../../../services/database/database_handler.dart';
import '../../../utils/confirmation_dialog.dart';
import '../../../widgets/custom_text_label.dart';

class MaintenanceScreen extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  const MaintenanceScreen({super.key, required this.vehicle});

  @override
  MaintenanceScreenState createState() => MaintenanceScreenState();
}

class MaintenanceScreenState extends State<MaintenanceScreen> {
  String searchString = '';
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.maintenance);

  @override
  void initState() {
    super.initState();
    dbHandler.fetchDataFromDatabase();
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
                  child: CustomCard(
                    title: widget.vehicle['brand'],
                    data: _getCardInfoVehicle(widget.vehicle),
                    id: widget.vehicle['id'],
                    imageUrl: widget.vehicle['imageUrl'],
                    hasImage: true,
                    hasDelete: false,
                    dbHandler: dbHandler,
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
                      builder: (context) => MaintenanceRegister(
                        idVehicle: widget.vehicle['id'],
                        maintenance: {},
                      ),
                    ),
                  ).then((value) {
                    if (value == true) {
                      dbHandler.fetchDataFromDatabase();
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
              child: StreamBuilder(
                stream: dbHandler.dataStream,
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                      var maintenance = items.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationDialog(
                                    content: GeneralConstants.confirmEdit,
                                    confirmationWidget:
                                    confirmationAction(context, maintenance));
                              });
                        },
                        child: CustomCard(
                          title: maintenance['type'],
                          data: _getCardInfoMaintenance(maintenance),
                          id: maintenance['id'],
                          dbHandler: dbHandler,
                          hasDelete: true,

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

  List<Widget> _getCardInfoVehicle(Map<String, dynamic> vehicle) {
    List<Widget> info = [];
    info.add(CustomTextLabel(
        label: '${VehicleConstants.yearLabel}: ${vehicle['year']}'));
    info.add(CustomTextLabel(
        label:
        '${VehicleConstants.licensePlateLabel}: ${vehicle['licensePlate']}'));
    return info;
  }

  List<Widget> _getCardInfoMaintenance(Map<String, dynamic> maintenance) {
    List<Widget> info = [];
    if (maintenance['frequency'] != null) {
      info.add(CustomTextLabel(
          label: '${ MaintenanceConstants.frequency[int.parse(
              maintenance['frequency'])]}'));
    }
    info.add(CustomTextLabel(label: 'Últ. verif: ${maintenance['lastCheck']}'));
    info.add(CustomTextLabel(label: 'Próx. verif.: ${maintenance['nextCheck']}'));
    return info;
  }

  Widget confirmationAction(BuildContext context, var maintenance) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaintenanceRegister(maintenance: maintenance, idVehicle: widget.vehicle['id'],),
            ),
          ).then((value) {
            dbHandler.fetchDataFromDatabase();
          });
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
  }
}
