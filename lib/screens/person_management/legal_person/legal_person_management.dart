import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/screens/person_management/legal_person/legal_person_card.dart';
import 'package:projeto_auto_locacao/screens/person_management/legal_person/legal_person_register.dart';

import '../../../constants/general_constants.dart';
import '../../../utils/confirmation_dialog.dart';
import '../../../widgets/custom_text_label.dart';

class LegalPersonManagement extends StatefulWidget {
  const LegalPersonManagement({super.key});

  @override
  LegalPersonManagementState createState() => LegalPersonManagementState();
}

class LegalPersonManagementState extends State<LegalPersonManagement> {
  String searchString = '';

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
                  ),
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
                stream: FirebaseFirestore.instance
                    .collection('pessoa_juridica')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  var items = snapshot.data!.docs.where((element) =>
                      element['company_name']
                          .toString()
                          .toLowerCase()
                          .contains(searchString));
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var legalPerson = items.elementAt(index).data();

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
                        child: LegalPersonCard(
                            legalPerson['company_name'],
                            legalPerson['cnpj'],
                            legalPerson['cell_phone'],
                            legalPerson['trading_name'],
                            legalPerson['id']),
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

  Widget confirmationAction(BuildContext context, var legalPerson) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LegalPersonRegister(legalPerson: legalPerson),
            ),
          );
        },
        child: const CustomTextLabel(
          label: GeneralConstants.ok,
        ));
  }
}
