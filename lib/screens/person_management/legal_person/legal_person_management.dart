import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/legal_person_constants.dart';
import 'package:projeto_auto_locacao/constants/person_management_constants.dart';
import 'package:projeto_auto_locacao/screens/person_management/legal_person/legal_person_register.dart';

import '../../../constants/collection_names.dart';
import '../../../constants/general_constants.dart';
import '../../../services/database/database_handler.dart';
import '../../../utils/confirmation_dialog.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_text_label.dart';

class LegalPersonManagement extends StatefulWidget {
  const LegalPersonManagement({super.key});

  @override
  LegalPersonManagementState createState() => LegalPersonManagementState();
}

class LegalPersonManagementState extends State<LegalPersonManagement> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.legalPerson);
  String searchString = '';

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
                      element['companyName']
                          .toString()
                          .toLowerCase()
                          .contains(searchString));
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
