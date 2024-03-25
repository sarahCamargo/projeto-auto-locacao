import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_auto_locacao/screens/person_management/cadastro_pessoa.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/gerenciar_veiculo.dart';
import 'services/firebase_options.dart';
import 'screens/vehicle_management/cadastro_veiculo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Inicial'),
      ),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GerenciarVeiculo(),
            SizedBox(width: 20), // Espaçamento entre os botões
            CadastroPessoa(), // Botão para cadastrar pessoa
          ],
        ),
      ),
    );
  }
}