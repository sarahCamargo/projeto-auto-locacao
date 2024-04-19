import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/person_management_constants.dart';
import 'package:projeto_auto_locacao/screens/person_management/natural_person_register.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';
import 'package:projeto_auto_locacao/widgets/person_card.dart';

class PersonManagement extends StatefulWidget {
  const PersonManagement({super.key});

  @override
  PersonManagementState createState() => PersonManagementState();
}

class PersonManagementState extends State<PersonManagement> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: PersonConstants.personManagementTitle,
        hasReturnScreen: false,
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
                    ),
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('pessoa_fisica')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                var items = snapshot.data!.docs.where((element) =>
                    element['nome']
                        .toString()
                        .toLowerCase()
                        .contains(searchString));
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var person = items.elementAt(index).data();

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NaturalPersonRegister(person: person),
                          ),
                        );
                      },
                      child: PersonCard(person['nome'], person['cpf'],
                          person['telefone'], person['id']),
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
}
