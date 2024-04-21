import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_coonstants.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/cadastro_veiculo.dart';

import '../../constants/colors_constants.dart';
import '../../constants/general_constants.dart';
import '../../utils/confirmation_dialog.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_card_vehicle.dart';
import '../../widgets/custom_text_label.dart';

class VehiclesManagement extends StatefulWidget {

  const VehiclesManagement({super.key});

  @override
  VehiclesManagementState createState() => VehiclesManagementState();
}

class VehiclesManagementState extends State<VehiclesManagement> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: VehicleConstants.vehicleManagementTitle,
        hasReturnScreen: true,
      ),
      body: Column(
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
                          labelText: 'Pesquisar',
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
                        builder: (context) => CadastroVeiculo(
                          veiculo: {},
                        ),
                      ),
                    ),
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection('veiculos').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var items = snapshot.data!.docs.where((element) =>
                    element['placa']
                        .toString()
                        .toLowerCase()
                        .contains(searchString));
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var veiculo = items.elementAt(index).data();

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationDialog(
                                  content: GeneralConstants.confirmEdit,
                                  confirmationWidget:
                                  confirmationAction(context, veiculo)
                              );
                            });
                      },
                      child: CustomCardVehicle(
                          veiculo['modelo'],
                          veiculo['anoFabricacao'],
                          veiculo['placa'],
                          veiculo['id']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget confirmationAction(BuildContext context, var veiculo) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CadastroVeiculo(veiculo: veiculo),
            ),
          );
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
  }
}
