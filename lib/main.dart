import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_auto_locacao/screens/person_management/listar_pessoas.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/listar_veiculos.dart';
import 'package:projeto_auto_locacao/widgets/custom_initial_button.dart';
import 'services/firebase_options.dart';

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
        scaffoldBackgroundColor: const Color(0xFFE8E8E8),
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
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
      body: Container(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomInitialButton("Pessoas", ListaPessoas(), Icons.people),
                CustomInitialButton("Veículos", ListarVeiculos(), Icons.directions_car),
              ],
            ),
          ],
        ),
      ),
    );
  }
}