import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/client_constants.dart';
import 'package:projeto_auto_locacao/screens/client_management/client_type.dart';

import '../../widgets/custom_app_bar.dart';

class ClientRegister extends StatefulWidget {
  final Map<String, dynamic> client;

  @override
  ClientRegisterState createState() => ClientRegisterState();

  const ClientRegister({super.key, required this.client});
}

class ClientRegisterState extends State<ClientRegister> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Cadastro Cliente"),
      body: ClientType(client: widget.client),
    );
  }
}
