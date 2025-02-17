import 'package:flutter/material.dart';

import 'package:projeto_auto_locacao/constants/client_constants.dart';
import 'package:projeto_auto_locacao/screens/client_management/client_register.dart';
import 'package:projeto_auto_locacao/widgets/buttons/delete_button.dart';
import 'package:projeto_auto_locacao/widgets/buttons/edit_button.dart';
import 'package:projeto_auto_locacao/widgets/filter_bar.dart';
import 'package:projeto_auto_locacao/widgets/search_input.dart';

import '../../../constants/collection_names.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/buttons/new_register_button.dart';
import '../../constants/app_icons.dart';
import '../../constants/colors_constants.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  ClientScreenListState createState() => ClientScreenListState();
}

class ClientScreenListState extends State<ClientListScreen> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.naturalPerson);
  DatabaseHandler dbHandlerLegalPerson =
      DatabaseHandler(CollectionNames.legalPerson);
  String _selectedFilter = "Todos";
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    dbHandler.fetchAllClients();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SearchInput(onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            }),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FilterBar(
                  filters: const ["Todos", "Física", "Jurídica"],
                  onFilterSelected: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                )),
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

                  var clients = _filteredClients(snapshot.data!);
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
                      itemCount: clients.length,
                      itemBuilder: (context, index) {
                        return _buildClientCard(client: clients[index]);
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
                builder: (context) => const ClientRegister(client: {}),
              ),
            ).then(
              (value) {
                if (value == true) {
                  dbHandler.fetchAllClients();
                }
              },
            );
          },
        )
      ],
    );
  }

  List<Map<String, dynamic>> _filteredClients(
      List<Map<String, dynamic>> clients) {
    var filteredClients = clients;

    if (_selectedFilter == "Física") {
      filteredClients =
          filteredClients.where((v) => v['typeClient'] == 1).toList();
    }

    if (_selectedFilter == "Jurídica") {
      filteredClients =
          filteredClients.where((v) => v['typeClient'] == 2).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredClients = filteredClients
          .where((v) => v['name'].toLowerCase().contains(_searchQuery))
          .toList();
    }

    return filteredClients;
  }

  Widget _buildClientCard({required var client}) {
    String documentName = "CPF";
    if (client['typeClient'] == 2) {
      documentName = "CNPJ";
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ColorsConstants.blueFields,
                child: Image.asset(
                  AppIcons.client,
                  color: Colors.white,
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${client['name']}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("$documentName: ${client['documentNumber']}",
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text("Contato: ${client['cellPhone']}",
              style: const TextStyle(color: Color(0xFF666666))),
          if (client['email'] != null && client['email'].isNotEmpty)
            Text("Email: ${client['email']}",
                style: const TextStyle(color: Color(0xFF666666))),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DeleteButton(onPressed: () {
                client['typeClient'] == 2
                    ? dbHandlerLegalPerson
                        .delete(client['id'])
                        .then((e) => {dbHandler.fetchAllClients()})
                    : dbHandler
                        .delete(client['id'])
                        .then((e) => {dbHandler.fetchAllClients()});
              }),
              const SizedBox(width: 10),
              EditButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientRegister(client: client),
                  ),
                ).then((value) {
                  setState(() {});
                  if (value == true) {
                    dbHandler.fetchAllClients();
                  }
                });
              }),
            ],
          ),
          const Divider(
            color: ColorsConstants.dividerColor,
            thickness: 1,
            indent: 5,
            endIndent: 5,
          )
        ],
      ),
    );
  }
}
