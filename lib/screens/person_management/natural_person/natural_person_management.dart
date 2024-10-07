
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/collection_names.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/screens/person_management/natural_person/natural_person_filters.dart';
import 'package:projeto_auto_locacao/screens/person_management/natural_person/natural_person_register.dart';
import 'package:projeto_auto_locacao/services/database/database_handler.dart';

import '../../../constants/general_constants.dart';
import '../../../constants/person_management_constants.dart';
import '../../../utils/confirmation_dialog.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_modal_filters.dart';
import '../../../widgets/custom_text_label.dart';

class NaturalPersonManagement extends StatefulWidget {
  const NaturalPersonManagement({super.key});

  @override
  NaturalPersonManagementState createState() => NaturalPersonManagementState();
}

class NaturalPersonManagementState extends State<NaturalPersonManagement> {
  String searchString = '';
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.naturalPerson);

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
                      builder: (context) => const NaturalPersonRegister(
                        person: {},
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
                      content: NaturalPersonFilters(filters: filters, addFilter: _addFilter),
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
                  /* var items = snapshot.data!.where((element) => element['name']
                      .toString()
                      .toLowerCase()
                      .contains(searchString));
                  */
                  print("Pss psss psss psss, chamando gatinho psss psss pss pss");
                  
                  var items = snapshot.data!.where((element) =>
                      (filters['name'] == null || filters['name'].toString().isEmpty || element['name'].toString().toLowerCase().contains(filters['name'].toString().toLowerCase())) &&
                      (filters['cpf'] == null || filters['cpf'].toString().isEmpty || element['cpf'].toString().toLowerCase().contains(filters['cpf'].toString().toLowerCase()))
                  );
                  
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var person = items.elementAt(index);

                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationDialog(
                                    content: GeneralConstants.confirmEdit,
                                    confirmationWidget:
                                        confirmationAction(context, person));
                              });
                        },
                        child: CustomCard(
                          title: person['name'],
                          data: _getCardInfo(person),
                          id: person['id'],
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

  List<Widget> _getCardInfo(Map<String, dynamic> naturalPerson) {
    List<Widget> info = [];
    info.add(CustomTextLabel(
        label: '${PersonConstants.cpfLabel}: ${naturalPerson['cpf']}'));
    info.add(CustomTextLabel(
        label:
            '${PersonConstants.cellPhoneLabel}: ${naturalPerson['cellPhone']}'));
    return info;
  }

  Widget confirmationAction(BuildContext context, Map<String, dynamic> person) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NaturalPersonRegister(person: person),
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
