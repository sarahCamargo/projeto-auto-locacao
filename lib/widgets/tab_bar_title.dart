import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/home_page_constants.dart';

class TabBarTitle extends StatelessWidget {
  const TabBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = DefaultTabController.of(context);

    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        String title = "";
        switch (tabController.index) {
          case 1:
            title = HomePageConstants.clientTitle;
          case 2:
            title = HomePageConstants.rentalTitle;
          case 3:
            title = HomePageConstants.vehicleTitle;
          case 4:
            title = HomePageConstants.maintenanceTitle;
          default:
            title = HomePageConstants.homeTitle;
        }
        return Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A355B),
            ),
          ),
        );
      },
    );
  }
}
