import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/home_page_constants.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_list_screen.dart';

import '../../../widgets/custom_initial_button.dart';
import '../../person_management/person_management.dart';
import '../../rental_management/rental_management.dart';
import '../../../constants/app_icons.dart';

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  QuickActionsState createState() => QuickActionsState();
}

class QuickActionsState extends State<QuickActions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  HomePageConstants.quickActions,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A355B),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomInitialButton(HomePageConstants.newClient,
                        PersonManagement(), AppIcons.client),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomInitialButton(HomePageConstants.newRental,
                        VehicleListScreen(), AppIcons.rental),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomInitialButton(HomePageConstants.newMaintenance,
                        RentalManagement(), AppIcons.maintenance),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomInitialButton(HomePageConstants.history,
                        RentalManagement(), AppIcons.history),
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
