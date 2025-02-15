import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/screens/client_management/legal_person_register.dart';
import 'package:projeto_auto_locacao/screens/client_management/natural_person_register.dart';

import '../../widgets/register_text_label.dart';

class ClientType extends StatefulWidget {
  @override
  ClientTypeState createState() => ClientTypeState();

  const ClientType({super.key});
}

class ClientTypeState extends State<ClientType> {
  String _typeController = 'F';

  @override
  Widget build(BuildContext context) {
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
              if (_typeController == 'F') const NaturalPersonRegister(person: {})
              else const LegalPersonRegister(legalPerson: {})
            ],
          ),
        ),
      ),
    );
  }
}
