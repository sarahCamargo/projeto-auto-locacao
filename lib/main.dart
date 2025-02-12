import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/home_page_constants.dart';
import 'package:projeto_auto_locacao/screens/rental_management/rental_management.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/maintenance/maintenance_screen.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/VehicleListScreen.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_maintenance_screen.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_screen.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle_management.dart';
import 'package:projeto_auto_locacao/services/database/database_helper.dart';
import 'package:projeto_auto_locacao/services/notification_service.dart';
import 'package:projeto_auto_locacao/widgets/TabBarTitle.dart';
import 'package:projeto_auto_locacao/widgets/drawer_navigator.dart';
import 'package:projeto_auto_locacao/widgets/menu_navigation.dart';
import 'package:projeto_auto_locacao/screens/person_management/person_management.dart';
import 'package:projeto_auto_locacao/widgets/custom_initial_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.database;
  NotificationService.initializeNotifications();
  runApp(MyApp());
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBarTitle(),
          leading: IconButton(onPressed: () {  }, icon: const Icon(Icons.menu),),
        ),
        body: TabBarView(
          children: [
            VehicleListScreen(),
            VehicleMaintenanceScreen()
          ],),
        bottomNavigationBar: Container(
          color: Color(0xFF1A355B),
          child: const TabBar(tabs: [
            Tab(icon: Icon(Icons.directions_car_rounded), text: "Veículos"),
            Tab(icon: Icon(Icons.car_repair), text: "Manutenção")
          ],
          indicatorColor: Color(0xFFED6E33),
          unselectedLabelColor: Colors.white,
          labelColor: Color(0xFFED6E33)),
        ),
      ),
    );
  }
}
