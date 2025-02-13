import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/screens/person_management/client_list_screen.dart';
import 'package:projeto_auto_locacao/widgets/drawer_navigator.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/home_page_constants.dart';
import '../../../widgets/tab_bar_title.dart';
import '../../rental_management/rental_management.dart';
import '../../vehicle_management/maintenance/maintenance_list_screen.dart';
import '../../vehicle_management/vehicle/vehicle_list_screen.dart';
import '../quick_actions/quick_actions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        drawer: const DrawerNavigator(),
        appBar: AppBar(
          centerTitle: true,
          title: const TabBarTitle(),
        ),
        body: const TabBarView(
          children: [
            QuickActions(),
            ClientListScreen(),
            RentalManagement(),
            VehicleListScreen(),
            MaintenanceListScreen(),
          ],
        ),
        bottomNavigationBar: Builder(
          builder: (context) {
            final TabController tabController =
                DefaultTabController.of(context);
            return Container(
              color: const Color(0xFF1A355B),
              child: TabBar(
                controller: tabController,
                onTap: (index) {
                  setState(() {});
                },
                tabs: [
                  Tab(
                    icon: SizedBox(
                      width: 32,
                      child: Image.asset(AppIcons.home,
                          color: getIconColor(tabController.index, 0)),
                    ),
                    text: HomePageConstants.homeTab,
                  ),
                  Tab(
                    icon: SizedBox(
                      width: 32,
                      child: Image.asset(AppIcons.client,
                          color: getIconColor(tabController.index, 1)),
                    ),
                    text: HomePageConstants.clientTab,
                  ),
                  Tab(
                    icon: SizedBox(
                      width: 32,
                      child: Image.asset(AppIcons.rental,
                          color: getIconColor(tabController.index, 2)),
                    ),
                    text: HomePageConstants.rentalTab,
                  ),
                  Tab(
                    icon: SizedBox(
                      width: 32,
                      child: Image.asset(AppIcons.vehicles,
                          color: getIconColor(tabController.index, 3)),
                    ),
                    text: HomePageConstants.vehicleTab,
                  ),
                  Tab(
                    icon: SizedBox(
                      width: 32,
                      child: Image.asset(AppIcons.maintenance,
                          color: getIconColor(tabController.index, 4)),
                    ),
                    text: HomePageConstants.maintenanceTab,
                  ),
                ],
                labelStyle: const TextStyle(fontSize: 12),
                indicatorColor: const Color(0xFFED6E33),
                unselectedLabelColor: Colors.white,
                labelColor: const Color(0xFFED6E33),
              ),
            );
          },
        ),
      ),
    );
  }

  Color getIconColor(int tabSelected, int tabIndex) {
    if (tabSelected == tabIndex) {
      return const Color(0xFFED6E33);
    }
    return Colors.white;
  }
}
