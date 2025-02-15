import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';
import 'package:projeto_auto_locacao/constants/client_constants.dart';
import 'package:projeto_auto_locacao/widgets/buttons/delete_button.dart';
import 'package:projeto_auto_locacao/widgets/buttons/edit_button.dart';
import 'package:projeto_auto_locacao/widgets/custom_divider.dart';
import 'package:projeto_auto_locacao/widgets/filter_bar.dart';
import 'package:projeto_auto_locacao/widgets/search_input.dart';

import '../../../constants/collection_names.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/buttons/new_register_button.dart';
import 'natural_person_register.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  ClientScreenListState createState() => ClientScreenListState();
}

class ClientScreenListState extends State<ClientListScreen> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.naturalPerson);

  @override
  void initState() {
    super.initState();
    dbHandler.fetchDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SearchInput(),
            const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: FilterBar(filters: ["Todos", "Física", "Jurídica"])),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: dbHandler.dataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(ClientConstants.noneClient),
                    );
                  }

                  var client = snapshot.data!;
                  return Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 70),
                      itemCount: client.length,
                      itemBuilder: (context, index) {
                        return _buildClientCard(client: client[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        NewRegisterFloatingButton(
          text: ClientConstants.newClient,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NaturalPersonRegister(person: {}),
              ),
            ).then(
              (value) {
                if (value == true) {
                  dbHandler.fetchDataFromDatabase();
                }
              },
            );
          },
        )
      ],
    );
  }

  Widget _buildClientCard({required var client}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 120,
                child: Icon(Icons.image_not_supported_outlined),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    Text(
                      "${ClientConstants.cpfLabel}: ${client['cpf']}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DeleteButton(onPressed: () {
                          dbHandler.delete(client['id']);
                        }),
                        const SizedBox(width: 10),
                        EditButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NaturalPersonRegister(person: client),
                            ),
                          ).then((value) {
                            if (value == true) {
                              dbHandler.fetchDataFromDatabase();
                            }
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const CustomDivider(),
        ],
      ),
    );
  }
}
