import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/person_management_constants.dart';
import 'package:projeto_auto_locacao/screens/person_management/cadastro_pessoa_fisica.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/cadastro_veiculo.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';
import 'package:projeto_auto_locacao/widgets/person_card.dart';

import '../../widgets/custom_card_vehicle.dart';

class PersonManagementHandler extends StatefulWidget {
  const PersonManagementHandler({super.key});

  @override
  PersonManagement createState() => PersonManagement();
}

class PersonManagement extends State<PersonManagementHandler> {
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
                        builder: (context) => const CadastroPessoaFisica(
                          pessoa: {},
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
                    var pessoa = items.elementAt(index).data();

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CadastroPessoaFisica(pessoa: pessoa),
                          ),
                        );
                      },
                      child: PersonCard(pessoa['nome'], pessoa['cpf'],
                          pessoa['telefone'], pessoa['id']),
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
