import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/maintenance_management_constants.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';

class MaintenanceManagement extends StatefulWidget {

  final Map<String, dynamic> vehicle;
  const MaintenanceManagement({super.key, required this.vehicle});

  @override
  MaintenanceManagementState createState() => MaintenanceManagementState();
}

class MaintenanceManagementState extends State<MaintenanceManagement> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: MaintenanceManagementConstants.maintenanceManagementTitle,
        hasReturnScreen: true,
      ),
      body: Container(color: Colors.blue, width: 100, height: 100,)
    );
  }
}
