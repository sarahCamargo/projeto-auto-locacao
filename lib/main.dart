import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_auto_locacao/cadastro_pessoa.dart';
import 'package:projeto_auto_locacao/visualizar_pessoas.dart';
import 'firebase_options.dart';
import 'cadastro_veiculo.dart';

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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroVeiculo()),
                );
              },
              child: Text('Cadastrar Veículo'),
            ),
            SizedBox(width: 20), // Espaçamento entre os botões
            CadastroPessoa(), // Botão para cadastrar pessoa
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaPessoas()),
                );
              },
              child: Text('Ver Pessoas'),
            ),
          ],
        ),
      ),
    );
  }
}