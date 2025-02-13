import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/home_page_constants.dart';
import 'package:projeto_auto_locacao/screens/main_screen/quick_actions/quick_actions.dart';
import 'package:projeto_auto_locacao/screens/rental_management/rental_management.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/maintenance/MaintenanceListScreen.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_list_screen.dart';
import 'package:projeto_auto_locacao/services/database/database_helper.dart';
import 'package:projeto_auto_locacao/services/notification_service.dart';
import 'package:projeto_auto_locacao/widgets/tab_bar_title.dart';
import 'package:projeto_auto_locacao/screens/person_management/person_management.dart';

import 'constants/app_icons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.database;
  NotificationService.initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: ColorsConstants.backgroundColor,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorsConstants.backgroundColor,
        ),
        tabBarTheme: const TabBarTheme(
          labelPadding: EdgeInsets.symmetric(horizontal: 0),
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
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBarTitle(),
        ),
        body: TabBarView(
          children: [
            const QuickActions(),
            const PersonManagement(),
            const RentalManagement(),
            const VehicleListScreen(),
            MaintenanceListScreen()
          ],
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFF1A355B),
          child: TabBar(
              tabs: [
                Tab(
                    icon:
                        SizedBox(width: 32, child: Image.asset(AppIcons.home)),
                    text: HomePageConstants.homeTab),
                Tab(
                    icon: SizedBox(
                        width: 32, child: Image.asset(AppIcons.client)),
                    text: HomePageConstants.clientTab),
                Tab(
                    icon: SizedBox(
                        width: 32, child: Image.asset(AppIcons.rental)),
                    text: HomePageConstants.rentalTab),
                Tab(
                    icon: SizedBox(
                        width: 32, child: Image.asset(AppIcons.vehicles)),
                    text: HomePageConstants.vehicleTab),
                Tab(
                    icon: SizedBox(
                        width: 32, child: Image.asset(AppIcons.maintaince)),
                    text: HomePageConstants.maintainceTab)
              ],
              labelStyle: const TextStyle(fontSize: 12),
              indicatorColor: const Color(0xFFED6E33),
              unselectedLabelColor: Colors.white,
              labelColor: const Color(0xFFED6E33)),
        ),
      ),
    );
  }
}
