import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/models/legal_person.dart';
import 'package:projeto_auto_locacao/screens/client_management/legal_person_register.dart';
import 'package:projeto_auto_locacao/screens/client_management/natural_person_register.dart';

import '../../constants/collection_names.dart';
import '../../models/natural_person.dart';
import '../../services/database/database_handler.dart';
import '../../widgets/text/register_text_label.dart';

class ClientType extends StatefulWidget {
  final Map<String, dynamic> client;

  @override
  ClientTypeState createState() => ClientTypeState();

  const ClientType({super.key, required this.client});
}

class ClientTypeState extends State<ClientType> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.naturalPerson);
  DatabaseHandler dbHandlerLegalPerson =
      DatabaseHandler(CollectionNames.legalPerson);
  NaturalPerson? naturalPerson;
  LegalPerson? legalPerson;

  String _typeController = 'F';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNaturalPerson();
  }

  Future<void> _loadNaturalPerson() async {
    if (widget.client["typeClient"] == 1) {
      final person = await dbHandler.getNaturalPerson(widget.client["id"]);
      setState(() {
        naturalPerson = person;
        _typeController = 'F';
        isLoading = false;
      });
    } else if (widget.client["typeClient"] == 2) {
      final person =
          await dbHandlerLegalPerson.getLegalPerson(widget.client["id"]);
      setState(() {
        legalPerson = person;
        _typeController = 'J';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16.0),
              const RegisterTextLabel(
                label: "Escolha o tipo de pessoa",
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Radio(
                    value: "F",
                    groupValue: _typeController,
                    onChanged: (value) {
                      setState(() {
                        _typeController = value.toString();
                      });
                    },
                  ),
                  const Text("Física"),
                  const SizedBox(width: 20.0),
                  Radio(
                    value: "J",
                    groupValue: _typeController,
                    onChanged: (value) {
                      setState(() {
                        _typeController = value.toString();
                      });
                    },
                  ),
                  const Text("Jurídica"),
                ],
              ),
              if (_typeController == 'F')
                if (naturalPerson == null)
                  const NaturalPersonRegister(person: {})
                else
                  NaturalPersonRegister(person: naturalPerson!.toMap())
              else if (legalPerson == null)
                const LegalPersonRegister(legalPerson: {})
              else
                LegalPersonRegister(legalPerson: legalPerson!.toMap())
            ],
          ),
        ),
      ),
    );
  }
}
