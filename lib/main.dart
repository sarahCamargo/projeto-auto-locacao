import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/home_page_constants.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/gerenciar_veiculo.dart';
import 'package:projeto_auto_locacao/widgets/drawer_navigator.dart';
import 'package:projeto_auto_locacao/widgets/menu_navigation.dart';
import 'package:projeto_auto_locacao/screens/person_management/person_management.dart';
import 'package:projeto_auto_locacao/widgets/custom_initial_button.dart';
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: ColorsConstants.backgroundColor,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MenuNavigation(title: HomePageConstants.homePage,),
      drawer: const DrawerNavigator(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomInitialButton(HomePageConstants.personFeature, PersonManagement(),
                        FontAwesomeIcons.userGroup),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomInitialButton(HomePageConstants.vehicleFeature,
                        VehiclesManagement(), FontAwesomeIcons.car),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
