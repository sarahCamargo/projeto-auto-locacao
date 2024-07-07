import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_constants.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_maintenance_screen.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_screen.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';

class VehicleManagement extends StatefulWidget {
  const VehicleManagement({super.key});

  @override
  VehicleManagementState createState() => VehicleManagementState();
}

class VehicleManagementState extends State<VehicleManagement> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: VehicleConstants.vehicleManagementTitle,
          hasReturnScreen: true,
        ),
        body: const TabBarView(
            children: [VehicleScreen(), VehicleMaintenanceScreen()]),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: const TabBar(tabs: [
            Tab(
              icon: Icon(
                FontAwesomeIcons.car,
                color: ColorsConstants.iconColor,
              ),
            ),
            Tab(
              icon: Icon(FontAwesomeIcons.screwdriverWrench,
                  color: ColorsConstants.iconColor),
            )
          ]),
        ),
      ),
    );
  }
}
