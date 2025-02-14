import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/client_constants.dart';
import 'package:projeto_auto_locacao/screens/client_management/client_type.dart';

import '../../widgets/custom_app_bar.dart';

class ClientRegister extends StatefulWidget {

  @override
  ClientRegisterState createState() => ClientRegisterState();

  const ClientRegister({super.key});
}

class ClientRegisterState extends State<ClientRegister> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Cadastro Cliente"),
      body: ClientType(),
    );
  }
}
