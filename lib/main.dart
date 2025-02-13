import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/screens/main_screen/home_page/home_page.dart';
import 'package:projeto_auto_locacao/services/database/database_helper.dart';
import 'package:projeto_auto_locacao/services/notification_service.dart';

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