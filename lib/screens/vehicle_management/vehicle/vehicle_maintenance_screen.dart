import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_constants.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/maintenance_manager.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_filters.dart';
import 'package:projeto_auto_locacao/widgets/custom_card.dart';

import '../../../constants/collection_names.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/general_constants.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/custom_modal_filters.dart';
import '../../../widgets/custom_text_label.dart';

class VehicleMaintenanceScreen extends StatefulWidget {
  const VehicleMaintenanceScreen({super.key});

  @override
  VehicleMaintenanceScreenState createState() => VehicleMaintenanceScreenState();
}

class VehicleMaintenanceScreenState extends State<VehicleMaintenanceScreen> {
  String searchString = '';
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.vehicle);

  Map<String, dynamic> filters = {};

  void _clearFilters() {
    setState(() {
      filters.clear();
    });
  }

  void _addFilter(String key, dynamic value) {
    setState(() {
      filters[key] = value;
    });
  }

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
              /*
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
              */
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.filter,
                  color: ColorsConstants.iconColor,
                  size: 40,
                ),
                onPressed: () => {
                  showDialog(context: context, builder: (BuildContext context) {
                    return CustomModalFilters(
                      content: VehicleFilters(filters: filters, addFilter: _addFilter),
                      clearFilters: _clearFilters,
                    );
                  })
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
                  /*
                  var items = snapshot.data!.where((element) =>
                      element['licensePlate']
                          .toString()
                          .toLowerCase()
                          .contains(searchString));
                  */

                  var items = snapshot.data!.where((element) =>
                  (filters['brand'] == null || filters['brand'].toString().isEmpty || element['brand'].toString().toLowerCase().contains(filters['brand'].toString().toLowerCase())) &&
                      (filters['model'] == null || filters['model'].toString().isEmpty || element['model'].toString().toLowerCase().contains(filters['model'].toString().toLowerCase())) &&
                      (filters['licensePlate'] == null || filters['licensePlate'].toString().isEmpty || element['licensePlate'].toString().toLowerCase().contains(filters['licensePlate'].toString().toLowerCase())) &&
                      (filters['renavam'] == null || filters['renavam'].toString().isEmpty || element['renavam'].toString().toLowerCase().contains(filters['renavam'].toString().toLowerCase())) &&
                      (filters['year'] == null || filters['year'].toString().isEmpty || element['year'].toString().toLowerCase().contains(filters['year'].toString().toLowerCase())) &&
                      (filters['color'] == null || filters['color'].toString().isEmpty || element['color'].toString().toLowerCase().contains(filters['color'].toString().toLowerCase()))
                  );

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var vehicle = items.elementAt(index);
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MaintenanceManagement(vehicle: vehicle),
                              ),
                            ).then((value) {
                              dbHandler.fetchDataFromDatabase();
                            });
                          },
                          child: CustomCard(
                            title: vehicle['brand'],
                            data: _getCardInfo(vehicle),
                            id: vehicle['id'],
                            imageUrl: vehicle['imageUrl'],
                            hasImage: true,
                            dbHandler: dbHandler,
                          ));
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

  List<Widget> _getCardInfo(Map<String, dynamic> vehicle) {
    List<Widget> info = [];
    info.add(CustomTextLabel(
        label: '${VehicleConstants.yearLabel}: ${vehicle['year']}'));
    info.add(CustomTextLabel(
        label:
        '${VehicleConstants.licensePlateLabel}: ${vehicle['licensePlate']}'));
    return info;
  }

  Widget confirmationAction(BuildContext context, var vehicle) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaintenanceManagement(vehicle: vehicle),
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
