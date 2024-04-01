import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_auto_locacao/screens/person_management/person_management.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/gerenciar_veiculo.dart';
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
      body: Center(
        child: SingleChildScrollView(
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GerenciarVeiculo(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonManagement()),
                  );
                },
                child: Text('Gerenciar Pessoas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}