import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/legal_person_constants.dart';
import 'package:projeto_auto_locacao/constants/person_management_constants.dart';
import 'package:projeto_auto_locacao/screens/person_management/legal_person/legal_person_filters.dart';
import 'package:projeto_auto_locacao/screens/person_management/legal_person/legal_person_register.dart';

import '../../../constants/collection_names.dart';
import '../../../constants/general_constants.dart';
import '../../../services/database/database_handler.dart';
import '../../../utils/confirmation_dialog.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_modal_filters.dart';
import '../../../widgets/custom_text_label.dart';

class LegalPersonManagement extends StatefulWidget {
  const LegalPersonManagement({super.key});

  @override
  LegalPersonManagementState createState() => LegalPersonManagementState();
}

class LegalPersonManagementState extends State<LegalPersonManagement> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.legalPerson);
  String searchString = '';

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
                  FontAwesomeIcons.userPlus,
                  color: ColorsConstants.iconColor,
                  size: 40,
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LegalPersonRegister(
                        legalPerson: {},
                      ),
                    ),
                  ).then((value) {
                    if (value == true) {
                      dbHandler.fetchDataFromDatabase();
                    }
                  }),
                },
              ),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.filter,
                  color: ColorsConstants.iconColor,
                  size: 40,
                ),
                onPressed: () => {
                  showDialog(context: context, builder: (BuildContext context) {
                    return CustomModalFilters(
                      content: LegalPersonFilters(filters: filters, addFilter: _addFilter),
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
                  /* var items = snapshot.data!.where((element) =>
                      element['companyName']
                          .toString()
                          .toLowerCase()
                          .contains(searchString));
                  */

                  print("Batatinha batatinha, que vontade de ficar saradinha");

                  var items = snapshot.data!.where((element) =>
                  (filters['companyName'] == null || filters['companyName'].toString().isEmpty || element['companyName'].toString().toLowerCase().contains(filters['companyName'].toString().toLowerCase())) &&
                  (filters['tradingName'] == null || filters['tradingName'].toString().isEmpty || element['tradingName'].toString().toLowerCase().contains(filters['tradingName'].toString().toLowerCase())) &&
                  (filters['cnpj'] == null || filters['cnpj'].toString().isEmpty || element['cnpj'].toString().toLowerCase().contains(filters['cnpj'].toString().toLowerCase())) &&
                  (filters['legalResponsible'] == null || filters['legalResponsible'].toString().isEmpty || element['legalResponsible'].toString().toLowerCase().contains(filters['legalResponsible'].toString().toLowerCase())) &&
                  (filters['legalResponsibleCpf'] == null || filters['legalResponsibleCpf'].toString().isEmpty || element['legalResponsibleCpf'].toString().toLowerCase().contains(filters['legalResponsibleCpf'].toString().toLowerCase()))
                  );

                  print(items);

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var legalPerson = items.elementAt(index);

                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationDialog(
                                    content: GeneralConstants.confirmEdit,
                                    confirmationWidget: confirmationAction(
                                        context, legalPerson));
                              });
                        },
                        child: CustomCard(
                            title: legalPerson['companyName'],
                            data: _getCardInfo(legalPerson),
                            id: legalPerson['id'],
                            dbHandler: dbHandler),
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

  List<Widget> _getCardInfo(Map<String, dynamic> legalPerson) {
    List<Widget> info = [];
    info.add(CustomTextLabel(
        label: '${LegalPersonConstants.cnpjLabel}: ${legalPerson['cnpj']}'));
    info.add(CustomTextLabel(
        label:
            '${PersonConstants.cellPhoneLabel}: ${legalPerson['cellPhone']}'));
    info.add(CustomTextLabel(
        label:
            '${LegalPersonConstants.tradingName}: ${legalPerson['tradingName']}'));
    return info;
  }

  Widget confirmationAction(BuildContext context, Map<String, dynamic> legalPerson) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LegalPersonRegister(legalPerson: legalPerson),
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
